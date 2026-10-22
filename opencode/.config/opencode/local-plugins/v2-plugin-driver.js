import assert from "node:assert/strict";
import subscriptionModelGuard from "./subscription-model-guard-v2.js";
import { createHerdrReporter, createHerdrState } from "./herdr-agent-state-v2.js";
import { setupHerdrTui } from "./herdr-tui-session-v2.js";

const agents = [
  { id: "hephaestus", name: "hephaestus", model: { providerID: "anthropic", id: "claude" } },
  { id: "fallback-small", name: "fallback-small", model: { providerID: "anthropic", id: "claude" } },
  { id: "custom", name: "custom", model: { providerID: "openai", id: "gpt-5.6-sol" } },
];
let transform;
await subscriptionModelGuard.setup({
  agent: {
    transform: async (callback) => {
      transform = callback;
      return { dispose: async () => {} };
    },
  },
  session: { hook: () => assert.fail("direct session models must not be rewritten") },
});
transform({
  list: () => structuredClone(agents),
  update: (id, update) => update(agents.find((agent) => agent.id === id)),
});
assert.deepEqual(agents[0].model, { providerID: "openai", id: "gpt-6.1-sol", variant: "high" });
assert.deepEqual(agents[1].model, { providerID: "anthropic", id: "claude" });
assert.deepEqual(agents[2].model, { providerID: "openai", id: "gpt-6.1-sol" });

const serverRequests = [];
const environment = { HERDR_ENV: "1", HERDR_SOCKET_PATH: "/fake", HERDR_PANE_ID: "pane-1" };
const state = createHerdrState(
  createHerdrReporter({
    environment,
    send: async (request) => serverRequests.push(request),
    now: () => 100,
    random: () => 0,
  }),
  async () => ({ metadata: { omoParentID: "root" } }),
);
await state.handle({ type: "session.created", data: { sessionID: "root" } });
await state.handle({ type: "session.status", data: { sessionID: "root", status: { type: "busy" } } });
await state.handle({ type: "session.created", data: { sessionID: "child", metadata: { omoParentID: "root" } } });
await state.handle({ type: "session.execution.started", data: { sessionID: "child" } });
await state.handle({ type: "session.execution.succeeded", data: { sessionID: "child" } });
await state.handle({ type: "session.execution.started", data: { sessionID: "resumed-child" } });
await state.handle({ type: "session.execution.succeeded", data: { sessionID: "resumed-child" } });
await state.handle({ type: "form.created", data: { form: { sessionID: "child" } } });
await state.handle({ type: "session.idle", data: { sessionID: "root" } });
assert.deepEqual(
  serverRequests.map((request) => [request.method, request.params.state, request.params.agent_session_id]),
  [
    ["pane.report_agent", "working", "root"],
    ["pane.report_agent", "blocked", undefined],
    ["pane.report_agent", "idle", "root"],
  ],
);
assert.ok(serverRequests.every((request) => typeof request.params.seq === "number"));

const tuiRequests = [];
const effects = [];
let currentRoute = { type: "session", sessionID: "root" };
let cachedSession;
let tuiEvent;
const dispose = setupHerdrTui(
  {
    data: {
      on: () => () => {},
      listen: (handler) => {
        tuiEvent = handler;
        return () => {};
      },
      session: {
        get: (sessionID) => cachedSession?.id === sessionID ? cachedSession : undefined,
        root: (sessionID) => sessionID,
      },
    },
    ui: {
      router: { current: () => currentRoute },
      slot: ({ render }) => {
        render();
        return () => {};
      },
    },
  },
  createHerdrReporter({
    environment,
    includeSequence: false,
    requestPrefix: "herdr:opencode:tui",
    send: async (request) => tuiRequests.push(request),
    now: () => 100,
    random: () => 0,
  }),
  (effect) => {
    effects.push(effect);
    effect();
  },
);
// The real TUI opens its route before the session cache is populated.
cachedSession = { id: "root" };
effects.forEach((effect) => effect());
tuiEvent({ details: { type: "session.execution.started", data: { sessionID: "root" } } });
tuiEvent({ details: { type: "session.execution.succeeded", data: { sessionID: "root" } } });
await new Promise((resolve) => setImmediate(resolve));
currentRoute = { type: "session", sessionID: "child" };
cachedSession = { id: "child", metadata: { omoParentID: "root" } };
effects.forEach((effect) => effect());
await new Promise((resolve) => setImmediate(resolve));
dispose();
assert.deepEqual(tuiRequests.slice(0, 1).map((request) => request.params), [
  {
    pane_id: "pane-1",
    source: "herdr:opencode",
    agent: "opencode",
    agent_session_id: "root",
    session_start_source: "select",
  },
]);
assert.deepEqual(tuiRequests.slice(1).map((request) => [request.params.state, request.params.agent_session_id]), [
  ["working", "root"],
  ["idle", "root"],
]);

console.log("v2-plugin-driver: passed");

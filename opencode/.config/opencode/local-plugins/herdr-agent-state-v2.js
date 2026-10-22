import net from "node:net";

const SOURCE = "herdr:opencode";
const AGENT = "opencode";

export function herdrEnabled(environment = process.env) {
  return (
    environment.HERDR_ENV === "1" &&
    Boolean(environment.HERDR_SOCKET_PATH) &&
    Boolean(environment.HERDR_PANE_ID)
  );
}

function socketEndpoint(environment) {
  return process.platform === "win32"
    ? `\\\\.\\pipe\\${environment.HERDR_SOCKET_PATH}`
    : environment.HERDR_SOCKET_PATH;
}

function sendSocketRequest(request, environment) {
  return new Promise((resolve) => {
    const client = net.createConnection(socketEndpoint(environment), () => {
      client.write(`${JSON.stringify(request)}\n`);
    });
    const finish = () => {
      client.destroy();
      resolve();
    };

    client.setTimeout(500, finish);
    client.on("data", finish);
    client.on("error", finish);
    client.on("end", finish);
    client.on("close", resolve);
  });
}

export function createHerdrReporter({
  environment = process.env,
  send = (request) => sendSocketRequest(request, environment),
  includeSequence = true,
  requestPrefix = SOURCE,
  now = Date.now,
  random = Math.random,
}) {
  let sequence = now() * 1000;
  let requestChain = Promise.resolve();

  const request = (method, params) => {
    const pending = requestChain.then(() => {
      const sequenceParams = includeSequence ? { seq: ++sequence } : {};
      return send({
        id: `${requestPrefix}:${now()}:${Math.floor(random() * 1_000_000)
          .toString()
          .padStart(6, "0")}`,
        method,
        params: {
          pane_id: environment.HERDR_PANE_ID,
          source: SOURCE,
          agent: AGENT,
          ...sequenceParams,
          ...params,
        },
      });
    });
    requestChain = pending.catch(() => {});
    return pending;
  };

  return {
    reportSession(sessionID, selected = false) {
      return request("pane.report_agent_session", {
        agent_session_id: sessionID,
        ...(selected ? { session_start_source: "select" } : {}),
      });
    },
    reportState(state, sessionID) {
      return request("pane.report_agent", {
        state,
        ...(sessionID ? { agent_session_id: sessionID } : {}),
      });
    },
  };
}

function sessionID(event) {
  const direct = event?.data?.sessionID;
  if (typeof direct === "string") return direct;

  const formSessionID = event?.data?.form?.sessionID;
  return typeof formSessionID === "string" ? formSessionID : undefined;
}

function stateFromStatus(status) {
  const type = typeof status === "string" ? status : status?.type;
  switch (type) {
    case "idle":
      return "idle";
    case "active":
    case "busy":
    case "pending":
    case "retry":
    case "running":
    case "streaming":
    case "working":
      return "working";
    default:
      return;
  }
}

export function createHerdrState(reporter, loadSession) {
  const childSessions = new Set();
  const knownSessions = new Set();
  let reportedRootSessionID;

  return {
    async handle(event) {
      const id = sessionID(event);
      if (!id) return;

      if (event.type === "session.created") {
        knownSessions.add(id);
        if (event.data.parentID || event.data.metadata?.omoParentID) childSessions.add(id);
        else reportedRootSessionID = id;
        return;
      }

      if (!knownSessions.has(id)) {
        const session = await loadSession(id);
        if (session.parentID || session.metadata?.omoParentID) childSessions.add(id);
        knownSessions.add(id);
      }

      if (childSessions.has(id)) {
        if (event.type === "permission.asked" || event.type === "form.created") {
          await reporter.reportState("blocked");
        }
        if (
          event.type === "permission.replied" ||
          event.type === "form.replied" ||
          event.type === "form.cancelled"
        ) {
          await reporter.reportState("working");
        }
        return;
      }

      switch (event.type) {
        case "session.status": {
          const state = stateFromStatus(event.data.status);
          if (state) await reporter.reportState(state, id);
          else await reporter.reportSession(id);
          return;
        }
        case "session.idle":
        case "session.execution.succeeded":
        case "session.execution.interrupted":
          await reporter.reportState("idle", id);
          return;
        case "session.execution.started":
        case "session.step.started":
        case "session.tool.called":
        case "permission.replied":
        case "form.replied":
        case "form.cancelled":
        case "session.compaction.started":
          await reporter.reportState("working", id);
          return;
        case "permission.asked":
        case "form.created":
        case "session.execution.failed":
        case "session.step.failed":
          await reporter.reportState("blocked", id);
          return;
        case "session.model.selected":
        case "session.agent.selected":
          if (id !== reportedRootSessionID) await reporter.reportSession(id);
          return;
        default:
          return;
      }
    },
  };
}

const herdrAgentState = {
  id: "local.herdr-agent-state-v2",
  setup(context) {
    if (!herdrEnabled()) return;

    const controller = new AbortController();
    const state = createHerdrState(createHerdrReporter({}), (sessionID) => context.session.get({ sessionID }));

    void (async () => {
      try {
        for await (const event of context.event.subscribe({ signal: controller.signal })) {
          if (event.location?.directory && event.location.directory !== context.location.directory) continue;
          await state.handle(event);
        }
      } catch {
        if (!controller.signal.aborted) return;
      }
    })();

    return () => controller.abort();
  },
};

export default herdrAgentState;

import { createEffect } from "solid-js";
import { createHerdrReporter, herdrEnabled } from "./herdr-agent-state-v2.js";
import { setupHerdrTui } from "./herdr-tui-session-v2.js";

export default {
  id: "local.herdr-tui-session-v2",
  setup(context) {
    if (!herdrEnabled()) return;
    return setupHerdrTui(
      context,
      createHerdrReporter({ requestPrefix: "herdr:opencode:tui" }),
      createEffect,
    );
  },
};

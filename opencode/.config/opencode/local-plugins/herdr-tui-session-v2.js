import { createHerdrState } from "./herdr-agent-state-v2.js";

export function setupHerdrTui(context, reporter, observe) {
  let selectedSessionID;

  const reportSelection = async (sessionID) => {
    const session = context.data.session.get(sessionID);
    if (!session || session.parentID || session.metadata?.omoParentID || sessionID === selectedSessionID) return;
    selectedSessionID = sessionID;
    await reporter.reportSession(sessionID, true);
  };

  const state = createHerdrState(reporter, async (sessionID) => context.data.session.get(sessionID));
  const stopEvents = context.data.listen(({ details }) => {
    const sessionID = details.data?.sessionID ?? details.data?.form?.sessionID;
    if (!sessionID || !selectedSessionID) return;
    const session = context.data.session.get(sessionID);
    if (!session) return;
    const rootID = session?.metadata?.omoParentID ?? context.data.session.root(sessionID);
    if (sessionID !== selectedSessionID && rootID !== selectedSessionID) return;
    void state.handle(details);
  });
  const stopSlot = context.ui.slot({
    append: "app",
    render() {
      observe(() => {
        const current = context.ui.router.current();
        if (current.type === "session") void reportSelection(current.sessionID);
      });
      return null;
    },
  });

  return () => {
    stopEvents();
    stopSlot();
  };
}

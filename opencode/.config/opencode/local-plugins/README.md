# Local OpenCode V2 Plugins

Register this ESM plugin directory in the permanent profile. Append this path
to the server `plugins` array in `~/.config/opencode/opencode.json`:

```json
{
  "plugins": [
    "/home/tomge/work/projects/dotfiles-arch/opencode/.config/opencode/local-plugins"
  ]
}
```

Also append it to the existing TUI `plugins` array in
`~/.config/opencode/cli.json`:

```json
{
  "plugins": [
    "/home/tomge/work/projects/dotfiles-arch/opencode/.config/opencode/local-plugins"
  ]
}
```

Installed `@opencode/plugin/dist/host.js` resolves a local plugin directory's
`index` server entrypoint and `tui` TUI entrypoint. This directory supplies
both: `index.js` combines the two server plugins and `tui.js` exposes the Herdr
selection plugin.

Use the real dotfiles directory in plugin registration: the installed runtime's
filesystem watcher reports an error when its configured plugin directory is a
symlink. The canonical `~/.config/opencode/local-plugins` link remains useful for
inspection and running the driver.

The server plugin uses the V2 structural plugin contract (`id`, `setup`) and the
TUI plugin uses the corresponding V2 TUI structural contract. `Plugin.define`
in installed `@opencode/plugin` 2.0.32 is an identity function, so avoiding the
package import keeps local entrypoints self-contained while remaining native V2.

`subscription-model-guard-v2.js` applies the legacy subscription policy only to
startup agent defaults through `context.agent.transform`. It does not register a
request-time model rewrite: V2 `SessionContext.model` is readonly, and this
preserves a direct TUI/session model override. The V2 server context has no TUI
toast method, so it cannot reproduce the legacy warning toast.

Live 2.1.2 validation showed this transform sees built-in agents before the
fork-generated Markdown overlays are loaded. Therefore the permanent `omo.jsonc`
uses the effective `gpt-6.1-sol` IDs explicitly rather than depending on the
legacy runtime rewrite. Changing agent files to another provider is not guarded
by this hook; keep automatic agent/category defaults on OpenAI manually.

`herdr-agent-state-v2.js` maps V2 execution events and
uses the existing newline-delimited Herdr socket RPC protocol. It maps V2 forms
to the legacy question blocked/working states and V2 execution events to the
legacy tool/error states. In particular, V2 `form.created` carries its session
ID at `data.form.sessionID`; reply and cancellation events carry it directly.
V2 has no `session.updated` event; model/agent selection events are the nearest
session-association equivalent.

The fork records child relationships in `metadata.omoParentID`, not native
`parentID`. Both are recognized. After a plugin reload or a resumed session,
the server resolves an unfamiliar session once through `context.session.get`
before reporting its state. Real worker-continuation testing confirmed that
child activity no longer replaces the pane's root session ID.

Herdr reporting runs in each TUI, not the shared server, so its socket/pane
environment belongs to that client. `herdr-tui-session-v2.js` observes the actual
reactive route and session cache from an app slot. It waits for the cache to load
and reports root selection without polling. The declared `tui.session.select`
server event did not fire on real TUI startup and is not used. The same client
forwards execution events only for its selected root and descendants, preserving
child blocking behavior without associating another pane's session.

Run the isolated fake-context check without touching a real Herdr socket:

```sh
node ~/.config/opencode/local-plugins/v2-plugin-driver.js
```

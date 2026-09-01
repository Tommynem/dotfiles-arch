---
name: ssh-access
description: Use for direct SSH access to remote hosts and production servers. Requires one directly connected, host-named, human-visible tmux window per AI and remote host through the ssh-access helper; never use unlocked SSH keys from ordinary local Bash.
---

# Shared SSH Access

Use the tracked `ssh-access` helper whenever work requires a direct SSH-family
connection backed by the user's manually unlocked keys.

This workflow is an audit boundary, not a security boundary between processes
running as the same Unix user. Follow the window ownership rules exactly.

## Start Gate

1. Run `ssh-access status` in ordinary local Bash.
2. If the socket is unavailable, run `ssh-access setup` once and check status
   again.
3. If no identities are loaded, ask the user to run `ssh-access attach` and
   unlock the keys in the `unlock` window. Stop until the user confirms.
4. Never attach to, capture, type into, or otherwise inspect the `unlock`
   window.

The user enters passphrases. Never request, receive, log, paste, or handle a
passphrase.

## Create One Owned Window Per Host

Create a directly connected window for each remote host required by the task:

```bash
ssh-access open '<ssh-host>' 'opencode-<short-context>'
```

`<ssh-host>` is an SSH config alias, hostname, address, or `user@host`, never
an option string. Use a short, non-sensitive label. Record all returned fields
for the remainder of the session:

```text
session=ssh-access
window_id=@<number>
window_name=<host>-...
host=<ssh-host>
owner_token=<uuid>
```

The immutable `window_id` is the only valid tmux target. The name is for human
readability and must identify the host at a glance. Never target a window by
index or name.

## Window Ownership Rules

- Use only the window ID created by this AI session.
- Never use, inspect, rename, close, capture, or send input to another window.
- Never use the human-controlled `unlock` window.
- Never reuse a window left by another AI or an earlier session.
- Keep every owned host window open for the entire AI session.
- Use one window for one host. If the task requires another host, create and
  separately track another directly connected window.
- Do not create a window for a host outside the user's requested scope.

If the recorded window no longer exists, create a new one through the helper.
Do not guess which existing window might be yours.

## Command Routing

The helper launches interactive SSH immediately. The first visible line names
the host, followed by the remote login. Do not send an `ssh` command yourself.

Use ordinary local Bash for local file inspection, builds, tests, Git, and all
other non-SSH work. Local Bash may call `ssh-access` and may use tmux commands
to control or read owned windows, but it must not make an SSH connection.

For remote work:

1. Open the host through `ssh-access open`.
2. Confirm the connected user and hostname in that same window before changes.
3. Send plain remote commands to the already-connected window so the user can
   watch them live.
4. Read output only from that owned host window.
5. Never hide remote work in escaped one-shot commands such as
   `ssh host 'command ...'`.

If SSH disconnects, the window remains open with its history and a closed
status message. Do not type commands into that disconnected window. Create a
new directly connected window if continued access is required, and retain both
until the user decides cleanup.

If a task specifically requires `scp`, `sftp`, or SSH-backed `rsync`, ask the
user before opening a separate visible transport window; do not bypass this
workflow in ordinary Bash.

## Readable Remote History

The tmux history is a human audit log. Optimize commands for the user reading
them live and later, not for minimizing tool calls.

- Send one logical command at a time and wait for its output before continuing.
- Prefer plain commands with obvious arguments over dense pipelines or command
  substitutions.
- Do not hide work inside `sh -c`, `eval`, base64 payloads, deeply nested
  quoting, or long `&&`/`;` chains.
- Never use download-and-execute pipelines such as `curl ... | sh`.
- A short, conventional pipeline is acceptable only when it is clearer than
  separate commands and every stage is easy to understand.
- For complex or multi-step logic, create a clearly named script instead of an
  inline shell program. Show the complete script with line numbers before
  running it, execute it as a separate command, and make cleanup visible.
- Do not compress a script into a one-line heredoc invocation merely to avoid
  creating a file. Readability and traceability take priority.

Prefer `interactive_bash` for tmux input. If output capture is required and the
interactive tool does not support it, ordinary local Bash may run:

```bash
tmux capture-pane -p -t '@<number>' -S -1000
```

## Forbidden Actions

- Do not run `ssh`, `scp`, `sftp`, or SSH-backed `rsync` directly in ordinary
  local Bash.
- Do not override `SSH_AUTH_SOCK` to bypass this workflow.
- Do not run `ssh-add`, remove identities, restart the agent, or stop its socket.
- Do not enable SSH agent forwarding or copy the agent socket to another host.
- Do not read private keys or change SSH key files.
- Do not interact with Bitwarden's SSH agent.
- Do not kill the `ssh-access` session.

## Cleanup Gate

Cleanup always requires a fresh, explicit user decision for every owned host
window, even if the task is complete. Tell the user each recorded window name,
ID, and remote host, then ask whether to close it so they can inspect the
history first.

Only after approval, run:

```bash
ssh-access close-window --confirmed-by-user '@<number>' '<owner-token>'
```

The helper verifies the session, immutable ID, AI role, ownership token, and
that the target is not the unlock window. If the user declines or does not
answer, leave the window open and report that it remains available.

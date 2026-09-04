<!-- CODEGRAPH_START -->
## CodeGraph Discovery Preference

For codebase discovery, prefer CodeGraph as an early step when it is available.

Use CodeGraph especially for:

- locating symbols, files, and call paths
- understanding cross-file behavior
- tracing callers, callees, or blast radius
- surveying unfamiliar modules before editing

If a `.codegraph/` directory exists at or above the repo root, use the
`codegraph_explore` MCP tool or `codegraph explore "<query>"` before falling
back to broad grep/read loops.

If CodeGraph is not indexed, do not block the task. Use normal tools instead.
For broad or repeated discovery work, mention that `codegraph init` can enable
it, but do not initialize automatically unless the user asked for repo mutation.

CodeGraph is preferred, not required; use `rg`, direct reads, LSP, or tests when
they are simpler or more precise.
<!-- CODEGRAPH_END -->

## User-input and loop safeguards

- When progress requires user input, use the `question` tool to ask for it rather than polling, retrying, or busy-waiting.
- Before asking for a preference, opinion, or decision, give a short brief that explicitly names the topic, summarizes the relevant context, states what input is needed, and explains the practical effect of the options. Never send a vague or context-free prompt.
- If a loop is detected, stop immediately. Use the `question` tool to confirm the gate or decision that is blocking progress; do not continue the loop until the user responds.

## Privileged commands

- Use `pkexec` when elevated privileges are required. Batch related privileged
  operations into one authorization request instead of prompting repeatedly.
- Keep the command easy to review: state what it changes, then show the exact
  command before execution. Do not hide privileged work in deeply nested,
  unformatted inline shell expressions.
- If the privileged operation needs more than a short, readable command, write
  a real `.sh` script, show its contents for review, and execute that script
  with `pkexec`.

## Git branches and worktrees

## `.omo/` state is temporary

- Treat `.omo/` as disposable, per-task agent state. It is not part of the
  repository and must never be staged or committed.
- Do not store documentation, decisions, or other material intended for future
  maintainers solely in `.omo/`; persist it in an appropriate tracked location
  when it is worth keeping.
- Do not search for committed `.omo/` state. If you encounter any during normal
  work, notify the user rather than acting on it.
- Before ending a task, consider whether any useful state or knowledge needs to
  be persisted outside `.omo/` for future work.

- Before creating a branch or worktree, inspect the current repository with
  `git worktree list --porcelain` and identify its Git common directory. Do not
  assume the current directory is the only checkout.
- When the repository uses a sibling-worktree layout—a bare repository such as
  `.bare/` alongside named worktree directories—create durable branches only as
  new sibling worktrees beside that bare repository. Use `git worktree add` to
  create both the worktree and its branch.
- Treat every existing worktree as assigned to its current branch. Never use
  `git checkout`, `git switch`, `git checkout -b`, or `git switch -c` to change
  the branch in an existing worktree. In particular, never repurpose a
  directory named `main` or otherwise alter its checked-out branch unless the
  user explicitly asks for that exact change.
- For repositories without that sibling-worktree layout, or for work that is
  genuinely short-lived, create an ephemeral worktree only under
  `/tmp/opencode/<repo>-<task>`. Remove it with `git worktree remove` when the
  work is finished.
- Do not create agent branches, clones, or worktrees anywhere else. If neither
  approved location is usable, ask the user rather than choosing a location.

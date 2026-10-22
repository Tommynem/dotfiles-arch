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

## Pragmatic scope and proportional process

- Treat `.omo`, plans, subagents, reviewers, test suites, security analysis, and
  browser/visual tooling as a toolbox, not a mandatory pipeline. Select only the
  smallest useful tool and the smallest useful version of its process for the
  task at hand.
- Optimize for a one-person business building small-business websites and
  internal tools unless the user or repository establishes higher stakes.
  Match effort to concrete blast radius, reversibility, and uncertainty—not to
  an imagined enterprise deployment scenario.
- Prefer the 80/20 solution and fast feedback from the real system over trying
  to predict every edge case up front. For cheap, reversible work, implement a
  narrow version, exercise it, learn from actual failures, and iterate.
- Do not turn small tasks into plans, assumption matrices, new abstractions,
  generalized frameworks, test harnesses, or multi-agent review programs.
  Added process and architecture must solve a demonstrated problem or a
  specific risk in the user's request.
- Keep verification proportional. Default to the lightest high-signal check of
  the changed behavior. Add tests when they protect important behavior or a
  reproduced bug; do not test incidental implementation details or create a
  rigid web of tests where a small source change requires broad test rewrites.
- Time-box browser and visual verification. Check the changed path and a small
  representative set of relevant states or viewports; do not spend hours in
  recursive Playwright, screenshot, or visual-review loops that substitute
  synthetic confidence for obvious human judgment.
- One focused implementation pass and one focused verification/review pass are
  the default. Continue cycling only for a concrete observed failure, an unmet
  acceptance criterion, or an explicit user request—not because another review
  might theoretically find something.
- Increase rigor when evidence justifies it: irreversible or destructive
  changes, sensitive data, authentication or authorization, secrets, payments,
  production incidents, large migrations, public APIs, or an explicit request
  for exhaustive review. “Important” alone is not a request for an elaborate
  testing or review apparatus.
- If further preparation is likely to cost more than trying the change and
  learning from the result, prefer the trial. State the meaningful residual
  risk briefly instead of building speculative machinery around it.

## Process check-in and right-sized plan review

- Before substantive implementation, check in with the user about the proposed
  process. Do this during the planning phase or, when a separate plan is not
  warranted, as a brief inline process proposal before starting the work.
- Make the process scope explicit: state the intended workflow, safety
  precautions, testing and review measures, why they fit this class of task,
  and what will deliberately be omitted to avoid overengineering. Keep this
  proportional—a small task may need only a few sentences, not a formal plan.
- Ask the user for feedback on that process and wait for their response before
  proceeding. Do not repeatedly check in unless the task's scope, risk, or
  assumptions materially change.
- Include process scope in any plan review. Judge whether it is right-sized in
  both directions: neither excessive for the demonstrated risk nor too weak for
  the likely consequences. Do not reduce this to asking only whether the plan
  is small enough.
- Treat the agreed process as a boundary. Do not silently add review rounds,
  test infrastructure, agents, security work, or browser/visual QA beyond it;
  explain the new evidence and check with the user first if expansion becomes
  necessary.

## User-input and loop safeguards

- Before asking the user to obtain infrastructure, access, credentials, or perform an operation, establish that it is needed for the current next step and cannot be obtained or tested independently. Never bundle speculative future prerequisites into an immediate handoff.
- Ask for only the next actionable owner step. State precisely what to supply, where/how to supply it safely, and why it unblocks work now. If it does not exist yet, explain concretely how to create or obtain it; do not assume the user can hand over a console, account, or UI-only action.
- For owner-executed diagnostic and verification commands, capture stdout/stderr in a unique private log and print only its path and exit code. Make privileged-run logs readable by the invoking owner without exposing them to other users. Read the log directly rather than asking the user to copy command output.
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

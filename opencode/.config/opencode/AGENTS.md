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

## Privileged commands

- Use `pkexec` when elevated privileges are required. Batch related privileged
  operations into one authorization request instead of prompting repeatedly.
- Keep the command easy to review: state what it changes, then show the exact
  command before execution. Do not hide privileged work in deeply nested,
  unformatted inline shell expressions.
- If the privileged operation needs more than a short, readable command, write
  a real `.sh` script, show its contents for review, and execute that script
  with `pkexec`.

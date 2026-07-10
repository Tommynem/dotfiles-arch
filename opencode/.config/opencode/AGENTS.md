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

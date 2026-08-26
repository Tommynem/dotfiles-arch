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

<!-- EXECUTION_LEVELS_START -->
## Execution levels

Accept integer `Effort-Level: E/10` and `Speed-Level: S/3` only. Reject non-integers or values outside E0-E10 and S0-S3, and stop for correction. If omitted, infer the lowest safe E and use S0. For nontrivial work, announce the effective E/S once. Effective E is the greater of requested or inferred E and the safety floor, and disclose any raise: E5 for cross-module or shared/global work; E7 for security, privacy, data integrity, destructive, production-impacting, or external-side-effect work; E9 for irreversible work, migrations without simple rollback, or broad high-blast-radius production work.

Requirements are cumulative: E0 direct atomic action plus outcome check; E1 inspect the exact target; E2 targeted verification; E3 inspect relevant dependencies/callers; E4 state acceptance criteria and relevant validation; E5 write a concise execution plan before mutation; E6 add applicable risks and rollback or stop conditions; E7 do task-relevant exploration/research before implementation and coordinate at least one bounded specialist; E8 add an independent verification/review pass and parallelize independent worksets when useful; E9 requires an approved formal `.omo` plan before execution; E10 runs the complete ultrawork pipeline: formal plan, broad parallel discovery/research, coordinated implementation, independent review/QA, and final synthesis. Persona or mode instructions may add gates, never weaken them. Plan-only mode remains non-mutating. An explicit ultrawork invocation fixes E10. An incapable agent hands off or stops.

Existing permissions remain authoritative. Every child prompt carries effective E/S, remaining active budget, command cap, role, required evidence, and `do not recursively delegate unless authorized`. Children inherit E/S and safety floors, use the earlier deadline, and escalate scope or safety raises to the coordinator.

S0 has no speed cap. S1 caps active work at 60 minutes and each command at 15 minutes. S2 caps active work at 30 minutes and each command at 5 minutes; use targeted fast checks only and avoid Playwright, browser, UI, and visual inspection unless indispensable to a safety or acceptance gate. S3 caps active work at 15 minutes and each command at 1 minute; run only fast targeted checks and do not start long-running commands, full suites, browsers, or visual inspection. Use a monotonic active clock, clamp timeouts, enforce process groups, and trap cleanup. Pause the active clock for user wait only after all commands and subagents are stopped. On deadline expiry, stop or cancel work where supported, report evidence and missing gates, and ask to raise Speed or narrow scope. Speed never weakens safety; if a speed cap conflicts with a required gate, report incomplete rather than skip the gate.
<!-- EXECUTION_LEVELS_END -->

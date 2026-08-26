#!/usr/bin/env bash
set -euo pipefail

readonly TEST_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly THUNDERBIRD_DIR="$(cd -- "$TEST_DIR/.." && pwd -P)"
readonly ROOT_DIR="$(cd -- "$THUNDERBIRD_DIR/.." && pwd -P)"
readonly FIXTURES_DIR="$TEST_DIR/fixtures"
readonly RUNTIME_DIR='/tmp/opencode'
readonly EXPECTED_PREF='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
readonly -a SECTIONS=(
  messenger-shell folder-pane thread-table thread-card reader-chrome compose-chrome
  address-book calendar-tasks today-pane settings-account menus-popovers
)
readonly -a STATES=(default hover pressed focus-visible selected disabled unread error)

WORK_ROOT=''

fail() {
  printf 'validate: %s\n' "$*" >&2
  return 1
}

cleanup() {
  [[ -z "$WORK_ROOT" ]] || rm -rf -- "$WORK_ROOT"
}

trap cleanup EXIT

require_text() {
  local file=$1 text=$2 label=$3
  grep -Fqx -- "$text" "$file" >/dev/null || fail "$label: missing exact line: $text"
}

require_fragment() {
  local file=$1 text=$2 label=$3
  grep -Fq -- "$text" "$file" || fail "$label: missing required text: $text"
}

validate_matrix() {
  local selector_file=$1
  awk -F'|' '
    BEGIN {
      split("Messenger shell, spaces rail, unified toolbar, tabs\034Folder pane\034Thread table layout\034Thread card layout\034Reader chrome and attachment chrome\034Rendered message document\034Compose chrome\034Compose editor document\034Address book\034Calendar and tasks\034Today pane\034Settings and add-ons\034Account setup and account management\034Menus, popovers, and dialogs", required, "\034")
      for (item in required) required_rows[required[item]] = 1
    }
    /^## Surface and state matrix$/ { inside = 1; next }
    /^## Namespace/ { inside = 0 }
    inside && /^\|/ && $2 !~ /Surface/ && $2 !~ /---/ {
      rows++
      if (NF != 8) exit 1
      surface = $2
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", surface)
      seen[surface] = 1
      for (field = 2; field <= 7; field++) {
        value = $field
        gsub(/[[:space:]]/, "", value)
        if (value == "") exit 1
      }
    }
    END {
      if (rows != 14) exit 1
      for (surface in required_rows) if (!(surface in seen)) exit 1
    }
  ' "$selector_file" || fail 'selector matrix contains a blank required cell'
}

validate_ledger() {
  local selector_file=$1
  awk '
    /^```text$/ { inside = 1; next }
    inside && /^```$/ { closed = 1; exit }
    inside {
      divider = index($0, " | ")
      if (divider == 0 || index(substr($0, divider + 3), " | ") != 0) exit 1
      selector = substr($0, 1, divider - 1)
      member = substr($0, divider + 3)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", selector)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", member)
      if (selector == "" || member == "" || member !~ /^chrome\// || seen[selector]++) exit 1
      rows++
    }
    END { if (!closed || rows != 60) exit 1 }
  ' "$selector_file" || fail 'selector ledger must contain 60 unique nonblank selector/archive records'
}

validate_contracts_at() {
  local tree=$1
  local design="$tree/DESIGN.md" selectors="$tree/selectors-153.0.2.md"
  local manager="$tree/manage-skin" pref="$tree/packages/enable/user.js"
  local heading command

  [[ -f "$design" ]] || fail 'DESIGN.md is missing'
  [[ -f "$selectors" ]] || fail 'selectors-153.0.2.md is missing'
  [[ -x "$manager" ]] || fail 'manage-skin must be executable'
  [[ -f "$pref" ]] || fail 'packages/enable/user.js is missing'

  for heading in \
    '# Thunderbird dual-skin design contract' '## 1. Atmosphere & identity' \
    '## 2. Color' '## 3. Typography' '## 4. Spacing & layout' \
    '## 5. Components and core-surface anatomy' '## 6. Motion & interaction' \
    '## 7. Depth & surface' '## Implementation handoff and QA gates'; do
    require_text "$design" "$heading" 'DESIGN contract' || return
  done
  for heading in \
    '# Thunderbird 153.0.2 selector and core-surface contract' \
    '## Pin and evidence method' '## Surface and state matrix' \
    '## Namespace, custom-element, and shadow-boundary rules' \
    '## Selector ledger for independent occurrence checks' '## Explicit exclusions'; do
    require_text "$selectors" "$heading" 'selector contract' || return
  done
  require_fragment "$selectors" 'Thunderbird **153.0.2**' 'selector contract' || return
  require_fragment "$selectors" 'BuildID' 'selector contract' || return
  require_fragment "$selectors" '**20260813184934**' 'selector contract' || return
  require_fragment "$selectors" 'SHA-256' 'selector contract' || return
  require_fragment "$design" 'Coworker light semantic tokens' 'DESIGN contract' || return
  require_fragment "$design" 'Personal Rosé Pine semantic tokens' 'DESIGN contract' || return
  validate_matrix "$selectors" || return
  validate_ledger "$selectors" || return

  printf '%s\n' "$EXPECTED_PREF" | cmp -s - "$pref" || { fail 'enable/user.js must contain exactly the required preference'; return; }
  bash -n "$manager" || { fail 'manage-skin has invalid Bash syntax'; return; }
  require_text "$manager" 'set -euo pipefail' 'manage-skin' || return
  require_fragment "$manager" 'THUNDERBIRD_MANAGE_SKIN_TESTING' 'manage-skin test seam' || return
  require_fragment "$manager" 'stow_command --simulate' 'manage-skin simulation' || return
  require_fragment "$manager" '--no-folding' 'manage-skin mode' || return
  for command in status install switch uninstall; do
    require_fragment "$manager" "$command)" 'manage-skin command mode' || return
  done
}

selector_ledger() {
  awk -F' [|] ' '
    /^```text$/ { inside = 1; next }
    inside && /^```$/ { exit }
    inside && $1 !~ /^#/ && NF == 2 { print $1 }
    inside && $1 ~ /^#/ && NF == 2 { print $1 }
  ' "$THUNDERBIRD_DIR/selectors-153.0.2.md"
}

skin_tokens() {
  local variant=$1 prefix
  case "$variant" in
    outlook) prefix='cw' ;;
    rose-pine) prefix='rp' ;;
    *) fail "unknown skin variant: $variant"; return ;;
  esac
  grep -oE -- "--(${prefix}|type|space|size|radius|border|focus|motion)-[a-z0-9-]+" \
    "$THUNDERBIRD_DIR/DESIGN.md" | sort -u
}

fixture_token_values() {
  local variant=$1
  python3 - "$variant" "$THUNDERBIRD_DIR/DESIGN.md" <<'PY'
import re
import sys
from pathlib import Path

variant = sys.argv[1]
prefix = "cw" if variant == "outlook" else "rp"
headings = {
    "### Coworker light semantic tokens": "cw",
    "### Personal Rosé Pine semantic tokens": "rp",
}
pattern = re.compile(rf"--{prefix}-[a-z0-9-]+$")
active_prefix = None
values = {}
for line in Path(sys.argv[2]).read_text(encoding="utf-8").splitlines():
    if line.startswith("#"):
        active_prefix = headings.get(line) if line.startswith("### ") else None
        continue
    match = re.match(r"^\|\s*`(--[a-z0-9-]+)`\s*\|\s*([^|]+?)\s*\|", line)
    if active_prefix == prefix and match and pattern.fullmatch(match.group(1)):
        token = match.group(1)
        value = match.group(2).strip().strip("`")
        if token in values and values[token] != value:
            raise SystemExit(f"conflicting fixture token values: {token}")
        values[token] = value
for token, value in values.items():
    print(f"{token}\t{value}")
PY
}

validate_css_file() {
  local variant=$1 css=$2 section
  [[ -f "$css" && ! -L "$css" ]] || { fail "skin CSS must be a standalone regular file: $css"; return; }

  for section in "${SECTIONS[@]}"; do
    require_fragment "$css" "section: $section" "CSS $variant" || return
  done
  python3 - "$css" "$variant" "$THUNDERBIRD_DIR/DESIGN.md" "$THUNDERBIRD_DIR/selectors-153.0.2.md" <<'PY'
import re
import sys
from pathlib import Path

css_path = Path(sys.argv[1])
variant = sys.argv[2]
design_path = Path(sys.argv[3])
selectors_path = Path(sys.argv[4])
source = css_path.read_text(encoding="utf-8")
css = re.sub(r"/\*.*?\*/", "", source, flags=re.S)

def fail(message: str) -> None:
    print(f"validate: CSS {variant} {message}", file=sys.stderr)
    raise SystemExit(1)

def blocks(text: str, depth: int = 0):
    cursor = 0
    while cursor < len(text):
        opening = -1
        statement_end = -1
        quote = ""
        escaped = False
        for position in range(cursor, len(text)):
            character = text[position]
            if quote:
                if escaped:
                    escaped = False
                elif character == "\\":
                    escaped = True
                elif character == quote:
                    quote = ""
            elif character in "\"'":
                quote = character
            elif character == "{":
                opening = position
                break
            elif character == "}":
                fail("has an unmatched closing brace")
            elif character == ";":
                statement_end = position
                break
        if opening == -1:
            if statement_end == -1:
                return
            cursor = statement_end + 1
            continue
        header = text[cursor:opening].strip()
        brace_depth = 1
        quote = ""
        escaped = False
        position = opening + 1
        while position < len(text) and brace_depth:
            character = text[position]
            if quote:
                if escaped:
                    escaped = False
                elif character == "\\":
                    escaped = True
                elif character == quote:
                    quote = ""
            elif character in "\"'":
                quote = character
            elif character == "{":
                brace_depth += 1
            elif character == "}":
                brace_depth -= 1
            position += 1
        if brace_depth:
            fail("has an unmatched opening brace")
        body = text[opening + 1:position - 1]
        if header.startswith("@"):
            yield from blocks(body, depth + 1)
        elif header and body.strip():
            yield header, body, depth
        cursor = position

rules = list(blocks(css))
if not rules:
    fail("has no nonempty CSS rules outside comments")
direct_rules = [(header, body) for header, body, depth in rules if depth == 0]

forbidden = re.compile(r"@import|url\s*\(|https?://|data:|usercontent|#messageBrowser|#composeContentBox|outlook|microsoft|tare5vwp", re.I)
if forbidden.search(css):
    fail("contains forbidden content, asset, import, profile ID, or branding")
if "#definitely-not-in-thunderbird-153" in css:
    fail("contains stale selector fixture token")

def normalize(value: str) -> str:
    return " ".join(value.strip().split())

def normalize_css_value(value: str) -> str:
    return normalize(re.sub(r"\s*!important\s*$", "", value, flags=re.I))

def approved_token_values(path: Path, prefix: str) -> dict[str, str]:
    headings = {
        "### Coworker light semantic tokens": "cw",
        "### Personal Rosé Pine semantic tokens": "rp",
    }
    token_pattern = re.compile(rf"--{prefix}-[a-z0-9-]+$")
    values = {}
    active_prefix = None
    for line in path.read_text(encoding="utf-8").splitlines():
        if line.startswith("#"):
            active_prefix = headings.get(line) if line.startswith("### ") else None
            continue
        match = re.match(r"^\|\s*`(--[a-z0-9-]+)`\s*\|\s*([^|]+?)\s*\|", line)
        if active_prefix == prefix and match and token_pattern.fullmatch(match.group(1)):
            token = match.group(1)
            value = normalize(match.group(2).strip().strip("`"))
            if token in values and values[token] != value:
                raise ValueError(f"DESIGN.md has conflicting approved token values: {token}")
            values[token] = value
    return values

def mask_quoted(value: str) -> str:
    masked = []
    quote = ""
    escaped = False
    for character in value:
        if quote:
            masked.append(" ")
            if escaped:
                escaped = False
            elif character == "\\":
                escaped = True
            elif character == quote:
                quote = ""
        elif character in "\"'":
            quote = character
            masked.append(" ")
        else:
            masked.append(character)
    return "".join(masked)

def selector_groups(header: str) -> list[str]:
    masked = mask_quoted(header)
    groups = []
    start = 0
    bracket_depth = 0
    parenthesis_depth = 0
    for position, character in enumerate(masked):
        if character == "[":
            bracket_depth += 1
        elif character == "]":
            bracket_depth -= 1
        elif character == "(":
            parenthesis_depth += 1
        elif character == ")":
            parenthesis_depth -= 1
        elif character == "," and not bracket_depth and not parenthesis_depth:
            groups.append(normalize(masked[start:position]))
            start = position + 1
    groups.append(normalize(masked[start:]))
    return [group for group in groups if group]

root_declarations = {}
non_direct_root_declarations = set()
for header, body, depth in rules:
    for match in re.finditer(r"(?:^|;)\s*(--[a-z0-9-]+)\s*:\s*([^;{}]+)", body, re.I | re.S):
        has_root_group = re.search(r"(^|,)\s*:root\s*(,|$)", header) is not None
        if depth == 0 and header.strip() == ":root":
            root_declarations.setdefault(match.group(1), []).append(normalize_css_value(match.group(2)))
        elif has_root_group:
            non_direct_root_declarations.add(match.group(1))

prefix = "cw" if variant == "outlook" else "rp"
try:
    approved_tokens = approved_token_values(design_path, prefix)
except ValueError as error:
    fail(str(error))
required_tokens = set(approved_tokens)
if not required_tokens:
    fail("DESIGN.md has no concrete approved token declarations")
missing_tokens = sorted(required_tokens - set(root_declarations))
if missing_tokens:
    if set(missing_tokens) & non_direct_root_declarations:
        fail("required token declaration must be direct top-level :root")
    fail(f"missing active :root token declaration: {missing_tokens[0]}")

inert_values = {"initial", "inherit", "unset", "revert", "revert-layer", "transparent"}
for token in sorted(required_tokens):
    for value in root_declarations[token]:
        if value in inert_values and approved_tokens[token] != value:
            fail(f"uses inert value for active :root token: {token}")
        if value != approved_tokens[token]:
            fail(f"has unapproved active :root token value: {token}")

root_properties = {name: values[-1] for name, values in root_declarations.items()}

color_pattern = re.compile(r"#[0-9a-f]{3,8}(?![\w-])|rgba?\s*\(", re.I)
for _, body, _ in rules:
    for color in color_pattern.finditer(body):
        declaration = body[max(body.rfind(";", 0, color.start()), body.rfind("{", 0, color.start())) + 1:color.start()]
        if not re.search(r"^\s*--[a-z0-9-]+\s*:\s*[^{}]*$", declaration, re.I | re.S):
            fail("has a raw color outside a local token declaration")

ledger = []
inside = False
for line in Path(selectors_path).read_text(encoding="utf-8").splitlines():
    if line == "```text":
        inside = True
        continue
    if inside and line == "```":
        break
    if inside:
        selector, separator, member = line.partition(" | ")
        if not separator or not selector or not member:
            fail("cannot read selector ledger")
        ledger.append(selector)

def legitimate_suffix(value: str) -> bool:
    return re.fullmatch(r"(?:\s*(?:::{1}|:)[-\w]+(?:\([^()]*\))?|\s*\[[^\]]+\])*", value) is not None

def matches(selector: str, group: str) -> bool:
    base = normalize(mask_quoted(selector))
    if selector.startswith("::"):
        position = group.find(base)
        if position == -1:
            return False
        return re.fullmatch(r"[.#\w-]*", group[:position]) is not None and legitimate_suffix(group[position + len(base):])
    return group.startswith(base) and legitimate_suffix(group[len(base):])

def declarations(body: str) -> list[tuple[str, str]]:
    result = []
    start = 0
    quote = ""
    escaped = False
    parenthesis_depth = 0
    for position, character in enumerate(body + ";"):
        if quote:
            if escaped:
                escaped = False
            elif character == "\\":
                escaped = True
            elif character == quote:
                quote = ""
        elif character in "\"'":
            quote = character
        elif character == "(":
            parenthesis_depth += 1
        elif character == ")":
            parenthesis_depth -= 1
        elif character == ";" and not parenthesis_depth:
            declaration = body[start:position]
            start = position + 1
            colon = declaration.find(":")
            if colon != -1:
                name = declaration[:colon].strip().lower()
                value = declaration[colon + 1:].strip()
                if name:
                    result.append((name, value))
    return result

inert_declaration_values = {"", "inherit", "initial", "unset", "revert", "revert-layer", "transparent"}

def var_arguments(content: str) -> tuple[str, str | None] | None:
    quote = ""
    escaped = False
    parenthesis_depth = 0
    for position, character in enumerate(content):
        if quote:
            if escaped:
                escaped = False
            elif character == "\\":
                escaped = True
            elif character == quote:
                quote = ""
        elif character in "\"'":
            quote = character
        elif character == "(":
            parenthesis_depth += 1
        elif character == ")":
            parenthesis_depth -= 1
        elif character == "," and not parenthesis_depth:
            return content[:position].strip(), content[position + 1:].strip()
    return content.strip(), None

def closing_parenthesis(value: str, opening: int) -> int | None:
    depth = 0
    quote = ""
    escaped = False
    for position in range(opening, len(value)):
        character = value[position]
        if quote:
            if escaped:
                escaped = False
            elif character == "\\":
                escaped = True
            elif character == quote:
                quote = ""
        elif character in "\"'":
            quote = character
        elif character == "(":
            depth += 1
        elif character == ")":
            depth -= 1
            if depth == 0:
                return position
    return None

def resolve_value(value: str, trail: tuple[str, ...] = ()) -> str | None:
    result = []
    cursor = 0
    while cursor < len(value):
        match = re.search(r"var\(", value[cursor:], re.I)
        if not match:
            result.append(value[cursor:])
            break
        opening = cursor + match.start() + 3
        closing = closing_parenthesis(value, opening)
        if closing is None:
            return None
        result.append(value[cursor:cursor + match.start()])
        arguments = var_arguments(value[opening + 1:closing])
        if arguments is None:
            return None
        name, fallback = arguments
        if not re.fullmatch(r"--[a-z0-9-]+", name, re.I):
            return None
        replacement = resolve_variable(name, trail)
        if replacement is None:
            if fallback is None:
                return None
            replacement = resolve_value(fallback, trail)
            if replacement is None:
                return None
        result.append(replacement)
        cursor = closing + 1
    return normalize_css_value("".join(result))

def resolve_variable(name: str, trail: tuple[str, ...]) -> str | None:
    if name in trail or name not in root_properties:
        return None
    return resolve_value(root_properties[name], trail + (name,))

def has_effective_declaration(body: str) -> bool:
    for name, value in declarations(body):
        resolved_value = resolve_value(value)
        if not name.startswith("--") and resolved_value is not None and resolved_value.lower() not in inert_declaration_values:
            return True
    return False

for selector in ledger:
    matching_rules = [body for header, body in direct_rules if any(matches(selector, group) for group in selector_groups(header))]
    if not matching_rules:
        fail(f"missing direct selector coverage: {selector}")
    if not any(has_effective_declaration(body) for body in matching_rules):
        fail(f"contract selector has no effective depth-0 declaration: {selector}")

groups = [group for header, _ in direct_rules for group in selector_groups(header)]
def attributes(group: str) -> list[tuple[str, str]]:
    return [(match.group(1).lower(), match.group(2) or "") for match in re.finditer(r"\[\s*([\w-]+)\s*([~|^$*]?=)?[^\]]*\]", group)]

def mask_not_contents(group: str) -> str:
    masked = list(group)
    position = 0
    while position < len(group):
        if group[position:position + 5].lower() != ":not(":
            position += 1
            continue
        depth = 0
        quote = ""
        escaped = False
        end = position + 4
        while end < len(group):
            character = group[end]
            if quote:
                if escaped:
                    escaped = False
                elif character == "\\":
                    escaped = True
                elif character == quote:
                    quote = ""
            elif character in "\"'":
                quote = character
            elif character == "(":
                depth += 1
            elif character == ")":
                depth -= 1
                if depth == 0:
                    break
            end += 1
        if depth:
            fail("has an unbalanced :not() selector")
        for index in range(position, end + 1):
            masked[index] = " "
        position = end + 1
    return "".join(masked)

def pseudo_source(group: str) -> str:
    return re.sub(r"\[[^\]]*\]", " ", mask_not_contents(group))

def has_pseudo(pattern: str) -> bool:
    return any(re.search(pattern, pseudo_source(group), re.I) for group in groups)

attribute_pairs = [pair for group in groups for pair in attributes(mask_not_contents(group))]
attribute_names = {name for name, _ in attribute_pairs}
state_checks = {
    "hover": lambda: has_pseudo(r":hover(?![-\w])"),
    "pressed": lambda: has_pseudo(r":active(?![-\w])") or {"pressed", "aria-pressed"} & attribute_names,
    "focus": lambda: has_pseudo(r":focus-visible(?![-\w])|:focus(?![-\w])"),
    "selected/current": lambda: {"selected", "aria-selected", "current", "aria-current"} & attribute_names,
    "disabled": lambda: has_pseudo(r":disabled(?![-\w])") or {"disabled", "aria-disabled"} & attribute_names,
    "unread": lambda: any(name == "data-properties" and operator == "~=" for name, operator in attribute_pairs) or any(re.search(r"\.(?:unread-count|new-messages)(?![-\w])", group, re.I) for group in groups),
    "error": lambda: has_pseudo(r":invalid(?![-\w])") or {"invalid", "aria-invalid", "error", "data-error"} & attribute_names or any(re.search(r"\.error(?![-\w])", group, re.I) for group in groups),
}
for state, satisfied in state_checks.items():
    if not satisfied():
        fail(f"has no actual {state} state selector rule")
PY
}

validate_skin() {
  local variant=$1 css="$THUNDERBIRD_DIR/packages/$1/chrome/userChrome.css"
  if [[ ! -f "$css" ]]; then
    printf 'validate: incomplete: %s CSS is not implemented: %s\n' "$variant" "$css" >&2
    return 2
  fi
  validate_css_file "$variant" "$css"
}

new_case() {
  local name=$1 case_dir
  case_dir="$(mktemp -d "$WORK_ROOT/${name}.XXXXXX")"
  cp -a -- "$THUNDERBIRD_DIR" "$case_dir/thunderbird"
  mkdir -p -- "$case_dir/profiles/profile" "$case_dir/bin"
  printf '[InstallFixture]\nDefault=profile\n' > "$case_dir/profiles/profiles.ini"
  : > "$case_dir/profiles/profile/prefs.js"
  printf '[App]\nVersion=153.0.2\nBuildID=20260813184934\n' > "$case_dir/application.ini"
  make_fixture_css "$case_dir/thunderbird/packages/outlook/chrome/userChrome.css" outlook
  make_fixture_css "$case_dir/thunderbird/packages/rose-pine/chrome/userChrome.css" rose-pine
  make_fake_stow "$case_dir/bin/stow"
  printf '%s\n' "$case_dir"
}

make_fixture_css() {
  local css=$1 variant=$2 mode=${3:-baseline} seed=${4:-} section state selector token value text_token rule_selector
  case "$variant" in
    outlook) text_token='cw-text-primary' ;;
    rose-pine) text_token='rp-text' ;;
    *) fail "unknown fixture skin variant: $variant"; return ;;
  esac
  mkdir -p -- "$(dirname -- "$css")"
  if [[ -n "$seed" ]]; then
    cat -- "$seed" > "$css"
  else
    : > "$css"
  fi
  {
    if [[ "$mode" == conditional-root ]]; then
      printf '@media (width < 0px) { :root {\n'
    else
      printf ':root {\n'
    fi
    while IFS=$'\t' read -r token value; do printf '  %s: %s;\n' "$token" "$value"; done < <(fixture_token_values "$variant")
    case "$mode" in
      inert-variable-alias) printf '  --inert: inherit;\n' ;;
      mixed-case-inert-alias) printf '  --inert: InHeRiT !IMPORTANT;\n' ;;
      variable-cycle) printf '  --cycle-a: var(--cycle-b);\n  --cycle-b: var(--cycle-a);\n' ;;
      important-token-control) printf '  --approved-important: var(--cw-text-primary) !IMPORTANT;\n' ;;
    esac
    if [[ "$mode" == conditional-root ]]; then
      printf '} }\n'
    else
      printf '}\n'
    fi
    for section in "${SECTIONS[@]}"; do printf '/* section: %s */\n' "$section"; done
    if [[ "$mode" == conditional-coverage ]]; then
      printf '@media (width < 0px) {\n'
    fi
    for state in "${STATES[@]}"; do printf '/* state: %s */\n' "$state"; done
    while IFS= read -r selector; do
      rule_selector=$selector
      [[ "$selector" != ::* ]] || rule_selector="menupopup$selector"
      if [[ "$mode" == inert-variable-alias || "$mode" == mixed-case-inert-alias || "$mode" == variable-cycle || "$mode" == unresolved-variable || "$mode" == approved-token-control || "$mode" == important-token-control ]]; then
        case "$mode" in
          inert-variable-alias) printf '%s { color: var(--inert) !important; }\n' "$rule_selector" ;;
          mixed-case-inert-alias) printf '%s { color: var(--inert) !important; }\n' "$rule_selector" ;;
          variable-cycle) printf '%s { color: var(--cycle-a); }\n' "$rule_selector" ;;
          unresolved-variable) printf '%s { color: var(--missing); }\n' "$rule_selector" ;;
          approved-token-control) printf '%s { color: var(--missing, var(--cw-text-primary)); }\n' "$rule_selector" ;;
          important-token-control) printf '%s { color: var(--approved-important) !important; }\n' "$rule_selector" ;;
        esac
      elif [[ "$mode" == effective-declarations ]]; then
        printf '%s { color: inherit; background-color: var(--cw-surface-pane); }\n' "$rule_selector"
      elif [[ "$mode" == negated-states || "$mode" == positive-not ]]; then
        printf '%s { color: var(--%s); }\n' "$rule_selector" "$text_token"
      else
        printf '%s:focus, %s:focus-visible { color: var(--%s); }\n' "$rule_selector" "$rule_selector" "$text_token"
      fi
    done < <(selector_ledger)
    case "$mode" in
      comment-states)
        printf '/* #spacesToolbar:hover, #spacesToolbar:active, #spacesToolbar[selected], #spacesToolbar:disabled, [data-properties~="unread"], #spacesToolbar[aria-invalid="true"] */\n'
        ;;
      invalid-attribute-state)
        printf '[data-contract=:hover], [data-contract=:active], [data-contract=selected], [data-contract=disabled], [data-contract=unread], [data-contract=error] { color: var(--%s); }\n' "$text_token"
        ;;
      negated-states)
        printf '#spacesToolbar:not(:hover), #spacesToolbar:not(:active), #spacesToolbar:not(:focus), #spacesToolbar:not([selected]), #spacesToolbar:not([disabled]), [data-properties~="unread"]:not([data-properties~="unread"]), #spacesToolbar:not([aria-invalid="true"]) { color: var(--%s); }\n' "$text_token"
        ;;
      positive-not)
        printf '#spacesToolbar:hover:not([data-contract="ignore"]), #spacesToolbar:active:not(.inactive), #spacesToolbar:focus-visible:not([hidden]), #spacesToolbar[selected]:not([hidden]), #spacesToolbar:disabled:not([hidden]), [data-properties~="unread"]:not([hidden]), #spacesToolbar[aria-invalid="true"]:not([hidden]) { color: var(--%s); }\n' "$text_token"
        ;;
      effective-declarations)
        printf '#spacesToolbar:hover, #spacesToolbar:active, #spacesToolbar:focus-visible, #spacesToolbar[selected], #spacesToolbar:disabled, [data-properties~="unread"], #spacesToolbar[aria-invalid="true"] { color: inherit; border-color: var(--cw-border-strong); }\n'
        ;;
      inert-variable-alias)
        printf '#spacesToolbar:hover, #spacesToolbar:active, #spacesToolbar:focus-visible, #spacesToolbar[selected], #spacesToolbar:disabled, [data-properties~="unread"], #spacesToolbar[aria-invalid="true"] { color: var(--inert) !important; }\n'
        ;;
      mixed-case-inert-alias)
        printf '#spacesToolbar:hover, #spacesToolbar:active, #spacesToolbar:focus-visible, #spacesToolbar[selected], #spacesToolbar:disabled, [data-properties~="unread"], #spacesToolbar[aria-invalid="true"] { color: var(--inert) !important; }\n'
        ;;
      variable-cycle)
        printf '#spacesToolbar:hover, #spacesToolbar:active, #spacesToolbar:focus-visible, #spacesToolbar[selected], #spacesToolbar:disabled, [data-properties~="unread"], #spacesToolbar[aria-invalid="true"] { color: var(--cycle-a); }\n'
        ;;
      unresolved-variable)
        printf '#spacesToolbar:hover, #spacesToolbar:active, #spacesToolbar:focus-visible, #spacesToolbar[selected], #spacesToolbar:disabled, [data-properties~="unread"], #spacesToolbar[aria-invalid="true"] { color: var(--missing); }\n'
        ;;
      approved-token-control)
        printf '#spacesToolbar:hover, #spacesToolbar:active, #spacesToolbar:focus-visible, #spacesToolbar[selected], #spacesToolbar:disabled, [data-properties~="unread"], #spacesToolbar[aria-invalid="true"] { color: var(--missing, var(--cw-text-primary)); }\n'
        ;;
      important-token-control)
        printf '#spacesToolbar:hover, #spacesToolbar:active, #spacesToolbar:focus-visible, #spacesToolbar[selected], #spacesToolbar:disabled, [data-properties~="unread"], #spacesToolbar[aria-invalid="true"] { color: var(--approved-important) !important; }\n'
        ;;
      *)
        printf '#spacesToolbar:hover, #spacesToolbar:active, #spacesToolbar[selected], #spacesToolbar:disabled, [data-properties~="unread"], #spacesToolbar[aria-invalid="true"] { color: var(--%s); }\n' "$text_token"
        ;;
    esac
    if [[ "$mode" == conditional-coverage ]]; then
      printf '}\n'
    fi
  } >> "$css"
}

make_fake_stow() {
  local stow=$1
  cat > "$stow" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
simulate=0
delete=0
packages_dir=''
target=''
packages=()
while (($#)); do
  case "$1" in
    --simulate) simulate=1 ;;
    --no-folding) ;;
    --dir) shift; packages_dir=$1 ;;
    --target) shift; target=$1 ;;
    -D) delete=1 ;;
    -S) ;;
    *) packages+=("$1") ;;
  esac
  shift
done
((simulate)) && exit 0
if [[ "${FAKE_STOW_MISLEAD:-0}" == 1 ]]; then
  printf 'fake stow: success\n'
  exit 0
fi
for package in "${packages[@]}"; do
  case "$package" in
    enable) source="$packages_dir/enable/user.js"; destination="$target/user.js" ;;
    outlook|rose-pine) source="$packages_dir/$package/chrome/userChrome.css"; destination="$target/chrome/userChrome.css" ;;
    *) exit 64 ;;
  esac
  if ((delete)); then
    rm -f -- "$destination"
  else
    mkdir -p -- "$(dirname -- "$destination")"
    ln -s -- "$(realpath --relative-to="$(dirname -- "$destination")" "$source")" "$destination"
  fi
done
EOF
  chmod +x -- "$stow"
}

manager() {
  local case_dir=$1
  shift
  env \
    THUNDERBIRD_MANAGE_SKIN_TESTING=1 \
    THUNDERBIRD_PROFILE_ROOT="$case_dir/profiles" \
    THUNDERBIRD_APPLICATION_INI="$case_dir/application.ini" \
    THUNDERBIRD_STOW_BIN="$case_dir/bin/stow" \
    THUNDERBIRD_STOW_TIMEOUT_SECONDS=3 \
    THUNDERBIRD_TEST_RUNNING="${THUNDERBIRD_TEST_RUNNING:-0}" \
    "$case_dir/thunderbird/manage-skin" "$@"
}

checksum() {
  local path=$1
  if [[ -L "$path" ]]; then
    printf 'link:%s\n' "$(readlink -- "$path")"
  elif [[ -e "$path" ]]; then
    sha256sum -- "$path"
  else
    printf 'absent\n'
  fi
}

expect_rejection() {
  local label=$1 expected=$2
  shift 2
  local output
  if output="$("$@" 2>&1)"; then
    fail "$label unexpectedly succeeded"
    return
  fi
  [[ "$output" == *"$expected"* ]] || fail "$label failed without expected diagnostic: $expected"
}

fixture_contract() {
  local mode=$1 case_dir="$2" result
  case "$mode" in
    malformed-contract)
      cp -- "$FIXTURES_DIR/contracts/malformed-DESIGN.md" "$case_dir/thunderbird/DESIGN.md"
      if validate_contracts_at "$case_dir/thunderbird"; then fail 'malformed contract unexpectedly passed'; fi
      ;;
    malformed-preference)
      cp -- "$FIXTURES_DIR/contracts/malformed-user.js" "$case_dir/thunderbird/packages/enable/user.js"
      if validate_contracts_at "$case_dir/thunderbird"; then fail 'malformed preference unexpectedly passed'; fi
      ;;
    missing-selector-section)
      cp -- "$FIXTURES_DIR/contracts/missing-selector-section.md" "$case_dir/thunderbird/selectors-153.0.2.md"
      if validate_contracts_at "$case_dir/thunderbird"; then fail 'missing selector section unexpectedly passed'; fi
      ;;
    *) fail "unknown contract fixture: $mode" ;;
  esac
}

fixture_design_prose_wildcard() {
  local case_dir output css
  case_dir="$(new_case design-prose-wildcard)"
  cat -- "$FIXTURES_DIR/contracts/design-prose-wildcard.md" >> "$case_dir/thunderbird/DESIGN.md"
  bash "$case_dir/thunderbird/tests/validate.sh" rose-pine
  css="$case_dir/thunderbird/packages/rose-pine/chrome/userChrome.css"
  python3 - "$css" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
path.write_text(re.sub(r"^\s*--rp-base:\s*[^;]+;\s*\n", "", path.read_text(encoding="utf-8"), flags=re.M), encoding="utf-8")
PY
  if output="$(bash "$case_dir/thunderbird/tests/validate.sh" rose-pine 2>&1)"; then
    fail 'missing concrete Rose Pine token unexpectedly passed'
    return
  fi
  [[ "$output" == *'missing active :root token declaration: --rp-base'* ]] || fail 'missing concrete Rose Pine token failed without the expected diagnostic'
}

fixture_incidental_token_table() {
  local case_dir output css design
  case_dir="$(new_case incidental-token-table)"
  design="$case_dir/thunderbird/DESIGN.md"
  css="$case_dir/thunderbird/packages/rose-pine/chrome/userChrome.css"
  cat -- "$FIXTURES_DIR/contracts/incidental-token-table.md" >> "$design"
  bash "$case_dir/thunderbird/tests/validate.sh" rose-pine
  python3 - "$design" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
marker = "\n### Color-routing rules"
row = "\n| `--rp-fixture-required` | `#123456` | fixture | authoritative fixture token |\n"
source = path.read_text(encoding="utf-8")
path.write_text(source.replace(marker, row + marker, 1), encoding="utf-8")
PY
  if output="$(bash "$case_dir/thunderbird/tests/validate.sh" rose-pine 2>&1)"; then
    fail 'added authoritative token unexpectedly passed without a CSS declaration'
    return
  fi
  [[ "$output" == *'missing active :root token declaration: --rp-fixture-required'* ]] || fail 'added authoritative token failed without the expected diagnostic'
  python3 - "$design" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
marker = "\n### Color-routing rules"
row = "\n| `--rp-fixture-required` | `#654321` | fixture | conflicting authoritative fixture token |\n"
source = path.read_text(encoding="utf-8")
path.write_text(source.replace(marker, row + marker, 1), encoding="utf-8")
PY
  if output="$(bash "$case_dir/thunderbird/tests/validate.sh" rose-pine 2>&1)"; then
    fail 'conflicting authoritative token values unexpectedly passed'
    return
  fi
  [[ "$output" == *'DESIGN.md has conflicting approved token values: --rp-fixture-required'* ]] || fail 'conflicting authoritative token values failed without the expected diagnostic'
  python3 - "$design" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
source = path.read_text(encoding="utf-8")
path.write_text(source.replace("\n| `--rp-fixture-required` | `#654321` | fixture | conflicting authoritative fixture token |\n", "\n", 1), encoding="utf-8")
PY
  python3 - "$css" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
source = path.read_text(encoding="utf-8")
path.write_text(source.replace("}", "  --rp-fixture-required: #123456;\n}", 1), encoding="utf-8")
PY
  bash "$case_dir/thunderbird/tests/validate.sh" rose-pine
  python3 - "$css" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
path.write_text(re.sub(r"^\s*--rp-fixture-required:\s*[^;]+;\s*\n", "", path.read_text(encoding="utf-8"), flags=re.M), encoding="utf-8")
PY
  if output="$(bash "$case_dir/thunderbird/tests/validate.sh" rose-pine 2>&1)"; then
    fail 'removed concrete CSS token unexpectedly passed'
    return
  fi
  [[ "$output" == *'missing active :root token declaration: --rp-fixture-required'* ]] || fail 'removed concrete CSS token failed without the expected diagnostic'
}

fixture_css() {
  local mode=$1 case_dir="$2" css="$2/thunderbird/packages/outlook/chrome/userChrome.css"
  case "$mode" in
    remote-url|user-content|stale-selector)
      cat -- "$FIXTURES_DIR/css/$mode.css" >> "$css"
      if validate_css_file outlook "$css"; then fail "$mode CSS fixture unexpectedly passed"; fi
      ;;
    comment-only)
      cat -- "$FIXTURES_DIR/css/comment-only.css" > "$css"
      while IFS= read -r token; do printf '/* :root { %s: initial; } */\n' "$token" >> "$css"; done < <(skin_tokens outlook)
      for section in "${SECTIONS[@]}"; do printf '/* section: %s */\n' "$section" >> "$css"; done
      for state in "${STATES[@]}"; do printf '/* state: %s */\n' "$state" >> "$css"; done
      while IFS= read -r selector; do printf '/* %s:focus, %s:focus-visible { color: var(--cw-text-primary); } */\n' "$selector" "$selector" >> "$css"; done < <(selector_ledger)
      if validate_css_file outlook "$css"; then fail 'comment-only CSS fixture unexpectedly passed'; fi
      ;;
    attribute-string-initial)
      cat -- "$FIXTURES_DIR/css/attribute-string-initial.css" > "$css"
      for section in "${SECTIONS[@]}"; do printf '/* section: %s */\n' "$section" >> "$css"; done
      printf ':root {\n' >> "$css"
      while IFS= read -r token; do printf '  %s: initial;\n' "$token" >> "$css"; done < <(skin_tokens outlook)
      printf '}\n' >> "$css"
      while IFS= read -r selector; do printf "[data-contract='%s'] { color: var(--cw-text-primary); }\n" "$selector" >> "$css"; done < <(selector_ledger)
      if validate_css_file outlook "$css"; then fail 'attribute-string-initial CSS fixture unexpectedly passed'; fi
      cat -- "$FIXTURES_DIR/css/attribute-string-initial.css" > "$css"
      for section in "${SECTIONS[@]}"; do printf '/* section: %s */\n' "$section" >> "$css"; done
      printf ':root {\n' >> "$css"
      while IFS=$'\t' read -r token value; do printf '  %s: %s;\n' "$token" "$value" >> "$css"; done < <(fixture_token_values outlook)
      printf '}\n' >> "$css"
      while IFS= read -r selector; do printf "[data-contract='%s'] { color: var(--cw-text-primary); }\n" "$selector" >> "$css"; done < <(selector_ledger)
      if validate_css_file outlook "$css"; then fail 'attribute-string selector CSS fixture unexpectedly passed'; fi
      ;;
    conditional-root|comment-states|conditional-coverage|invalid-attribute-state)
      make_fixture_css "$css" outlook "$mode" "$FIXTURES_DIR/css/$mode.css"
      if validate_css_file outlook "$css"; then fail "$mode CSS fixture unexpectedly passed"; fi
      ;;
    negated-states)
      make_fixture_css "$css" outlook "$mode" "$FIXTURES_DIR/css/$mode.css"
      if validate_css_file outlook "$css"; then fail 'negated-states CSS fixture unexpectedly passed'; fi
      ;;
    positive-not)
      make_fixture_css "$css" outlook "$mode" "$FIXTURES_DIR/css/$mode.css"
      validate_css_file outlook "$css"
      ;;
    inert-declarations)
      make_fixture_css "$css" outlook baseline "$FIXTURES_DIR/css/inert-declarations.css"
      python3 - "$css" <<'PY'
import re
import sys
from pathlib import Path

path = Path(sys.argv[1])
source = path.read_text(encoding="utf-8")
root_end = source.index("}") + 1
path.write_text(source[:root_end] + re.sub(r"\{[^{}]*\}", "{ color: inherit; }", source[root_end:]), encoding="utf-8")
PY
      if validate_css_file outlook "$css"; then fail 'inert-declarations CSS fixture unexpectedly passed'; fi
      ;;
    effective-declarations)
      make_fixture_css "$css" outlook "$mode" "$FIXTURES_DIR/css/effective-declarations.css"
      validate_css_file outlook "$css"
      ;;
    inert-variable-alias|mixed-case-inert-alias|variable-cycle|unresolved-variable)
      make_fixture_css "$css" outlook "$mode" "$FIXTURES_DIR/css/$mode.css"
      if validate_css_file outlook "$css"; then fail "$mode CSS fixture unexpectedly passed"; fi
      ;;
    approved-token-control)
      make_fixture_css "$css" outlook "$mode" "$FIXTURES_DIR/css/approved-token-control.css"
      validate_css_file outlook "$css"
      ;;
    important-token-control)
      make_fixture_css "$css" outlook "$mode" "$FIXTURES_DIR/css/important-token-control.css"
      validate_css_file outlook "$css"
      ;;
    *) fail "unknown CSS fixture: $mode" ;;
  esac
}

fixture_collisions() {
  local case_dir=$1 profile="$1/profiles/profile" before after
  printf 'unmanaged preference\n' > "$profile/user.js"
  before="$(checksum "$profile/user.js")"
  expect_rejection 'unmanaged user.js collision' 'unmanaged user.js' manager "$case_dir" --profile profile install outlook
  after="$(checksum "$profile/user.js")"
  [[ "$before" == "$after" ]] || fail 'unmanaged user.js checksum changed'
  rm -- "$profile/user.js"

  mkdir -p -- "$profile/chrome"
  printf 'unmanaged chrome\n' > "$profile/chrome/userChrome.css"
  before="$(checksum "$profile/chrome/userChrome.css")"
  expect_rejection 'unmanaged userChrome.css collision' 'unmanaged chrome/userChrome.css' manager "$case_dir" --profile profile install outlook
  after="$(checksum "$profile/chrome/userChrome.css")"
  [[ "$before" == "$after" ]] || fail 'unmanaged userChrome.css checksum changed'
}

fixture_manager() {
  local case_dir profile before after output
  case_dir="$(new_case manager)"
  profile="$case_dir/profiles/profile"
  manager "$case_dir" --profile profile status | grep -Fx 'enablement=absent' >/dev/null
  manager "$case_dir" --profile profile install outlook >/dev/null
  [[ -L "$profile/user.js" && -L "$profile/chrome/userChrome.css" ]] || fail 'install did not create managed links'
  manager "$case_dir" --profile profile switch rose-pine >/dev/null
  [[ "$(realpath -e -- "$profile/chrome/userChrome.css")" == "$case_dir/thunderbird/packages/rose-pine/chrome/userChrome.css" ]] || fail 'switch did not activate rose-pine'
  manager "$case_dir" --profile profile uninstall >/dev/null
  [[ ! -e "$profile/user.js" && ! -e "$profile/chrome/userChrome.css" ]] || fail 'uninstall left managed paths'
  manager "$case_dir" --profile profile uninstall >/dev/null

  fixture_collisions "$case_dir"
  rm -f -- "$profile/chrome/userChrome.css"
  ln -s -- "$(realpath --relative-to="$profile" "$case_dir/thunderbird/packages/enable/user.js")" "$profile/user.js"
  before="$(checksum "$profile/user.js")"
  expect_rejection 'stale incomplete state' 'managed skin state is incomplete' manager "$case_dir" --profile profile uninstall
  [[ "$before" == "$(checksum "$profile/user.js")" ]] || fail 'stale state was modified'
  rm -- "$profile/user.js"

  before="$(checksum "$profile/user.js")"
  THUNDERBIRD_TEST_RUNNING=1 expect_rejection 'running Thunderbird' 'Thunderbird appears to be running' manager "$case_dir" --profile profile install outlook
  [[ "$before" == "$(checksum "$profile/user.js")" ]] || fail 'running-state rejection modified the profile'
  printf 'untracked fixture sentinel\n' > "$case_dir/dirty-worktree-sentinel"
  before="$(checksum "$case_dir/dirty-worktree-sentinel")"
  (cd -- "$case_dir" && manager "$case_dir" --profile profile install outlook >/dev/null)
  [[ "$before" == "$(checksum "$case_dir/dirty-worktree-sentinel")" ]] || fail 'dirty-worktree sentinel changed'
  manager "$case_dir" --profile profile uninstall >/dev/null

  case_dir="$(new_case misleading-success)"
  profile="$case_dir/profiles/profile"
  before="$(checksum "$profile/user.js") $(checksum "$profile/chrome/userChrome.css")"
  FAKE_STOW_MISLEAD=1 expect_rejection 'misleading Stow success' 'Stow reported success' manager "$case_dir" --profile profile install outlook
  after="$(checksum "$profile/user.js") $(checksum "$profile/chrome/userChrome.css")"
  [[ "$before" == "$after" ]] || fail 'misleading-success fixture changed managed paths'
}

run_fixture() {
  local mode=$1 case_dir
  case "$mode" in
    malformed-contract|malformed-preference|missing-selector-section)
      case_dir="$(new_case "$mode")"; fixture_contract "$mode" "$case_dir" ;;
    design-prose-wildcard) fixture_design_prose_wildcard ;;
    incidental-token-table) fixture_incidental_token_table ;;
    remote-url|user-content|stale-selector|comment-only|attribute-string-initial|conditional-root|comment-states|conditional-coverage|invalid-attribute-state|negated-states|positive-not|inert-declarations|effective-declarations|inert-variable-alias|mixed-case-inert-alias|variable-cycle|unresolved-variable|approved-token-control|important-token-control)
      case_dir="$(new_case "$mode")"; fixture_css "$mode" "$case_dir" ;;
    collision-user-js|collision-user-chrome|collisions)
      case_dir="$(new_case collisions)"; fixture_collisions "$case_dir" ;;
    manager) fixture_manager ;;
    *) fail "unknown fixture target: $mode" ;;
  esac
  printf 'validate: fixture passed: %s\n' "$mode"
}

fixtures() {
  local target
  for target in malformed-contract malformed-preference missing-selector-section design-prose-wildcard incidental-token-table remote-url user-content stale-selector comment-only attribute-string-initial conditional-root comment-states conditional-coverage invalid-attribute-state negated-states positive-not inert-declarations effective-declarations inert-variable-alias mixed-case-inert-alias variable-cycle unresolved-variable approved-token-control important-token-control collisions manager; do
    run_fixture "$target"
  done
}

usage() {
  cat <<'EOF'
Usage: bash thunderbird/tests/validate.sh [contracts|fixtures|outlook|rose-pine|fixture NAME]

Without an argument, validates contracts, fixtures, and both CSS skins. CSS targets
return 2 with an explicit incomplete diagnostic until their userChrome.css exists.
Fixture names: malformed-contract, malformed-preference, missing-selector-section,
design-prose-wildcard, incidental-token-table, remote-url, user-content, stale-selector, comment-only, attribute-string-initial, conditional-root, comment-states, conditional-coverage, invalid-attribute-state, negated-states, positive-not, inert-declarations, effective-declarations, inert-variable-alias, mixed-case-inert-alias, variable-cycle, unresolved-variable, approved-token-control, important-token-control, collision-user-js, collision-user-chrome,
collisions, manager.
EOF
}

main() {
  [[ -d "$RUNTIME_DIR" ]] || { printf 'validate: runtime directory is missing: %s\n' "$RUNTIME_DIR" >&2; return 1; }
  WORK_ROOT="$(mktemp -d "$RUNTIME_DIR/thunderbird-validate.XXXXXX")"
  case "${1:-all}" in
    contracts) validate_contracts_at "$THUNDERBIRD_DIR"; printf 'validate: contracts passed\n' ;;
    fixtures) fixtures ;;
    outlook|rose-pine) validate_skin "$1" ;;
    fixture) [[ $# -eq 2 ]] || { usage >&2; return 64; }; run_fixture "$2" ;;
    all) validate_contracts_at "$THUNDERBIRD_DIR" && fixtures && validate_skin outlook && validate_skin rose-pine ;;
    --help|-h) usage ;;
    *) usage >&2; return 64 ;;
  esac
}

main "$@"

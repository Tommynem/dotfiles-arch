# Thunderbird dual-skin design contract

**Scope.** This contract governs `userChrome.css` application chrome for the
Thunderbird 153.0.2 package only. It is the implementation source of truth:
every CSS color, font, spacing, radius, border, shadow, and transition must map
to a token below. It does not authorize CSS yet.

## 1. Atmosphere & identity

Two intentional modes share one accessible information model. **Coworker** is a
light-only, roomy, calm mail workspace: neutral paper-like panes make dense
mail intelligible, while one restrained blue identifies actions, selection, and
keyboard focus. **Personal** is a polished terminal-adjacent command surface:
Rosé Pine's tinted dark layers, precise outlines, and mono-forward chrome make
state and hierarchy legible without neon, glow, dense clutter, or faux-hacker
decoration. The memorable contrast is not a brand imitation: it is the same
mail workflow expressed as either approachable daylight or quiet, disciplined
developer tooling.

### Content and platform boundaries

- Style only Thunderbird chrome whose selector contract is later proven for
  Thunderbird 153.0.2. Native title bars, OS dialogs, file pickers,
  notifications, closed shadow trees, and unavailable `::part`s are out of
  scope.
- Never target rendered message documents, remote/content tabs, HTML message
  bodies, quote blocks, attachment previews, the compose editor document, or
  any `userContent.css` context. The message reader and compose **chrome** may
  be styled; authored and received content remains Thunderbird/user controlled.
- Do not load remote/data assets, bundled fonts, logos, product marks, or copied
  iconography. Use Thunderbird-native icons and controls only; the words
  “Outlook-inspired” describe visual grammar, never visible branding.
- The shared hierarchy must preserve sender, subject, date, unread, selected,
  error, and disabled distinctions without relying on color alone.

### Shared accessibility and content rules

- Keyboard focus is always visible (`focus-visible` only), has a 2px ring that
  reaches 3:1 against its adjacent surface, and is never replaced by selection.
- Normal chrome text, essential text-bearing icons, and readable disabled text
  target WCAG 2.2 AA 4.5:1; large text targets 3:1. Focus indicators and enabled
  interactive boundaries target 3:1. Purely decorative dividers and a disabled
  control's non-text boundary are exempt, but must never be the sole focus,
  selected, unread, error, or enabled-control signal. If a native icon cannot
  meet its applicable threshold, retain its semantic label/tooltip rather than
  hiding it.
- Hover is supplementary; all commands remain discoverable and operable by
  keyboard. Pressed feedback is brief and does not move layout. Disabled items
  remain identifiable but do not masquerade as unread or selected content.
- Preserve native zoom, reduced-motion, high-contrast/forced-colors behavior,
  and platform focus semantics. Under `prefers-reduced-motion`, eliminate all
  non-essential opacity/transform transitions.
- Body copy, sender/subject content, and compose-editor content retain the
  Thunderbird/document font and user text settings. Mono styling applies only
  to application chrome labels, compact metadata, counters, toolbar commands,
  and optional code-like utility labels—not message/editor content.

## 2. Color

### Provenance and token policy

| Source ID | Read-only source | What it establishes |
| --- | --- | --- |
| `O1` | Microsoft Design, “Redefining productivity with Outlook”, opened 2026-08-25 | White/neutral surface grammar, Segoe UI Variable stack, blue interactive text (`rgb(0, 103, 184)` / `#0067B8` observed), and an explicit focus on craftsmanship, personalization, responsive density, and non-overwhelming motion. Visual data only; no branding/assets/copy are reused. |
| `O2` | Official inbox reference image named in the plan | A light three-pane inbox grammar: quiet white canvas, pale pane separation, blue selected/action signal, roomy rows, and prominent search/primary actions. It is visual data only and is not downloaded or embedded. |
| `R1` | `~/.config/omarchy/themes/rose-pine-dark/hyprland.conf:5-24` | Canonical Rosé Pine base/surfaces/text/highlights/accent values and restrained active-border gradient routing. |
| `R2` | `kitty.conf:1-34`, `walker.css:1-6`, `alacritty.toml:1-29` in that same active-theme directory | Terminal/launcher confirmation of foreground, selection, cursor/border, active/inactive tabs, and accent values. |
| `R3` | Repository `alacritty/.config/alacritty/alacritty.toml:4-17` | The active Omarchy theme import and local mono window precedent; it is not a runtime dependency for Thunderbird. |

Values marked **adaptation** are approved implementation values selected to
express the cited grammar; they are not claimed to be copied product tokens.
No unlisted raw color, shadow pigment, or shadow recipe is permitted in either
skin: every visual value must resolve through a semantic token in this contract.

### Coworker light semantic tokens

| Token | Approved value | Provenance | Use |
| --- | --- | --- | --- |
| `--cw-surface-app` | `#F8F9FA` | O1/O2 adaptation | window and spaces-rail ground |
| `--cw-surface-pane` | `#FFFFFF` | O1/O2 adaptation | folder, thread, reader, editor chrome |
| `--cw-surface-raised` | `#FFFFFF` | O1/O2 adaptation | menu, popover, dialog, active toolbar group |
| `--cw-surface-hover` | `#F3F4F6` | O1/O2 adaptation | hover fill |
| `--cw-surface-pressed` | `#E7EAEE` | O1/O2 adaptation | pressed fill |
| `--cw-surface-selected` | `#E8F2FC` | O1/O2 adaptation | selected row/navigation item |
| `--cw-text-primary` | `#242424` | O1 observed neutral text family | sender, subject, headings, commands |
| `--cw-text-secondary` | `#616161` | O1/O2 adaptation | metadata and inactive labels |
| `--cw-text-disabled` | `#707070` | O1/O2 adaptation | readable disabled text; 4.95:1 on `--cw-surface-pane` |
| `--cw-border-subtle` | `#EDEDED` | O1/O2 adaptation | decorative low-emphasis divider only |
| `--cw-border-default` | `#D1D1D1` | O1/O2 adaptation | decorative pane divider only; not an interactive boundary |
| `--cw-border-strong` | `#767676` | O1/O2 adaptation | enabled field/control boundary; 4.54:1 on `--cw-surface-pane` |
| `--cw-accent` | `#0067B8` | O1 observed | primary action, link, focus, selected text marker |
| `--cw-accent-hover` | `#005A9E` | O1 adaptation | hover primary action |
| `--cw-accent-pressed` | `#004578` | O1 adaptation | pressed primary action |
| `--cw-focus` | `#0067B8` | O1 observed | focus-visible ring |
| `--cw-status-success` | `#107C10` | adaptation | confirmation only |
| `--cw-status-warning` | `#8A5A00` | adaptation | caution only |
| `--cw-status-error` | `#C50F1F` | adaptation | validation/connection error |
| `--cw-status-info` | `#0067B8` | O1 observed | informational message |
| `--cw-shadow-color` | `rgb(36 36 36 / 12%)` | O1/O2 adaptation | approved semantic pigment for the one light elevation shadow |

### Personal Rosé Pine semantic tokens

| Token | Approved value | Provenance | Use |
| --- | --- | --- | --- |
| `--rp-base` | `#191724` | R1/R2 | app ground and inactive regions |
| `--rp-surface` | `#1F1D2E` | R1 | primary pane material |
| `--rp-overlay` | `#26233A` | R1/R2 | raised pane, menu, dialog, active tab |
| `--rp-highlight-low` | `#21202E` | R1 | low active/hover tonal change |
| `--rp-highlight-med` | `#403D52` | R1/R2 | selected-row fill or decorative divider; never the only selected/focus/control signal |
| `--rp-highlight-high` | `#524F67` | R1/R2 | decorative inactive outline/cursor-adjacent contrast; never the only interactive boundary |
| `--rp-muted` | `#6E6A86` | R1/R2 | decorative inactive marker only; not text or the only enabled-control boundary |
| `--rp-subtle` | `#908CAA` | R1 | readable secondary/disabled chrome text and enabled control boundary on base/surface/overlay; never selected-highlight label text |
| `--rp-text` | `#E0DEF4` | R1/R2 | primary chrome text/icons |
| `--rp-love` | `#EB6F92` | R1/R2 | destructive/error marker or label on base/surface/overlay only; never selected-highlight label text |
| `--rp-gold` | `#F6C177` | R1/R2 | warning/attention only |
| `--rp-pine` | `#31748F` | R1/R2 | active pane indicator against base/surface only; never overlay indicator/boundary, text-bearing fill, or focus ring |
| `--rp-foam` | `#9CCFD8` | R1/R2 | focus ring, primary action text/outline, info/link; 8.91:1 minimum on approved surfaces |
| `--rp-iris` | `#C4A7E7` | R1/R2 | secondary command text/outline only |
| `--rp-rose` | `#EBBCBA` | R1/R2 | selected/current marker; 9.76:1 minimum on approved surfaces |
| `--rp-status-success` | `#31748F` | R1 adaptation | success marker only on base/surface; success label always uses `--rp-text` |
| `--rp-status-warning` | `#F6C177` | R1 | warning |
| `--rp-status-error` | `#EB6F92` | R1 | error/destructive |
| `--rp-status-info` | `#9CCFD8` | R1 | informational |

### Color-routing rules

- Coworker uses blue only for intentional interaction/focus and selection; it
  is never decorative. Low-contrast neutral dividers carry passive structure;
  enabled fields and controls use `--cw-border-strong` or the focus token.
- Personal uses one accent per meaning: pine = active/primary, foam = focus or
  information, rose = current selection/emphasis, iris = secondary utility,
  gold = warning, love = error. Pine is an active indicator only where it clears
  3:1 on base/surface and is never used on overlay; foam/rose provide the
  sufficient-contrast focus/selection signal. On overlay, use foam/rose/text as
  appropriate for an indicator, boundary, or label. Do not blend all accents
  into one control.
- Unread is a text-weight/marker distinction, selected is a surface distinction,
  and focus is an outline distinction. They may coexist and must remain legible;
  neither `--rp-highlight-*` nor a decorative divider may be the only signal.
- A selected or pressed `--rp-highlight-med` surface routes every text-bearing role—ordinary, status, success, and error labels, plus essential status icons—through `--rp-text`, `--rp-foam`, or `--rp-rose` only. It must not use
  `--rp-subtle`, `--rp-love`, `--rp-status-success`, or `--rp-status-error`
  there; preserve success/error meaning with native icon, wording, and/or a
  non-color marker.

## 3. Typography

### Approved font stacks

| System | Chrome/UI stack | Content exception |
| --- | --- | --- |
| Coworker | `"Segoe UI Variable", "Segoe UI", "Adwaita Sans", system-ui, sans-serif` | Do not impose this stack on rendered messages or compose editor content. |
| Personal | `"JetBrainsMono Nerd Font", "CaskaydiaMono Nerd Font", "JetBrains Mono", ui-monospace, monospace` | Restrict to application chrome and metadata. Rendered message/editor content retains Thunderbird/user font settings. |

### Shared type scale

| Token | Size / line height | Weight | Tracking | Use |
| --- | --- | --- | --- |
| `--type-command` | `14px / 20px` | 400 | normal | toolbar, folders, menus, controls |
| `--type-list` | `14px / 20px` | 400 | normal | thread rows and ordinary labels |
| `--type-meta` | `12px / 16px` | 400 | `0.01em` | date, count, utility metadata |
| `--type-label` | `12px / 16px` | 600 | `0.02em` | compact section/control labels |
| `--type-title` | `16px / 22px` | 600 | normal | reader/compose/page title chrome |
| `--type-unread` | inherit | 600 | inherit | sender/subject; never all-caps |

Coworker uses the scale at ordinary font proportions with line-height favoring
scanning. Personal retains the same readable sizes; mono is not license to
shrink content below `--type-meta` or to make mail rows dense.

## 4. Spacing & layout

### Shared spacing, dimensions, and radii

All dimensions map to this 4px system; no incidental spacing values are allowed.

| Token | Value | Use |
| --- | --- | --- |
| `--space-1` | `4px` | icon gap, fine internal offset |
| `--space-2` | `8px` | compact groups, row inset |
| `--space-3` | `12px` | standard control inset |
| `--space-4` | `16px` | comfortable control/pane inset |
| `--space-5` | `20px` | roomy toolbar/section inset |
| `--space-6` | `24px` | dialog and major pane inset |
| `--space-8` | `32px` | separated regions |
| `--size-icon` | `16px` | native toolbar/list icon target |
| `--size-control` | `32px` | minimum regular command/search control height |
| `--size-row-coworker` | `44px` | default light folder/thread/action row minimum |
| `--size-row-personal` | `36px` | default personal folder/thread/action row minimum |
| `--radius-none` | `0` | Rosé Pine pane dividers and dense rail joins |
| `--radius-tight` | `4px` | Personal controls/rows, Coworker small controls |
| `--radius-standard` | `6px` | Coworker inputs/actions, Personal raised layers |
| `--radius-dialog` | `8px` | dialog/popover outer shell only |
| `--border-width` | `1px` | decorative and interactive outline geometry; the semantic color decides its accessibility role |
| `--focus-width` | `2px` | focus-visible outline/ring |

### Layout grammar

- Retain Thunderbird's responsive three-pane architecture: spaces rail,
  navigation/folder pane, thread pane, reader; do not reorder DOM or hide
  essential commands. At constrained widths, preserve native collapse behavior.
- Coworker panes separate primarily with decorative `--cw-border-subtle/default`
  and generous `--space-3/4` insets. Enabled search/field boundaries use
  `--cw-border-strong`, and focus uses `--cw-focus`; search and primary actions
  are easy to find, not oversized or branded.
- Personal panes separate with decorative `1px` `--rp-highlight-med/high`
  outlines, `--space-2/3` insets, and short tonal steps. Enabled controls use
  `--rp-subtle`; focus uses `--rp-foam`; selection includes a `--rp-rose` marker.
  An active pane may receive one pine border only on base/surface. It must not
  receive glow, gradients, or a full-frame neon edge.

## 5. Components and core-surface anatomy

### State contract used by every interactive surface

| State | Coworker treatment | Personal treatment | Non-negotiable behavior |
| --- | --- | --- | --- |
| Default | token-appropriate pane/transparent control; neutral text | base/surface/overlay by elevation; text/subtle hierarchy | no decorative accent |
| Hover | `--cw-surface-hover`; preserve text contrast | `--rp-highlight-low`; preserve accessible outline when enabled | pointer affordance only |
| Pressed | `--cw-surface-pressed` | `--rp-highlight-med`; ordinary/status/success/error labels and essential status icons use `--rp-text`, `--rp-foam`, or `--rp-rose` only | 100ms opacity/transform only; no layout shift |
| Focus-visible | 2px `--cw-focus` ring | 2px `--rp-foam` ring | keyboard-visible, 3:1 minimum, and distinct from selected |
| Selected/current | `--cw-surface-selected` plus `--cw-accent` marker/text | `--rp-highlight-med` plus `--rp-rose` marker; inherits the selected-or-pressed safe label/icon route | marker, not low-contrast fill alone, survives hover and unread; never use disallowed semantic status tokens on highlight-med |
| Disabled | `--cw-text-disabled`, no hover/press | `--rp-subtle` readable text, no hover/press | readable text remains AA; a disabled non-text boundary may be decorative/exempt |
| Unread | `--type-unread`, primary text, optional accent marker | `--type-unread`, `--rp-text`, optional rose marker | no color-only meaning |
| Error | `--cw-status-error` text/icon/border, concise native message | `--rp-status-error` label only where it meets 4.5:1; on selected or pressed highlight-med use `--rp-text`/foam/rose label plus native error icon/wording | never an error-colored whole pane without text |

### Core-surface matrix

Every row implements every state from the state contract when the native control
supports it. A non-interactive subpart has default/disabled/error only; it never
manufactures a fake hover or pressed state.

| Core surface | Anatomy and hierarchy | Default / hover / pressed | Focus-visible / selected / disabled | Unread / error |
| --- | --- | --- | --- | --- |
| Spaces rail | narrow app-level rail; native icons in a vertically spaced command group | cw app ground / hover fill / pressed fill; rp base with 1px separators / low / med | ring on focused icon; selected app gets cw blue or rp pine border; disabled muted | unread badge is native/semantic with adjacent accessible label; sync failure uses status-error icon/text |
| Tabs and unified toolbar | tab strip, active tab, search, primary compose/action, secondary command groups | cw pane with modest 4–6px control corners; rp base/overlay active tab, decorative 1px boundaries | focused control ring; selected tab uses cw selected or rp overlay+rose marker; disabled has no fill | unread tab count remains text/badge; command error appears in native error region |
| Folder/navigation pane | account/folder tree, disclosure control, counts, “new folder” and compact headers | roomy cw 44px rows; rp 36px rows with 4px row radius | focused treeitem ring; current folder selected; disabled accounts muted | unread folder is weighted plus count; account/network error uses status line/icon |
| Thread list: table layout | row with sender, subject/snippet, date, tags, star/flag and selection column | cw white rows with quiet dividers; rp surface rows with crisp divider; hover/pressed per state contract | row/action focus ring; selected background plus marker; disabled row remains readable | unread sender/subject weighted; error/status row uses icon + concise text |
| Thread list: card layout | card row preserves sender/subject/metadata order and native quick actions | cw card-like surface without heavy shadows; rp outlined surface, no oversized rounding | card/quick-action focus ring; selected state as above; unavailable action disabled | unread is weighted/marked; error stays local to affected card/action |
| Reader header and attachment chrome | sender block, subject, date, reply/forward actions, attachment strip/chips | cw spacious header and subtle chip fill; rp surface/overlay header and outlined attachments | each command focusable; selected attachment uses system selected token; unavailable action disabled | message unread indicator remains semantic; attachment load/error uses status token + text |
| Compose chrome | recipient/header fields, formatting/command toolbar, send and attach controls, status strip | cw raised editable chrome and blue primary Send; rp outlined overlay controls with foam primary Send label/outline and foam/rose success/current indicator | field/control ring; selected recipients/chips use selected token; disabled Send clearly muted | recipient unread is not applicable; validation/send failure uses error text/icon in chrome only |
| Address book | sidebar/list/detail, search, contact actions and selection | cw roomy list/detail panes; rp crisp outlined panes, no contact-content restyle | focus ring on search/list/actions; selected contact clear; disabled actions muted | unread not applicable; sync/validation error local and textual |
| Calendar, tasks, and today pane | calendar grid, task list, event row, today summary and action controls | cw neutral grid with blue current/selected marker; rp surface grid with pine active boundary | keyboard cell/event focus ring; selected/current remains distinct; disabled dates/actions muted | unread not applicable; calendar/task error uses status-error label/icon |
| Settings, add-ons, and account setup | category navigation, form fields, toggles, cards/sections, primary/secondary actions | cw is spacious and form-led; rp is outlined and text-led, not terminal parody | standard form focus ring; selected category clear; disabled form action readable | unread not applicable; field/account error is adjacent text/icon and error border |
| Menus, popovers, dialogs | raised shell, menuitem/list, field/action footer, dismiss control | cw white raised shell with subtle outline; rp overlay shell with 1px high outline; no heavy shadow/glow | menu/dialog keyboard ring; selected menuitem clear; disabled no hover | unread submenu count semantic; error dialog/inline alert uses error token plus text |

### Reusable primitive rules

| Primitive | Structure | Variants | Spacing and material | Accessibility / motion |
| --- | --- | --- | --- | --- |
| Command control | native icon, optional label, accessible tooltip | primary, secondary, icon-only, disabled | icon-label `--space-2`; cw 6px, rp 4px radius | all state-contract states; 100ms press transition only |
| Search/input | native field, leading native icon, optional clear control | regular, focused, invalid, disabled | `--space-3` inset, `--size-control`, cw pane/rp overlay | label/name retained; invalid state uses text + error token; no motion beyond focus transition |
| Navigation/list row | optional disclosure/icon, primary label, secondary count/meta, trailing action | default, current, unread, disabled, error | cw `--size-row-coworker` / rp `--size-row-personal`; `--space-2/3` horizontal inset | tree/list keyboard navigation retained; row and trailing action have separable focus |
| Pane | header, scrollable native body, optional footer/action | base, raised, active, error | cw decorative divider plus accessible enabled control boundary; rp decorative 1px outline/tonal layers | never traps focus; focus/selection do not rely on pane outline; only active base/surface pane receives restrained pine border |
| Status message | native icon, concise sentence, optional retry command | info, success, warning, error | `--space-2/3`, no decorative banner | success label is `--rp-text`; Pine is only a base/surface marker. On selected or pressed highlight-med, every ordinary/status/success/error label and essential status icon is text/foam/rose; retry receives state contract |

## 6. Motion & interaction

| Token | Value | Use |
| --- | --- | --- |
| `--motion-press` | `100ms ease-out` | pressed fill/transform |
| `--motion-state` | `150ms ease-out` | hover/focus/color transition |
| `--motion-panel` | `200ms cubic-bezier(0.2, 0, 0, 1)` | native-supported popover/pane transition |

- Animate only `opacity`, `transform`, and color/outline paint; never position,
  dimension, or layout. Do not add decorative animation to mail rows, panes, or
  backgrounds.
- Motion explains a command, focus change, or native panel state. It must not
  imitate a terminal cursor, scan line, glow pulse, or branded product motion.
- `prefers-reduced-motion: reduce` collapses the above durations to `0ms` for
  non-essential motion while retaining immediate focus/selected feedback.

## 7. Depth & surface

### Coworker: light border-and-tonal hierarchy

Use white/pale neutral surfaces separated by `--cw-border-subtle/default` and
small tonal shifts. Popovers/dialogs can use one subtle elevation treatment
only if native chrome needs separation:

| Token | Approved value | Provenance | Use |
| --- | --- | --- | --- |
| `--cw-shadow-popover` | `0 2px 8px var(--cw-shadow-color)` | O1/O2 adaptation | the only allowed Coworker raised-shell shadow |

The shadow's pigment resolves through `--cw-shadow-color`; neither its pigment
nor its recipe may be restated as a raw CSS value. Do not create floating card
grids, glass, gradients, or conspicuous shadows.

### Personal: dark tonal layers with crisp outlines

Use `base → surface → overlay` as the elevation ramp. A decorative pane divider
is exactly `--border-width solid` using `--rp-highlight-med/high`; it is not an
enabled-control boundary. Enabled controls use `--rp-subtle`; keyboard focus
uses `--rp-foam`; selection includes a `--rp-rose` marker. Active base/surface
context may replace one decorative edge with `--rp-pine`; overlay context must
use foam/rose/text instead because Pine is only 2.91:1 on overlay. No blur,
drop-shadow glow, gradient background, neon effect, decorative grid, or
arbitrary rounded card stack is permitted. This is a Quickshell/terminal-like
precision grammar, not a fake terminal UI.

## Implementation handoff and QA gates

1. Later CSS must declare local custom properties from the chosen system only;
   it must not import the mutable Omarchy theme path. Rosé Pine values are
   copied from the verified baseline so the skin is self-contained.
2. Selector work must prove each application-chrome selector against the pinned
   Thunderbird build. Unsupported/native/content surfaces stay unstyled rather
   than receiving guessed fallbacks.
3. Before any CSS is accepted, audit for every required surface, all eight
   states, exact token provenance, no unlisted raw colors/shadows/dimensions,
   measured AA text contrast, measured 3:1 focus/enabled-boundary contrast, no
   remote assets/branding, and no message/editor content scope.
4. Manual visual QA later checks both modes across mail, compose, address book,
   calendar/tasks/today, settings/add-ons/account setup, menus/popovers/dialogs,
   focus traversal, unread/selection coexistence, disabled/error clarity, and
   reduced-motion/high-contrast behavior. Message/account content must be
   redacted in any captured evidence.

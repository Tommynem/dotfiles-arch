# Thunderbird 153.0.2 selector and core-surface contract

## Pin and evidence method

This contract is pinned to Thunderbird **153.0.2**, BuildID
**20260813184934**, from `/usr/lib/thunderbird/application.ini`. It applies
only while `/usr/lib/thunderbird/omni.ja` has SHA-256
`046289bc0502f312aba20ca6be493f5525c96b61274c9d0b8dd7aec19aafc8b0`.

Each non-unsupported selector below is an exact token from the installed
archive member named in the selector ledger. Archive presence proves the
version-specific DOM/CSS contract; it does not promise that Mozilla will keep
it stable. `Verified—runtime check` means the token was proven in the archive
and must additionally be proven to load from `userChrome.css` during the later
runtime validation. Both planned skins have the same coverage expectation:
style every **Verified** or **Verified—runtime check** row and the states that
its installed CSS exposes; do not add an unsupported fallback.

The temporary inspection set consisted only of these installed members:

- `chrome/messenger/content/messenger/messenger.xhtml`
- `chrome/messenger/content/messenger/about3Pane.xhtml`
- `chrome/messenger/content/messenger/aboutMessage.xhtml`
- `chrome/messenger/content/messenger/messengercompose/messengercompose.xhtml`
- `chrome/messenger/content/messenger/addressbook/aboutAddressBook.xhtml`
- `chrome/messenger/content/messenger/preferences/preferences.xhtml`
- `chrome/messenger/content/messenger/AccountManager.xhtml`
- `chrome/messenger/content/messenger/AccountWizard.xhtml`
- `chrome/messenger/content/messenger/accountcreation/accountHub.js`
- `chrome/messenger/content/messenger/{about3Pane,aboutMessage,message-pane,tree-view,auto-tree-view,thread-row,thread-card,folder-tree-row,spacesToolbar,customElements}.js|mjs`
- `chrome/messenger/content/messenger/unifiedtoolbar/unified-toolbar.mjs`
- `chrome/classic/skin/classic/messenger/{about3Pane,aboutMessage,aboutAddressBook,folderPane,messageHeader,messenger,spacesToolbar}.css`
- `chrome/classic/skin/classic/messenger/shared/{threadPane,spacesToolbar,unifiedToolbar,unifiedToolbarTab,preferences,contextMenu,messageHeader}.css`
- `chrome/classic/skin/classic/messenger/messengercompose/messengercompose.css`
- `chrome/calendar/skin/classic/calendar/{calendar,today-pane}.css`
- `chrome/calendar/skin/classic/calendar/shared/{today-pane,calendar-task-tree,calendar-task-view,calendar-views}.css`
- `chrome/toolkit/{content/global/elements/{menupopup,panel,menulist}.js,content/mozapps/extensions/{aboutaddons.html,aboutaddons.css},skin/classic/global/{menu,popup}.css}`

## Surface and state matrix

| Surface | States covered or explicitly bounded | Selectors | Installed archive evidence | Both-skin coverage expectation | Status |
| --- | --- | --- | --- | --- | --- |
| Messenger shell, spaces rail, unified toolbar, tabs | Default, hover, pressed, keyboard focus, selected/current tab, disabled toolbar controls, customization UI | `#spacesToolbar`, `#unifiedToolbar`, `.unified-toolbar`, `#tabmail-tabs`, `.tabmail-tab` | `chrome/messenger/content/messenger/messenger.xhtml`; `chrome/classic/skin/classic/messenger/shared/{spacesToolbar,unifiedToolbar,unifiedToolbarTab}.css` | Both theme the listed shell chrome and visible interaction states. | Verified |
| Folder pane | Default, hover, focus-visible, selected, unread, new messages, collapsed child unread, drag/context target, disabled header buttons | `#folderPane`, `#folderTree`, `#folderPaneWriteMessage`, `.unread-count`, `.new-messages` | `chrome/messenger/content/messenger/about3Pane.xhtml`; `chrome/messenger/content/messenger/folder-tree-row.mjs`; `chrome/classic/skin/classic/messenger/about3Pane.css` | Both theme pane, rows, badges, and supported states after runtime loading is proven. | Verified—runtime check |
| Thread table layout | Default, hover, focus/focus-within, selected, unread, tagged, flagged, junk, attachment, replied/forwarded/redirected, current cell | `#threadTree`, `.table-layout`, `[data-properties~="unread"]`, `.tree-button-flag`, `.tree-button-spam` | `chrome/messenger/content/messenger/{about3Pane.xhtml,thread-row.mjs}`; `chrome/classic/skin/classic/messenger/shared/threadPane.css` | Both theme list rows, selection/focus, unread/tag/status signals, and row action controls. | Verified—runtime check |
| Thread card layout | Default, hover, focus/focus-within, selected, unread, tagged, flagged, junk, attachment, reply/forward state | `.card-layout`, `.thread-card-subject-container`, `.thread-card-icon-info`, `.button-star`, `.attachment-icon` | `chrome/messenger/content/messenger/{about3Pane.xhtml,thread-card.mjs}`; `chrome/classic/skin/classic/messenger/shared/threadPane.css` | Both theme card rows and the same semantic states as table layout; no table-only assumption. | Verified—runtime check |
| Reader chrome and attachment chrome | Default, hover, active, focus-visible, expanded/collapsed attachment bar, selected attachment | `#messagePane`, `#messageHeader`, `#attachmentBar`, `#attachmentList`, `#attachmentToggle` | `chrome/messenger/content/messenger/{about3Pane.xhtml,aboutMessage.xhtml}`; `chrome/classic/skin/classic/messenger/shared/messageHeader.css` | Both theme message header and attachment controls only. | Verified—runtime check |
| Rendered message document | Rendered HTML/plain-text message body, remote content, message iframe/browser descendants | `#messageBrowser` is a host only; no descendant selector is allowed | `chrome/messenger/content/messenger/{about3Pane.xhtml,message-pane.mjs}` proves the separate browser and `contentDocument` boundary. | Neither skin styles rendered message content. | Unsupported |
| Compose chrome | Default, hover, active, focus-visible, disabled controls, attachment bucket; rich-text editor document excluded | `#compose-toolbox`, `#composeToolbar2`, `#msgSubject`, `#attachmentBucket` | `chrome/messenger/content/messenger/messengercompose/messengercompose.xhtml`; `chrome/classic/skin/classic/messenger/messengercompose/messengercompose.css` | Both theme toolbar, subject, and attachment chrome without targeting the editor document. | Verified |
| Compose editor document | Editable rich-text/plain-text body and its document descendants | `#composeContentBox` is intentionally not a styling target | `chrome/messenger/content/messenger/messengercompose/messengercompose.xhtml` contains the editor container; it is outside this chrome contract. | Neither skin styles editor content. | Unsupported |
| Address book | Default, hover, focus-visible, selected book/list/card, primary/disabled controls, details chrome | `#booksPane`, `#books`, `.bookRow`, `#cardsPane`, `#cards`, `#detailsPane` | `chrome/messenger/content/messenger/addressbook/aboutAddressBook.xhtml`; `chrome/classic/skin/classic/messenger/aboutAddressBook.css` | Both theme the address-book application surface and selection states. | Verified—runtime check |
| Calendar and tasks | Default, hover, active, focus-visible, checked/selected calendar list, task rows, disabled controls | `#calendar-list`, `#calendar-task-tree`, `#calendar-add-task-button`, `#calendar-task-details` | `chrome/messenger/content/messenger/messenger.xhtml`; `chrome/calendar/skin/classic/calendar/shared/{calendar-task-tree,calendar-task-view,calendar-views}.css` | Both theme calendar/task chrome and documented states. | Verified |
| Today pane | Default, hover, active, focus-visible, selected agenda item, past/now/all-day agenda states, hidden/collapsed pane | `#today-pane-panel`, `#agenda`, `.agenda-listitem-details`, `#unifinder-todo-tree`, `.today-pane-cycler` | `chrome/messenger/content/messenger/messenger.xhtml`; `chrome/calendar/skin/classic/calendar/shared/today-pane.css` | Both theme pane header, agenda, and todo chrome. | Verified |
| Settings and add-ons | Browser host only; settings/add-ons document contents and native file picker are excluded | `#preferencesbrowser`; `#categories` and `#addonsButton` are evidence-only content selectors | `chrome/messenger/content/messenger/messenger.xhtml`; `chrome/messenger/content/messenger/preferences/preferences.xhtml`; `chrome/toolkit/content/mozapps/extensions/aboutaddons.html` | Both may style only the host-level chrome where it is exposed; neither claims inner settings/add-ons document styling. | Host verified; inner content unsupported |
| Account setup and account management | Account Hub modal/default controls when present; transient flow internals require runtime proof; OS/native account/file dialogs excluded | `account-hub-container`, `.account-hub-view`, `#tabmail` | `chrome/messenger/content/messenger/accountcreation/accountHub.js`; `chrome/messenger/content/messenger/{AccountManager,AccountWizard}.xhtml`; `chrome/classic/skin/classic/messenger/accountHub.css` | Both style only archive-proven modal chrome after runtime proof; native dialogs remain unstyled. | Verified—runtime check; native boundary unsupported |
| Menus, popovers, and dialogs | Default, hover, active, focus-visible, disabled, checked/open; native OS menus/dialogs excluded | `menupopup`, `menuitem`, `panel`, `#folderPaneContext`, `#editContactPanel` | `chrome/messenger/content/messenger/{about3Pane,aboutMessage}.xhtml`; `chrome/{toolkit/skin/classic/global/{menu,popup}.css,messenger/skin/classic/messenger/shared/contextMenu.css}` | Both theme in-process XUL menus/panels/dialog chrome and never native surfaces. | Verified |

## Namespace, custom-element, and shadow-boundary rules

- The privileged XHTML documents declare `xmlns="http://www.w3.org/1999/xhtml"`
  and `xmlns:xul="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul"`
  in `chrome/messenger/content/messenger/about3Pane.xhtml`. When namespace
  qualification is needed, use `html|button` and `xul|toolbar` only after
  declaring the matching CSS namespace; otherwise prefer the verified IDs and
  classes in the ledger.
- Installed custom-element registrations include `tree-view`, `thread-row`,
  `thread-card`, `folder-tree-row`, `message-pane`, and `unified-toolbar` in
  `chrome/messenger/content/messenger/{tree-view,thread-row,thread-card,folder-tree-row,message-pane}.mjs`
  and `chrome/messenger/content/messenger/unifiedtoolbar/unified-toolbar.mjs`.
  Treat internals as opaque unless a listed light-DOM selector or exposed part
  proves otherwise. Do not target private shadow descendants.
- Open-shadow part exposures proved by installed source are `::part(content)`,
  `::part(arrowscrollbox)`, `::part(label-box)`, `::part(icon)`,
  `::part(label)`, and `::part(dropmarker)`. They come respectively from
  `chrome/toolkit/content/global/elements/{panel,menupopup,menulist}.js` and
  are the only part selectors in this contract. The `scrollbox` part is
  re-exported by `menupopup` as `arrowscrollbox-scrollbox`.
- No claim is made for closed or undocumented shadow roots, browser/document
  descendants, OS title bars, native notifications, file pickers, or other
  native dialogs.

## Selector ledger for independent occurrence checks

The following `selector | archive-member` records are the complete
non-unsupported selector corpus used by this contract. The occurrence check
accepts either a literal CSS token or its exact XHTML `id`/class evidence in
the cited installed member. A record may name a custom-element tag or a part
token where that is the installed API evidence rather than a complete future
CSS rule.

```text
#spacesToolbar | chrome/messenger/content/messenger/messenger.xhtml
#unifiedToolbar | chrome/messenger/content/messenger/messenger.xhtml
.unified-toolbar | chrome/messenger/content/messenger/messenger.xhtml
#tabmail-tabs | chrome/messenger/content/messenger/messenger.xhtml
.tabmail-tab | chrome/messenger/content/messenger/messenger.xhtml
#folderPane | chrome/messenger/content/messenger/about3Pane.xhtml
#folderTree | chrome/messenger/content/messenger/about3Pane.xhtml
#folderPaneWriteMessage | chrome/messenger/content/messenger/about3Pane.xhtml
.unread-count | chrome/messenger/content/messenger/about3Pane.xhtml
.new-messages | chrome/classic/skin/classic/messenger/about3Pane.css
#threadPane | chrome/messenger/content/messenger/about3Pane.xhtml
#threadTree | chrome/messenger/content/messenger/about3Pane.xhtml
.table-layout | chrome/classic/skin/classic/messenger/shared/threadPane.css
.card-layout | chrome/classic/skin/classic/messenger/shared/threadPane.css
[data-properties~="unread"] | chrome/classic/skin/classic/messenger/shared/threadPane.css
.tree-button-flag | chrome/messenger/content/messenger/about3Pane.xhtml
.tree-button-spam | chrome/messenger/content/messenger/about3Pane.xhtml
.thread-card-subject-container | chrome/messenger/content/messenger/about3Pane.xhtml
.thread-card-icon-info | chrome/messenger/content/messenger/about3Pane.xhtml
.button-star | chrome/messenger/content/messenger/about3Pane.xhtml
.attachment-icon | chrome/messenger/content/messenger/about3Pane.xhtml
#messagePane | chrome/messenger/content/messenger/about3Pane.xhtml
#messageHeader | chrome/messenger/content/messenger/aboutMessage.xhtml
#attachmentBar | chrome/classic/skin/classic/messenger/shared/messageHeader.css
#attachmentList | chrome/classic/skin/classic/messenger/shared/messageHeader.css
#attachmentToggle | chrome/classic/skin/classic/messenger/shared/messageHeader.css
#compose-toolbox | chrome/messenger/content/messenger/messengercompose/messengercompose.xhtml
#composeToolbar2 | chrome/messenger/content/messenger/messengercompose/messengercompose.xhtml
#msgSubject | chrome/messenger/content/messenger/messengercompose/messengercompose.xhtml
#attachmentBucket | chrome/messenger/content/messenger/messengercompose/messengercompose.xhtml
#booksPane | chrome/messenger/content/messenger/addressbook/aboutAddressBook.xhtml
#books | chrome/messenger/content/messenger/addressbook/aboutAddressBook.xhtml
.bookRow | chrome/messenger/content/messenger/addressbook/aboutAddressBook.xhtml
#cardsPane | chrome/messenger/content/messenger/addressbook/aboutAddressBook.xhtml
#cards | chrome/messenger/content/messenger/addressbook/aboutAddressBook.xhtml
#detailsPane | chrome/messenger/content/messenger/addressbook/aboutAddressBook.xhtml
#calendar-list | chrome/messenger/content/messenger/messenger.xhtml
#calendar-task-tree | chrome/messenger/content/messenger/messenger.xhtml
#calendar-add-task-button | chrome/messenger/content/messenger/messenger.xhtml
#calendar-task-details | chrome/messenger/content/messenger/messenger.xhtml
#today-pane-panel | chrome/messenger/content/messenger/messenger.xhtml
#agenda | chrome/messenger/content/messenger/messenger.xhtml
.agenda-listitem-details | chrome/messenger/content/messenger/messenger.xhtml
#unifinder-todo-tree | chrome/messenger/content/messenger/messenger.xhtml
.today-pane-cycler | chrome/messenger/content/messenger/messenger.xhtml
#preferencesbrowser | chrome/messenger/content/messenger/messenger.xhtml
account-hub-container | chrome/messenger/content/messenger/accountcreation/accountHub.js
.account-hub-view | chrome/messenger/content/messenger/accountcreation/accountHub.js
#tabmail | chrome/messenger/content/messenger/messenger.xhtml
menupopup | chrome/messenger/content/messenger/about3Pane.xhtml
menuitem | chrome/messenger/content/messenger/about3Pane.xhtml
panel | chrome/messenger/content/messenger/aboutMessage.xhtml
#folderPaneContext | chrome/messenger/content/messenger/about3Pane.xhtml
#editContactPanel | chrome/messenger/content/messenger/aboutMessage.xhtml
::part(content) | chrome/toolkit/skin/classic/global/popup.css
::part(arrowscrollbox) | chrome/classic/skin/classic/messenger/shared/contextMenu.css
::part(label-box) | chrome/classic/skin/classic/messenger/shared/preferences/preferences.css
::part(icon) | chrome/classic/skin/classic/messenger/shared/preferences/preferences.css
::part(label) | chrome/classic/skin/classic/messenger/shared/preferences/preferences.css
::part(dropmarker) | chrome/classic/skin/classic/messenger/messengercompose/messengercompose.css
```

## Explicit exclusions

This is a chrome-surface contract, not a content-document contract. Neither
future skin may target rendered message content, message iframe/browser
descendants, compose editor content, `userContent.css`, account/mail data, or
any profile file. Unsupported rows stay unsupported until an installed-build
and runtime evidence update replaces them; a remembered Firefox/Thunderbird
snippet is not evidence.

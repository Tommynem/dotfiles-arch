# Thunderbird dual skins

This package supplies two `userChrome.css` skins for Thunderbird application
chrome. `outlook` is a light, roomy coworker preview. `rose-pine` is a dark,
mono-forward personal skin. The Outlook skin is currently installed as the
local preview, but this repository never records or requires a local profile
directory name.

## Support and prerequisites

- Thunderbird **153.0.2**, BuildID **20260813184934**, is the only supported
  build. Thunderbird custom CSS is unsupported by Mozilla and selectors can
  change with an update.
- GNU Stow and `timeout` from GNU coreutils must be installed.
- Start commands from the repository root. The helper locates its packages
  relative to itself.
- The target must be a real profile below `~/.thunderbird` and contain
  `prefs.js`. The helper reads that marker only. It never edits `prefs.js`.
- Close Thunderbird completely before `install`, `switch`, or `uninstall`.
  `status` is read-only.

For background, Mozilla documents the profile location at
<https://support.mozilla.org/en-US/kb/profiles-where-thunderbird-stores-user-data>
and warns that `userChrome.css` customization is unsupported at
<https://support.mozilla.org/en-US/kb/userchromecss-js-usercontent-unsupported>.

## Choose a profile

The helper automatically selects a profile only when `~/.thunderbird/profiles.ini`
has exactly one nonempty `Default=` value in an `[Install...]` section. Otherwise,
or whenever you want to be explicit, pass the profile directory:

```bash
./thunderbird/manage-skin --profile "$HOME/.thunderbird/<profile-directory>" status
```

Replace `<profile-directory>` with your own profile directory name. Do not copy a
profile name from another machine. An explicit path must still resolve inside
`~/.thunderbird`.

## Install, switch, inspect, and remove

Start with the light Outlook preview. Each mutating command checks the pinned
version and BuildID, confirms Thunderbird is closed, checks ownership, and runs
a `stow --simulate --no-folding` preflight before it changes anything.

```bash
# Config-first clean install of the Outlook preview.
./thunderbird/manage-skin install outlook

# Read the selected profile, pinned build, enablement link, and active skin.
./thunderbird/manage-skin status

# With Thunderbird fully closed, change the active skin.
./thunderbird/manage-skin switch rose-pine

# With Thunderbird fully closed, remove only package-owned links.
./thunderbird/manage-skin uninstall
```

Add `--profile "$HOME/.thunderbird/<profile-directory>"` before the command in
any example to target a particular profile. `install` refuses to replace an
active managed variant. Use `switch` instead. `uninstall` removes only the
package-owned `user.js` and `chrome/userChrome.css` links. It does not delete
mail, accounts, preferences, or any other profile state.

Restart Thunderbird fully after each install, switch, or uninstall. Closing a
window is not enough if a Thunderbird process remains. The new stylesheet is
read at startup.

## Collisions and manual preference merge

The helper stops without modifying either target when it finds an unmanaged
`user.js` or `chrome/userChrome.css`. Preserve those files first. For an
unmanaged `user.js`, add this exact line once to your existing `user.js`:

```js
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
```

Do not put it in `prefs.js`. Then preserve, move, or manually reconcile any
existing `chrome/userChrome.css` before retrying. The helper will not merge CSS
or overwrite either unmanaged file for you. If keeping your own stylesheet is
more important, stop there and do not install this package.

## Updating Thunderbird

Before every install, switch, or uninstall, the helper requires exactly
Thunderbird 153.0.2, BuildID 20260813184934. After a Thunderbird update, a
version or BuildID mismatch is an intentional stop, not a warning to ignore.
Revalidate the selector contract against the installed archive, update the
pin and skins only after that review, and run:

```bash
bash thunderbird/tests/validate.sh
```

Until the validation and a fresh visual review pass, uninstall the package or
leave the existing profile configuration untouched. Do not force the helper
past an unsupported build.

## Optional unified-toolbar command placement

CSS changes appearance, not Thunderbird command placement. Only if a command
is missing or poorly placed for your workflow, and only after the skin itself
has been reviewed, use Thunderbird's UI: right-click an empty area of the
Unified Toolbar, choose **Customize…**, drag the command to the desired
position, then choose **Done**. This is optional and not required for either
skin. Thunderbird owns the resulting UI configuration. Do not edit or copy
`xulstore.json`.

## Visual review checklist

Run this after a full restart. Review one skin at a time, report the skin name,
surface, action, expected result, actual result, and a redacted screenshot only
when useful. Do not include mail, account, or contact content in screenshots.

### Outlook

- [ ] Spaces rail, tabs, and Unified Toolbar are light, roomy, and easy to scan.
      Search and primary actions are visible, and native controls remain usable.
- [ ] Folder pane and thread list work in table and card layouts. Check hover,
      pressed, keyboard focus, selection, unread, tags, quick actions, disabled,
      and error states.
- [ ] Reader header and attachment controls are clear. Rendered message content
      itself is unchanged.
- [ ] Compose toolbar, subject field, Send and attachment controls are readable.
      The message editor content itself is unchanged.
- [ ] Address Book list, selection, search, details, and disabled actions remain
      easy to use.
- [ ] Calendar, tasks, and Today pane show readable current, selected, focus,
      disabled, and error states.
- [ ] Settings, Add-ons, and account setup respect their documented host-only
      boundary. Menus, popovers, and dialogs remain legible and keyboard usable.
- [ ] Check keyboard focus, unread plus selection together, errors, reduced
      motion, high contrast, normal density, and narrow-window behavior.

### Rose Pine

- [ ] Spaces rail, tabs, and Unified Toolbar use a calm dark hierarchy with
      visible Foam focus and restrained Rose selection markers.
- [ ] Folder pane and thread list work in table and card layouts. Check hover,
      pressed, keyboard focus, selection, unread, tags, quick actions, disabled,
      and error states without low-contrast text.
- [ ] Reader header and attachment controls are clear. Rendered message content
      itself is unchanged.
- [ ] Compose toolbar, subject field, Send and attachment controls are readable.
      The message editor content itself is unchanged.
- [ ] Address Book list, selection, search, details, and disabled actions remain
      easy to use.
- [ ] Calendar, tasks, and Today pane show readable current, selected, focus,
      disabled, and error states.
- [ ] Settings, Add-ons, and account setup respect their documented host-only
      boundary. Menus, popovers, and dialogs remain legible and keyboard usable.
- [ ] Check keyboard focus, unread plus selection together, errors, reduced
      motion, high contrast, normal density, and narrow-window behavior. The
      application chrome may be monospaced, but message and editor content must
      retain Thunderbird's own font settings.

## Safety and rollback summary

These skins are independent of Omarchy. Rosé Pine values are stored in the CSS,
not imported from an Omarchy theme. The package never reads or changes mail,
accounts, credentials, `prefs.js`, native dialogs, or rendered message/editor
documents. If a review fails, close Thunderbird, run `uninstall`, restart, and
confirm with `status` that the skin is `none`. That rollback removes only links
the package owns.

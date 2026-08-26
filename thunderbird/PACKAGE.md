# Thunderbird package boundary

`thunderbird/` is an isolated, profile-targeted Thunderbird package. Its source may contain portable package files and documentation only.

The live Thunderbird profile is protected. Package operations must select one install-mapped profile explicitly or prove that exactly one selection exists. They must never hard-code a local profile ID.

Package operations must not edit `prefs.js`, mail stores, account data, credentials, or other generated profile state. They may manage only package-owned `user.js` and `chrome/userChrome.css` paths after collision and ownership checks.

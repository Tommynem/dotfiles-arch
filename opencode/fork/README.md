# Deliberately pinned OmO fork

The manifest and lock pin `gdraganic/oh-my-openagent` at
`68d88c68fac9f519aeb988b4878c9dbaa2aa7ea9` (`v5.1.38-fork.1`). Do not replace
this with a rolling package or add an automatic update job.

`install-pinned-fork.sh` is an explicit maintenance action, not part of CLI
startup. Stop the shared service first, run the helper, then start it again.
It installs into `~/.local/share/opencode/packages`, checks the pristine bundle
hash, and applies:

1. `reasoning-frontmatter.patch`: retain configured reasoning in model references.
2. `preserve-user-agents.patch`: leave curated symlinked agent definitions alone.

Both patches were applied to the pristine pinned bundle and compared byte-for-byte
with the promoted runtime. A focused driver reproduced the symlink-overwrite bug,
then confirmed that curated contents remain unchanged while generated agents
still receive their reasoning variant.

See [the maintenance record](../MAINTENANCE.md) for archive hashes, acceptance
evidence, and the boundary between rolling CLI updates and this pinned fork.

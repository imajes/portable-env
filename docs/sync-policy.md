# Selective source promotion

This public repository contains reviewed preferences, not a copy of a live HOME.
`sync-files.txt` names individual, reusable source files. `just sync` uses rsync
to preview differences for exactly those paths. It never applies or deletes
anything. New paths and changed contents require review before manual promotion;
an allowlisted filename is not a guarantee that future contents are public-safe.

The preview deliberately omits credential-bearing or mixed files such as npmrc,
GitHub account metadata, full Git configuration, GnuPG state, agent homes and
installed binaries. Do not reintroduce directory globs or a FOLDERS override.

## Source ownership

- Author zsh and Neovim in their source repositories. Select reviewed commits in
  the two gitlinks after source review and publication. Keep plugin lock changes
  visible as a separate review concern.
- Bat's default pair is dayfox/duskfox. Its seven original Nightfox assets and
  native delta features are shared. Build caches locally as each account.
- Rod's Linux config lives in `.config/rod/config.toml`. Its macOS source uses
  `Library/Application Support/rod/config.toml`; copy only the reviewed fallback
  preference when updating the portable version.
- Git behavior is selected deliberately. Keep identity, signing, credential
  helpers, local hooks and private includes outside automatic copying. Shared
  ignore/attribute paths use `~/` so they work for other users and root. The active
  `.gitignore_global` includes `**/.claude/settings.local.json` to keep per-machine
  Claude settings out of new repositories.
- `.gitattributes` supplies reusable diff drivers and declares the existing
  `bin/git-activity-report` LFS object. Fetch LFS payloads deliberately; do not
  substitute arbitrary local binaries for recorded objects.

## Intentional platform and account differences

The portable mise configuration keeps the reviewed Linux baseline: no mandatory
Java installation, Rust analyzer/LLVM components, and an opt-in Ruby environment
helper. `.tool-versions` stays aligned with that baseline. Local workstation
Java and automatic Ruby environment wiring are not automatic sync inputs.

Portable shell policy still comes from `.zsh_portable-env`. The root `.zshenv`
link remains intact. Appearance detection is independent of this portable/full
prompt policy and derives its result from the attached terminal.

WezTerm's reusable SSH/OSC7 tab behavior, Codex title passthrough and safe no-GUI
appearance fallback are shared. Workstation window geometry stays local.
Neovide's existing desktop config includes the native-tab preference; it is only
relevant on hosts where Neovide is used. Monitor/editor preferences do not install
the corresponding applications.

Markdownlint's small home config accompanies the source Neovim integration.
ShellCheck, HTML Tidy, mdcat, htop and AmazingPrint preferences are individual files. Broader
btop, lnav and Vale exports need platform/dependency review before being added.

## Agent configuration boundary

There is currently no `.agents`, `.codex` or `.claude` deployment payload here.
Review those as a separate source slice. Qualified shared skills belong under
`.agents/skills`; app-owned `.codex/skills/.system` stays local. Client-specific
links or registration files should refer to reviewed shared sources, with
portable relative paths where supported.

Keep credentials, session history, memories, project registries, MCP endpoints,
permission/trust records, plugin caches and automations out of bulk promotion.
Reusable skills, role definitions and minimal client preferences require an
explicit manifest and independent review. Do not replace deliberate permission
policy with application defaults while extracting a portable config.

## Existing repository content

This sync boundary does not certify older tracked content. Existing GnuPG key,
keyring/trust state and account metadata need their separate publication review.
Do not refresh those files from HOME. Removing tracked private material and any
history cleanup require an explicit, separately reviewed action.

The native chezmoi migration is a separate candidate. If adopted, map these files
to its `home/dot_config` and other native source paths; do not merge a second
competing directory layout into this branch during source synchronization.

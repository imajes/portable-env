# Nightfox themes for bat and delta

This directory ships all seven official Nightfox TextMate theme exports from
[EdenEast/nightfox.nvim](https://github.com/EdenEast/nightfox.nvim).
The default pair is **dayfox** (light) and **duskfox** (dark).
All assets are vendored without modification from commit
`4dacd3f0185a2227bdf3b6c0975a8f0bf87cac9a`:

| Theme | Mode | Upstream source | SHA-256 |
| --- | --- | --- | --- |
| `dayfox` | light | [Official export](https://github.com/EdenEast/nightfox.nvim/blob/4dacd3f0185a2227bdf3b6c0975a8f0bf87cac9a/extra/dayfox/dayfox.tmTheme) | `1dfd7e14fdbb598d8663b61f2cc92ce2a3b748572a883fd25b5d8e9878ed9c03` |
| `dawnfox` | light | [Official export](https://github.com/EdenEast/nightfox.nvim/blob/4dacd3f0185a2227bdf3b6c0975a8f0bf87cac9a/extra/dawnfox/dawnfox.tmTheme) | `39a0dd71f90c274db7edf7c34371fd88da474eab51c0a1432fe40c0a9f882402` |
| `duskfox` | dark | [Official export](https://github.com/EdenEast/nightfox.nvim/blob/4dacd3f0185a2227bdf3b6c0975a8f0bf87cac9a/extra/duskfox/duskfox.tmTheme) | `386a96ac927f52316ea9e748c87d0da515974905268c1ece26b10bcf07c3b307` |
| `nightfox` | dark | [Official export](https://github.com/EdenEast/nightfox.nvim/blob/4dacd3f0185a2227bdf3b6c0975a8f0bf87cac9a/extra/nightfox/nightfox.tmTheme) | `27fd1b683118ad5ee89fba9e1dae1d22f2c73d8e021f49552e3e084761b4a4db` |
| `nordfox` | dark | [Official export](https://github.com/EdenEast/nightfox.nvim/blob/4dacd3f0185a2227bdf3b6c0975a8f0bf87cac9a/extra/nordfox/nordfox.tmTheme) | `0c978a65e051e19c4fb70f0a23caa349409de911ab8ecda4c8fc9b4a2c1065b8` |
| `terafox` | dark | [Official export](https://github.com/EdenEast/nightfox.nvim/blob/4dacd3f0185a2227bdf3b6c0975a8f0bf87cac9a/extra/terafox/terafox.tmTheme) | `0093022d44ea24faf7babf961b27ca040ddd662b73fa050ceb58ec124ef7643f` |
| `carbonfox` | dark | [Official export](https://github.com/EdenEast/nightfox.nvim/blob/4dacd3f0185a2227bdf3b6c0975a8f0bf87cac9a/extra/carbonfox/carbonfox.tmTheme) | `44d3dad44553252f055f1201de35c8948d09bfae56393ddca3079a3e1074784f` |

The upstream MIT license is in `NIGHTFOX-LICENSE`. Upstream's XML currently
contains stale Catppuccin display metadata; bat and delta address these assets
by their file stems (`dayfox` and `duskfox`). The original exports are preserved.

## Installation and cache

Install this directory as `~/.config/bat`, then run:

```sh
bat cache --build
bat --list-themes
delta --list-syntax-themes
```

Run the cache build as each account that will use the themes, including root
when that account receives the configuration. Do not commit the compiled cache.
The bat config uses `--theme-light` and `--theme-dark`; verify those options are
supported before deploying it to older hosts. Tested with bat 0.26.1 and delta
0.20.1. The XML assets themselves do not require those exact versions.

## Selection

Bat automatically chooses dayfox or duskfox from the terminal background when
it can detect it. Explicit previews are:

```sh
bat --theme=light example.py
bat --theme=dark example.py
```

An inherited `BAT_THEME` can override these preferences. The current recorded
portable zsh revision comments out the old fixed exports. Older deployed hosts
may still contain them; check those shells before expecting automatic pairing
to take effect.

The portable Git config includes `~/.config/bat/nightfox.gitconfig`, which
provides one native delta feature for each of the seven themes. Preview the
default pair with:

```sh
DELTA_FEATURES=+dayfox git diff
DELTA_FEATURES=+duskfox git diff
```

On a machine where that include has not been installed, the direct equivalent is:

```sh
git -c delta.syntax-theme=dayfox -c delta.light=true diff
git -c delta.syntax-theme=duskfox -c delta.dark=true diff
```

Delta reads bat's theme cache, but does not read bat's light/dark theme preferences.
Its native background detection does not select an arbitrary pair of syntax
themes. In delta 0.20.1, a name like `dayfox` is also classified as dark if no
terminal response or explicit light option is available. These features set the
mode explicitly so light diffs keep suitable background colors.

No default delta feature is forced in this include. The coordinated terminal
appearance module selects one at shell startup. Real-time switching is a later enhancement.
If using a theme feature, select exactly one Fox variant. The two light
features are `dayfox` and `dawnfox`; the five dark features are `duskfox`,
`nightfox`, `nordfox`, `terafox`, and `carbonfox`. For example, use
`DELTA_FEATURES=+carbonfox git diff` or `bat --theme=dawnfox example.py`
for a temporary preview without changing the defaults.

Upstream also provides native exports for WezTerm, Ghostty, tmux, kitty,
Alacritty, iTerm, Konsole, fish, starship, Warp, and Windows Terminal. Use those
exports for a future integration rather than hand-transcribing palette colors.

References: [bat themes](https://github.com/sharkdp/bat#adding-new-themes),
[delta custom themes](https://dandavison.github.io/delta/custom-themes.html),
[delta theme selection](https://github.com/dandavison/delta/blob/0.20.1/src/options/theme.rs).

# AI Agent Instructions for `mariovictorrs/dotfiles`

## Build, test, and lint commands

This repository does not define a conventional app build/test pipeline (no `package.json`, `Makefile`, CI workflow, or dedicated test suite). Use these commands for the workflows that exist:

| Purpose | Command |
| --- | --- |
| Apply dotfiles symlinks (from `$HOME`, as described in `README.md`) | `stow dotfiles` |
| Bootstrap Linux workstation | `./install_linux.sh` |
| Bootstrap macOS workstation | `./install_mac.sh` |
| Rebuild active NixOS host from this flake | `sudo nixos-rebuild switch --flake .#yoga` |
| Build-only NixOS host check (single target) | `sudo nixos-rebuild build --flake .#yoga` |
| Update flake inputs | `sudo nix flake update` |
| Lint Nix files | `statix check hosts` |
| Format Nix files | `nixfmt hosts/**/*.nix` |
| Format Lua files using repo config | `stylua .config/nvim/lua` |

Single-target equivalent to a “single test”: run `sudo nixos-rebuild build --flake .#yoga` to validate only the `yoga` host configuration without switching the system.

## High-level architecture

This repo combines three layers:

1. **Dotfiles layer (GNU Stow-managed):** root-level dotfiles (for example `.zshrc`, `.wezterm.lua`, `.config/*`) are the primary user environment and are intended to be symlinked into `$HOME`.
2. **NixOS host layer (`hosts/` + `flake.nix`):** `flake.nix` exposes host entries under `nixosConfigurations`; `hosts/yoga/configuration.nix` composes reusable modules from `hosts/modules/` plus hardware config.
3. **Machine bootstrap layer (`install_*.sh` + `scripts/`):** OS-specific setup scripts install required packages and tools (Arch via `yay`, macOS via `brew`) before/alongside stow-based dotfile usage.

For Neovim specifically, config is modularized under `.config/nvim/lua/mario`:

- `init.lua` loads `mario.core`, `mario.lazy`, and `mario.custom`
- `mario/plugins/*.lua` contains one plugin spec per file (Lazy.nvim pattern)
- LSP/formatter/linter behavior is split between `core/*` and plugin specs (`lsp_config.lua`, `conform.lua`, `linting.lua`)

## Key repository conventions

1. **Keep NixOS host config modular:** host files in `hosts/<hostname>/configuration.nix` should mostly compose `hosts/modules/*.nix` modules rather than inlining large blocks.
2. **Respect installer ordering on Linux:** `install_linux.sh` sources `scripts/linux/01-...` through `10-...` in order; this sequencing is intentional and should be preserved when adding steps.
3. **Treat `.stow-local-ignore` as part of the architecture:** files and directories listed there (notably `hosts/`, `scripts/`, `flake.*`, and docs) are intentionally excluded from symlink management.
4. **Prefer declaring editor/dev tooling in Nix modules first:** Neovim tooling is system-provisioned in `hosts/modules/packages-nvim.nix`, while Mason in Neovim only installs tools missing from `PATH`.
5. **Follow existing Neovim module boundaries:** global options/keymaps/autocmds live in `mario/core/*`; plugin-specific setup stays in `mario/plugins/*`; custom UX helpers stay in `mario/custom/*`.

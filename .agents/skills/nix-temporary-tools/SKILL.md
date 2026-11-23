---
name: nix-temporary-tools
description: Recommends using temporary Nix environments for tools that are not installed on NixOS, without modifying the system configuration.
license: MIT
---

# Temporary tools on NixOS

## When to use

Use this skill when the user is on NixOS and a required CLI tool is not available in
`PATH`, or when a task only needs a tool briefly.

Prefer a temporary environment over installing the tool globally or changing the
NixOS configuration unless the user explicitly asks for a permanent installation.

## Default approach

For one-off tools, recommend:

```bash
nix-shell -p <package>
```

Examples:

```bash
nix-shell -p ripgrep jq
nix-shell -p python3Packages.pyyaml --run 'python -c "import yaml; print(yaml.safe_load(open(\"file.yml\")))"'
```

The packages are available inside the shell and are not added to the system
profile. The user can leave it with `exit` or `Ctrl-D`.

Use `--run` when the tool is only needed for one command:

```bash
nix-shell -p imagemagick --run 'convert input.png output.webp'
```

## Project environments

If the repository has a flake with a `devShell`, prefer:

```bash
nix develop
```

Use `nix develop` for project-defined development environments and `nix-shell -p`
for ad-hoc utilities. Do not create a `shell.nix`, modify `flake.nix`, or update
NixOS modules merely to obtain a temporary tool.

## Guidance

- Check whether the command already exists before suggesting a package.
- Use the Nixpkgs attribute name, which may differ from the executable name.
- Keep temporary tooling separate from the requested code or configuration change.
- Do not suggest `sudo apt`, `brew`, or permanent `nix-env` installation for a
  NixOS workstation unless the user explicitly requests that approach.
- If package lookup or evaluation fails, report the error and suggest checking the
  Nixpkgs package name; do not silently fall back to another package.

## References

- `nix-shell`: https://nix.dev/manual/nix/stable/command-ref/nix-shell
- Ad-hoc shell environments: https://nix.dev/tutorials/first-steps/ad-hoc-shell-environments
- `nix develop`: https://nix.dev/manual/nix/stable/command-ref/new-cli/nix3-develop
- Declarative shell environments: https://nix.dev/tutorials/first-steps/declarative-shell

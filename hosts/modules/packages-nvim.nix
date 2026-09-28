# Neovim development tools
# LSP servers, formatters, linters, and debuggers for various languages
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Nvim | Base
    tree-sitter
    imagemagick

    # Nvim | Lint
    statix
    nixfmt

    # Nvim | LSP - Language Servers
    nil
    lua-language-server
    gopls
    eslint_d
    vtsls
    tailwindcss-language-server
    rust-analyzer
    zls
    dockerfile-language-server
    docker-compose-language-service
    pyright
    golangci-lint-langserver

    # Nvim | Formatters & Linters
    hadolint
    prettier
    mypy
    ruff
    gotools
    gofumpt
    golines
    gomodifytags
    impl
    golangci-lint
    stylua
    marksman

    # Nvim | Debuggers
    vscode-js-debug
  ];
}

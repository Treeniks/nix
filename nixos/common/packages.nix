{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # llvm
    llvm
    clang
    clang-tools
    lld
    lldb

    # dev
    gcc
    gdb
    rustup
    tree-sitter
    deno
    mono
    nodejs-slim
    (python3.withPackages (python-pkgs: with python-pkgs; [ requests ]))
    nixfmt
    nixd

    # cli
    wget
    ripgrep
    ouch
    btop
    starship
    eza
    yazi
    zoxide
  ];
}

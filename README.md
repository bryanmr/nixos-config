# NixOS Configuration Overview

This repository defines a declarative NixOS system using flakes.

## System Settings
- Enables experimental Nix features (`nix-command`, `flakes`)
- Sets timezone to America/New_York
- Configures GC to run weekly with 30-day retention

## Packages
Installs: vim, sops, age, jq, nvidia-container-toolkit

## Secret Management
Uses `sops` with age encryption for secret files at `/home/bryan/secrets/secrets.yaml`

## SSH Agent
Starts ssh-agent and configures it to automatically add private keys

## Environment
Sets `EDITOR` and `VISUAL` to vim, defines aliases:
- `nix-clean`: runs `sudo nix-collect-garbage -d`
- `sec-edit`: opens secret file with sops

## Module Imports
Imports additional configuration files via flakes:
- ./ollama.nix
- ./opencode.nix
- ./desktop.nix, ./wsl.nix, etc.

## Build Script
Provides a `rebuild` script that auto-detects environment (WSL/desktop) and runs
`sudo nixos-rebuild switch --flake /home/bryan/nixos-config#<TARGET>`.

This configuration offers a reproducible, modular setup for development
and personal use.
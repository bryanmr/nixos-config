# Gemini Context: NixOS Configuration

This repository contains the NixOS configuration for the user 'bryan', managed as a Nix Flake.

## Core Mandates for Gemini

1.  **Update Documentation**: Whenever the configuration is modified, this `GEMINI.md` file MUST be updated to reflect the changes.
2.  **Commit on Change**: After modifying the configuration, always perform a `git commit` describing the changes. Do NOT push unless explicitly asked.

## Structure

- **`flake.nix`**: The entry point. Defines inputs (nixos-25.11, nixpkgs-unstable) and system outputs.
- **`home.nix`**: User-level configuration (Home Manager).
  - Installs user packages (e.g., `gemini-cli` from unstable).
- **`configuration.nix`**: System-level configuration.
- **`ollama.nix`**: AI service configuration (Ollama, Open WebUI).

## Key Configurations

### Gemini CLI
The `gemini-cli` package is installed via `home.nix`. It is pulled from `nixpkgs-unstable` to ensure the latest features are available.

### AI Stack
The AI stack (Ollama, Open WebUI) is defined in `ollama.nix` and uses `nixpkgs-unstable` for CUDA support and newer models.

### Rust Development
The Rust development environment is set up by installing `rustup`, `cargo`, and `rust-analyzer` via `home.nix`. This provides the core tools for Rust programming.

### Tauri Development
To support Tauri development, several packages have been added to `home.nix`. These include `webkitgtk_4_1`, `gtk3`, `libsoup`, `openssl`, `dbus`, `pkg-config`, `libappindicator-gtk3`, and `cargo-tauri` from the unstable channel. These packages provide the necessary libraries and tools for building Tauri applications.

## Usage

To apply changes, use the provided helper script:

```bash
rebuild
```

This script automatically detects the environment (WSL or Desktop) and runs `nixos-rebuild switch`.

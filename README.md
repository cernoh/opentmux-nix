# OpenTmux

[![npm version](https://img.shields.io/npm/v/opentmux.svg)](https://www.npmjs.com/package/opentmux)
[![npm downloads](https://img.shields.io/npm/dt/opentmux)](https://www.npmjs.com/package/opentmux)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An [OpenCode](https://opencode.ai) plugin that provides **smart tmux integration** for viewing agent execution in real-time. Automatically spawns panes, streams output, and manages your terminal workspace.

- **Agent-Agnostic**: Works with oh-my-opencode, omoc-slim, or vanilla OpenCode.
- **Cross-Platform**: Full support for **macOS**, **Linux**, and **Windows** (via PowerShell or WSL).

![Opencode Agent Tmux Demo](https://raw.githubusercontent.com/angansamadder/opentmux/main/assets/demo.png)
*Note: The demo shows the "sisyphus" agent from [oh-my-opencode](https://github.com/code-yeongyu/oh-my-opencode), but this plugin supports ALL OpenCode subagents.*

## Installation

### 🤖 Let an LLM do it (Recommended)

Paste this into any LLM agent (OpenCode, Claude Code, Cursor, etc.):

```text
Install the opentmux plugin by following: https://raw.githubusercontent.com/AnganSamadder/opentmux/main/README.md
```

<details>
<summary><b>Instructions for LLM Agents</b></summary>

To install this plugin, please perform the following steps for the user:

1.  **Install the NPM package globally:**
    ```bash
    npm install -g opentmux
    ```
    *Note: This installer automatically configures the user's shell (Bash/Zsh/Fish/PowerShell) to use the smart wrapper.*

2.  **Configure OpenCode:**
    Add `"opentmux"` to the `plugin` array in the user's config file (usually `~/.config/opencode/opencode.json`).

    ```json
    {
      "plugin": [
        "opentmux"
      ]
    }
    ```

3.  **Verify & Finalize:**
    *   Check if `tmux` is installed on the system. If not, advise the user to install it (e.g., `brew install tmux`, `sudo apt install tmux`, or `winget install tmux`).
    *   Tell the user: **"Installation complete! Please restart your terminal and run `opencode` to see the tmux integration in action."**

</details>

### 👤 For Humans (Manual)

1.  **Install via NPM:**
    ```bash
    npm install -g opentmux
    ```
    *The installer automatically configures your shell to use the smart wrapper.*

2.  **Enable the Plugin:**
    Add `"opentmux"` to your `~/.config/opencode/opencode.json`:
    ```json
    {
      "plugin": [
        "opentmux"
      ]
    }
    ```

3.  **Run OpenCode:**
    Restart your terminal and type `opencode`. The plugin handles the rest!

## ❄️ Nix / Home-Manager

This repository ships a Nix flake that packages `opentmux` and exposes a
[home-manager](https://github.com/nix-community/home-manager) module so you can
declaratively configure the plugin alongside the rest of your dotfiles.

### Quick start

Add the flake to your inputs and import the module:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opentmux = {
      url = "github:cernoh/opentmux-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, opentmux, ... }: {
    homeConfigurations."you@host" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      # Apply the overlay so pkgs.opentmux is available.
      extraSpecialArgs = { inherit opentmux; };

      modules = [
        # 1. Apply the package overlay
        { nixpkgs.overlays = [ opentmux.overlays.default ]; }

        # 2. Import the home-manager module
        opentmux.homeManagerModules.default

        # 3. Your config
        {
          programs.opentmux = {
            enable = true;
            layout = "main-vertical";
            enableShellAlias = true;   # aliases `opencode` → `opentmux`
          };
        }
      ];
    };
  };
}
```

Then run:

```bash
home-manager switch --flake .#you@host
```

### Module options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | bool | — | Enable the module (required) |
| `package` | package | `pkgs.opentmux` | Package to install |
| `enabled` | bool | `true` | Enable tmux integration |
| `port` | port | `4096` | OpenCode server port |
| `layout` | enum | `"main-vertical"` | Tmux layout (`main-horizontal`, `main-vertical`, `tiled`, `even-horizontal`, `even-vertical`) |
| `mainPaneSize` | int (20–80) | `60` | Percentage of the window for the main pane |
| `autoClose` | bool | `true` | Close panes automatically when sessions end |
| `spawnDelayMs` | int (50–2000) | `300` | Delay between pane spawns (ms) |
| `maxRetryAttempts` | int (0–5) | `2` | Spawn retry limit |
| `layoutDebounceMs` | int (50–1000) | `150` | Layout re-apply debounce (ms) |
| `maxAgentsPerColumn` | int (1–10) | `3` | Max agent panes per column |
| `reaperEnabled` | bool | `true` | Enable zombie-process reaper |
| `reaperIntervalMs` | int | `30000` | Reaper scan interval (ms) |
| `reaperMinZombieChecks` | int | `3` | Scans before a zombie is killed |
| `reaperGracePeriodMs` | int | `5000` | Grace period before kill (ms) |
| `reaperAutoSelfDestruct` | bool | `true` | Self-destruct idle servers |
| `reaperSelfDestructTimeoutMs` | int | `3600000` | Idle timeout before self-destruct (ms) |
| `rotatePort` | bool | `false` | Recycle oldest session when no port is free |
| `maxPorts` | int (1–100) | `10` | Number of ports to scan |
| `enableShellAlias` | bool | `false` | Add `opencode = opentmux` shell alias |
| `shellAliasName` | string | `"opencode"` | Name of the shell alias |
| `extraSettings` | attrs | `{}` | Extra keys merged into `opentmux.json` |

The module writes the configuration to `~/.config/opencode/opentmux.json`
(managed via `xdg.configFile`).

### Building the package standalone

```bash
nix build github:cernoh/opentmux-nix
./result/bin/opentmux --help
```

> **First-time contributors:** The `npmDepsHash` in `nix/package.nix` is set to
> `lib.fakeHash` so the file is self-documenting. Replace it with the correct
> hash shown in the build error after your first `nix build` attempt, or run:
>
> ```bash
> nix run nixpkgs#prefetch-npm-deps -- package-lock.json
> ```

## 🛠️ Development

For contributors working on this plugin locally, see [LOCAL_DEVELOPMENT.md](docs/LOCAL_DEVELOPMENT.md) for setup instructions.

## ✨ Features

- **Automatic Tmux Pane Spawning**: When any agent starts, automatically spawns a tmux pane
- **Live Streaming**: Each pane runs `opencode attach` to show real-time agent output
- **Auto-Cleanup**: Panes automatically close when agents complete
- **Configurable Layout**: Support multiple tmux layouts (`main-vertical`, `tiled`, etc.)
- **Multi-Port Support**: Automatically finds available ports (4096-4106) when running multiple instances
- **Smart Wrapper**: Automatically detects if you are in tmux; if not, launches a session for you.

## ⚙️ Configuration

You can customize behavior by creating `~/.config/opencode/opentmux.json`:

```json
{
  "enabled": true,
  "port": 4096,
  "layout": "main-vertical",
  "main_pane_size": 60,
  "auto_close": true
}
```

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enabled` | boolean | `true` | Enable/disable the plugin |
| `port` | number | `4096` | OpenCode server port |
| `layout` | string | `"main-vertical"` | Tmux layout: `main-horizontal`, `main-vertical`, `tiled`, etc. |
| `main_pane_size` | number | `60` | Size of main pane (20-80%) |
| `auto_close` | boolean | `true` | Auto-close panes when sessions complete |

## ❓ Troubleshooting

### Panes Not Spawning
1. Verify you're inside tmux: `echo $TMUX`
2. Check tmux is installed: `which tmux` (or `where tmux` on Windows)
3. Check logs: `cat /tmp/opentmux.log`

### Server Not Found
Make sure OpenCode is started with the `--port` flag matching your config (the wrapper does this automatically).

## 🗺️ Roadmap

The following features are planned for future releases:
- **Glow Integration**: Support for [Glow](https://github.com/charmbracelet/glow) to render markdown beautifully in spawned panes.
- **Neovim Quick-Launch**: Direct integration to launch Neovim at the agent's current working directory.
- **Enhanced Customization**: More options for pane positioning, colors, and persistent layouts.

## 📄 License

MIT

## 🙏 Acknowledgements
This project extracts and improves upon the tmux session management from [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) by alvinunreal.

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

### Prerequisites

Before you begin, make sure you have:

- **Nix** with [flakes enabled](https://nixos.wiki/wiki/Flakes)
  (`experimental-features = nix-command flakes` in `nix.conf` or `/etc/nix/nix.conf`)
- **tmux** available in your environment (`nixpkgs.tmux`, or `programs.tmux.enable = true`)
- **OpenCode** installed (`opencode` binary reachable in your PATH)
- An existing **home-manager** configuration (standalone *or* NixOS module — both patterns are shown below)

---

### Pattern A — Standalone home-manager

Use this if you run `home-manager switch` independently of NixOS
(e.g. on macOS with nix-darwin, or on Linux without NixOS).

**Step 1 — Add the flake input**

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager    = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opentmux = {
      url = "github:cernoh/opentmux-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, opentmux, ... }: {
    homeConfigurations."youruser@yourhostname" =
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; }; # adjust system as needed

        modules = [
          # 1. Make pkgs.opentmux available
          { nixpkgs.overlays = [ opentmux.overlays.default ]; }

          # 2. Import the home-manager module
          opentmux.homeManagerModules.default

          # 3. Enable and configure the plugin
          {
            programs.opentmux = {
              enable           = true;
              layout           = "main-vertical"; # see Module options below
              enableShellAlias = true;             # adds alias: opencode → opentmux
            };
          }
        ];
      };
  };
}
```

**Step 2 — Apply the configuration**

```bash
home-manager switch --flake .#youruser@yourhostname
```

---

### Pattern B — NixOS with home-manager as a NixOS module

Use this if home-manager is imported as a NixOS module inside your
`nixosConfigurations`.

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager    = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opentmux = {
      url = "github:cernoh/opentmux-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, opentmux, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Make pkgs.opentmux available system-wide
        { nixpkgs.overlays = [ opentmux.overlays.default ]; }

        home-manager.nixosModules.home-manager
        {
          home-manager.users.youruser = { pkgs, ... }: {
            imports = [ opentmux.homeManagerModules.default ];

            programs.opentmux = {
              enable           = true;
              layout           = "main-vertical";
              enableShellAlias = true;
            };
          };
        }

        ./configuration.nix  # your existing NixOS config
      ];
    };
  };
}
```

**Step 2 — Rebuild your system**

```bash
sudo nixos-rebuild switch --flake .#yourhostname
```

---

### Step 3 — Register the plugin with OpenCode (required for both patterns)

The Nix module installs the `opentmux` binary and writes the plugin config
file, but OpenCode itself must be told to load the plugin.  Edit
`~/.config/opencode/opencode.json` and add `"opentmux"` to the `plugin`
array:

```json
{
  "plugin": [
    "opentmux"
  ]
}
```

> **Note:** This file is not managed by the Nix module intentionally — you
> likely have other OpenCode settings there that should remain under your own
> control.

---

### Step 4 — Verify the installation

1. Open a new terminal (so the shell alias takes effect if you enabled it).
2. Start a tmux session if you are not already inside one:
   ```bash
   tmux
   ```
3. Launch OpenCode:
   ```bash
   opencode   # or `opentmux` directly if you did not enable the alias
   ```
4. When an agent spawns a sub-session you will see a new tmux pane appear
   automatically, running `opencode attach` for that session.
5. If nothing appears, check the log for errors:
   ```bash
   cat /tmp/opentmux.log
   ```

---

### Module options

All options live under `programs.opentmux`.

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

> **Note for contributors:** The `npmDepsHash` in `nix/package.nix` is set to
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

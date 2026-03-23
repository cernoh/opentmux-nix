# nix/module.nix
#
# Home-manager module for opentmux.
#
# Usage – add to your home-manager configuration:
#
#   {
#     programs.opentmux = {
#       enable = true;
#       layout = "main-vertical";
#       enableShellAlias = true;   # aliases `opencode` → `opentmux`
#     };
#   }
#
# See README.md for full examples including flake integration.

{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.programs.opentmux;

  # Build the JSON object that will be written to
  # ~/.config/opencode/opentmux.json.  Only keys explicitly set by the user
  # (i.e. not equal to their default) are emitted, which keeps the file small
  # and lets the Node.js plugin apply its own defaults for unset keys.
  configAttrs = {
    enabled = cfg.enabled;
    port = cfg.port;
    layout = cfg.layout;
    main_pane_size = cfg.mainPaneSize;
    auto_close = cfg.autoClose;
    spawn_delay_ms = cfg.spawnDelayMs;
    max_retry_attempts = cfg.maxRetryAttempts;
    layout_debounce_ms = cfg.layoutDebounceMs;
    max_agents_per_column = cfg.maxAgentsPerColumn;
    reaper_enabled = cfg.reaperEnabled;
    reaper_interval_ms = cfg.reaperIntervalMs;
    reaper_min_zombie_checks = cfg.reaperMinZombieChecks;
    reaper_grace_period_ms = cfg.reaperGracePeriodMs;
    reaper_auto_self_destruct = cfg.reaperAutoSelfDestruct;
    reaper_self_destruct_timeout_ms = cfg.reaperSelfDestructTimeoutMs;
    rotate_port = cfg.rotatePort;
    max_ports = cfg.maxPorts;
  } // cfg.extraSettings;

  configFile = (pkgs.formats.json { }).generate "opentmux.json" configAttrs;
in
{
  options.programs.opentmux = {
    enable = mkEnableOption "opentmux — OpenCode tmux integration plugin";

    package = mkOption {
      type = types.package;
      default = pkgs.opentmux;
      defaultText = lib.literalExpression "pkgs.opentmux";
      description = ''
        The opentmux package to install.  Defaults to the package exposed by
        this flake's overlay.  You can substitute any derivation that provides
        an <literal>opentmux</literal> binary.
      '';
    };

    # ── Core options ──────────────────────────────────────────────────────────

    enabled = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether the tmux integration is active.  Set to <literal>false</literal>
        to disable pane spawning while keeping the package installed.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 4096;
      description = "Default OpenCode server port.";
    };

    layout = mkOption {
      type = types.enum [
        "main-horizontal"
        "main-vertical"
        "tiled"
        "even-horizontal"
        "even-vertical"
      ];
      default = "main-vertical";
      description = "Tmux window layout applied when agent panes are open.";
    };

    mainPaneSize = mkOption {
      type = types.ints.between 20 80;
      default = 60;
      description = ''
        Percentage of the window width (for main-vertical) or height (for
        main-horizontal) occupied by the primary pane.
      '';
    };

    autoClose = mkOption {
      type = types.bool;
      default = true;
      description = "Automatically close agent panes when their session ends.";
    };

    # ── Spawn / retry tuning ──────────────────────────────────────────────────

    spawnDelayMs = mkOption {
      type = types.ints.between 50 2000;
      default = 300;
      description = "Delay in milliseconds between consecutive pane spawns.";
    };

    maxRetryAttempts = mkOption {
      type = types.ints.between 0 5;
      default = 2;
      description = "Maximum number of pane spawn retries on failure.";
    };

    layoutDebounceMs = mkOption {
      type = types.ints.between 50 1000;
      default = 150;
      description = "Debounce window in milliseconds before re-applying the layout.";
    };

    maxAgentsPerColumn = mkOption {
      type = types.ints.between 1 10;
      default = 3;
      description = "Maximum number of agent panes stacked in a single column.";
    };

    # ── Zombie reaper ─────────────────────────────────────────────────────────

    reaperEnabled = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable the zombie-process reaper that periodically kills stale
        <literal>opencode attach</literal> processes.
      '';
    };

    reaperIntervalMs = mkOption {
      type = types.ints.unsigned;
      default = 30000;
      description = "Interval in milliseconds between reaper scans.";
    };

    reaperMinZombieChecks = mkOption {
      type = types.ints.unsigned;
      default = 3;
      description = ''
        Number of consecutive scans a process must appear as a zombie before
        it is killed.
      '';
    };

    reaperGracePeriodMs = mkOption {
      type = types.ints.unsigned;
      default = 5000;
      description = ''
        Minimum time in milliseconds a process must have been detected as a
        zombie before the reaper will kill it.
      '';
    };

    reaperAutoSelfDestruct = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Exit the OpenCode server automatically when it has had no active client
        connections for <option>reaperSelfDestructTimeoutMs</option>.
      '';
    };

    reaperSelfDestructTimeoutMs = mkOption {
      type = types.ints.unsigned;
      default = 3600000; # 1 hour
      description = ''
        Idle time in milliseconds after which an abandoned OpenCode server
        self-destructs.  Only relevant when
        <option>reaperAutoSelfDestruct</option> is <literal>true</literal>.
      '';
    };

    # ── Port management ───────────────────────────────────────────────────────

    rotatePort = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When no port in the configured range is free, recycle the oldest
        running session instead of refusing to start.
      '';
    };

    maxPorts = mkOption {
      type = types.ints.between 1 100;
      default = 10;
      description = ''
        Number of ports to scan starting from <option>port</option> when
        looking for a free slot.
      '';
    };

    # ── Shell integration ─────────────────────────────────────────────────────

    enableShellAlias = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Add an alias that maps <literal>opencode</literal> to
        <literal>opentmux</literal> in every shell managed by home-manager
        (bash, zsh, fish).  This mirrors the alias the npm postinstall script
        would set up, but in a declarative, Nix-managed way.
      '';
    };

    shellAliasName = mkOption {
      type = types.str;
      default = "opencode";
      description = ''
        Name of the shell alias created when
        <option>enableShellAlias</option> is <literal>true</literal>.
      '';
    };

    # ── Escape hatch ──────────────────────────────────────────────────────────

    extraSettings = mkOption {
      type = types.attrsOf types.anything;
      default = { };
      example = lib.literalExpression ''
        { my_custom_key = "value"; }
      '';
      description = ''
        Arbitrary key/value pairs merged into the generated
        <filename>opentmux.json</filename> configuration file.  Use this for
        settings not yet exposed as dedicated module options.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Install the binary.
    home.packages = [ cfg.package ];

    # Write the configuration file to the location the plugin searches first.
    xdg.configFile."opencode/opentmux.json".source = configFile;

    # Optional shell alias: opencode → opentmux
    programs.bash.shellAliases = mkIf cfg.enableShellAlias {
      ${cfg.shellAliasName} = "opentmux";
    };
    programs.zsh.shellAliases = mkIf cfg.enableShellAlias {
      ${cfg.shellAliasName} = "opentmux";
    };
    programs.fish.shellAliases = mkIf cfg.enableShellAlias {
      ${cfg.shellAliasName} = "opentmux";
    };
  };
}

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.6.0](https://github.com/cernoh/opentmux-nix/compare/v1.5.6...v1.6.0) (2026-03-23)


### Features

* add 'oc' alias for opentmux and 'cc' alias for claude ([8fae996](https://github.com/cernoh/opentmux-nix/commit/8fae996d7d8f2662b9e99238fe1bb2ee4ecf3545))
* add GitHub Actions workflow to check Nix package build ([0eb722d](https://github.com/cernoh/opentmux-nix/commit/0eb722dc4d6f00fd7dd1f2cfe499c7b7bf1ca327))
* add installation scripts and auto-port detection wrapper ([ebb2cd4](https://github.com/cernoh/opentmux-nix/commit/ebb2cd44dbb8022148d96354f5c4e605c9a7e77e))
* add plugin entry point with event handling and config ([1fb10c6](https://github.com/cernoh/opentmux-nix/commit/1fb10c62b0bf815938a1de0a3e53367076c597e3))
* bypass tmux for logging arguments ([78b18fa](https://github.com/cernoh/opentmux-nix/commit/78b18faa07d8cd698ce64845376fc84b62089498))
* implement core tmux session management and utilities ([a4c8809](https://github.com/cernoh/opentmux-nix/commit/a4c8809ed60a9565ba87280f0adaa58b9578ae81))
* implement dynamic-vertical layout and header suppression ([c7ec457](https://github.com/cernoh/opentmux-nix/commit/c7ec4573a783a8684e28f10bd6237e2931973e58))
* **reaper:** add auto self-destruct for abandoned servers (default 1h) ([0295cb2](https://github.com/cernoh/opentmux-nix/commit/0295cb243af247e63b5bc97d98c889b839d631d1))
* **reaper:** implement zombie process reaper and CLI command ([1ecbb00](https://github.com/cernoh/opentmux-nix/commit/1ecbb008549b8d5b8a91a0fa6b0d6d57ce5950a4))
* release v1.5.0 - port rotation and aggressive reaping ([e168a83](https://github.com/cernoh/opentmux-nix/commit/e168a83a78b7ec00cabf1f7c8260d3555b7c2eb2))
* selective tmux launch for server/UI only ([f6fec27](https://github.com/cernoh/opentmux-nix/commit/f6fec27cef875ec90e38359c3c2cfc9b1d0346a5))
* support --log-update flag and include updater script ([9244415](https://github.com/cernoh/opentmux-nix/commit/9244415f9d3444674273fa6e8660082164edd361))


### Bug Fixes

* actually remove registry-url to prevent token injection ([4e6d73e](https://github.com/cernoh/opentmux-nix/commit/4e6d73ef9b7bd9ceeb178e70ac686a852dedd021))
* add always-auth for npm OIDC ([d5e08c4](https://github.com/cernoh/opentmux-nix/commit/d5e08c4db8ad60015d5ceee4f6989f3001d49625))
* add environment: release for npm OIDC authentication ([0dd9614](https://github.com/cernoh/opentmux-nix/commit/0dd9614dd08aab39f7683ee99314f2dd00884994))
* add explicit npm upgrade for OIDC support ([7fe4a60](https://github.com/cernoh/opentmux-nix/commit/7fe4a60a9d579dd6726157598a6b59fc8e5d6ab3))
* add registry-url to enable npm OIDC auth path ([63a8b72](https://github.com/cernoh/opentmux-nix/commit/63a8b7297680f725cb8d9af4fac2755a118cc099))
* add token clearing like working package ([f8162e4](https://github.com/cernoh/opentmux-nix/commit/f8162e4bdaae7e7b738ea26da0b8bfcf8fe52038))
* bypass tmux wrapper for interactive mode (no args) ([51acfd5](https://github.com/cernoh/opentmux-nix/commit/51acfd5bf4e3e83cf1cf7c3ab5974894d876da19))
* **ci:** actually switch to bun workflow ([5e5e37a](https://github.com/cernoh/opentmux-nix/commit/5e5e37ac25c374b90b31e163d6e717683006a155))
* **ci:** configure OIDC publishing by clearing token envs ([a8c8e11](https://github.com/cernoh/opentmux-nix/commit/a8c8e116aa1aba40f30517b1af8a2ea2382d619e))
* **ci:** configure package for public access and remove registry-url to enable OIDC ([190bf03](https://github.com/cernoh/opentmux-nix/commit/190bf03b139a1726f073e6f224b044ca8024c158))
* **ci:** delete .npmrc before publishing to ensure OIDC auth ([780dc03](https://github.com/cernoh/opentmux-nix/commit/780dc03ed5343d20fec1cfb5627decf1f42eb80f))
* **ci:** delete package-lock.json before install and add deps ([8a85312](https://github.com/cernoh/opentmux-nix/commit/8a853124b441ab856571c5de0a71406e0f659bd1))
* **ci:** restore registry-url and clear tokens to match working reference ([7100e11](https://github.com/cernoh/opentmux-nix/commit/7100e11c83eff0e7d0df88caaf25451db9620805))
* **ci:** use npm install instead of npm ci to fix linux build ([8334bfb](https://github.com/cernoh/opentmux-nix/commit/8334bfb8540de60796d70b81aaa2cd9208a9422e))
* **cli:** allow -reap flag and run it before port checks ([aa1038e](https://github.com/cernoh/opentmux-nix/commit/aa1038e5e1fa1fd95ca4db9cbb1e0dded923e39f))
* correct GitHub Actions workflows for OIDC publishing ([2b351c0](https://github.com/cernoh/opentmux-nix/commit/2b351c048cbaabfa57b6c0cbb8a4b33eae96109f))
* cross-platform install script and updated docs ([2ecf9a0](https://github.com/cernoh/opentmux-nix/commit/2ecf9a0d77c637407371b859e64a4a55f7f86e4c))
* ensure interactive mode launches tmux session ([d3444ed](https://github.com/cernoh/opentmux-nix/commit/d3444ed28d02632acd25fb043430984b9789192d))
* handle opentmux symlink in argv parsing ([baa8c7e](https://github.com/cernoh/opentmux-nix/commit/baa8c7e80cf971d08f2c44f274e6791b9a3bb3a5))
* handle symlinked binaries in argument parsing ([9dea6e0](https://github.com/cernoh/opentmux-nix/commit/9dea6e05a5ca33a7f86b43ddd0f886830b0e724f))
* improve argument parsing to correctly handle -reap and CLI commands ([1228616](https://github.com/cernoh/opentmux-nix/commit/12286165cfebb1948992b8584127423d4c20652b))
* improve security and achieve full type safety ([f05a9d6](https://github.com/cernoh/opentmux-nix/commit/f05a9d67ffe8a216ff4e3aba747f5f0f37336d3d))
* installer now overwrites outdated alias configuration ([bdc7be6](https://github.com/cernoh/opentmux-nix/commit/bdc7be68c4b304832ecffcba92352209bb964553))
* **layout:** ensure custom multi-column layout applies for 1-3 agents ([0e2176c](https://github.com/cernoh/opentmux-nix/commit/0e2176c8bcff7c0d77bb070a1f005fd9d9533a4b))
* make postinstall optional for CI environments ([4667e66](https://github.com/cernoh/opentmux-nix/commit/4667e66a3f37c3516093ee9c014bdee56877fb33))
* make zombie reaper fail-safe and robust to API changes ([ee71ead](https://github.com/cernoh/opentmux-nix/commit/ee71eadcd4084bb8c7ded2d0e3ab54a8b725d1ad))
* pass through all flags to opencode without interception ([ebcbdc7](https://github.com/cernoh/opentmux-nix/commit/ebcbdc74b302eedc3e7f36a8b44d782812e0e0dc))
* prevent aggressive killing of healthy sessions (Exit 137) and fix log suppression ([67a7d21](https://github.com/cernoh/opentmux-nix/commit/67a7d2182a43c7083c31fdcecf28fc194ca5504f))
* quote npmDepsHash value in nix/package.nix ([63d124e](https://github.com/cernoh/opentmux-nix/commit/63d124e4302f18161a227d0319e7ff12112af25e))
* **reaper:** improve zombie detection regex and url matching ([21feab3](https://github.com/cernoh/opentmux-nix/commit/21feab383aedebfb34bc94e65b6a17861f721182))
* reclaim idle opencode ports ([fd258b6](https://github.com/cernoh/opentmux-nix/commit/fd258b63993b6cf01f1367f2d687f7a788fcb9e1))
* remove 'cc' alias from opentmux install script ([8d9d217](https://github.com/cernoh/opentmux-nix/commit/8d9d21731f4094d80b7c46a79b82fd0212955123))
* remove empty token env vars blocking OIDC ([4bb524d](https://github.com/cernoh/opentmux-nix/commit/4bb524d92e15a37e54fee3529af376c3d3e8fcd0))
* remove environment constraint from release workflow ([df54176](https://github.com/cernoh/opentmux-nix/commit/df541767b945b82ce7e8c40ccd1d6ff1061465c9))
* remove environment requirement and use NPM_TOKEN for publishing ([f9e8ba1](https://github.com/cernoh/opentmux-nix/commit/f9e8ba147b0fa4b0ce135bbf7c8aca31959d69b9))
* remove leading ./ from bin path in package.json ([a40547d](https://github.com/cernoh/opentmux-nix/commit/a40547d6b0948b9e109637d5e846b99eff68de6a))
* rename bin file to opentmux.ts ([83c3b14](https://github.com/cernoh/opentmux-nix/commit/83c3b1431fcf9304dc712940785d550a5664171e))
* restore flag extraction in wrapper to prevent opencode binary errors ([8086bba](https://github.com/cernoh/opentmux-nix/commit/8086bba0a0a230fc1ef40ffd49d55696b1e1bd6b))
* restore simplified launch logic for opencode-tmux ([d004dca](https://github.com/cernoh/opentmux-nix/commit/d004dca82748deb9c12ab59f9442b7a7a6053a1a))
* restore SpawnQueue and fix pane resizing regression (revert to v1.3.0 logic) ([91db75d](https://github.com/cernoh/opentmux-nix/commit/91db75d15f1f1b5187f915292f0284da7d59f7e4))
* robust alias handling and binary detection ([7215eaa](https://github.com/cernoh/opentmux-nix/commit/7215eaa4b8fa89e3e4b1cebea8e0f8952e902aec))
* scope package to [@angansamadder](https://github.com/angansamadder) and bump to 1.1.2 ([8320ac3](https://github.com/cernoh/opentmux-nix/commit/8320ac3b7228aa54bad40c331ca8e1dcb135c2b8))
* stabilize trusted npm publishing ([e4433e3](https://github.com/cernoh/opentmux-nix/commit/e4433e3c13d88b05fcefe05b61c80410b7bcd5b1))
* support stats command and suppress info logs ([2a2f380](https://github.com/cernoh/opentmux-nix/commit/2a2f3801d2cf7d98460fee9e2d46fcc19dd24323))
* test OIDC publishing with trusted publisher ([ae15478](https://github.com/cernoh/opentmux-nix/commit/ae154789120d5bad35d954f7a5ade04e901478cf))
* **tmux:** add singleton guard to zombie reaper ([3ec6afc](https://github.com/cernoh/opentmux-nix/commit/3ec6afc28c79a6aa31dfcfece3d9b2178b487e8f))
* **tmux:** add startup reaper for zombie attach processes ([058e0f1](https://github.com/cernoh/opentmux-nix/commit/058e0f158667ddf668a5f8f74d742d1cea1ff18e))
* **tmux:** resolve log suppression and aggressive port reclamation ([010af4c](https://github.com/cernoh/opentmux-nix/commit/010af4c755569a9037dc2f981a1f4f2b3b438365))
* trigger automated release with RELEASE_PAT ([2c99ff6](https://github.com/cernoh/opentmux-nix/commit/2c99ff694fa0c6e20ea55b0d75281cd3f986be6f))
* trigger release to test OIDC with npm upgrade ([1d9eab1](https://github.com/cernoh/opentmux-nix/commit/1d9eab1bbafa8a8d3eeea6f6ecb30928eadc4201))
* trigger release with corrected OIDC workflows ([6d682fc](https://github.com/cernoh/opentmux-nix/commit/6d682fc066c8a6c1b3a4b9b640a8c0a73374622a))
* update CLI alias generation to use opentmux binary name ([fb4a058](https://github.com/cernoh/opentmux-nix/commit/fb4a058abc3e493abfe2cc69be6d4b9ed4dff3af))
* update release workflow and prevent accidental major version bumps ([0a5258a](https://github.com/cernoh/opentmux-nix/commit/0a5258a2ddd58635ff418b039d56c40e6766f51a))
* Use 'plugin' (singular) instead of 'plugins' in docs ([ef4a847](https://github.com/cernoh/opentmux-nix/commit/ef4a847997108404d04bec9e6ef76e3cab5bb0b6))
* use OIDC Trusted Publisher for npm authentication ([f5da296](https://github.com/cernoh/opentmux-nix/commit/f5da29627d37c5b3247e763593571df3b5ca3710))
* use RELEASE_PAT for workflow triggering ([381a161](https://github.com/cernoh/opentmux-nix/commit/381a16113dbf91c492cc924615ad1ceb1ba0ee94))
* use string format for bin field instead of object ([8b21ed0](https://github.com/cernoh/opentmux-nix/commit/8b21ed01b446e2284445053d298532805919f563))
* v1.0.8 ensures generic alias updates ([7649cd3](https://github.com/cernoh/opentmux-nix/commit/7649cd367a1554acad3f68e8da89528fa766530f))

## [1.5.6](https://github.com/AnganSamadder/opentmux/compare/v1.5.5...v1.5.6) (2026-02-11)


### Bug Fixes

* add explicit npm upgrade for OIDC support ([7fe4a60](https://github.com/AnganSamadder/opentmux/commit/7fe4a60a9d579dd6726157598a6b59fc8e5d6ab3))
* trigger release to test OIDC with npm upgrade ([1d9eab1](https://github.com/AnganSamadder/opentmux/commit/1d9eab1bbafa8a8d3eeea6f6ecb30928eadc4201))

## [1.5.5](https://github.com/AnganSamadder/opentmux/compare/v1.5.4...v1.5.5) (2026-02-11)


### Bug Fixes

* test OIDC publishing with trusted publisher ([ae15478](https://github.com/AnganSamadder/opentmux/commit/ae154789120d5bad35d954f7a5ade04e901478cf))

## [1.5.4](https://github.com/AnganSamadder/opentmux/compare/v1.5.3...v1.5.4) (2026-02-11)


### Bug Fixes

* trigger automated release with RELEASE_PAT ([2c99ff6](https://github.com/AnganSamadder/opentmux/commit/2c99ff694fa0c6e20ea55b0d75281cd3f986be6f))
* use RELEASE_PAT for workflow triggering ([381a161](https://github.com/AnganSamadder/opentmux/commit/381a16113dbf91c492cc924615ad1ceb1ba0ee94))

## [1.5.3](https://github.com/AnganSamadder/opentmux/compare/v1.5.2...v1.5.3) (2026-02-10)


### Bug Fixes

* correct GitHub Actions workflows for OIDC publishing ([2b351c0](https://github.com/AnganSamadder/opentmux/commit/2b351c048cbaabfa57b6c0cbb8a4b33eae96109f))

## [1.5.2](https://github.com/AnganSamadder/opentmux/compare/v1.5.1...v1.5.2) (2026-02-10)


### Bug Fixes

* bypass tmux wrapper for interactive mode (no args) ([51acfd5](https://github.com/AnganSamadder/opentmux/commit/51acfd5bf4e3e83cf1cf7c3ab5974894d876da19))
* correct GitHub Actions workflows for OIDC publishing ([2b351c0](https://github.com/AnganSamadder/opentmux/commit/2b351c048cbaabfa57b6c0cbb8a4b33eae96109f))
* handle opentmux symlink in argv parsing ([baa8c7e](https://github.com/AnganSamadder/opentmux/commit/baa8c7e80cf971d08f2c44f274e6791b9a3bb3a5))
* handle symlinked binaries in argument parsing ([9dea6e0](https://github.com/AnganSamadder/opentmux/commit/9dea6e05a5ca33a7f86b43ddd0f886830b0e724f))
* remove leading ./ from bin path in package.json ([a40547d](https://github.com/AnganSamadder/opentmux/commit/a40547d6b0948b9e109637d5e846b99eff68de6a))
* use string format for bin field instead of object ([8b21ed0](https://github.com/AnganSamadder/opentmux/commit/8b21ed01b446e2284445053d298532805919f563))

## [1.5.2] - 2026-02-10

### Fixed

- Fixed critical bug in `opentmux` binary argument parsing where npm global installs (which use symlinks without extensions) were incorrectly identified as binary executables instead of node scripts, causing infinite recursion loops.

## [1.5.0](https://github.com/AnganSamadder/opentmux/compare/v1.4.4...v1.5.0) (2026-02-09)

### Features

- release v1.5.0 - port rotation and aggressive reaping ([e168a83](https://github.com/AnganSamadder/opentmux/commit/e168a83a78b7ec00cabf1f7c8260d3555b7c2eb2))

### Bug Fixes

- improve argument parsing to correctly handle -reap and CLI commands ([1228616](https://github.com/AnganSamadder/opentmux/commit/12286165cfebb1948992b8584127423d4c20652b))
- improve security and achieve full type safety ([f05a9d6](https://github.com/AnganSamadder/opentmux/commit/f05a9d67ffe8a216ff4e3aba747f5f0f37336d3d))
- make zombie reaper fail-safe and robust to API changes ([ee71ead](https://github.com/AnganSamadder/opentmux/commit/ee71eadcd4084bb8c7ded2d0e3ab54a8b725d1ad))
- update release workflow and prevent accidental major version bumps ([0a5258a](https://github.com/AnganSamadder/opentmux/commit/0a5258a2ddd58635ff418b039d56c40e6766f51a))

## [1.5.0] - 2026-02-06

### Added

- **Port Rotation**: New `rotate_port` config option (default: `false`). When enabled, automatically kills the oldest session to make room for new ones when the port limit is reached.
- **Configurable Port Range**: New `max_ports` config option (default: `10`) to control how many concurrent sessions are allowed.
- **Aggressive Reaping**: The `-reap` command now aggressively detects and kills stuck servers that fail to respond to health checks.

### Fixed

- **Suicide Prevention**: `-reap` now whitelists the current session's port to prevent accidental self-termination.
- **Reap Command Logic**: Fixed a bug where `oc -reap` would fail with "No available ports" if all ports were occupied.
- **Health Check Robustness**: Added retry logic (3 attempts) to server health checks to avoid false positives on busy servers.

## [1.4.7] - 2026-02-05

### Fixed

- **CLI Argument Handling**: Improved logic to correctly identify CLI commands (like `config`, `auth`, `agent`) versus TUI commands, ensuring arguments are passed correctly.
- **Graceful Shutdown**: Fixed issue where `AbortError` (code 20) during interrupt (Ctrl+C) was logged as a fatal error. Now handles it cleanly by exiting with code 0.
- **Zombie Reaper Flag**: Fixed `--reap` flag handling to ensure it executes the reaper logic instead of passing it to opencode.

## [1.4.6] - 2026-02-05

### Fixed

- Internal release with CLI logic improvements. Superseded by 1.4.7.

## [1.4.5] - 2025-02-04

### Fixed

- **Plugin duplicate detection**: Fixed `update-plugins.ts` to properly detect local path installations (`/opentmux`) in addition to registry names, preventing duplicate plugin entries
- **Runtime duplicate prevention**: Added `isInitialized` guard in plugin entry point to prevent duplicate initialization if plugin is loaded multiple times
- **Race condition prevention**: Added `pendingSessions` Set to prevent race conditions when multiple child sessions spawn simultaneously
- **Pane layout fixes**: Fixed main-vertical-multi-column layout to correctly identify the main pane and agent panes

## [1.4.0] - 2026-02-03

### Features

- **Zombie Reaper**: Introduced a new system to automatically detect and clean up orphaned "opencode attach" processes that persist after sessions end.
  - Added `ZombieReaper` class that safely identifies zombies by verifying session status with the server.
  - Added background reaping (default interval: 30s) to `TmuxSessionManager`.
  - Added CLI command `opentmux --reap` for manual global cleanup of zombie processes.
- **Safety**: Reaper strictly validates that processes belong to the current server instance before killing them, preventing accidental termination of other active OpenCode instances.

### Fixes

- Fixed memory leak where `opencode attach` processes would remain running indefinitely after their parent tmux pane or session was closed.

## [1.3.2](https://github.com/AnganSamadder/opentmux/compare/v1.3.1...v1.3.2) (2026-02-03)

### Bug Fixes

- rename bin file to opentmux.ts ([83c3b14](https://github.com/AnganSamadder/opentmux/commit/83c3b1431fcf9304dc712940785d550a5664171e))
- restore SpawnQueue and fix pane resizing regression (revert to v1.3.0 logic) ([91db75d](https://github.com/AnganSamadder/opentmux/commit/91db75d15f1f1b5187f915292f0284da7d59f7e4))
- update CLI alias generation to use opentmux binary name ([fb4a058](https://github.com/AnganSamadder/opentmux/commit/fb4a058abc3e493abfe2cc69be6d4b9ed4dff3af))

## [1.2.7] - 2026-01-27

### Fixed

- Fixed issue where tmux window closes instantly when opencode exits with success code (0).
- Changed shell wrapper to always pause and show exit code after execution, ensuring users can see final output/errors before the window closes.

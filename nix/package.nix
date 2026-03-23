# nix/package.nix
#
# Builds the opentmux Node.js package from the local TypeScript source using
# buildNpmPackage. The resulting derivation provides the `opentmux` binary.
#
# Alternatively, run:
#   nix run nixpkgs#prefetch-npm-deps -- path/to/package-lock.json

{ lib
, buildNpmPackage
, esbuild
, makeWrapper
, nodejs_22
, src
}:

buildNpmPackage {
  pname = "opentmux";
  version = "1.5.7";

  inherit src;

  nodejs = nodejs_22;

  # Hash of the fetched npm dependency closure.  Replace with the real hash
  # after a first failed build (see note above).
  npmDepsHash = "sha256-IryEQT3tJhDai7lUC5m4vvAcJnjpyatwA36KCOFinfs=";

  # buildNpmPackage already passes --ignore-scripts during the offline install
  # step, which prevents the postinstall script from attempting to modify the
  # user's shell config (that is handled by the home-manager module instead).

  nativeBuildInputs = [ esbuild makeWrapper ];

  # tsup (the TypeScript bundler) locates the esbuild binary by looking inside
  # the platform-specific @esbuild/* package shipped in node_modules.  When npm
  # runs with --ignore-scripts those packages' own install hooks are skipped, so
  # the binary symlink is never created.  We point tsup at the esbuild binary
  # that nixpkgs already provides for the current platform.
  preBuild = ''
    local platform
    platform=$(node -e "
      const p = process.platform === 'darwin' ? 'darwin' : 'linux';
      const a = process.arch === 'arm64' ? 'arm64' : 'x64';
      process.stdout.write(p + '-' + a);
    ")
    mkdir -p "node_modules/@esbuild/$platform"
    ln -sf "${esbuild}/bin/esbuild" "node_modules/@esbuild/$platform/esbuild"
  '';

  # Run the TypeScript compiler / bundler.
  npmBuildScript = "build";

  # After the build tsup produces a self-contained ESM bundle inside dist/.
  # We install only that directory plus the shim wrapper so the binary can be
  # called without the caller needing to know the Node.js path.
  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/node_modules/opentmux"
    cp -r dist "$out/lib/node_modules/opentmux/"
    cp package.json "$out/lib/node_modules/opentmux/"

    mkdir -p "$out/bin"
    makeWrapper "${nodejs_22}/bin/node" "$out/bin/opentmux" \
      --add-flags "$out/lib/node_modules/opentmux/dist/bin/opentmux.js"

    runHook postInstall
  '';

  meta = with lib; {
    description =
      "OpenCode tmux integration: automatically opens subagent panes and "
      + "renders real-time agent execution with smart layouts";
    homepage = "https://github.com/AnganSamadder/opentmux";
    license = licenses.mit;
    mainProgram = "opentmux";
    platforms = platforms.unix;
  };
}

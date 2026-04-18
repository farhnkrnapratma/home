set shell := ["/usr/bin/env", "bash", "-euo", "pipefail", "-c"]

build_script    := "./build.ts"
serve_script    := "./serve.ts"

alias a := audit
alias b := build
alias c := clean
alias d := check
alias f := format
alias i := install
alias l := lint
alias s := serve
alias u := update

[doc("Run standard maintenance workflow: clean, audit, and update")]
@default:
  echo "[just] Starting standard project maintenance..."
  @just clean
  @just format
  @just lint
  @just check
  echo "[just] Maintenance workflow completed successfully."

[doc("Audit all packages for vulnerabilities")]
@audit:
  echo "[just] Auditing packages with Bun..."
  @bun audit
  echo "[just] Audit finished."

[doc("Build the project after generating and validating")]
@build:
  echo "[just] Starting full build process..."
  @just format
  @just lint
  @just check
  @bun run {{build_script}}
  echo "[just] Build completed successfully."

[doc("Remove build directory...")]
@clean:
  echo "[just] Cleaning up build artifacts..."
  @rm -rf ./build
  echo "[just] Cleanup finished."

[doc("Run Biome check to fix formatting and linting issues")]
@check:
  echo "[just] Running Biome check and auto-fix..."
  @bunx --bun @biomejs/biome check --write
  echo "[just] Check finished."

[doc("Format the project files (Biome, shfmt, xq)")]
@format:
  echo "[just] Formatting project files..."
  @bunx --bun @biomejs/biome format --write
  echo "[just] Formatting completed."

[doc("Install all project dependencies")]
@install:
  echo "[just] Installing dependencies with Bun..."
  @bun install
  echo "[just] Installation finished."

[doc("Lint the project (Biome and Shellcheck)")]
@lint:
  echo "[just] Linting project files..."
  @bunx --bun @biomejs/biome lint --write
  echo "[just] Linting finished."

[doc("Start the development server with hot reload")]
@serve:
  echo "[just] Starting development server on {{serve_script}}..."
  @bun run {{serve_script}} --hot

[doc("Update all project packages")]
@update:
  echo "[just] Updating Bun packages..."
  @bun update
  echo "[just] Update finished."

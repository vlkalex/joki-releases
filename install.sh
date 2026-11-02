#!/bin/bash
# Installs (or updates) JOKI for Mac from the newest "macos-v..." release of vlkalex/joki-releases:
#   curl -fsSL https://raw.githubusercontent.com/vlkalex/joki-releases/main/install.sh | bash
# Everything runs inside main(), so a download cut off half-way never executes a partial script.
set -euo pipefail

main() {
  local repo="vlkalex/joki-releases"
  local dest="${JOKI_INSTALL_DIR:-/Applications}"   # override only for testing
  local app="${dest}/JOKI.app"

  if [[ "$(uname)" != "Darwin" ]]; then echo "JOKI runs on macOS only." >&2; exit 1; fi
  local major
  major=$(sw_vers -productVersion | cut -d. -f1)
  if (( major < 14 )); then echo "JOKI needs macOS 14 (Sonoma) or later; this Mac has $(sw_vers -productVersion)." >&2; exit 1; fi

  tmp=$(mktemp -d)
  trap 'hdiutil detach "${tmp}/mnt" -quiet 2>/dev/null || true; rm -rf "${tmp}"' EXIT

  # The newest Mac release (the repo may also hold Android releases), resolved once so the DMG and its
  # checksum come from the same release. GitHub lists releases newest first.
  local tag
  tag=$(curl -fsSL "https://api.github.com/repos/${repo}/releases?per_page=30" \
    | grep -oE '"tag_name": *"macos-v[0-9]+(\.[0-9]+)*"' | head -1 | grep -oE 'macos-v[0-9.]+' || true)
  [[ "${tag}" =~ ^macos-v[0-9]+(\.[0-9]+)*$ ]] || { echo "Could not find the latest JOKI release." >&2; exit 1; }
  local base="https://github.com/${repo}/releases/download/${tag}"

  echo "Downloading JOKI ${tag#macos-v}..."
  curl -fL --progress-bar "${base}/JOKI.dmg" -o "${tmp}/JOKI.dmg"
  curl -fsSL "${base}/JOKI.dmg.sha256" -o "${tmp}/JOKI.dmg.sha256" \
    || { echo "The release has no checksum; not installing." >&2; exit 1; }
  local expected actual
  expected=$(awk '{print $1}' "${tmp}/JOKI.dmg.sha256")
  actual=$(shasum -a 256 "${tmp}/JOKI.dmg" | awk '{print $1}')
  [[ -n "${expected}" && "${expected}" == "${actual}" ]] || { echo "Checksum mismatch; the download is damaged. Try again." >&2; exit 1; }

  hdiutil attach "${tmp}/JOKI.dmg" -nobrowse -readonly -noautoopen -mountpoint "${tmp}/mnt" -quiet
  [[ -d "${tmp}/mnt/JOKI.app" && ! -L "${tmp}/mnt/JOKI.app" ]] || { echo "The download does not contain JOKI.app." >&2; exit 1; }

  local sudo=""
  [[ -w "${dest}" ]] || sudo="sudo"
  echo "Installing to ${app}..."
  # Copy next to the old app first, then swap: an interrupted copy never leaves you without JOKI.
  local staged="${dest}/.JOKI-install-$$.app"
  pkill -x JOKI 2>/dev/null && sleep 1 || true
  ${sudo} rm -rf "${staged}"
  ${sudo} cp -R "${tmp}/mnt/JOKI.app" "${staged}"
  ${sudo} rm -rf "${app}"
  ${sudo} mv "${staged}" "${app}"
  # The app is not notarized by Apple; this removes the "cannot be opened" block for this copy only.
  ${sudo} xattr -dr com.apple.quarantine "${app}" 2>/dev/null || true

  echo "Done. Starting JOKI..."
  open "${app}"
}

main "$@"

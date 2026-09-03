#!/usr/bin/env bash
################################################################################
# Build and run the dotfiles installers inside throwaway containers.
#
# Usage:
#   ./make/test/run.sh                          # fast phase, all distros
#   ./make/test/run.sh --phase full ubuntu      # full install, one distro
#   ./make/test/run.sh --phase extras ubuntu    # the opt-in tool sets only
#   ./make/test/run.sh --no-headless archlinux  # include the 10GB of GUI packages
#   ./make/test/run.sh --keep-image             # skip the image rebuild
#
# Phases:
#   fast   syntax + dispatch + `make init` + `make test-symlinks`   (~1 min)
#   full   the whole installer end-to-end, then `make test`         (20-60 min)
#   extras the six optional installers - aws, gcp, azure, kubernetes,
#          llm, tui - which no `make install` path ever reaches      (10-25 min)
#
# Logs land in make/test/logs/<distro>-<phase>.log (gitignored).
# Exit code is the number of distros that reported failures.
################################################################################

set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
LOGS="$HERE/logs"

ALL_DISTROS=(ubuntu archlinux amazonlinux termux)

PHASE=fast
HEADLESS=1
BUILD=1
INSTALL_TIMEOUT=3600
EXTRAS_TIMEOUT=900
DISTROS=()

die() { echo "error: $*" >&2; exit 2; }

while [ $# -gt 0 ]; do
    case "$1" in
        --phase)        PHASE="${2:-}"; shift 2 ;;
        --phase=*)      PHASE="${1#*=}"; shift ;;
        --no-headless)  HEADLESS=0; shift ;;
        --keep-image)   BUILD=0; shift ;;
        --timeout)      INSTALL_TIMEOUT="${2:-}"; shift 2 ;;
        --timeout=*)    INSTALL_TIMEOUT="${1#*=}"; shift ;;
        --extras-timeout)   EXTRAS_TIMEOUT="${2:-}"; shift 2 ;;
        --extras-timeout=*) EXTRAS_TIMEOUT="${1#*=}"; shift ;;
        -h | --help)    sed -n '2,22p' "${BASH_SOURCE[0]}"; exit 0 ;;
        -*)             die "unknown option: $1" ;;
        *)              DISTROS+=("$1"); shift ;;
    esac
done

case "$PHASE" in
    fast | full | extras) ;;
    *) die "--phase must be 'fast', 'full' or 'extras', got '$PHASE'" ;;
esac

[ "${#DISTROS[@]}" -eq 0 ] && DISTROS=("${ALL_DISTROS[@]}")

for d in "${DISTROS[@]}"; do
    [ -f "$HERE/Dockerfile.$d" ] || die "no Dockerfile.$d (have: ${ALL_DISTROS[*]})"
done

command -v docker >/dev/null 2>&1 || die "docker is not installed"
docker info >/dev/null 2>&1 || die "cannot talk to the docker daemon"

mkdir -p "$LOGS"

echo "repo:    $REPO"
echo "phase:   $PHASE"
echo "distros: ${DISTROS[*]}"
echo "headless: $HEADLESS"
echo

overall=0
declare -a REPORT=()

for distro in "${DISTROS[@]}"; do
    image="dotfiles-test:$distro"
    log="$LOGS/$distro-$PHASE.log"

    echo "================================================================================"
    echo "== $distro ($PHASE)"
    echo "================================================================================"

    if [ "$BUILD" -eq 1 ]; then
        echo "-- building $image"
        if ! docker build -t "$image" -f "$HERE/Dockerfile.$distro" "$HERE" \
                > "$LOGS/$distro-build.log" 2>&1; then
            echo "-- BUILD FAILED (see $LOGS/$distro-build.log)"
            tail -20 "$LOGS/$distro-build.log"
            REPORT+=("$distro: BUILD FAILED")
            overall=$((overall + 1))
            continue
        fi
    fi

    # Read-only mount: install-ubuntu.sh runs `git config --global` against the
    # .gitconfig that init.sh symlinks back into the repo, and the rubygems tarball
    # extracts into the CWD. The entrypoint copies to $HOME/dotfiles before touching
    # anything.
    #
    # No -i and no TTY: a missing -y should surface as a timeout, not a prompt that
    # someone can answer.
    echo "-- running (log: $log)"
    docker run --rm \
        --name "dotfiles-test-$distro-$PHASE" \
        -v "$REPO:/staging:ro" \
        -e "PHASE=$PHASE" \
        -e "DISTRO=$distro" \
        -e "INSTALL_TIMEOUT=$INSTALL_TIMEOUT" \
        -e "EXTRAS_TIMEOUT=$EXTRAS_TIMEOUT" \
        -e "DOTFILES_HEADLESS=$HEADLESS" \
        "$image" > "$log" 2>&1
    rc=$?

    summary="$(sed -n '/^##### FAILED=/p' "$log" | tail -1)"
    echo "-- exit=$rc ${summary:-<no summary block>}"
    sed -n '/^##### SUMMARY/,$p' "$log" | sed 's/^/   /'

    if [ "$rc" -eq 0 ]; then
        REPORT+=("$distro: PASS")
    else
        REPORT+=("$distro: $rc failed step(s) ${summary:-}")
        overall=$((overall + 1))
    fi
    echo
done

echo "================================================================================"
echo "== RESULTS ($PHASE)"
echo "================================================================================"
for line in "${REPORT[@]}"; do
    echo "  $line"
done
echo
echo "logs: $LOGS"

exit "$overall"

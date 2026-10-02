#!/usr/bin/env bash
# Run in environment setup; publication and fresh-task skill discovery are separate.
set -euo pipefail
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec "$script_dir/agent-env" apply --profile cloud "$@"

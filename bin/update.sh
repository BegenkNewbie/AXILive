#!/bin/bash
# Script update sekarang sudah digabung ke dalam install.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/install.sh" "$@"
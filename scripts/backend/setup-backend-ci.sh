#!/usr/bin/env bash
set -euo pipefail

echo "Setting up backend CI dependencies..."

cd "$(dirname "$0")/../../app/backend"

npm install

npm install --save-dev jest supertest

echo "Backend CI dependencies installed successfully."

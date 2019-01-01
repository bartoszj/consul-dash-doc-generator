#!/usr/bin/env bash

set -ex

# Read parameters
TAG=$1
if [ -z $TAG ]; then
    echo '"TAG" must be specified'
    exit 1
fi

# Paths
CWD=$(pwd)
BUILD_PATH="${CWD}/build/$TAG"
CONSUL_PATH="${CWD}/consul"
WEBSITE_PATH="${CONSUL_PATH}/website"

# Clean build
rm -rf "${BUILD_PATH}"
mkdir -p "${BUILD_PATH}"

# Checkout and clean
git clone "https://github.com/hashicorp/consul.git" || true
cd "${CONSUL_PATH}"
git fetch --all --prune
git checkout -- .
git checkout "v${TAG}"

# Install gems
cd "${WEBSITE_PATH}"
bundle install

rm Rakefile || true
# cp "${CWD}/Rakefile" .
ln -s "${CWD}/Rakefile" || true

# Build
rake

mv Consul.tgz "${BUILD_PATH}"

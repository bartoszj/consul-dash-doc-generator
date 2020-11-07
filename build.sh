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
if [[ ${OSTYPE} == "linux-gnu"* ]] && [[ -d ${WEBSITE_PATH} ]]; then
  sudo chown -R $(id -u):$(id -g) ${WEBSITE_PATH}
fi

# Checkout and clean
git clone "https://github.com/hashicorp/consul.git" || true
cd "${CONSUL_PATH}"
git fetch --all --prune
git clean -fdx
git checkout -- .
git checkout "v${TAG}"

# Install gems
cd "${WEBSITE_PATH}"

rm Rakefile || true
# cp "${CWD}/Rakefile" .
ln -s "${CWD}/Rakefile" || true

# Build
if [[ ${OSTYPE} == "linux-gnu"* ]]; then
  sed -i'' 's|npm run static$|bash -c \"npm install; npm run static\"|g' Makefile
else
  sed -i '' 's|npm run static$|bash -c \"npm install; npm run static\"|g' Makefile
fi
rake

mv Consul.tgz "${BUILD_PATH}"

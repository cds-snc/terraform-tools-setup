#!/bin/bash

TEST_DIR="./test_dir"

# Removing existing test_bin
rm -rf ${TEST_DIR}

# Set versions
CONFTEST_VERSION="${CONFTEST_VERSION:-0.30.0}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.1.7}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-0.36.3}"

# Call script
mkdir ${TEST_DIR}
BIN_DIR=${TEST_DIR} ./get_tools.sh

# Test conftest
OUTPUT=$(${TEST_DIR}/conftest --version)
EXPECTED="Version: 0.30.0"

if [ "${OUTPUT}" != "${EXPECTED}" ]; then
  echo "Test conftest failed"
  exit 1
fi

# Test terraform
OUTPUT=$(${TEST_DIR}/terraform --version)
EXPECTED="Terraform v1.1.7
on linux_amd64"

if [ "${OUTPUT}" != "${EXPECTED}" ]; then
  echo "Test terraform failed"
  exit 1
fi

# Test terragrunt
OUTPUT=$(${TEST_DIR}/terragrunt --version)
EXPECTED="terragrunt version v0.36.3"

if [ "${OUTPUT}" != "${EXPECTED}" ]; then
  echo "Test terragrunt failed"
  exit 1
fi

echo "All tests passed!"
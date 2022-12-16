#!/bin/bash

TEST_DIR="./test_dir"
RUNNER_TEMP="./"

# Removing existing test_bin
rm -rf ${TEST_DIR}

# Set versions
CONFTEST_VERSION="${CONFTEST_VERSION:-0.36.0}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.3.6}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-0.42.5}"

# Call script
mkdir ${TEST_DIR}
BIN_DIR=${TEST_DIR} RUNNER_TEMP=${RUNNER_TEMP} ./get_tools.sh

# Test conftest
OUTPUT=$(${TEST_DIR}/conftest --version)
EXPECTED="Version: ${CONFTEST_VERSION}"

if [ "${OUTPUT}" != "${EXPECTED}" ]; then
  echo "Test conftest failed"
  exit 1
fi

# Test terraform
OUTPUT=$(${TEST_DIR}/terraform --version)
EXPECTED="Terraform v${TERRAFORM_VERSION}
on linux_amd64"

if [ "${OUTPUT}" != "${EXPECTED}" ]; then
  echo "Test terraform failed"
  exit 1
fi

# Test terragrunt
OUTPUT=$(${TEST_DIR}/terragrunt --version)
EXPECTED="terragrunt version v${TERRAGRUNT_VERSION}"

if [ "${OUTPUT}" != "${EXPECTED}" ]; then
  echo "Test terragrunt failed"
  exit 1
fi

echo "All tests passed!"
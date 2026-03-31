#!/bin/bash

function test {
  local PROGRAM=$1
  local OUTPUT=$2
  local EXPECTED=$3

  echo "Testing $PROGRAM"
  echo "Output: $OUTPUT"
  echo "Expected: $EXPECTED"

  if [ "$OUTPUT" == "$EXPECTED" ]; then
    echo "PASS: $PROGRAM"
  else
    echo "FAIL: $PROGRAM"
    exit 1
  fi
}

TEST_DIR="./test_dir"
RUNNER_TEMP="./"

# Removing existing test_bin
rm -rf ${TEST_DIR}

# Set versions
export CONFTEST_VERSION="0.36.0"
export TERRAFORM_VERSION="1.14.3"
export TERRAGRUNT_VERSION="0.98.0"
export TF_SUMMARIZE_VERSION="0.2.3"
export TRUFFLEHOG_VERSION="3.90.12"

# Set a manual checksum
export TRUFFLEHOG_CHECKSUM="318fd1e8af68b54f4465437208582003a5948293ea401c5c67bb55f17e4e2102"

# Call script
mkdir ${TEST_DIR}
BIN_DIR=${TEST_DIR} RUNNER_TEMP=${RUNNER_TEMP} ./get_tools.sh

test "conftest" "$(${TEST_DIR}/conftest --version | head -n 1)" "Conftest: ${CONFTEST_VERSION}"
test "terraform" "$(${TEST_DIR}/terraform --version -json | jq -r .terraform_version)" "${TERRAFORM_VERSION}"
test "terragrunt" "$(${TEST_DIR}/terragrunt --version)" "terragrunt version v${TERRAGRUNT_VERSION}"
test "tf-summarize" "$(${TEST_DIR}/tf-summarize -v)" "Version: ${TF_SUMMARIZE_VERSION}"
test "trufflehog" "$(${TEST_DIR}/trufflehog --version)" "trufflehog ${TRUFFLEHOG_VERSION}"

echo "All tests passed!"
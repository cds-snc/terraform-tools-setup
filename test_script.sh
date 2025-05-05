#!/bin/bash

function test {
  local PROGRAM=$1
  local OUTPUT=$2
  local EXPECTED=$3

  echo "Testing $PROGRAM"
  echo "Output: $OUTPUT"
  echo "Expected: $EXPECTED"

  if [[ "$OUTPUT" =~ "$EXPECTED" ]]; then
    echo "PASS: $PROGRAM"
  else
    echo "FAIL: $PROGRAM"
    exit 1
  fi
}

TEST_DIR="./test_dir"
RUNNER_TEMP="./"

# Set versions
CONFTEST_VERSION="${CONFTEST_VERSION:-0.36.0}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.3.6}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-0.42.5}"
TF_SUMMARIZE_VERSION="${TF_SUMMARIZE_VERSION:-0.2.3}"

# Call script
mkdir -p ${TEST_DIR}
BIN_DIR=${TEST_DIR} RUNNER_TEMP=${RUNNER_TEMP} ./get_tools.sh

test "conftest" "$(${TEST_DIR}/conftest --version | head -n 1)" "Conftest: ${CONFTEST_VERSION}"
test "terraform" "$(${TEST_DIR}/terraform --version)" "Terraform v${TERRAFORM_VERSION}
on linux_amd64"
test "terragrunt" "$(${TEST_DIR}/terragrunt --version)" "terragrunt version v${TERRAGRUNT_VERSION}"
test "tf-summarize" "$(${TEST_DIR}/tf-summarize -v)" "Version: ${TF_SUMMARIZE_VERSION}"

echo "All tests passed!"
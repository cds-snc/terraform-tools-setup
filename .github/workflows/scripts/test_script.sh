#!/bin/bash
set -e

function test_version {
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

test_version "conftest" "$(conftest --version | head -n 1)" "Conftest: ${CONFTEST_VERSION}"
test_version "terraform" "$(terraform --version -json | jq -r .terraform_version)" "${TERRAFORM_VERSION}"
test_version "terragrunt" "$(terragrunt --version)" "terragrunt version v${TERRAGRUNT_VERSION}"
test_version "tf-summarize" "$(tf-summarize -v)" "Version: ${TF_SUMMARIZE_VERSION}"
test_version "trufflehog" "$(trufflehog --version)" "trufflehog ${TRUFFLEHOG_VERSION}"

echo "All tests passed!"

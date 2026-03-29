#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

BIN_DIR="${BIN_DIR:-/usr/local/bin}"
RUNNER_TEMP="${RUNNER_TEMP:-/tmp}"

cd "${RUNNER_TEMP}"

# Get conftest

if [[ -n "${CONFTEST_VERSION}" ]]; then
  echo "Getting conftest ${CONFTEST_VERSION} ..."
  wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz"
  if [[ -n "${CONFTEST_CHECKSUM}" ]]; then
    echo "${CONFTEST_CHECKSUM}  conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" | sha256sum --check --status
  else
    wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/checksums.txt"
    grep "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz$" < checksums.txt | sha256sum --check --status
    rm checksums.txt
  fi
  tar -zxvf "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" conftest
  chmod +x conftest
  mv conftest "${BIN_DIR}"
  rm "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz"
  echo "Done downloading conftest ${CONFTEST_VERSION}"
fi

# Get terraform

if [[ -n "${TERRAFORM_VERSION}" ]]; then
  echo "Getting terraform ${TERRAFORM_VERSION} ..."
  wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  if [[ -n "${TERRAFORM_CHECKSUM}" ]]; then
    echo "${TERRAFORM_CHECKSUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" | sha256sum --check --status
  else
    wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS"
    grep "terraform_${TERRAFORM_VERSION}_linux_amd64.zip$" < "terraform_${TERRAFORM_VERSION}_SHA256SUMS" | sha256sum --check --status
    rm "terraform_${TERRAFORM_VERSION}_SHA256SUMS"
  fi
  unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" terraform
  chmod +x terraform
  mv terraform "${BIN_DIR}"
  rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  echo "Done downloading terraform ${TERRAFORM_VERSION}"
fi

# Get terragrunt

if [[ -n "${TERRAGRUNT_VERSION}" ]]; then
  echo "Getting terragrunt ${TERRAGRUNT_VERSION} ..."
  wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
  if [[ -n "${TERRAGRUNT_CHECKSUM}" ]]; then
    echo "${TERRAGRUNT_CHECKSUM}  terragrunt_linux_amd64" | sha256sum --check --status
  else
    wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/SHA256SUMS"
    grep "terragrunt_linux_amd64$" < SHA256SUMS | sha256sum --check --status
    rm SHA256SUMS
  fi
  mv "terragrunt_linux_amd64" terragrunt
  chmod +x terragrunt
  mv terragrunt "${BIN_DIR}"
  echo "Done downloading terragrunt ${TERRAGRUNT_VERSION}"
fi

# Get tf-summarize

if [[ -n "${TF_SUMMARIZE_VERSION}" ]]; then
  echo "Getting tf-summarize ${TF_SUMMARIZE_VERSION} ..."
  wget "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_linux_amd64.zip"
  if [[ -n "${TF_SUMMARIZE_CHECKSUM}" ]]; then
    echo "${TF_SUMMARIZE_CHECKSUM}  tf-summarize_linux_amd64.zip" | sha256sum --check --status
  else
    wget "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_SHA256SUMS"
    grep "tf-summarize_linux_amd64.zip$" < tf-summarize_SHA256SUMS | sha256sum --check --status
    rm "tf-summarize_SHA256SUMS"
  fi
  unzip "tf-summarize_linux_amd64.zip" tf-summarize
  chmod +x tf-summarize
  mv tf-summarize "${BIN_DIR}"
  rm "tf-summarize_linux_amd64.zip"
  echo "Done downloading tf-summarize ${TF_SUMMARIZE_VERSION}"
fi

# Get trufflehog

if [[ -n "${TRUFFLEHOG_VERSION}" ]]; then
  echo "Getting trufflehog ${TRUFFLEHOG_VERSION} ..."
  wget "https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz"
  if [[ -n "${TRUFFLEHOG_CHECKSUM}" ]]; then
    echo "${TRUFFLEHOG_CHECKSUM}  trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz" | sha256sum --check --status
  else
    wget "https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_checksums.txt"
    grep "trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz$" < "trufflehog_${TRUFFLEHOG_VERSION}_checksums.txt" | sha256sum --check --status
    rm "trufflehog_${TRUFFLEHOG_VERSION}_checksums.txt"
  fi
  tar -zxvf "trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz" trufflehog
  chmod +x trufflehog
  mv trufflehog "${BIN_DIR}"
  rm "trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz"
  echo "Done downloading trufflehog ${TRUFFLEHOG_VERSION}"
fi

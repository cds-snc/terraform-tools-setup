#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

BIN_DIR="${BIN_DIR:-/usr/local/bin}"
RUNNER_TEMP="${RUNNER_TEMP:-/tmp}"

# Set versions

CONFTEST_VERSION="${CONFTEST_VERSION:-0.36.0}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.3.6}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-0.42.5}"
TF_SUMMARIZE_VERSION="${TF_SUMMARIZE_VERSION:-0.2.3}"

CPU_ARCH=$(uname -m)

cd "${RUNNER_TEMP}"

# Get conftest

if [[ "${OSTYPE}" == "darwin"* ]]; then
  if [[ "${CPU_ARCH}" == "arm64" ]]; then
    CONFTEST_OS="Darwin_arm64"
    TERRAFORM_OS="darwin_arm64"
    TERRAGRUNT_OS="darwin_arm64"
    TF_SUMMARIZE_OS="darwin_arm64"
  else
    CONFTEST_OS="Darwin_x86_64"
    TERRAFORM_OS="darwin_amd64"
    TERRAGRUNT_OS="darwin_amd64"
    TF_SUMMARIZE_OS="darwin_amd64"
  fi
else
  if [[ "${CPU_ARCH}" == "aarch64" ]]; then
    CONFTEST_OS="Linux_arm64"
    TERRAFORM_OS="linux_arm64"
    TERRAGRUNT_OS="linux_arm64"
    TF_SUMMARIZE_OS="linux_arm64"
  else
    CONFTEST_OS="Linux_x86_64"
    TERRAFORM_OS="linux_amd64"
    TERRAGRUNT_OS="linux_amd64"
    TF_SUMMARIZE_OS="linux_amd64"
  fi
fi

echo "Getting conftest ${CONFTEST_VERSION} ..."
wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_${CONFTEST_OS}.tar.gz"
wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/checksums.txt"
grep "${CONFTEST_OS}.tar.gz" < checksums.txt | sha256sum --check  --status
tar -zxvf "conftest_${CONFTEST_VERSION}_${CONFTEST_OS}.tar.gz" conftest
chmod +x conftest
mv conftest "${BIN_DIR}"
rm "conftest_${CONFTEST_VERSION}_${CONFTEST_OS}.tar.gz" checksums.txt
echo "Done downloading conftest ${CONFTEST_VERSION}"

# Get terraform

echo "Getting terraform ${TERRAFORM_VERSION} ..."
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}.zip"
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS"
grep "${TERRAFORM_OS}.zip" < "terraform_${TERRAFORM_VERSION}_SHA256SUMS" | sha256sum --check  --status
unzip "terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}.zip" terraform
chmod +x terraform
mv terraform "${BIN_DIR}"
rm "terraform_${TERRAFORM_VERSION}_${TERRAFORM_OS}.zip" "terraform_${TERRAFORM_VERSION}_SHA256SUMS"
echo "Done downloading terraform ${TERRAFORM_VERSION}"

# Get terragrunt

echo "Getting terragrunt ${TERRAGRUNT_VERSION} ..."
wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_${TERRAGRUNT_OS}"
wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/SHA256SUMS"
grep "${TERRAGRUNT_OS}" < SHA256SUMS | sha256sum --check  --status
mv "terragrunt_${TERRAGRUNT_OS}" terragrunt
chmod +x terragrunt
mv terragrunt "${BIN_DIR}"
rm SHA256SUMS
echo "Done downloading terragrunt ${TERRAGRUNT_VERSION}"

# Get tf-summarize

echo "Getting tf-summarize ${TF_SUMMARIZE_VERSION} ..."
wget "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_${TF_SUMMARIZE_OS}.zip"
wget "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_SHA256SUMS"
grep "tf-summarize_${TF_SUMMARIZE_OS}.zip" < tf-summarize_SHA256SUMS | sha256sum --check  --status
unzip "tf-summarize_${TF_SUMMARIZE_OS}.zip" tf-summarize
chmod +x tf-summarize
mv tf-summarize "${BIN_DIR}"
rm "tf-summarize_${TF_SUMMARIZE_OS}.zip" "tf-summarize_SHA256SUMS"
echo "Done downloading tf-summarize ${TF_SUMMARIZE_VERSION}"

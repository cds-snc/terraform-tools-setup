#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

BIN_DIR="${BIN_DIR:-/usr/local/bin}"

# Set versions

CONFTEST_VERSION="${CONFTEST_VERSION:-0.30.0}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.1.7}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-0.36.3}"

# Get conftest

echo "Getting conftest ${CONFTEST_VERSION} ..."
wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz"
wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/checksums.txt"
grep 'Linux_x86_64.tar.gz' < checksums.txt | sha256sum --check  --status
tar -zxvf "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" conftest_binary
chmod +x conftest_binary
mv conftest_binary ${BIN_DIR}/conftest
rm "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" checksums.txt
echo "Done downloading conftest ${CONFTEST_VERSION}"

# Get terraform

echo "Getting terraform ${TERRAFORM_VERSION} ..."
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS"
grep 'linux_amd64.zip' < terraform_${TERRAFORM_VERSION}_SHA256SUMS | sha256sum --check  --status
unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" terraform_binary
chmod +x terraform_binary
mv terraform_binary ${BIN_DIR}/terraform
rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" terraform_${TERRAFORM_VERSION}_SHA256SUMS
echo "Done downloading terraform ${TERRAFORM_VERSION}"

# Get terragrunt

echo "Getting terragrunt ${TERRAGRUNT_VERSION} ..."
wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/SHA256SUMS"
grep 'linux_amd64' < SHA256SUMS | sha256sum --check  --status
mv "terragrunt_linux_amd64" terragrunt_binary
chmod +x terragrunt_binary
mv terragrunt_binary ${BIN_DIR}/terragrunt
rm SHA256SUMS
echo "Done downloading terragrunt ${TERRAGRUNT_VERSION}"
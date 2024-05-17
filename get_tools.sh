#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

BIN_DIR="${BIN_DIR:-/usr/local/bin}"
RUNNER_TEMP="${RUNNER_TEMP:-/tmp}"

# Set versions

CONFTEST_VERSION="${CONFTEST_VERSION:-0.36.0}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.3.6}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-0.42.5}"
TF_SUMMARIZE_VERSION="${TF_SUMMARIZE_VERSION:-0.2.3}"

cd "${RUNNER_TEMP}"

# Get conftest

echo "Checking if conftest is installed:"
if [[ ! "$($BIN_DIR/conftest --version | head -n 1)" =~ ${CONFTEST_VERSION} ]]; then
    echo "Getting conftest ${CONFTEST_VERSION} ..."
    wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz"
    wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/checksums.txt"
    grep 'Linux_x86_64.tar.gz' < checksums.txt | sha256sum --check  --status
    tar -zxvf "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" conftest
    chmod +x conftest
    mv conftest "${BIN_DIR}"
    rm "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" checksums.txt
    echo "Done downloading conftest ${CONFTEST_VERSION}"
else
    echo "conftest version ${CONFTEST_VERSION} is already installed"
fi

# Get terraform

echo "Checking if terraform is installed:"
if [[ ! "$($BIN_DIR/terraform --version | head -n 1)" =~ ${TERRAFORM_VERSION} ]]; then
    echo "Getting terraform ${TERRAFORM_VERSION} ..."
    wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
    wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS"
    grep 'linux_amd64.zip' < "terraform_${TERRAFORM_VERSION}_SHA256SUMS" | sha256sum --check  --status
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" terraform
    chmod +x terraform
    mv terraform "${BIN_DIR}"
    rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" "terraform_${TERRAFORM_VERSION}_SHA256SUMS"
    echo "Done downloading terraform ${TERRAFORM_VERSION}"
else
    echo "terraform version ${TERRAFORM_VERSION} is already installed"
fi

# Get terragrunt

echo "Checking if terragrunt is installed:"
if [[ ! "$($BIN_DIR/terragrunt --version | head -n 1)" =~ ${TERRAGRUNT_VERSION} ]]; then
    echo "Getting terragrunt ${TERRAGRUNT_VERSION} ..."
    wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
    wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/SHA256SUMS"
    grep 'linux_amd64' < SHA256SUMS | sha256sum --check  --status
    mv "terragrunt_linux_amd64" terragrunt
    chmod +x terragrunt
    mv terragrunt "${BIN_DIR}"
    rm SHA256SUMS
    echo "Done downloading terragrunt ${TERRAGRUNT_VERSION}"
else
    echo "terragrunt version ${TERRAGRUNT_VERSION} is already installed"
fi

# Get tf-summarize

echo "Checking if tf-summarize is installed:"
if [[ ! "$($BIN_DIR/tf-summarize -v | head -n 1)" =~ ${TF_SUMMARIZE_VERSION} ]]; then
    echo "Getting tf-summarize ${TF_SUMMARIZE_VERSION} ..."
    wget "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_linux_amd64.zip"
    wget "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_SHA256SUMS"
    grep "tf-summarize_linux_amd64.zip" < tf-summarize_SHA256SUMS | sha256sum --check  --status
    unzip "tf-summarize_linux_amd64.zip" tf-summarize
    chmod +x tf-summarize
    mv tf-summarize "${BIN_DIR}"
    rm "tf-summarize_linux_amd64.zip" "tf-summarize_SHA256SUMS"
    echo "Done downloading tf-summarize ${TF_SUMMARIZE_VERSION}"
else
    echo "tf-summarize version ${TF_SUMMARIZE_VERSION} is already installed"
fi
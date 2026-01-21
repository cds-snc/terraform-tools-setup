#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

BIN_DIR="${BIN_DIR:-/usr/local/bin}"
RUNNER_TEMP="${RUNNER_TEMP:-/tmp}"

# Set versions

CONFTEST_VERSION="${CONFTEST_VERSION:-0.36.0}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.14.3}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-0.98.0}"
TF_SUMMARIZE_VERSION="${TF_SUMMARIZE_VERSION:-0.2.3}"
TRUFFLEHOG_VERSION="${TRUFFLEHOG_VERSION:-3.90.12}"

cd "${RUNNER_TEMP}"

# Get conftest

echo "Getting conftest ${CONFTEST_VERSION} ..."
wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz"
wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/checksums.txt"
grep "^conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz$" < checksums.txt | sha256sum --check  --status
tar -zxvf "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" conftest
chmod +x conftest
mv conftest "${BIN_DIR}"
rm "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" checksums.txt
echo "Done downloading conftest ${CONFTEST_VERSION}"

# Get terraform

echo "Getting terraform ${TERRAFORM_VERSION} ..."
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS"
grep "^terraform_${TERRAFORM_VERSION}_linux_amd64.zip$" < "terraform_${TERRAFORM_VERSION}_SHA256SUMS" | sha256sum --check  --status
unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" terraform
chmod +x terraform
mv terraform "${BIN_DIR}"
rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" "terraform_${TERRAFORM_VERSION}_SHA256SUMS"
echo "Done downloading terraform ${TERRAFORM_VERSION}"

# Get terragrunt

echo "Getting terragrunt ${TERRAGRUNT_VERSION} ..."
wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/SHA256SUMS"
grep "^terragrunt_linux_amd64$" < SHA256SUMS | sha256sum --check  --status
mv "terragrunt_linux_amd64" terragrunt
chmod +x terragrunt
mv terragrunt "${BIN_DIR}"
rm SHA256SUMS
echo "Done downloading terragrunt ${TERRAGRUNT_VERSION}"


echo "Getting tf-summarize ${TF_SUMMARIZE_VERSION} ..."
wget "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_linux_amd64.zip"
wget "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_SHA256SUMS"
grep "^tf-summarize_linux_amd64.zip$" < tf-summarize_SHA256SUMS | sha256sum --check  --status
unzip "tf-summarize_linux_amd64.zip" tf-summarize
chmod +x tf-summarize
mv tf-summarize "${BIN_DIR}"
rm "tf-summarize_linux_amd64.zip" "tf-summarize_SHA256SUMS"
echo "Done downloading tf-summarize ${TF_SUMMARIZE_VERSION}"

# Get trufflehog

echo "Getting trufflehog ${TRUFFLEHOG_VERSION} ..."
wget "https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz"
wget "https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_checksums.txt"
grep "^trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz$" < "trufflehog_${TRUFFLEHOG_VERSION}_checksums.txt" | sha256sum --check  --status
tar -zxvf "trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz" trufflehog
chmod +x trufflehog
mv trufflehog "${BIN_DIR}"
rm "trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz" "trufflehog_${TRUFFLEHOG_VERSION}_checksums.txt"
echo "Done downloading trufflehog ${TRUFFLEHOG_VERSION}"

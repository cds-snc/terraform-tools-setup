#!/usr/bin/env bash
set -e # Exit with nonzero exit code if anything fails

BIN_DIR="${BIN_DIR:-/usr/local/bin}"
RUNNER_TEMP="${RUNNER_TEMP:-/tmp}"

# Default versions and their SHA256 checksums, reviewed out-of-band.
# Renovate bumps each version/checksum pair together (see renovate.json), except
# terraform, whose checksum must be updated by hand from the HashiCorp SHA256SUMS.

# renovate: datasource=github-release-attachments depName=open-policy-agent/conftest
CONFTEST_DEFAULT_TAG="v0.36.0"
CONFTEST_DEFAULT_CHECKSUM="d98783276c4fd47c779a1ece4c0decba9ee6462687839d25389882a468c362cc"
CONFTEST_DEFAULT_VERSION="${CONFTEST_DEFAULT_TAG#v}"
# renovate-version-only: datasource=github-releases depName=hashicorp/terraform
TERRAFORM_DEFAULT_VERSION="1.14.3"
TERRAFORM_DEFAULT_CHECKSUM="178b2a602251bb68b94732aceca2cc1023d87597cb83dba92cab31b6689edb4d"
# renovate: datasource=github-release-attachments depName=gruntwork-io/terragrunt
TERRAGRUNT_DEFAULT_TAG="v0.98.0"
TERRAGRUNT_DEFAULT_CHECKSUM="68a9e029b438957c4164e505dfade123c67d6c3c3e11880bcadf3f2b33a8d865"
TERRAGRUNT_DEFAULT_VERSION="${TERRAGRUNT_DEFAULT_TAG#v}"
# renovate: datasource=github-release-attachments depName=dineshba/tf-summarize
TF_SUMMARIZE_DEFAULT_TAG="v0.2.3"
TF_SUMMARIZE_DEFAULT_CHECKSUM="c3dd0b0361e66914236c40d51960c45756564c351f42505720ea7682e917acca"
TF_SUMMARIZE_DEFAULT_VERSION="${TF_SUMMARIZE_DEFAULT_TAG#v}"
# renovate: datasource=github-release-attachments depName=trufflesecurity/trufflehog
TRUFFLEHOG_DEFAULT_TAG="v3.90.12"
TRUFFLEHOG_DEFAULT_CHECKSUM="318fd1e8af68b54f4465437208582003a5948293ea401c5c67bb55f17e4e2102"
TRUFFLEHOG_DEFAULT_VERSION="${TRUFFLEHOG_DEFAULT_TAG#v}"

CONFTEST_VERSION="${CONFTEST_VERSION:-${CONFTEST_DEFAULT_VERSION}}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-${TERRAFORM_DEFAULT_VERSION}}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-${TERRAGRUNT_DEFAULT_VERSION}}"
TF_SUMMARIZE_VERSION="${TF_SUMMARIZE_VERSION:-${TF_SUMMARIZE_DEFAULT_VERSION}}"
TRUFFLEHOG_VERSION="${TRUFFLEHOG_VERSION:-${TRUFFLEHOG_DEFAULT_VERSION}}"

# *_CHECKSUM overrides the embedded checksum. For a non-default version with no
# *_CHECKSUM set, the checksum file published next to the binary is used, which
# only detects corruption and does not authenticate the download.

CONFTEST_CHECKSUM="${CONFTEST_CHECKSUM:-}"
TERRAFORM_CHECKSUM="${TERRAFORM_CHECKSUM:-}"
TERRAGRUNT_CHECKSUM="${TERRAGRUNT_CHECKSUM:-}"
TF_SUMMARIZE_CHECKSUM="${TF_SUMMARIZE_CHECKSUM:-}"
TRUFFLEHOG_CHECKSUM="${TRUFFLEHOG_CHECKSUM:-}"

[[ -z "${CONFTEST_CHECKSUM}" && "${CONFTEST_VERSION}" == "${CONFTEST_DEFAULT_VERSION}" ]] && CONFTEST_CHECKSUM="${CONFTEST_DEFAULT_CHECKSUM}"
[[ -z "${TERRAFORM_CHECKSUM}" && "${TERRAFORM_VERSION}" == "${TERRAFORM_DEFAULT_VERSION}" ]] && TERRAFORM_CHECKSUM="${TERRAFORM_DEFAULT_CHECKSUM}"
[[ -z "${TERRAGRUNT_CHECKSUM}" && "${TERRAGRUNT_VERSION}" == "${TERRAGRUNT_DEFAULT_VERSION}" ]] && TERRAGRUNT_CHECKSUM="${TERRAGRUNT_DEFAULT_CHECKSUM}"
[[ -z "${TF_SUMMARIZE_CHECKSUM}" && "${TF_SUMMARIZE_VERSION}" == "${TF_SUMMARIZE_DEFAULT_VERSION}" ]] && TF_SUMMARIZE_CHECKSUM="${TF_SUMMARIZE_DEFAULT_CHECKSUM}"
[[ -z "${TRUFFLEHOG_CHECKSUM}" && "${TRUFFLEHOG_VERSION}" == "${TRUFFLEHOG_DEFAULT_VERSION}" ]] && TRUFFLEHOG_CHECKSUM="${TRUFFLEHOG_DEFAULT_CHECKSUM}"

wget() { command wget --no-verbose "$@"; }

# Usage: verify_checksum <tool> <checksum> <file> <upstream-checksum-file-url>
verify_checksum() {
  local sums
  if [[ -n "$2" ]]; then
    echo "$2  $3" | sha256sum --check --status
    return
  fi
  echo "::warning::No pinned checksum for $1; set $1_CHECKSUM to authenticate the download"
  sums="$(basename "$4")"
  wget "$4"
  grep "$3\$" < "${sums}" | sha256sum --check --status
  rm "${sums}"
}

cd "${RUNNER_TEMP}"

# Get conftest

if [[ "${CONFTEST_VERSION}" == "NONE" ]]; then
  echo "Skipping conftest (version set to NONE)"
else
  echo "Getting conftest ${CONFTEST_VERSION} ..."
  wget "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz"
  verify_checksum CONFTEST "${CONFTEST_CHECKSUM}" "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" \
    "https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/checksums.txt"
  tar -zxvf "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz" conftest
  chmod +x conftest
  mv conftest "${BIN_DIR}"
  rm "conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz"
  echo "Done downloading conftest ${CONFTEST_VERSION}"
fi

# Get terraform

if [[ "${TERRAFORM_VERSION}" == "NONE" ]]; then
  echo "Skipping terraform (version set to NONE)"
else
  echo "Getting terraform ${TERRAFORM_VERSION} ..."
  wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  verify_checksum TERRAFORM "${TERRAFORM_CHECKSUM}" "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
    "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS"
  unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" terraform
  chmod +x terraform
  mv terraform "${BIN_DIR}"
  rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
  echo "Done downloading terraform ${TERRAFORM_VERSION}"
fi

# Get terragrunt

if [[ "${TERRAGRUNT_VERSION}" == "NONE" ]]; then
  echo "Skipping terragrunt (version set to NONE)"
else
  echo "Getting terragrunt ${TERRAGRUNT_VERSION} ..."
  wget "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
  verify_checksum TERRAGRUNT "${TERRAGRUNT_CHECKSUM}" "terragrunt_linux_amd64" \
    "https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/SHA256SUMS"
  mv "terragrunt_linux_amd64" terragrunt
  chmod +x terragrunt
  mv terragrunt "${BIN_DIR}"
  echo "Done downloading terragrunt ${TERRAGRUNT_VERSION}"
fi

# Get tf-summarize

if [[ "${TF_SUMMARIZE_VERSION}" == "NONE" ]]; then
  echo "Skipping tf-summarize (version set to NONE)"
else
  echo "Getting tf-summarize ${TF_SUMMARIZE_VERSION} ..."
  wget "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_linux_amd64.zip"
  verify_checksum TF_SUMMARIZE "${TF_SUMMARIZE_CHECKSUM}" "tf-summarize_linux_amd64.zip" \
    "https://github.com/dineshba/tf-summarize/releases/download/v${TF_SUMMARIZE_VERSION}/tf-summarize_SHA256SUMS"
  unzip "tf-summarize_linux_amd64.zip" tf-summarize
  chmod +x tf-summarize
  mv tf-summarize "${BIN_DIR}"
  rm "tf-summarize_linux_amd64.zip"
  echo "Done downloading tf-summarize ${TF_SUMMARIZE_VERSION}"
fi

# Get trufflehog

if [[ "${TRUFFLEHOG_VERSION}" == "NONE" ]]; then
  echo "Skipping trufflehog (version set to NONE)"
else
  echo "Getting trufflehog ${TRUFFLEHOG_VERSION} ..."
  wget "https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz"
  verify_checksum TRUFFLEHOG "${TRUFFLEHOG_CHECKSUM}" "trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz" \
    "https://github.com/trufflesecurity/trufflehog/releases/download/v${TRUFFLEHOG_VERSION}/trufflehog_${TRUFFLEHOG_VERSION}_checksums.txt"
  tar -zxvf "trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz" trufflehog
  chmod +x trufflehog
  mv trufflehog "${BIN_DIR}"
  rm "trufflehog_${TRUFFLEHOG_VERSION}_linux_amd64.tar.gz"
  echo "Done downloading trufflehog ${TRUFFLEHOG_VERSION}"
fi
# Terraform tools Setup GitHub Action

This repository contains a GitHub action that sets up all the tooling required for running Terraform in CDS CI/CD flows.

It currently download the following tool version, although each can be overriden with an environment variable:

|Tool|Version|ENV name|
|---|---|---|
|[conftest](https://github.com/open-policy-agent/conftest)|0.36.0|CONFTEST_VERSION|
|[terraform](https://github.com/hashicorp/terraform)|1.14.3|TERRAFORM_VERSION|
|[terragrunt](https://github.com/gruntwork-io/terragrunt)|0.98.0|TERRAGRUNT_VERSION|
|[TF Summarize](https://github.com/dineshba/tf-summarize)|0.2.3|TF_SUMMARIZE_VERSION|
|[TruffleHog](https://github.com/trufflesecurity/trufflehog)|3.90.12|TRUFFLEHOG_VERSION|

## Using the action

To use the action you can invoke it in the following way:

```yaml
on: [push]

jobs:
  my_ci_flow:
    runs-on: ubuntu-latest
    steps:
      - name: Setup Terraform tools
        uses: cds-snc/terraform-tools-setup@v1
        env: # In case you want to override default versions
          CONFTEST_VERSION: 0.36.0
          TERRAFORM_VERSION: 1.14.3
          TERRAGRUNT_VERSION: 0.36.3
          TF_SUMMARIZE_VERSION: 0.2.3
          TRUFFLEHOG_VERSION: 3.90.10
```

To skip installing a given tool, pass a version of `NONE`:

```yaml
      - name: Setup Terraform tools
        uses: cds-snc/terraform-tools-setup@v1
        env:
          TRUFFLEHOG_VERSION: NONE
```

You can also pass an optional checksum for each tool you are installing. By default this action validates the downloaded binaries using the checksums published by their maintainers. By passing your own checksum, you close the door on an attack where a malicious actor publishes a malicious binary, along with an altered checksum file.

```yaml
      - name: Setup Terraform tools
        uses: cds-snc/terraform-tools-setup@v1
        env:
          CONFTEST_VERSION: 0.36.0 
          CONFTEST_CHECKSUM: d98783276c4fd47c779a1ece4c0decba9ee6462687839d25389882a468c362cc
          TERRAFORM_VERSION: 1.14.3
          TERRAFORM_CHECKSUM: 178b2a602251bb68b94732aceca2cc1023d87597cb83dba92cab31b6689edb4d
          TF_SUMMARIZE_VERSION: 0.2.3
          TF_SUMMARIZE_CHECKSUM: c3dd0b0361e66914236c40d51960c45756564c351f42505720ea7682e917acca
          TERRAGRUNT_VERSION: NONE
          TRUFFLEHOG_VERSION: NONE
```

## Updating versions and testing

To test the script you can run `./test_script.sh`. 

If you would like to update the default versions, you need to update the following lines in both `get_tools.sh` and `test_script.sh`

```sh
export CONFTEST_VERSION="0.36.0"
export TERRAFORM_VERSION="1.14.3"
export TERRAGRUNT_VERSION="0.98.0"
export TF_SUMMARIZE_VERSION="0.2.3"
export TRUFFLEHOG_VERSION="3.90.12"
```
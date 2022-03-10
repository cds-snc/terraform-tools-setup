# Terraform tools Setup GitHub Action

This repository contains a GitHub action that sets up all the tooling required for running Terraform in CDS CI/CD flows.

It currently download the following tool version, although each can be overriden with an environment variable:

|Tool|Version|ENV name|
|---|---|---|
|[conftest](https://github.com/open-policy-agent/conftest)|0.30.0|CONFTEST_VERSION|
|[terraform](https://github.com/hashicorp/terraform)|1.1.7|TERRAFORM_VERSION|
|[terragrunt](https://github.com/gruntwork-io/terragrunt)|0.36.3|TERRAGRUNT_VERSION|

## Using the action

To use the action you can invoke it in the following way:

```
on: [push]

jobs:
  my_ci_flow:
    runs-on: ubuntu-latest
    steps:
      - name: setup terraform tools
        uses: cds-snc/terraform-tools-setup@v1
        env: # In case you want to override default versions
            CONFTEST_VERSION: 0.30.0 
            TERRAFORM_VERSION: 1.1.7
            TERRAGRUNT_VERSION: 0.36.3
```

## Updating versions and testing

To test the script you can run `./test_script.sh`. 

If you would like to update the default versions, you need to update the following lines in both `get_tools.sh` and `test_script.sh`

```
CONFTEST_VERSION="${CONFTEST_VERSION:-0.30.0}"
TERRAFORM_VERSION="${TERRAFORM_VERSION:-1.1.7}"
TERRAGRUNT_VERSION="${TERRAGRUNT_VERSION:-0.36.3}"
```
#!/bin/sh

set -e

githooksSetup() {
    cp -a ${1}/* ${2}/hooks/
    chmod +x ${2}/hooks/*
}

terraformSetup() {
    cp -n ${1}/.env.example ${1}/.env 
    # cp -n ${1}/terraform.tfvars.example ${1}/infra/envs/*/terraform.tfvars
    for dir in $(ls -d ${1}/infra/envs/*/); do
        cp -n ${1}/terraform.tfvars.example ${dir}/terraform.tfvars
    done
}

readonly SCRIPT_DIR=$(dirname "$(realpath "$0")")
readonly GIT_DIR=${SCRIPT_DIR}/.git
readonly GIT_HOOKS_SCRIPT_DIR=${SCRIPT_DIR}/git-hooks
readonly TERRAFORM_DIR=${SCRIPT_DIR}/terraform

githooksSetup ${GIT_HOOKS_SCRIPT_DIR} ${GIT_DIR}
terraformSetup ${TERRAFORM_DIR}
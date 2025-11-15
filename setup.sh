#!/bin/sh

set -e

readonly SCRIPT_DIR=$(dirname "$(realpath "$0")")
readonly GIT_DIR=${SCRIPT_DIR}/.git
readonly GIT_HOOKS_SCRIPT_DIR=${SCRIPT_DIR}/git-hooks
readonly TERRAFORM_DIR=${SCRIPT_DIR}/terraform

cp -a ${GIT_HOOKS_SCRIPT_DIR}/* ${GIT_DIR}/hooks/
chmod +x ${GIT_DIR}/hooks/*

cp -n ${TERRAFORM_DIR}/.env.example ${TERRAFORM_DIR}/.env 
# cp -n ${TERRAFORM_DIR}/terraform.tfvars.example ${TERRAFORM_DIR}/infra/envs/*/terraform.tfvars

for dir in $(ls -d ${TERRAFORM_DIR}/infra/envs/*/); do
    cp -n ${TERRAFORM_DIR}/terraform.tfvars.example ${dir}/terraform.tfvars
done
#!/bin/sh

set -e

githooksSetup() {
    cp -a ${1}/* ${2}/hooks/
    chmod +x ${2}/hooks/*
}

terraformSetup() {
    cp -n ${1}/.env.example ${1}/.env 
    # cp -n ${1}/terraform.tfvars.example ${1}/src/envs/*/terraform.tfvars
    for dir in $(ls -d ${1}/src/envs/*/); do
        cp -n ${1}/terraform.tfvars.example ${dir}/terraform.tfvars
    done
}

eventSetup() {
    cp -n ${1}/.env.example ${1}/.env
    for main in $(ls -1 ${1}/src/*/main.go); do
        mainDir=$(dirname ${main})

        if [ -f "${mainDir}/event.json" ] ; then
            continue
        fi

        defBeginRow=$(grep -n "type Event struct {" ${main} | cut -d: -f1)

        if [ -z "${defBeginRow}" ] ; then
            continue
        fi

        defEndRow=$(awk "NR>=${defBeginRow} && /^}$/ {print NR; exit}" ${main})
        
        echo '{' > ${mainDir}/event.json
        
        for defRow in $(seq $(( defBeginRow + 1 )) $(( defEndRow - 1 )) ); do
            defData=$(sed -n ${defRow}p ${main})
            itemType=$(echo ${defData} | awk '{print $2}')
            itemName=$(echo ${defData} | awk '{print $3}' | sed 's/^`json:"//;s/"`$//')

            if [ ${defRow} -eq $(( defEndRow - 1 )) ]; then
                comma=""
            else
                comma=","
            fi

            case ${itemType} in
                string)
                    echo "  \"${itemName}\": \"\"${comma}" >> ${mainDir}/event.json
                    ;;
                int | int32 | int64 | float32 | float64)
                    echo "  \"${itemName}\": 0${comma}" >> ${mainDir}/event.json
                    ;;
                bool)
                    echo "  \"${itemName}\": false${comma}" >> ${mainDir}/event.json
                    ;;
                *)
                    # ネストした構造体や配列などはとりあえずnullにする
                    echo "  \"${itemName}\": null${comma}" >> ${mainDir}/event.json
                    ;;
            esac
        done
        
        echo '}' >> ${mainDir}/event.json
    done
}

readonly SCRIPT_DIR=$(dirname "$(realpath "$0")")
readonly GIT_DIR=${SCRIPT_DIR}/.git
readonly GIT_HOOKS_SCRIPT_DIR=${SCRIPT_DIR}/git-hooks
readonly TERRAFORM_DIR=${SCRIPT_DIR}/infra
readonly EVENT_DIR=${SCRIPT_DIR}/event

githooksSetup ${GIT_HOOKS_SCRIPT_DIR} ${GIT_DIR}
terraformSetup ${TERRAFORM_DIR}
eventSetup ${EVENT_DIR}
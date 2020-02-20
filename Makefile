################################################################################
# This file is part of the "ssc-generator" project.
#
# Copyright (C) 2020 - Gamaliel SICK, IDEACLOUD.
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
################################################################################

TARGET_DOCKER_REGISTRY ?= my.docker.registry
TARGET_IMAGE_NAME ?= ssc-generator
DOCKER_TAG ?= $(shell git log --pretty=format:'%h' -n 1)

PASSWORD ?= "sscpwd"
DEST_DIR ?= "/data/cert"
DOMAIN ?= "custom.foo"

LOCAL_USER_UID   ?= $(shell id -u)
LOCAL_USER_GID   ?= $(shell id -g)

# COLORS
YELLOW = $(shell printf "\33[33m")
RESET  = $(shell printf "\33[0m")

build:
	@echo "${YELLOW}Building Docker image \"${TARGET_DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}:${DOCKER_TAG}\"${RESET}"
	@docker build -t ${TARGET_DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}:${DOCKER_TAG} .

publish:
	@echo "${YELLOW}Publishing Docker image \"${TARGET_DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}:${DOCKER_TAG}\"${RESET}"
	@docker push ${TARGET_DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}:${DOCKER_TAG}

generate:
	@echo "${YELLOW}Generate certificates${RESET}"
	@docker run --volume ${PWD}:/data --user ${LOCAL_USER_UID}:${LOCAL_USER_GID} \
	--env DEST_DIR=${DEST_DIR} --env PASSWORD=${PASSWORD} --env DOMAIN=${DOMAIN} --env USERGROUP=${LOCAL_USER_GID} --env USERID=${LOCAL_USER_UID} \
	${TARGET_DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}:${DOCKER_TAG}

clean:
	@echo "${YELLOW}Cleaning${RESET}"
	@rm -rf cert
	@docker rmi -f ${TARGET_DOCKER_REGISTRY}/${TARGET_IMAGE_NAME}:${DOCKER_TAG}

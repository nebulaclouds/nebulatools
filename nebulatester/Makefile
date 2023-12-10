export IMAGE_NAME=nebulatools
VERSION=$(shell ./version.sh)
PROJECT=nebulatester
DOMAIN=development

serialize:
	pynebula -p ${PROJECT} -d ${DOMAIN} serialize workflows

execute:
	pynebula -p ${PROJECT} -d ${DOMAIN} lp execute app-workflows-work-one-python-task-w-f

.PHONY: register_staging_in_container
register_staging_in_container:
	pynebula -p ${PROJECT} -d ${DOMAIN} --config /root/staging.config register workflows


.PHONY: register_staging
register_staging: docker_push
	docker run -e NEBULA_CREDENTIALS_CLIENT_ID=${NEBULA_CREDENTIALS_CLIENT_ID} \
	-e NEBULA_CREDENTIALS_CLIENT_SECRET=${NEBULA_CREDENTIALS_CLIENT_SECRET} \
	-e NEBULA_CREDENTIALS_AUTH_MODE=basic -e NEBULA_CREDENTIALS_AUTHORIZATION_METADATA_KEY=nebula-authorization \
	-e NEBULA_CREDENTIALS_SCOPE=svc -e NEBULA_PLATFORM_AUTH=True \
	ghcr.io/nebulaclouds/${IMAGE_NAME}:${VERSION} /usr/local/bin/nebulakit_venv make register_staging_in_container

.PHONY: register_production_in_container
register_production_in_container:
	pynebula -p ${PROJECT} -d ${DOMAIN} --config /root/production.config register workflows

.PHONY: register_production
register_production: docker_push
	docker run -e NEBULA_CREDENTIALS_CLIENT_ID=${NEBULA_CREDENTIALS_CLIENT_ID} \
	-e NEBULA_CREDENTIALS_CLIENT_SECRET=${NEBULA_CREDENTIALS_CLIENT_SECRET} \
	-e NEBULA_CREDENTIALS_AUTH_MODE=basic -e NEBULA_CREDENTIALS_AUTHORIZATION_METADATA_KEY=nebula-authorization \
	-e NEBULA_CREDENTIALS_SCOPE=svc -e NEBULA_PLATFORM_AUTH=True \
	ghcr.io/nebulaclouds/${IMAGE_NAME}:${VERSION} /usr/local/bin/nebulakit_venv make register_production_in_container

.PHONY: register_production_in_container
register_sandbox_in_container:
	pynebula --config /root/sandbox.config register -p ${PROJECT} -d ${DOMAIN} workflows

.PHONY: register_sandbox
register_sandbox: docker_push
	docker run ghcr.io/nebulaclouds/${IMAGE_NAME}:${VERSION} /usr/local/bin/nebulakit_venv make register_sandbox_in_container

.PHONY: end2end
end2end_test:
	nebulakit_venv end2end/run.sh

.PHONY: functional_test
functional_test:
	nebulakit_venv functional-tests/run.sh

.PHONY: docker_build
docker_build:
	scripts/docker_build.sh

.PHONY: docker_push
docker_push:
	REGISTRY=ghcr.io/nebulaclouds scripts/docker_build.sh

.PHONY: docker_build_push
docker_build_push: docker_build docker_push
	echo "built"

export HELM_EXPERIMENTAL_OCI=1

DOCKER_REGISTRY ?= registry.cloud.okteto.net
RELEASE_NAME ?= tech-exam-app
CHART ?= chart/app
DEPLOY_CONFIG ?= ${CHART}/config/prod.yml
IMAGE_REPO ?= alert
IMAGE_TAG ?= v2

.PHONY: build
build: login docker-build-push

login:
	docker login ${DOCKER_REGISTRY} -u $$OKTETO_API_USER -p $$OKTETO_API_TOKEN

docker-build-push:
	docker build -t ${DOCKER_REGISTRY}/$$OKTETO_API_USER/${IMAGE_REPO}:${IMAGE_TAG} .
	docker push ${DOCKER_REGISTRY}/$$OKTETO_API_USER/${IMAGE_REPO}:${IMAGE_TAG}

.PHONY: dryrun
dryrun:
	helm3 upgrade ${RELEASE_NAME} ./${CHART_NAME} \
	--debug --install --atomic \
	--values ${DEPLOY_CONFIG} \
	--dry-run

.PHONY: deploy
deploy:
	helm3 upgrade ${RELEASE_NAME} ${CHART} \
	--debug --install --atomic \
	--values ${DEPLOY_CONFIG}
export HELM_EXPERIMENTAL_OCI=1

DOCKER_REGISTRY ?= registry.cloud.okteto.net
RELEASE_NAME ?= tech-exam-app
CHART ?= chart/app
DEPLOY_CONFIG ?= ${CHART}/config/prod.yml
IMAGE_REPO ?= alert
IMAGE_TAG ?= v3

.PHONY: build
build: login docker-build-push

login:
	docker login ${DOCKER_REGISTRY} -u $$OKTETO_API_USER -p $$OKTETO_API_TOKEN

docker-build-push:
	docker build -t ${DOCKER_REGISTRY}/$$OKTETO_API_USER/${IMAGE_REPO}:${IMAGE_TAG} .
	docker push ${DOCKER_REGISTRY}/$$OKTETO_API_USER/${IMAGE_REPO}:${IMAGE_TAG}

.PHONY: helm-dryrun
helm-dryrun:
	helm3 upgrade ${RELEASE_NAME} ./${CHART_NAME} \
	--debug --install --atomic \
	--values ${DEPLOY_CONFIG} \
	--dry-run

.PHONY: helm-deploy
helm-deploy:
	helm3 upgrade ${RELEASE_NAME} ${CHART} \
	--debug --install --atomic \
	--values ${DEPLOY_CONFIG}

.PHONY: deploy
deploy:
	ansible-playbook ./deploy.yml --extra-vars "chart=${CHART} config=${DEPLOY_CONFIG} tag=${IMAGE_TAG}"
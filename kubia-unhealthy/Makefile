RELEASE		?= 0.0.1
COMMIT		?= $(shell git rev-parse --short HEAD)
BUILD_TIME	?= $(shell date -u '+%Y-%m-%d_%H:%M:%S')

kubia-unhealthy-amd64:
	docker build --build-arg GOARCH=amd64 \
		-t geoffgarside/kubia-unhealthy-amd64:${RELEASE} .

kubia-unhealthy-arm7:
	docker build --build-arg GOARCH=arm \
		-t geoffgarside/kubia-unhealthy-arm7:${RELEASE} .

kubia-unhealthy-arm64:
	docker build --build-arg GOARCH=arm64 \
		-t geoffgarside/kubia-unhealthy-arm64:${RELEASE} .

push-kubia-unhealthy-amd64: kubia-unhealthy-amd64
	docker push geoffgarside/kubia-unhealthy-amd64:${RELEASE}

push-kubia-unhealthy-arm7: kubia-unhealthy-arm7
	docker push geoffgarside/kubia-unhealthy-arm7:${RELEASE}

push-kubia-unhealthy-arm64: kubia-unhealthy-arm64
	docker push geoffgarside/kubia-unhealthy-arm64:${RELEASE}

.PHONY: kubia-unhealthy
kubia-unhealthy: push-kubia-unhealthy-amd64 push-kubia-unhealthy-arm7 push-kubia-unhealthy-arm64
	docker manifest create geoffgarside/kubia-unhealthy:${RELEASE} \
		geoffgarside/kubia-unhealthy-amd64:${RELEASE} \
		geoffgarside/kubia-unhealthy-arm7:${RELEASE} \
		geoffgarside/kubia-unhealthy-arm64:${RELEASE}
	docker manifest annotate geoffgarside/kubia-unhealthy:${RELEASE} \
		geoffgarside/kubia-unhealthy-arm7:${RELEASE} \
		--os linux --arch arm
	docker manifest annotate geoffgarside/kubia-unhealthy:${RELEASE} \
		geoffgarside/kubia-unhealthy-arm64:${RELEASE} \
		--os linux --arch arm64
	docker manifest push geoffgarside/kubia-unhealthy:${RELEASE}

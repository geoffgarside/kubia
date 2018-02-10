RELEASE		?= 0.0.1
COMMIT		?= $(shell git rev-parse --short HEAD)
BUILD_TIME	?= $(shell date -u '+%Y-%m-%d_%H:%M:%S')

kubia-amd64:
	docker build --build-arg GOARCH=amd64 \
		-t geoffgarside/kubia-amd64:${RELEASE} .

kubia-arm7:
	docker build --build-arg GOARCH=arm \
		-t geoffgarside/kubia-arm7:${RELEASE} .
kubia-arm64:
	docker build --build-arg GOARCH=arm64 \
		-t geoffgarside/kubia-arm64:${RELEASE} .

push-kubia-amd64: kubia-amd64
	docker push geoffgarside/kubia-amd64:${RELEASE}

push-kubia-arm7: kubia-arm7
	docker push geoffgarside/kubia-arm7:${RELEASE}

push-kubia-arm64: kubia-arm64
	docker push geoffgarside/kubia-arm64:${RELEASE}

.PHONY: kubia
kubia: push-kubia-amd64 push-kubia-arm7 push-kubia-arm64
	docker manifest create geoffgarside/kubia:${RELEASE} \
		geoffgarside/kubia-amd64:${RELEASE} \
		geoffgarside/kubia-arm7:${RELEASE} \
		geoffgarside/kubia-arm64:${RELEASE}
	docker manifest annotate geoffgarside/kubia:${RELEASE} \
		geoffgarside/kubia-arm7:${RELEASE} \
		--os linux --arch arm
	docker manifest annotate geoffgarside/kubia:${RELEASE} \
		geoffgarside/kubia-arm64:${RELEASE} \
		--os linux --arch arm64
	docker manifest push geoffgarside/kubia:${RELEASE}

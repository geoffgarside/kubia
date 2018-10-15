RELEASE		?= $(shell git describe --first-parent HEAD)
COMMIT		?= $(shell git rev-parse --short HEAD)
BUILD_TIME	?= $(shell date -u '+%Y-%m-%d_%H:%M:%S')

.PHONY: all build-amd64 build-arm64
all: batch-job kubia kubia-pet-set kubia-unhealthy ssd-monitor
build-amd64: batch-job-amd64 kubia-amd64 kubia-pet-set-amd64 kubia-unhealthy-amd64 ssd-monitor-amd64
build-arm64: batch-job-arm64 kubia-arm64 kubia-pet-set-arm64 kubia-unhealthy-arm64 ssd-monitor-arm64

batch-job-amd64:
	docker build -f dockerfiles/batch-job/Dockerfile -t geoffgarside/batch-job-amd64:$(RELEASE) cmd/batch-job

batch-job-arm64:
	docker build -f dockerfiles/batch-job/Dockerfile.arm64 -t geoffgarside/batch-job-arm64:$(RELEASE) cmd/batch-job

push-batch-job-amd64: batch-job-amd64
	docker push geoffgarside/batch-job-amd64:$(RELEASE)

push-batch-job-arm64: batch-job-arm64
	docker push geoffgarside/batch-job-arm64:$(RELEASE)

.PHONY: batch-job
batch-job: push-batch-job-amd64 push-batch-job-arm64
	docker manifest create geoffgarside/batch-job:$(RELEASE) \
		geoffgarside/batch-job-amd64:$(RELEASE) \
		geoffgarside/batch-job-arm64:$(RELEASE)
	docker manifest annotate geoffgarside/batch-job:$(RELEASE) \
		geoffgarside/batch-job-arm64:$(RELEASE) \
		--os linux --arch arm64
	docker manifest push geoffgarside/batch-job:$(RELEASE)

kubia-amd64:
	docker build -f dockerfiles/kubia/Dockerfile -t geoffgarside/kubia-amd64:$(RELEASE) cmd/kubia

kubia-arm64:
	docker build -f dockerfiles/kubia/Dockerfile.arm64 -t geoffgarside/kubia-arm64:$(RELEASE) cmd/kubia

push-kubia-amd64: kubia-amd64
	docker push geoffgarside/kubia-amd64:$(RELEASE)

push-kubia-arm64: kubia-arm64
	docker push geoffgarside/kubia-arm64:$(RELEASE)

.PHONY: kubia
kubia: push-kubia-amd64 push-kubia-arm64
	docker manifest create geoffgarside/kubia:$(RELEASE) \
		geoffgarside/kubia-amd64:$(RELEASE) \
		geoffgarside/kubia-arm64:$(RELEASE)
	docker manifest annotate geoffgarside/kubia:$(RELEASE) \
		geoffgarside/kubia-arm64:$(RELEASE) \
		--os linux --arch arm64
	docker manifest push geoffgarside/kubia:$(RELEASE)

kubia-pet-set-amd64:
	docker build -f dockerfiles/kubia-pet-set/Dockerfile -t geoffgarside/kubia-pet-set-amd64:$(RELEASE) cmd/kubia-pet-set

kubia-pet-set-arm64:
	docker build -f dockerfiles/kubia-pet-set/Dockerfile.arm64 -t geoffgarside/kubia-pet-set-arm64:$(RELEASE) cmd/kubia-pet-set

push-kubia-pet-set-amd64: kubia-pet-set-amd64
	docker push geoffgarside/kubia-pet-set-amd64:$(RELEASE)

push-kubia-pet-set-arm64: kubia-pet-set-arm64
	docker push geoffgarside/kubia-pet-set-arm64:$(RELEASE)

.PHONY: kubia-pet-set
kubia-pet-set: push-kubia-pet-set-amd64 push-kubia-pet-set-arm64
	docker manifest create geoffgarside/kubia-pet-set:$(RELEASE) \
		geoffgarside/kubia-pet-set-amd64:$(RELEASE) \
		geoffgarside/kubia-pet-set-arm64:$(RELEASE)
	docker manifest annotate geoffgarside/kubia-pet-set:$(RELEASE) \
		geoffgarside/kubia-pet-set-arm64:$(RELEASE) \
		--os linux --arch arm64
	docker manifest push geoffgarside/kubia-pet-set:$(RELEASE)

kubia-unhealthy-amd64:
	docker build -f dockerfiles/kubia-unhealthy/Dockerfile -t geoffgarside/kubia-unhealthy-amd64:$(RELEASE) cmd/kubia-unhealthy

kubia-unhealthy-arm64:
	docker build -f dockerfiles/kubia-unhealthy/Dockerfile.arm64 -t geoffgarside/kubia-unhealthy-arm64:$(RELEASE) cmd/kubia-unhealthy

push-kubia-unhealthy-amd64: kubia-unhealthy-amd64
	docker push geoffgarside/kubia-unhealthy-amd64:$(RELEASE)

push-kubia-unhealthy-arm64: kubia-unhealthy-arm64
	docker push geoffgarside/kubia-unhealthy-arm64:$(RELEASE)

.PHONY: kubia-unhealthy
kubia-unhealthy: push-kubia-unhealthy-amd64 push-kubia-unhealthy-arm64
	docker manifest create geoffgarside/kubia-unhealthy:$(RELEASE) \
		geoffgarside/kubia-unhealthy-amd64:$(RELEASE) \
		geoffgarside/kubia-unhealthy-arm64:$(RELEASE)
	docker manifest annotate geoffgarside/kubia-unhealthy:$(RELEASE) \
		geoffgarside/kubia-unhealthy-arm64:$(RELEASE) \
		--os linux --arch arm64
	docker manifest push geoffgarside/kubia-unhealthy:$(RELEASE)

ssd-monitor-amd64:
	docker build -f dockerfiles/ssd-monitor/Dockerfile -t geoffgarside/ssd-monitor-amd64:$(RELEASE) cmd/ssd-monitor

ssd-monitor-arm64:
	docker build -f dockerfiles/ssd-monitor/Dockerfile.arm64 -t geoffgarside/ssd-monitor-arm64:$(RELEASE) cmd/ssd-monitor

push-ssd-monitor-amd64: ssd-monitor-amd64
	docker push geoffgarside/ssd-monitor-amd64:$(RELEASE)

push-ssd-monitor-arm64: ssd-monitor-arm64
	docker push geoffgarside/ssd-monitor-arm64:$(RELEASE)

.PHONY: ssd-monitor
ssd-monitor: push-ssd-monitor-amd64 push-ssd-monitor-arm64
	docker manifest create geoffgarside/ssd-monitor:$(RELEASE) \
		geoffgarside/ssd-monitor-amd64:$(RELEASE) \
		geoffgarside/ssd-monitor-arm64:$(RELEASE)
	docker manifest annotate geoffgarside/ssd-monitor:$(RELEASE) \
		geoffgarside/ssd-monitor-arm64:$(RELEASE) \
		--os linux --arch arm64
	docker manifest push geoffgarside/ssd-monitor:$(RELEASE)

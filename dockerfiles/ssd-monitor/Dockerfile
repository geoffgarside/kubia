FROM golang:alpine AS build-env
RUN addgroup -g 10001 kubia && adduser -D -u 10001 -G kubia kubia
COPY . /go/src/app
WORKDIR /go/src/app
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -installsuffix cgo -ldflags '-s -w' -o /service

FROM scratch
COPY --from=build-env /etc/passwd /etc/passwd
COPY --from=build-env /etc/group /etc/group
COPY --from=build-env /service /service
EXPOSE 8080
USER kubia
CMD ["/service"]

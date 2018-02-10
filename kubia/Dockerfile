FROM golang:alpine AS build-env
ARG GOOS=linux
ARG GOARCH=amd64
WORKDIR /go/src/app
COPY . .
RUN CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} \
      go build -a -installsuffix cgo -ldflags '-s -w' -o /service

FROM scratch
COPY --from=build-env /service /service
EXPOSE 8080
CMD ["/service"]

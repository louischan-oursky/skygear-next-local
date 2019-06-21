FROM golang:1.12.5 as builder

ENV GO111MODULE on

WORKDIR /go/src/myapp

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN GOARCH=amd64 GOOS=linux CGO_ENABLED=0 go build -ldflags '-extldflags "-static" -w -s' -o /tmp/myapp

FROM scratch

COPY --from=builder /tmp/myapp /myapp

ENTRYPOINT ["/myapp"]

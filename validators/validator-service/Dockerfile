FROM golang:1.24.1-alpine AS builder

WORKDIR /app
COPY main.go .

RUN go mod init validator-service && \
    go build -o validator-service

FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/validator-service .

ENV PORT=8080

EXPOSE 8080

CMD ["./validator-service"]
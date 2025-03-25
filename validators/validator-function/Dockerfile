FROM golang:1.24.1-alpine AS builder

WORKDIR /app
COPY . .

RUN go mod tidy && \
    go build -o function

FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/function .

ENV PORT=8080

EXPOSE 8080

CMD ["./function"]
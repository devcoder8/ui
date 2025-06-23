FROM golang:1.23-alpine AS builder
WORKDIR /app

# Install templ if needed
RUN go install github.com/a-h/templ/cmd/templ@latest

COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN templ generate && \
    CGO_ENABLED=0 GOOS=linux go build -o ./app ./cmd/main.go
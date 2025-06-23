FROM golang:1.23-alpine AS builder
WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o ./app ./cmd/main.go

# Production stage
FROM alpine:latest
RUN apk add --no-cache ca-certificates tzdata
WORKDIR /app
COPY --from=builder /app/app .
COPY --from=builder /app/views ./views
COPY --from=builder /app/assets ./assets
ENV TZ=UTC
EXPOSE 8080
CMD ["./app"]
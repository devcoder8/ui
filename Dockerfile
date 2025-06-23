# Build stage
FROM golang:1.22 as builder

WORKDIR /app
COPY . .

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main

# Run stage
FROM alpine:latest

WORKDIR /app
COPY --from=builder /app/main /app/main
COPY --from=builder /app/views /app/views  # If using Templ/HTML
COPY --from=builder /app/static /app/static  # If using CSS/JS

EXPOSE 8080
CMD ["/app/main"]
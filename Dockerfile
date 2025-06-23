FROM golang:1.23-alpine AS builder

# Set working directory
WORKDIR /app

# Copy module files first (better caching)
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy all source files
COPY . .

# Build explicitly pointing to main package
RUN CGO_ENABLED=0 GOOS=linux go build -o /app/main ./cmd/main.go

RUN ls -la /app  # Add this before build to verify files

# Final lightweight image
FROM alpine:latest
COPY --from=builder /app/main /app/main
WORKDIR /app
ENTRYPOINT ["/app/main"]
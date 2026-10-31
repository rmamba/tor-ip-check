# Specifies a parent image
FROM golang:1.19.2-bullseye AS build
 
# Creates an app directory to hold your app’s source code
WORKDIR /app
 
# Copies everything from your root directory into /app
COPY . .

# Installs Go dependencies
RUN go mod download

# Builds your app with optional configuration
RUN CGO_ENABLED=0 go build -o testIP

# Specifies a parent image
FROM lusky3/privoxy:latest

# Copy application
COPY --from=build /app/testIP /tmp/testIP

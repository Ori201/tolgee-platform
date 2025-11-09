FROM eclipse-temurin:21-jdk-alpine

# Install necessary tools
RUN apk update && apk add --no-cache \
    curl \
    wget \
    git \
    bash

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Make gradlew executable
RUN chmod +x ./gradlew

# Build only the API module (backend only)
RUN ./gradlew :api:build -x test

# Expose port
EXPOSE 8080

# Run the application directly
CMD ["sh", "-c", "\
    echo 'Starting Tolgee backend...'; \
    if [ -f 'backend/api/build/libs/api.jar' ]; then \
        echo 'Running backend/api/build/libs/api.jar'; \
        java -jar backend/api/build/libs/api.jar; \
    else \
        echo 'JAR file not found!'; \
        find . -name '*.jar' -type f; \
        exit 1; \
    fi \
"]

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

# Build the API module properly
RUN ./gradlew :api:build -x test

# Debug: Show directory structure
RUN echo "=== Directory structure ===" && \
    find . -name "build" -type d && \
    echo "=== JAR files ===" && \
    find . -name "*.jar" -type f

# Expose port
EXPOSE 8080

# Run the application with correct path
CMD ["sh", "-c", "\
    cd backend && \
    java -cp \\\"api/build/libs/*:api/build/libs/*.jar:lib/*\\\" \\
    -Dloader.path=api/build/libs/,api/build/libs/*.jar \\
    org.springframework.boot.loader.PropertiesLauncher"]

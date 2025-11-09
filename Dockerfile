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

# List what was built to see actual JAR name
RUN echo "Checking build directory:" && \
    find api/build/libs -name "*.jar" -type f 2>/dev/null || \
    find . -name "*.jar" -type f 2>/dev/null || \
    echo "No JAR files found"

# Expose port
EXPOSE 8080

# Run the application with error checking
CMD ["sh", "-c", "JAR_FILE=$(find api/build/libs -name '*.jar' -type f | head -1) && \
    if [ -n \"$JAR_FILE\" ]; then \
        echo \"Running JAR: $JAR_FILE\" && \
        java -jar \"$JAR_FILE\"; \
    else \
        echo \"No JAR file found!\" && \
        ls -la api/ && \
        ls -la api/build/ && \
        ls -la api/build/libs/ 2>/dev/null || echo \"libs directory not found\" && \
        exit 1; \
    fi"]

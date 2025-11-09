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

# Debug: Show what JAR files were created
RUN echo "=== Looking for JAR files ===" && \
    find . -name "*.jar" -type f && \
    echo "=== Checking JAR manifest ===" && \
    for jarfile in $(find . -name "*.jar" -type f); do \
        echo "Checking $jarfile:"; \
        unzip -p "$jarfile" META-INF/MANIFEST.MF 2>/dev/null | head -10 || echo "No manifest found"; \
        echo "---"; \
    done

# Expose port
EXPOSE 8080

# Try to find and run the correct JAR
CMD ["sh", "-c", "\
    # Look for executable JARs (with Main-Class) \
    EXECUTABLE_JAR=$(find . -name \"*.jar\" -exec sh -c 'unzip -p \"{}\" META-INF/MANIFEST.MF 2>/dev/null | grep -q \"Main-Class\" && echo \"{}\"' \\; | head -1); \
    if [ -n \"$EXECUTABLE_JAR\" ]; then \
        echo \"Found executable JAR: $EXECUTABLE_JAR\"; \
        java -jar \"$EXECUTABLE_JAR\"; \
    else \
        echo \"No executable JAR found, trying to run with Spring Boot class\"; \
        # Try common Spring Boot entry points \
        java -cp \"api/build/libs/*:api/build/libs/*.jar\" org.springframework.boot.loader.PropertiesLauncher || \
        java -cp \"api/build/libs/*\" org.springframework.boot.loader.PropertiesLauncher || \
        java -cp \"$(find api/build/libs -name '*.jar' -type f | head -1)\" org.springframework.boot.loader.PropertiesLauncher || \
        echo \"Failed to find executable JAR or main class\" && exit 1; \
    fi \
"]

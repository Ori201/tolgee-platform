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

# Build executable JAR using bootJar task
RUN ./gradlew :backend:api:bootJar -x test || \
    ./gradlew :api:bootJar -x test || \
    ./gradlew bootJar -x test

# Debug: Show what was built
RUN echo \"=== Looking for executable JARs ===\" && \
    find . -name \"*.jar\" -type f | head -10

# Expose port
EXPOSE 8080

# Run the application
CMD [\"sh\", \"-c\", \"\
    JAR_FILE=\\$(find . -name '*.jar' -type f | grep -E '(api|server|boot)' | head -1); \
    if [ -z \\\"\\$JAR_FILE\\\" ]; then \
        JAR_FILE=\\$(find . -name '*.jar' -type f | head -1); \
    fi; \
    echo \\\"Running JAR: \\$JAR_FILE\\\"; \
    java -jar \\\"\\$JAR_FILE\\\"\"
]

FROM eclipse-temurin:21-jdk-alpine

# Install necessary tools
RUN apk update && apk add --no-cache \
    curl \
    wget \
    git \
    bash

# Set working directory
WORKDIR /app

# Copy everything (this preserves .git folder)
COPY . .

# Make gradlew executable
RUN chmod +x ./gradlew

# Build only the API module (backend only, skip frontend)
RUN ./gradlew :api:build -x test

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "./backend/api/build/libs/api.jar"]

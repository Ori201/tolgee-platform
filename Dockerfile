FROM eclipse-temurin:21-jdk-alpine

# Install necessary tools including Node.js and npm
RUN apk update && apk add --no-cache \
    curl \
    wget \
    git \
    bash \
    nodejs \
    npm

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Make gradlew executable
RUN chmod +x ./gradlew

# Build the application
RUN ./gradlew build -x test

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "api/build/libs/api.jar"]

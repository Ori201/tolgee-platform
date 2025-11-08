FROM gradle:7.6.4-jdk11-alpine

# Install necessary tools
RUN apk update && apk add --no-cache \
    curl \
    wget \
    git

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Make gradlew executable
RUN chmod +x ./gradlew

# Build the application
RUN ./gradlew build

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "api/build/libs/api.jar"]

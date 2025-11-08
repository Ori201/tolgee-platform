FROM openjdk:11-jre-slim

# Install necessary tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy everything (this allows you to modify files)
COPY . .

# Make gradlew executable
RUN chmod +x ./gradlew

# Build the application
RUN ./gradlew build

# Expose port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "api/build/libs/api.jar"]

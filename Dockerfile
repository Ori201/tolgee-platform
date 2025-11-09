## Multi-stage Dockerfile for Tolgee
## Stage 1: build server-app bootJar
FROM gradle:8.5-jdk21 AS builder
WORKDIR /workspace

# Copy project
COPY . .

# Build only the server app bootJar (skip tests for faster builds)
# Limit Gradle/JVM memory and parallelism so the build fits into Render build RAM limits
RUN GRADLE_OPTS="-Xmx2g -Dfile.encoding=UTF-8" \
	gradle :server-app:bootJar -x test --no-daemon --no-parallel --max-workers=1

## Stage 2: runtime image
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Copy the built jar from builder stage; the archive name includes the project version
COPY --from=builder /workspace/backend/app/build/libs/tolgee-*.jar /app/app.jar

EXPOSE 8080

ENV JAVA_OPTS=""

# Run the jar
CMD ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]

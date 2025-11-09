# Deploying Tolgee Platform on Render

## Overview
This guide explains how to deploy Tolgee Platform on Render using the provided configuration.

## Pre-requisites
- A Render account
- Your repository connected to Render
- A Postgres database (created automatically via render.yaml)

## Configuration Steps

1. **Database Setup**
   - The `render.yaml` will automatically create a Postgres database service named `tolgee-db`
   - Database credentials are automatically injected into the backend service

2. **Environment Variables**
   Required environment variables are configured in `render.yaml`, but you should set these values in Render dashboard:

   Backend Service (`tolgee-backend`):
   ```
   # Database (auto-configured by render.yaml)
   spring.datasource.url          # From tolgee-db connectionString
   spring.datasource.username     # From tolgee-db user
   spring.datasource.password     # From tolgee-db password
   
   # Application config
   SPRING_PROFILES_ACTIVE=prod    # Always use prod profile
   TOLGEE_JWT_SECRET             # Set a secure random string
   TOLGEE_FRONTEND_URL          # Set to your frontend service URL
   
   # Ensure Docker-based features are disabled
   tolgee.postgres-autostart.enabled=false
   ```

   Frontend Service (`tolgee-frontend`):
   - No additional environment variables required

3. **Deployment Order**
   1. Database is created first
   2. Backend service builds and starts
   3. Frontend service builds and deploys

4. **Health Checks**
   - Backend health endpoint: `/actuator/health`
   - Frontend: Root path `/`

## Common Issues

1. **Database Connection**
   - Ensure `spring.datasource.*` variables are correctly set
   - Check database service is running

2. **Frontend/Backend Communication**
   - Set `TOLGEE_FRONTEND_URL` to the actual frontend service URL
   - Format: `https://your-frontend-service.onrender.com`

## Local Testing

Test the Docker build locally:
```bash
# Build the backend image
docker build -t tolgee:local .

# Run with required env vars
docker run -p 8080:8080 \
  -e "SPRING_PROFILES_ACTIVE=prod" \
  -e "spring.datasource.url=jdbc:postgresql://host:5432/dbname" \
  -e "spring.datasource.username=user" \
  -e "spring.datasource.password=pass" \
  -e "TOLGEE_JWT_SECRET=your-secret" \
  -e "tolgee.postgres-autostart.enabled=false" \
  tolgee:local
```

## Monitoring

1. **Logs**
   - View logs in Render dashboard
   - Backend logs include Spring Boot startup info
   - Frontend logs show build progress

2. **Metrics**
   - Backend exposes metrics at `/actuator/metrics`
   - Monitor resource usage in Render dashboard

## Support
For issues, check:
1. Application logs in Render dashboard
2. Database connection status
3. Environment variable configuration
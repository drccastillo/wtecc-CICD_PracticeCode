FROM python:3.9-slim

# Metadatos de la imagen
LABEL maintainer="drccastillo" \
      description="WTECC CI/CD Practice Application" \
      version="1.0" \
      org.opencontainers.image.source="https://github.com/drccastillo/wtecc-CICD_PracticeCode"

# Establish a working folder
WORKDIR /app

# Instalar dependencias del sistema si son necesarias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        && rm -rf /var/lib/apt/lists/*

# Establish dependencies
COPY requirements.txt .
RUN python -m pip install -U pip wheel && \
    pip install --no-cache-dir -r requirements.txt

# Copy source files last because they change the most
COPY service ./service

# Become non-root user for security
RUN useradd -m -r service && \
    chown -R service:service /app
USER service

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:$PORT/health || exit 1

# Run the service on port 8000
ENV PORT=8000
EXPOSE $PORT
CMD ["sh", "-c", "gunicorn service:app --bind 0.0.0.0:$PORT --workers 1 --timeout 60"]

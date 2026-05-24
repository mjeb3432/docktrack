# syntax=docker/dockerfile:1

FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    netcat-openbsd \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Collect static files
RUN python manage.py collectstatic --noinput

# Create entrypoint script
RUN printf '#!/bin/bash\n\
python manage.py migrate --noinput\n\
gunicorn doctrack.wsgi:application --bind 0.0.0.0:$PORT\n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

# Expose port
EXPOSE $PORT

ENTRYPOINT ["/entrypoint.sh"]

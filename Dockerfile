FROM python:3.9-alpine3.13

LABEL maintainer="AbdullahHussein"

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PATH="/scripts:/py/bin:$PATH"

# Copy dependency files and application code
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# Set working directory
WORKDIR /app

# Expose application port
EXPOSE 8000

# Build arguments
ARG DEV=false

# Install dependencies, setup virtual environment, and create a non-root user
RUN apk add --no-cache shadow && \
    python -m venv /py && \
    /py/bin/pip install --upgrade pip --no-cache-dir && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; then \
      /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
      --disabled-password \
      --no-create-home \
      django-user

# Switch to non-root user
USER django-user

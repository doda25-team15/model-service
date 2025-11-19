
# Stage 1 — Build Stage

FROM python:3.12.9-slim AS builder

WORKDIR /build

RUN apt-get update && apt-get install -y \
    build-essential gfortran libopenblas-dev liblapack-dev curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2 — runtime
FROM python:3.12.9-slim AS runtime

WORKDIR /app

# Port for model-service
ENV PORT=8081

# Create folder for external model mount
RUN mkdir -p /app/output

# Copy installed site-packages only (lighter)
COPY --from=builder /usr/local/lib/python3.12 /usr/local/lib/python3.12
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy source code
COPY . .

EXPOSE ${PORT}

# Serve model (model must be in /app/output OR downloaded at start)
CMD ["python", "src/serve_model.py"]

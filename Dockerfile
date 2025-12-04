FROM python:3.12.9-slim AS builder

WORKDIR /build

RUN apt-get update && apt-get install -y \
    build-essential gfortran libopenblas-dev liblapack-dev curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.12.9-slim AS runtime

WORKDIR /app
ENV PYTHONPATH="/app"

ENV PORT=8081

RUN mkdir -p /app/output

COPY --from=builder /usr/local/lib/python3.12 /usr/local/lib/python3.12
COPY --from=builder /usr/local/bin /usr/local/bin

COPY . .

EXPOSE ${PORT}

CMD ["python", "src/serve_model.py"]
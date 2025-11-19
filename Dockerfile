FROM python:3.12.9-slim AS trainer

WORKDIR /root/sms

RUN apt-get update && apt-get install -y \
    build-essential gfortran libopenblas-dev liblapack-dev curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p output
RUN python src/read_data.py && \
    python src/text_preprocessing.py && \
    python src/text_classification.py


FROM python:3.12.9-slim AS runtime

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
COPY --from=trainer /root/sms/output /app/output

EXPOSE 8081

CMD ["python", "src/serve_model.py"]

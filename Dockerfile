# Use official Python 3.12 slim image
FROM python:3.12.9-slim

# Set working directory inside container
WORKDIR /app

# Install OS-level dependencies needed for scientific Python packages
RUN apt-get update && apt-get install -y \
    build-essential \
    gfortran \
    libopenblas-dev \
    liblapack-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first (helps with caching)
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files into container
COPY . .

# Expose the port the Flask app runs on
EXPOSE 8081

# Start the Flask microservice
CMD ["python", "src/serve_model.py"]

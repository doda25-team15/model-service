#I think this pulls latest
FROM ghcr.io/doda25-team15/model-service:latest 

WORKDIR /app
ENV PYTHONPATH="/app"
ENV PORT=8081

COPY . .

EXPOSE ${PORT}

CMD ["python", "src/serve_model.py"]
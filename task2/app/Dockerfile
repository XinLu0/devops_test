FROM python:3.12-slim

WORKDIR /app

# Install dependencies first for better layer caching
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Run as non-root for security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

COPY app.py ./

USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:3000/health')" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:3000", "--workers", "2", "app:app"]

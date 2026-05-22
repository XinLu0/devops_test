from flask import Flask, jsonify
from datetime import datetime, timezone
import os

app = Flask(__name__)

PORT = int(os.environ.get("PORT", 3000))


@app.route("/")
def index():
    return f"""<!DOCTYPE html>
<html>
  <head><title>Hello World</title></head>
  <body>
    <h1>Hello World!</h1>
    <p>Running on port {PORT}</p>
    <p>Server time: {datetime.now(timezone.utc).isoformat()}</p>
  </body>
</html>"""


@app.route("/health")
def health():
    return jsonify(status="healthy", timestamp=datetime.now(timezone.utc).isoformat())


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=PORT)

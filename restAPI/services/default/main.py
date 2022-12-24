"""
This module contains main endpoints of default services.
"""
from flask import Flask, jsonify

app = Flask(__name__)


@app.get("/")
def main():
    """
    main endpoint.
    """
    return jsonify(success=True)

if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

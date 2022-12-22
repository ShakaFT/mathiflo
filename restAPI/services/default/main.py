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

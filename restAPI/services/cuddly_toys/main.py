"""
Test module
"""
from flask import Flask, jsonify, request
from flask_cors import CORS

from History import History

app = Flask(__name__)
CORS(app)


@app.get("/")
def default():
    """
    main endpoint.
    """
    return jsonify(success=True)


@app.get("/history")
def get_history():
    """
    This endpoint returns the 5 last nights.
    """
    print("---")
    print(request.headers)
    print(request.headers.get("User-Agent", "not found"))
    print("---")
    try:
        history = History.from_token(request.args.get("token"))
        return jsonify(history.to_dict())
    except TypeError:
        return jsonify(error="Invalid token"), 400


@app.post("/new-night")
def new_night():
    """
    This endpoint generates a new night and stores it in history.
    It called by Scheduler Job every 24 hours at 20:00 pm.
    """
    history = History.new_night()
    history.update_database()
    return jsonify(), 204


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

"""
Test module
"""
from flask import Flask, jsonify, request
from flask_cors import CORS
from google.cloud import exceptions

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
    try:
        history = History.from_token(request.args.get("token"))
        return jsonify(history.to_dict())
    except TypeError:
        return jsonify(error="Invalid token"), 400


@app.put("/history")
def update_history():
    """
    This endpoint updates history.
    """
    try:
        if token := request.args.get("token"):
            history = History(request.get_json(force=True), token)
            history.update_database()
            return jsonify(), 204
        else:
            return jsonify(error="Missing token"), 400

    except exceptions.NotFound:
        return jsonify(error="Invalid token"), 400

    except ValueError as e:
        return jsonify(error=str(e)), 400


@app.post("/new-night")
def new_night():
    """
    This endpoint generates a new night and stores it in history.
    It called by Scheduler Job every 24 hours at 20:00 pm.
    """
    history = History.new_night()
    print(history.florent)
    print(history.mathilde)
    # history.update_database()
    return jsonify(), 204


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

"""
Test module
"""
from flask import Flask, jsonify
from flask_cors import CORS

from CuddlyToy import CuddlyToys
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
    last_nights = History.get_latest_history(nb_night=5)
    result = [ night.to_dict() for night in last_nights ]
    return jsonify(success=True, last_nights=result)


@app.post("/new-night")
def new_night():
    """
    This endpoint creates and returns new_night.
    """
    try:
        cuddly_toys = CuddlyToys()
        cuddly_toys.new_night()
        cuddly_toys.add_history()
        return jsonify(success=True, night=cuddly_toys.to_dict())

    except Exception as e: # pylint: disable=broad-except
        return jsonify(success=False, error=str(e))


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

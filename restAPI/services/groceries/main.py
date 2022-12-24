"""
This module contains main endpoints of groceries service.
"""
from firebase_admin import firestore
from flask import Flask, jsonify, request
from flask_cors import CORS

from FirestoreClient import db

app = Flask(__name__)
CORS(app)


@app.get("/")
def default():
    """
    main endpoint.
    """
    return jsonify(success=True)


@app.get("/groceries")
def get_groceries():
    """
    This endpoint returns groceries list.
    """
    return jsonify(db.groceries_list.get().to_dict() or {})


@app.post("/groceries/update")
def add_groceries():
    """
    This endpoint updates groceries list.
    If quandity == 0, the item is removed.
    """
    payload = request.get_json(force=True)
    new_items = payload.get("newItems")

    if new_items is None:
        return jsonify(error="missing newItems"), 400

    # remove field if quantity == 0
    update_dict = {
        item: quantity or firestore.DELETE_FIELD
        for item, quantity in new_items.items()
    }

    # store new groceries list to database
    db.groceries_list.set(update_dict, merge=True)

    return jsonify(), 204


@app.post("/groceries/reset")
def reset_groceries():
    """
    This endpoint resets groceries list.
    """
    db.groceries_list.delete()
    return jsonify(), 204


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

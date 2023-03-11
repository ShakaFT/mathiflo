"""
This module contains main endpoints of groceries service.
"""
from flask import Flask, jsonify, request
from flask_cors import CORS

from FirestoreClient import database

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
    groceries_list = database.groceries_list.get().to_dict() or {}
    return jsonify(groceriesList=groceries_list.get("list", []))


@app.post("/groceries")
def update_groceries():
    """
    This endpoint updates groceries list.
    """
    payload = request.get_json(force=True)
    groceries_list = payload.get("groceriesList")

    if groceries_list is None:
        return jsonify(error="missing groceriesList"), 400

    database.groceries_list.set({"list": groceries_list}, merge=True)

    return jsonify(), 204


@app.delete("/groceries")
def delete_groceries():
    """
    This endpoint deletes groceries list.
    """
    payload = request.get_json(force=True)

    if payload.get("all", False):
        database.groceries_list.delete()
        return jsonify(), 204

    groceries_list = (database.groceries_list.get().to_dict() or {}).get("list", [])
    new_groceries_list = [
        item
        for item in groceries_list
        if item["name"] not in payload.get("toDelete", [])
    ]

    database.groceries_list.update({"list": new_groceries_list})
    return jsonify(), 204


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

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
    return jsonify(
        groceriesList=[
            item.to_dict() | {"id": item.id} for item in database.groceries.stream()
        ]
    )


@app.post("/groceries/<item_id>")
def add_groceries_item(item_id: str):
    """
    This endpoint adds item in groceries list.
    """
    payload = request.get_json(force=True)

    try:
        new_item = {
            "name": str(payload["name"]),
            "quantity": int(payload["quantity"]),
        }
    except (KeyError, TypeError):
        return jsonify(error="groceriesItem format is not valid."), 400

    item_doc = database.groceries.document(item_id)

    if item_doc.get().exists:
        return jsonify(error="This item already exists"), 400

    if database.groceries_item_exists(new_item["name"]):
        # This item already exists (maybe a desynchronization between the local and the server)
        return jsonify(success=False, exists=True)

    item_doc.set(new_item)
    return jsonify(success=True, exists=False)


@app.put("/groceries/<item_id>")
def update_groceries_item(item_id: str):
    """
    This endpoint updates item from groceries list.
    """
    payload = request.get_json(force=True)

    try:
        updated_item = {
            "name": str(payload["name"]),
            "quantity": int(payload["quantity"]),
        }
    except (KeyError, TypeError):
        return jsonify(error="groceriesItem format is not valid."), 400

    item_doc = database.groceries.document(item_id)

    if database.groceries_item_exists(updated_item["name"]):
        # This item not exists (maybe a desynchronization between the local and the server)
        return jsonify(success=False, exists=False)

    item_doc.set(updated_item)
    return jsonify(success=True, exists=True)


@app.delete("/groceries")
def delete_groceries_items():
    """
    This endpoint deletes multiple items from groceries list.
    """
    payload = request.get_json(force=True)

    if payload.get("all", False):
        for document in database.groceries.stream():
            document.reference.delete()
        return jsonify(), 204

    items_to_delete = payload.get("groceriesItems")
    if items_to_delete is None or not isinstance(items_to_delete, list):
        return jsonify(error="groceriesItems format is not valid."), 400

    for item_id in items_to_delete:
        database.groceries.document(item_id).delete()

    return jsonify(), 204


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

"""
This module contains main endpoints of groceries service.
"""
import os

from dotenv import load_dotenv
from flask import current_app, jsonify, request

load_dotenv()

from Item import Item

from restAPI.FlaskApp import FlaskApp
from restAPI.FirestoreClient import FirestoreClient


API_KEY_HEADER = os.environ["MATHIFLO_API_KEY_HEADER"]
API_KEY = os.environ["MATHIFLO_API_KEY"]

app = FlaskApp(os.environ["GAE_SERVICE"], os.environ["GCP_PROJECT"])
app.api_key(os.environ["MATHIFLO_API_KEY_HEADER"], os.environ["MATHIFLO_API_KEY"])
app.discord(os.environ["DISCORD_ERROR_WEBHOOK"])


@app.get("/groceries")
def get_groceries():
    """
    This endpoint returns groceries list.
    """
    database: FirestoreClient = current_app.config["database"]
    return jsonify(groceries_list=Item.groceries_item(database))


@app.post("/groceries/<item_id>")
def add_groceries_item(item_id: str):
    """
    This endpoint adds item in groceries list.
    """
    database: FirestoreClient = current_app.config["database"]
    payload = request.get_json(force=True)

    try:
        item = Item(database, item_id, payload)
    except (KeyError, TypeError):
        return jsonify(error="groceriesItem format is not valid."), 400

    if item.exists:
        return jsonify(error="This item already exists"), 400

    if item.equivalent_exists:
        # This item already exists (maybe a desynchronization between the local and the server)
        return jsonify(success=False, exists=True)

    item.update_database()
    return jsonify(success=True, exists=False)


@app.put("/groceries/<item_id>")
def update_groceries_item(item_id: str):
    """
    This endpoint updates item from groceries list.
    """
    database: FirestoreClient = current_app.config["database"]
    payload = request.get_json(force=True)

    item = Item.from_database(database, item_id)

    if not item:
        # This item not exists (maybe a desynchronization between the local and the server)
        return jsonify(success=False, deleted=True)

    try:
        item.name = str(payload["name"])
        item.quantity = int(payload["quantity"])
    except (KeyError, TypeError):
        return jsonify(error="groceries item format is not valid."), 400

    item.update_database()
    return jsonify(success=True, exists=True)


@app.delete("/groceries")
def delete_groceries_items():
    """
    This endpoint deletes multiple items from groceries list.
    """
    database: FirestoreClient = current_app.config["database"]
    payload = request.get_json(force=True)

    if payload.get("all", False):
        Item.delete_all(database)
        return jsonify(), 204

    items_to_delete = payload.get("groceries_items")
    if not isinstance(items_to_delete, list):
        return jsonify(error="groceries_items format is not valid."), 400

    for item_id in items_to_delete:
        if item := Item.from_database(database, item_id):
            item.delete()

    return jsonify(), 204


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

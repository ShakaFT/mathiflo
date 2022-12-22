"""
This module contains main endpoints of groceries service.
"""
from flask import Flask, jsonify, request
from flask_cors import CORS

from FirestoreManager import fclient

app = Flask(__name__)
CORS(app)


@app.get("/")
def default():
    """
    main endpoint.
    """
    return jsonify(success=True)


@app.post("/groceries/add")
def add_groceries():
    """
    This endpoint add items to groceries list.
    """
    payload = request.get_json(force=True)
    new_items = payload.get("new_items")

    if new_items is None:
        return jsonify(error="missing new_items"), 400

    # get current groceries list in database
    doc = fclient.groceries.document("groceries_list").get()
    groceries_list = doc.to_dict() if doc.exists else {}

    # add new items to groceries list
    for item, quantity in new_items.items():
        if item in groceries_list:
            groceries_list[item] += quantity
        else:
            groceries_list[item] = quantity

        if groceries_list[item] <= 0:
            # user has remove this item of groceries list
            groceries_list.pop(item)

    # store new groceries list to database
    fclient.groceries.document("groceries_list").set(groceries_list)

    return jsonify(groceries_list=groceries_list)


@app.post("/groceries/reset")
def reset_groceries():
    """
    This endpoint reset groceries list.
    """
    fclient.groceries.document("groceries_list").delete()
    return jsonify()


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

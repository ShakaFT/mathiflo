"""
This module contains main endpoints of default services.
"""
import os

from dotenv import load_dotenv
from flask import current_app, jsonify, request

load_dotenv()

from Event import Event

from restAPI.FlaskApp import FlaskApp
from restAPI.FirestoreClient import FirestoreClient


app = FlaskApp(os.environ["GAE_SERVICE"], os.environ["GOOGLE_CLOUD_PROJECT"])
app.api_key(os.environ["MATHIFLO_API_KEY_HEADER"], os.environ["MATHIFLO_API_KEY"])
app.discord(os.environ["DISCORD_ERROR_WEBHOOK"])


@app.post("/event/<event_id>")
def create_event(event_id: str):
    """
    This endpoint creates an event.
    """
    database: FirestoreClient = current_app.config["database"]
    payload = request.get_json(force=True)

    try:
        event = Event(database, event_id, payload)
    except (KeyError, ValueError) as e:
        return jsonify(error=f"Event format is not valid : {e}"), 400

    if event.exists:
        return jsonify(error=f"There is already an event with id : {event_id}"), 400

    event.update_database()
    return jsonify(), 204


@app.put("/event/<event_id>")
def update_event(event_id: str):
    """
    This endpoint updates an event.
    """
    database: FirestoreClient = current_app.config["database"]
    payload = request.get_json(force=True)

    event = Event.from_database(database, event_id)

    if not event:
        return jsonify(error=f"There is no event with id : {event_id}"), 400

    try:
        event.title = str(payload["title"])
        event.start_timestamp = int(payload["start_timestamp"])
        event.end_timestamp = int(payload["end_timestamp"])
    except (KeyError, ValueError) as e:
        return jsonify(error=f"Event format is not valid : {e}"), 400

    event.update_database()
    return jsonify(), 204


@app.delete("/event/<event_id>")
def delete_event(event_id: str):
    """
    This endpoint deletes an event.
    """
    database: FirestoreClient = current_app.config["database"]

    event = Event.from_database(database, event_id)

    if not event:
        return jsonify(error=f"There is no event with id : {event_id}"), 400

    event.delete()
    return jsonify(), 204


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

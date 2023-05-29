"""
This module contains main endpoints of default services.
"""
import os

from dotenv import load_dotenv
from flask import jsonify, request

load_dotenv()

from Event import Event

from restAPI.FlaskApp import FlaskApp


app = FlaskApp(os.environ["GAE_SERVICE"], os.environ["GOOGLE_CLOUD_PROJECT"])
app.api_key(os.environ["MATHIFLO_API_KEY_HEADER"], os.environ["MATHIFLO_API_KEY"])
app.discord(os.environ["DISCORD_ERROR_WEBHOOK"])


@app.get("/events")
def get_events():
    """
    This endpoint returns paging of events.
    """
    start_timestamp = request.args.get("start_timestamp")
    end_timestamp = request.args.get("end_timestamp")

    if not start_timestamp:
        return jsonify(error="Invalid payload : missing `start_timestamp`"), 400
    if not end_timestamp:
        return jsonify(error="Invalid payload : missing `end_timestamp`"), 400

    try:
        start_timestamp = int(start_timestamp)
        end_timestamp = int(end_timestamp)
    except ValueError as e:
        return jsonify(error=f"Invalid format : {e}"), 400

    if start_timestamp > end_timestamp:
        return jsonify(error="`start_timestamp` must be lower than `end_timestamp`"), 400

    events = Event.paging_events(app.database, start_timestamp, end_timestamp)
    return jsonify(events=events)


@app.post("/event/<event_id>")
def create_event(event_id: str):
    """
    This endpoint creates an event.
    """
    payload = request.get_json(force=True)

    try:
        event = Event(app.database, event_id, payload)
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
    payload = request.get_json(force=True)

    event = Event.from_database(app.database, event_id)

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
    event = Event.from_database(app.database, event_id)

    if not event:
        return jsonify(error=f"There is no event with id : {event_id}"), 400

    event.delete()
    return jsonify(), 204


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

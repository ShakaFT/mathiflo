"""
This module contains main endpoints of cuddly_toys service.
"""
from datetime import datetime, timedelta
import os

from dotenv import load_dotenv
from firebase_admin import storage
from flask import jsonify, request
from google.auth import compute_engine
import google.auth.transport.requests
from unidecode import unidecode

load_dotenv()

import constants
from History import History
from scheduler import scheduler

from restAPI.FlaskApp import FlaskApp


app = FlaskApp(os.environ["GAE_SERVICE"], os.environ["GOOGLE_CLOUD_PROJECT"])
app.api_key(os.environ["MATHIFLO_API_KEY_HEADER"], os.environ["MATHIFLO_API_KEY"])
app.discord(os.environ["DISCORD_ERROR_WEBHOOK"])

app.register_blueprint(scheduler)


@app.get("/start")
def start():
    """
    This endpoint returns data to load when CuddlyToys page is launched.
    """
    bucket = storage.bucket(f"{os.environ['GOOGLE_CLOUD_PROJECT']}.appspot.com")
    expires_at_ms = datetime.now() + timedelta(minutes=1)

    auth_request = google.auth.transport.requests.Request()
    signing_credentials = compute_engine.IDTokenCredentials(auth_request, "")

    return jsonify(
        cuddly_toys={
            cuddly_toy: bucket.blob(
                f"cuddly_toys_pictures/{unidecode(cuddly_toy)}.png"
            ).generate_signed_url(
                expiration=expires_at_ms, credentials=signing_credentials
            )
            for cuddly_toy in app.database.get(
                constants.COLLECTION_CUDDLY_TOYS, constants.DOCUMENT_CUDDLY_TOYS
            )[  # type: ignore
                "cuddly_toys"
            ]
        }
    )


@app.get("/history")
def get_history():
    """
    This endpoint returns the 5 last nights.
    """
    try:
        history = History.from_token(app.database, request.args.get("token"))
        return jsonify(history.to_dict())
    except TypeError:
        return jsonify(error="Invalid token"), 400


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

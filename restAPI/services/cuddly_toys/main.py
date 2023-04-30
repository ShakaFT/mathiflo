"""
This module contains main endpoints of cuddly_toys service.
"""
from datetime import datetime, timedelta
import os

from dotenv import load_dotenv
from firebase_admin import storage
from flask import current_app, jsonify, request
from google.auth import compute_engine
import google.auth.transport.requests
from unidecode import unidecode

load_dotenv()

import constants
from History import History
from scheduler import scheduler

from restAPI.config import create_app
from restAPI.FirestoreClient import FirestoreClient


app = create_app(
    __name__, os.environ["MATHIFLO_API_KEY_HEADER"], os.environ["MATHIFLO_API_KEY"]
)
app.register_blueprint(scheduler)


@app.get("/start")
def start():
    """
    This endpoint returns data to load when CuddlyToys page is launched.
    """
    database: FirestoreClient = current_app.config["database"]

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
            for cuddly_toy in database.get(
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
    print("hello")
    database: FirestoreClient = current_app.config["database"]
    try:
        history = History.from_token(database, request.args.get("token"))
        return jsonify(history.to_dict())
    except TypeError:
        return jsonify(error="Invalid token"), 400


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

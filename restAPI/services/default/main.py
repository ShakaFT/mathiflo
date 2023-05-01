"""
This module contains main endpoints of default services.
"""
import os

from dotenv import load_dotenv
from flask import current_app, jsonify, request

load_dotenv()

import constants

from restAPI.config import create_app
from restAPI.FirestoreClient import FirestoreClient


app = create_app(
    __name__, os.environ["MATHIFLO_API_KEY_HEADER"], os.environ["MATHIFLO_API_KEY"]
)


@app.get("/app-version")
def get_app_version():
    """
    This endpoint returns app version.
    """
    database: FirestoreClient = current_app.config["database"]
    mobile_app_info = (
        database.get(constants.COLLECTION_MOBILE_APP, constants.DOCUMENT_MOBILE_APP)
        or {}
    )
    return jsonify(
        app_version=mobile_app_info["app_version"],
        code_version=mobile_app_info["code_version"],
    )


@app.put("/app-version")
def update_app_version():
    """
    This endpoint updates app version.
    """
    database: FirestoreClient = current_app.config["database"]
    payload = request.get_json(force=True)

    try:
        database.update(
            constants.COLLECTION_MOBILE_APP,
            constants.DOCUMENT_MOBILE_APP,
            {
                "app_version": payload["app_version"],
                "code_version": payload["code_version"],
            },
        )
    except KeyError as e:
        return jsonify(error=f"Invalid payload : {e}"), 400

    return jsonify(), 204


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

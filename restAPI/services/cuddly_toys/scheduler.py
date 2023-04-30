"""
This module contains endpoints called by Scheduler jobs.
"""
from flask import Blueprint, current_app, jsonify

from History import History

from restAPI.decorators import check_scheduler_job
from restAPI.FirestoreClient import FirestoreClient


scheduler = Blueprint("scheduler", __name__)


@scheduler.post("/new-night")
@check_scheduler_job()
def new_night():
    """
    This endpoint generates a new night and stores it in history.
    It called by Scheduler Job every 24 hours at 20:00 pm.
    """
    database: FirestoreClient = current_app.config["database"]
    history = History.new_night(database)
    history.update_database()
    return jsonify(), 204

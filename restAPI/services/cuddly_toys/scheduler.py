"""
This module contains endpoints called by Scheduler jobs.
"""
from flask import Blueprint, current_app, jsonify

from History import History

from restAPI.decorators import check_scheduler_job


scheduler = Blueprint("scheduler", __name__)


@scheduler.post("/new-night")
@check_scheduler_job()
def new_night():
    """
    This endpoint generates a new night and stores it in history.
    It called by Scheduler Job every 24 hours at 20:00 pm.
    """
    history = History.new_night(current_app.database)  # type: ignore
    history.update_database()
    return jsonify(), 204

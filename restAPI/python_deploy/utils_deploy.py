"""
This module contains util functions.
"""
import os

def get_services() -> list[str]:
    """
    This function returns a list that contains services.
    """
    return next(os.walk("services"))[1]

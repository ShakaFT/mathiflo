"""
This module contains util functions
"""
import os
import subprocess


def get_services() -> list[str]:
    """
    This function returns a list that contains services.
    """
    return sorted(next(os.walk("services"))[1])


def run_service(service: str):
    """
    This function sets GAC and executes main.py of selected service.
    """
    root_path = os.path.join(os.path.dirname(__file__), os.pardir)
    commands = [
        f"GOOGLE_APPLICATION_CREDENTIALS={root_path}/services/credentials.json",
        f"python services/{service}/main.py"
    ]
    subprocess.call(" ".join(commands), shell=True)

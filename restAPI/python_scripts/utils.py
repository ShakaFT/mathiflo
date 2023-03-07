"""
This module contains util functions.
"""
import os
import subprocess


def branch_name() -> str:
    """
    This function returns True if your branch is main, else False.
    """
    return subprocess.getoutput("git symbolic-ref --short HEAD")


def is_prod() -> bool:
    """
    This function returns :
    - 'prod' : if main branch is active.
    - 'dev' : else
    """
    return branch_name() == "main"


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
    os.environ[
        "GOOGLE_APPLICATION_CREDENTIALS"
    ] = f"{root_path}/services/credentials.json"
    subprocess.call(f"python services/{service}/main.py", shell=True)


def set_project(project_id: str):
    """
    This function sets gcloud project.
    """
    subprocess.call(f"gcloud config set project {project_id}", shell=True)

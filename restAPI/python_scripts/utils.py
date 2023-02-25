"""
This module contains util functions
"""
import os
import subprocess
from typing import Any


def branch_name() -> str:
    """
    This function returns True if your branch is master, else False.
    """
    return __write_in_shell("git symbolic-ref --short HEAD", returned=True)


def is_prod() -> bool:
    """
    This function returns :
    - 'prod' : if master branch is active.
    - 'dev' : else
    """
    return branch_name() == "master"


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
        "GOOGLE_CLOUD_PROJECT=mathiflo-dev",
        f"python services/{service}/main.py"
    ]
    subprocess.call(" ".join(commands), shell=True)


def set_project(project_id: str):
    """
    This function sets gcloud project.
    """
    subprocess.call(f"gcloud config set project {project_id}", shell=True)


def __write_in_shell(command_line: str, returned: bool = False, split: bool = True) -> Any | None:
    # sourcery skip: move-assign
    """
    This function executes the <command_line> in shell. If you want the returned value of your command line,
    you can set the 'returned' parameter to True.
    """
    result = os.popen(command_line)
    if returned and split:
        return result.read().split()[0]

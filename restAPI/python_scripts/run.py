"""
This module allows to run locally services.
"""
import os
import subprocess
import sys

from pick import pick
from rich import print as shell_print

import utils


ENVIRONMENT = utils.environment()
SERVICES = utils.get_services()


def run_service(service: str):
    """
    This function sets GAC and executes main.py of selected service.
    """
    os.environ["GAE_SERVICE"] = service
    subprocess.call(f"python services/{service}/main.py", shell=True)


def select_menu() -> str:
    """
    This function shows select menus and returns the services to deploy.
    """
    title = "Choose the service you want to run locally:"
    options = ["None", *SERVICES]
    service_to_run, _ = pick(options, title)

    return str(service_to_run)


def main():
    """
    main function.
    """
    param_service = sys.argv[1].lower() if len(sys.argv) >= 2 else None
    if param_service and param_service not in SERVICES:
        shell_print(f"[bold red]Unknown `{param_service}` service...")
        return

    service_to_run = param_service or select_menu()

    if service_to_run == "None":
        shell_print("[magenta]No service will be locally")
        return

    utils.set_env_var(ENVIRONMENT)
    utils.set_project()

    shell_print(
        f"[magenta]\nThis service will be runned locally : [green]{service_to_run}\n"
    )
    run_service(service_to_run)


if __name__ == "__main__":
    try:
        main()
    except Exception as e:  # pylint: disable=broad-except
        shell_print(f"[bold red]Unknown error : {e}")

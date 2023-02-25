"""
This module allows to deploy services.
"""
import subprocess
import sys

from pick import pick
from rich import print as shell_print

import utils

PROJECT_ID = "mathiflo" if utils.is_prod() else "mathiflo-dev"
SERVICES: list[str] = utils.get_services()


def deploy_services(services_to_deploy:list[str]):
    """
    This function deploys services.
    """
    for service in services_to_deploy:
        shell_print(f"[bold][magenta]\nI will deploy service : [green]{service}\n")
        subprocess.call(f"gcloud app deploy --quiet --project {PROJECT_ID} services/{service}/app.yaml", shell=True)


def select_menu() -> list:
    """
    This function shows select menus and returns the services to deploy.
    """
    title = "Choose the service you want to deploy: "
    options = ["None", "All"]
    options.extend(SERVICES)
    service_to_deploy, _ = pick(options, title)

    match service_to_deploy:
        case "All":
            services_to_deploy = SERVICES
        case "None":
            services_to_deploy = []
        case _:
            services_to_deploy = [service_to_deploy]

    shell_print(f"services_to_deploy : {services_to_deploy}")

    return services_to_deploy


def main():
    """
    main function
    """
    if utils.is_prod():
        shell_print("[bold italic yellow on red blink]You really want to deploy in production ?")
        input("Press Enter to continue...")

    services_to_deploy = select_menu()

    if not services_to_deploy:
        shell_print("Exit, no service to deploy...")
        sys.exit()

    utils.set_project(PROJECT_ID)
    deploy_services(services_to_deploy)


if __name__ == "__main__":
    main()

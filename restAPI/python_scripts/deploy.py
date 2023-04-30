"""
This module allows to deploy services.
"""
import os
import subprocess
import sys

from dotenv import load_dotenv
from pick import pick
from rich import print as shell_print
import yaml

import utils


load_dotenv()
ENVIRONMENT = utils.environment()
SERVICES = utils.get_services()


def deploy_services(services_to_deploy: list[str]):
    """
    This function deploys services.
    """
    command_to_deploy = (
        f"gcloud app deploy --quiet --project {os.environ['GCP_PROJECT_ID']}"
    )

    for service in services_to_deploy:
        set_flask_environment_variables(service)
        set_package(service)
        command_to_deploy += f" services/{service}/app.yaml"

    subprocess.call(command_to_deploy, shell=True)


def select_menu() -> list[str]:
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
            services_to_deploy = [str(service_to_deploy)]

    return services_to_deploy


def set_flask_environment_variables(service: str):
    """
    This function sets environment variables in app.yaml.
    """
    config_path = f"services/{service}/app.yaml"

    with open(config_path, "r", encoding="UTF-8") as file:
        config_data: dict = yaml.load(file, Loader=yaml.FullLoader)

    try:
        for env_var in config_data.get("env_variables", {}):
            config_data["env_variables"][env_var] = os.environ[env_var]
    except KeyError as e:
        shell_print(f"[bold red]{service} service need {e} environment variable.")
        sys.exit()

    with open(config_path, "w", encoding="UTF-8") as file:
        yaml.dump(config_data, file)


def set_package(service: str):
    """
    This function sets package in requirements.txt.
    """
    token = os.environ["RESTAPI_PACKAGE_TOKEN"]
    username = os.environ["RESTAPI_PACKAGE_USERNAME"]
    with open(
        f"services/{service}/requirements.txt", mode="a", encoding="UTF-8"
    ) as file:
        file.write(
            f"\ngit+https://{username}:{token}@github.com/ShakaFT/restAPI-package.git"
        )


def main():
    """
    main function
    """
    if ENVIRONMENT == "prod":
        shell_print(
            "[bold italic yellow on red blink]You really want to deploy in production ?"
        )
        input("Press Enter to continue...")

    param_service = sys.argv[1].lower() if len(sys.argv) >= 2 else None

    if param_service == "all":
        services_to_deploy = SERVICES
    elif param_service in SERVICES:
        services_to_deploy = [param_service]
    elif not param_service:
        services_to_deploy = select_menu()
    else:
        shell_print(f"[bold red]Unknown `{param_service}` service...")
        return

    if not services_to_deploy:
        shell_print("[bold red]Exit, no service to deploy...")
        return

    shell_print(f"services_to_deploy : {services_to_deploy}")

    utils.set_env_var(ENVIRONMENT)
    utils.set_project()
    deploy_services(services_to_deploy)


if __name__ == "__main__":
    utils.verify_environment()
    try:
        main()
    except Exception as e:  # pylint: disable=broad-except
        shell_print(f"[bold red]Unknown error : {e}")
    finally:
        shell_print("[bold magenta]Reset using git.")
        utils.reset()

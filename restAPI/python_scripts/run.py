"""
This module allows to run locally services.
"""
from pick import pick
from rich import print as shell_print

import utils


def select_menu() -> str:
    """
    This function shows select menus and returns the services to deploy.
    """
    title = "Choose the service you want to run locally: "
    options = ["None"]
    options.extend(utils.get_services())
    service_to_run, _ = pick(options, title)

    return str(service_to_run)


def main():
    """
    main function.
    """
    service_to_run = select_menu()

    if service_to_run == "None":
        shell_print("[magenta]No service will be locally")
        return

    shell_print(
        f"[magenta]This service will be runned locally : [green]{service_to_run}"
    )
    utils.run_service(service_to_run)


if __name__ == "__main__":
    main()

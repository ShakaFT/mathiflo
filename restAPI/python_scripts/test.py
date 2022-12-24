"""
This module allows to deploy verify environment before to deploy.
"""
from pick import pick
from rich import print as shell_print

import utils


def select_menu() -> str:
    """
    This function shows select menus and returns the services to deploy.
    """
    title = "Choose the service you want to test: "
    options = ["None"]
    options += utils.get_services()
    service_to_test, _ = pick(options, title)

    return service_to_test


def main():
    """
    main function.
    """
    service_to_test = select_menu()

    if service_to_test == "None":
        shell_print("[magenta]No service will be tested")
        return

    shell_print(f"[magenta]This service will be tested : [green]{service_to_test}")
    utils.run_service(service_to_test)


if __name__ == "__main__":
    main()

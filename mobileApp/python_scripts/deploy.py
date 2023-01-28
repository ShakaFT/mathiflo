"""
This script is used to locally deploy app.
"""
import subprocess
import sys

from pick import pick
from rich import print as shell_print

import utils

ENVIRONNEMENT = utils.get_environnement()
SERVICES: list[str] = utils.get_devices()


def deploy(target_device: str):
    """
    This function deploys app on target device.
    """
    shell_print(f"[green]Will run on device : {target_device}")
    subprocess.call(f"flutter run -d {target_device}", shell=True)


def select_menu() -> list:
    """
    This function shows select menu and returns the target device.
    """
    title = "Choose the target device :"
    options = ["None", *utils.get_devices()]
    chosen_device, _ = pick(options, title)

    return chosen_device.split("(")[0]


def main():
    """
    main function
    """
    if ENVIRONNEMENT == "prod":
        shell_print("[bold italic yellow on red blink]You really want to deploy in production ?")
        input("Press Enter to continue...")

    target_device = select_menu()

    if target_device == "None" :
        shell_print("[red]Exit, no service to deploy...")
        sys.exit()

    utils.set_config(ENVIRONNEMENT)
    utils.rename_app()
    deploy(target_device)


if __name__ == "__main__":
    utils.verify_environment()
    try:
        main()
    except Exception as e: # pylint: disable=broad-except
        shell_print(f"[bold red]Exit with error : {str(e)}")
    finally:
        utils.reset()

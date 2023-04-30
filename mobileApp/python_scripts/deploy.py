"""
This script is used to locally deploy app.
"""
import subprocess
import sys

from pick import pick
from rich import print as shell_print

import utils


ENVIRONMENT = utils.get_environnement()


def deploy(target_device: str):
    """
    This function deploys app on target device.
    """
    shell_print(f"[green]Will deploy on device : {target_device}")
    args = [
        "--dart-define-from-file=env.json",
        "--web-browser-flag",
        "'--disable-web-security'",
    ]
    subprocess.call(
        f"flutter run -d {target_device} {' '.join(args)}",
        shell=True,
    )


def get_devices() -> list[str]:
    """
    This function returns the list of connected devices.
    """
    devices = subprocess.getoutput("flutter devices").split("\n")[2:]
    result = []
    for device in devices:
        splited_device = device.split("•")
        device_name = splited_device[0].strip()
        device_id = splited_device[1].strip()
        result.append(f"{device_name} - {device_id}")

    return result


def select_menu() -> str:
    """
    This function shows select menu and returns the target device.
    """
    title = "Choose the target device :"
    options = ["None", *get_devices()]
    chosen_device, _ = pick(options, title)

    if chosen_device != "None":
        chosen_device = str(chosen_device).split("-")[1].strip()

    return str(chosen_device)


def main():
    """
    main function.
    """
    if ENVIRONMENT == "prod":
        shell_print(
            "[bold italic yellow on red blink]You really want to deploy in production ?"
        )
        input("Press Enter to continue...")

    target_device = select_menu()

    if target_device == "None":
        shell_print("[red]Exit, no service to deploy...")
        sys.exit()

    utils.set_config(ENVIRONMENT)

    if ENVIRONMENT == "prod":
        # By default, app name & app bundle are the ones of the dev version.
        utils.rename_app_name()
        utils.rename_app_bundle()
    deploy(target_device)


if __name__ == "__main__":
    utils.verify_environment()
    try:
        main()
    except Exception as e:  # pylint: disable=broad-except
        shell_print(f"[bold red]Exit with error : {e}")
    finally:
        shell_print("[bold magenta]Reset using git.")
        utils.git_reset()

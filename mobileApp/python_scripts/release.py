"""
This script is used to locally deploy app.
"""
import subprocess
import sys

from rich import print as shell_print
import yaml

import utils

ENVIRONNEMENT = utils.get_environnement()
SERVICES: list[str] = utils.get_devices()


def release():
    """
    This function sends a new release on Play Store.
    """
    subprocess.call("flutter build appbundle", shell=True)
    subprocess.call("fastlane deploy", shell=True)


def upgrade_version():
    """
    This function increments code version.
    """
    with open("pubspec.yaml", "r", encoding="UTF-8") as file:
        pubspec = yaml.load(file, Loader=yaml.FullLoader)

    splited_version = pubspec["version"].split("+")
    pubspec["version"] = f"{splited_version[0]}+{int(splited_version[1]) + 1}"

    with open("pubspec.yaml", "w", encoding="UTF-8") as file:
        yaml.dump(pubspec, file)

    utils.push("chore: new release --> upgrade code version")


def main():
    """
    main function
    """
    if ENVIRONNEMENT == "prod":
        shell_print(
            "[bold italic yellow on red blink]You really want to send release in production ?")
        input("Press Enter to continue...")
    else:
        shell_print("[red]Exit ! You can send release only on master...")
        sys.exit()

    upgrade_version()
    utils.set_config(ENVIRONNEMENT)
    utils.rename_app()
    release()


if __name__ == "__main__":
    main()
    utils.verify_environment()
    try:
        main()
    except Exception as e:  # pylint: disable=broad-except
        shell_print(f"[bold red]Exit with error : {str(e)}")
    finally:
        utils.reset()

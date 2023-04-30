"""
This script is used to locally deploy app.
"""
import os
import subprocess
import sys

from rich import print as shell_print
import yaml

import utils


ENVIRONMENT = utils.get_environnement()


def release():
    """
    This function sends a new release on Play Store.
    """
    subprocess.call(
        "flutter build appbundle --dart-define-from-file=env.json", shell=True
    )
    os.chdir("android")
    fastlane_code = subprocess.call("fastlane deploy", shell=True) == 0
    utils.git_reset()

    if fastlane_code == 0:
        utils.git_push()
    else:
        utils.git_cancel_commits(1)

def upgrade_version():
    """
    This function increments code version.
    """
    with open("pubspec.yaml", "r", encoding="UTF-8") as file:
        pubspec_data = yaml.load(file, Loader=yaml.FullLoader)

    app_version, code_version = pubspec_data["version"].split("+")
    new_code_version = int(code_version) + 1
    pubspec_data["version"] = f"{app_version}+{new_code_version}"

    with open("pubspec.yaml", "w", encoding="UTF-8") as file:
        yaml.dump(pubspec_data, file)

    utils.git_commit(
        f"chore: new release --> upgrade code version to {new_code_version}"
    )


def main():
    """
    main function.
    """
    if ENVIRONMENT == "prod":
        shell_print(
            "[bold italic yellow on red blink]You really want to send release in production ?"
        )
        input("Press Enter to continue...")
    else:
        shell_print("[red]Exit ! You can send release only on main branch...")
        sys.exit()

    upgrade_version()
    utils.set_config(ENVIRONMENT)
    utils.rename_app_name()
    utils.rename_app_bundle()
    release()


if __name__ == "__main__":
    utils.verify_environment()
    try:
        main()
    except Exception as e:  # pylint: disable=broad-except
        shell_print(f"[bold red]Exit with error : {e}")
    finally:
        shell_print("[bold magenta]Reset using git.")
        utils.git_reset()

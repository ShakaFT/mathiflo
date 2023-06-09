"""
This script is used to locally deploy app.
"""
import os
import subprocess
import sys

import requests
from rich import print as shell_print
import yaml

import utils


ENVIRONMENT = utils.get_environnement()


def release(app_version: str, code_version: str):
    """
    This function sends a new release on Play Store.
    """
    subprocess.call(
        "flutter build appbundle --dart-define-from-file=env.json", shell=True
    )
    os.chdir("android")
    fastlane_code = subprocess.call("fastlane deploy", shell=True)
    utils.git_reset()

    if fastlane_code == 0:
        utils.git_push()
        shell_print("[bold magenta]\nWill update network app version")
        update_network_app_version(app_version, code_version, environment="prod")
        update_network_app_version(app_version, code_version, environment="dev")
    else:
        utils.git_cancel_commits(1)


def update_network_app_version(app_version: str, code_version: str, environment: str):
    """
    This function updates app version from database.
    """
    url = (
        "https://mathiflo.ew.r.appspot.com/app-version"
        if environment == "prod"
        else "https://mathiflo-dev.ew.r.appspot.com/app-version"
    )
    headers = {os.environ["MATHIFLO_API_KEY_HEADER"]: os.environ["MATHIFLO_API_KEY"]}
    payload = {"app_version": app_version, "code_version": code_version}

    response = requests.put(url, headers=headers, json=payload, timeout=60)
    if response.status_code not in range(200, 300):
        shell_print(
            "[bold red]\nError : Error during update network app version process..."
        )
        shell_print(
            f"[bold red]    {environment} : {response.status_code} => {response.text}\n"
        )


def upgrade_version() -> tuple[str, str]:
    """
    This function increments code version. It returns a tuple :
    - tuple[0] : new app version
    - tuple[1] : new code version
    """
    with open("pubspec.yaml", "r", encoding="UTF-8") as file:
        pubspec_data = yaml.load(file, Loader=yaml.FullLoader)

    app_version, code_version = pubspec_data["version"].split("+")
    new_code_version = str(int(code_version) + 1)
    pubspec_data["version"] = f"{app_version}+{new_code_version}"

    with open("pubspec.yaml", "w", encoding="UTF-8") as file:
        yaml.dump(pubspec_data, file)

    utils.git_commit(
        f"chore: new release --> upgrade code version to {new_code_version}"
    )
    return app_version, new_code_version


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

    utils.set_env_var()
    app_version, code_version = upgrade_version()
    utils.set_config(ENVIRONMENT)
    utils.rename_app_name()
    utils.rename_app_bundle()
    release(app_version, code_version)


if __name__ == "__main__":
    # utils.verify_environment()
    try:
        main()
    except Exception as e:  # pylint: disable=broad-except
        shell_print(f"[bold red]Exit with error : {e}")
    finally:
        shell_print("[bold magenta]Reset using git.")
        utils.git_reset()

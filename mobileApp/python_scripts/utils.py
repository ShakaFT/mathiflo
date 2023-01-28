"""
This module contains util functions.
"""
import json
import os
import plistlib
import subprocess
from typing import Any
from xml.etree import ElementTree as et


def branch_name() -> str:
    """
    This function returns True if your branch is master, else False.
    """
    return __write_in_shell("git symbolic-ref --short HEAD", returned=True)


def committed_directory() -> bool:
    """
    This function returns False if you didn't commit, else return True.
    """
    try:
        # if there is an error, there are no files to commit
        __write_in_shell("git status --porcelain", returned=True)
        return False

    except IndexError:
        return True


def get_environnement() -> str:
    """
    This function returns :
    - 'prod' : if master branch is active.
    - 'dev' : else
    """
    return "prod" if branch_name() == "master" else "dev"


def get_devices() -> list[str]:
    """
    This function returns a list that contains connected devices.
    """
    devices = subprocess.getoutput("flutter devices").split("\n")[2:]
    result = []
    for device in devices:
        splited_device = device.split('•')
        device_name = splited_device[0].strip()
        device_id = splited_device[1].strip()
        result.append(f"{device_name} - {device_id}")

    return result


def push(message: str):
    """
    This functions commits and pushs.
    """
    __write_in_shell(f"git commit -am '{message}'")
    __write_in_shell("git push")


def rename_app():
    """
    This function renames app to "Mathiflo" (production name).
    """
    # Android
    et.register_namespace('android', 'http://schemas.android.com/apk/res/android')
    tree = et.parse("android/app/src/main/AndroidManifest.xml")
    application = tree.getroot().find('application')
    application.attrib['{http://schemas.android.com/apk/res/android}label'] = "Mathiflo"
    tree.write("android/app/src/main/AndroidManifest.xml")

    # IOS
    with open("ios/Runner/Info.plist", "rb") as file:
        ios_config = plistlib.load(file)

    ios_config["CFBundleName"] = "Mathiflo"

    with open("ios/Runner/Info.plist", "wb") as file:
        plistlib.dump(ios_config, file)


def reset():
    """
    This function executes `git reset --hard` command.
    """
    __write_in_shell("git reset --hard")


def run_service(service: str):
    """
    This function sets GAC and executes main.py of selected service.
    """
    root_path = os.path.join(os.path.dirname(__file__), os.pardir)
    commands = [
        f"GOOGLE_APPLICATION_CREDENTIALS={root_path}/services/credentials.json",
        f"python services/{service}/main.py"
    ]
    subprocess.call(" ".join(commands), shell=True)


def set_config(environnement: str):
    """
    This function sets lib/config.json file.
    """
    flutter_config_path = "assets/config/config.json"
    python_config_path = "python_scripts/config.json"

    with open(python_config_path, "r", encoding="UTF-8") as file:
        python_config = json.load(file)

    with open(flutter_config_path, "w", encoding="UTF-8") as file:
        json.dump(python_config[environnement], file)


def verify_environment():
    """
    This function verifies if your environment is ready to deploy,
    else raise SystemError.
    """
    if not committed_directory():
        raise SystemExit("Exit : Uncomitted changes in the repository.")


def __write_in_shell(command_line: str, returned: bool = False, split: bool = True) -> Any | None:
    # sourcery skip: move-assign
    """
    This function executes the <command_line> in shell.
    If you want the returned value of your command line,
    you can set the 'returned' parameter to True.
    """
    result = os.popen(command_line)
    if returned and split:
        return result.read().split()[0]

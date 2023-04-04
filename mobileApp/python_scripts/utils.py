"""
This module contains util functions.
"""
import json
import plistlib
import subprocess
from xml.etree import ElementTree as et


def branch_name() -> str:
    """
    This function returns current branch name.
    """
    return subprocess.getoutput("git symbolic-ref --short HEAD")


def committed_directory() -> bool:
    """
    This function returns False if you didn't commit, else return True.
    """
    return not subprocess.getoutput("git status --porcelain")


def get_environnement() -> str:
    """
    This function returns :
    - 'prod' : if main branch is active.
    - 'dev' : else
    """
    return "prod" if branch_name() == "main" else "dev"


def get_devices() -> list[str]:
    """
    This function returns a list that contains connected devices.
    """
    devices = subprocess.getoutput("flutter devices").split("\n")[2:]
    result = []
    for device in devices:
        splited_device = device.split("•")
        device_name = splited_device[0].strip()
        device_id = splited_device[1].strip()
        result.append(f"{device_name} - {device_id}")

    return result


def push(message: str):
    """
    This functions commits and pushs.
    """
    subprocess.call(f"git commit -am '{message}'", shell=True)
    subprocess.call("git push", shell=True)


def rename_app():
    """
    This function renames app to "Mathiflo" (production name).
    """
    # Android
    et.register_namespace("android", "http://schemas.android.com/apk/res/android")
    tree = et.parse("android/app/src/main/AndroidManifest.xml")
    application = tree.getroot().find("application")
    application.attrib[  # type: ignore
        "{http://schemas.android.com/apk/res/android}label"
    ] = "Mathiflo"
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
    subprocess.call("git reset --hard", shell=True)


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

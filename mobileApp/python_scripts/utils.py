"""
This module contains util functions used by Python scripts.
"""
import json
import os
import subprocess


def get_environnement() -> str:
    """
    This function returns :
    - 'prod' : if main branch is active.
    - 'dev' : else
    """
    return (
        "prod"
        if subprocess.getoutput("git symbolic-ref --short HEAD") == "main"
        else "dev"
    )


def git_cancel_commits(number_commits: int):
    """
    This function cancel last {number_commits} commits.
    """
    subprocess.call(f"git reset HEAD~{number_commits}", shell=True)


def git_commit(message: str):
    """
    This function executes git commit.
    """
    subprocess.call(f"git commit -am '{message}'", shell=True)


def git_push():
    """
    This function executes git push.
    """
    subprocess.call("git push", shell=True)


def git_reset():
    """
    This function executes `git reset --hard` command.
    """
    subprocess.call("git reset --hard", shell=True)


def rename_app_bundle():
    """
    This function renames app bundle to "com.mathiflo" (production name).
    """
    dev_bundle = "com.mathiflo.dev"
    prod_bundle = "com.mathiflo"
    file_to_rename = [
        "android/app/src/debug/AndroidManifest.xml",  # Android
        "android/app/src/main/AndroidManifest.xml",  # Android
        "android/app/src/profile/AndroidManifest.xml",  # Android
        "android/app/src/main/kotlin/com/mathiflo/MainActivity.kt",  # Android
        "android/app/build.gradle",  # Android
    ]
    for file in file_to_rename:
        replace_file_string(dev_bundle, prod_bundle, file)


def rename_app_name():
    """
    This function renames app name to "Mathiflo" (production name).
    """
    # Android
    replace_file_string(
        "Mathiflo-dev", "Mathiflo", "android/app/src/main/AndroidManifest.xml"
    )

    # IOS
    replace_file_string("Mathiflo-dev", "Mathiflo", "ios/Runner/Info.plist")

    # Web
    replace_file_string("Mathiflo-dev", "Mathiflo", "web/index.html")


def replace_file_string(old_string: str, new_string: str, file_path: str):
    """
    This function replaces string in file.
    """
    current_directory = os.getcwd()
    splitted_path = file_path.split("/")

    if len(splitted_path) > 1:
        os.chdir("/".join(splitted_path[:-1]))
    subprocess.call(
        f"sed -i '' s/{old_string}/{new_string}/ {splitted_path[-1]}", shell=True
    )

    os.chdir(current_directory)


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
    if subprocess.getoutput("git status --porcelain"):
        raise SystemExit("Exit : Uncomitted changes in the repository.")

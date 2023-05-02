"""
This module contains util functions.
"""
import json
import os
import subprocess


def environment() -> str:
    """
    This function returns :
    - 'prod' : if `main` branch is active.
    - 'dev' : else
    """
    return (
        "prod"
        if subprocess.getoutput("git symbolic-ref --short HEAD") == "main"
        else "dev"
    )


def get_services() -> list[str]:
    """
    This function returns a list that contains services.
    """
    return sorted(next(os.walk("services"))[1])


def git_reset():
    """
    This function executes `git reset --hard` command.
    """
    subprocess.call("git reset --hard", shell=True)


def set_env_var(environment: str):
    """
    This function sets the environment variables of deployment environment.
    """
    config_path = os.path.join(
        os.path.dirname(__file__),
        os.pardir,
        "services/deploy_config.json",
    )

    with open(config_path, encoding="UTF-8") as file:
        config_variables: dict = json.load(file)
    project_config: dict = config_variables.get(environment, config_variables["dev"])

    for env_var_name, env_var_value in project_config.items():
        if env_var_name == "GOOGLE_APPLICATION_CREDENTIALS":
            os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = os.environ[env_var_value]
        else:
            os.environ[env_var_name] = env_var_value


def set_project():
    """
    This function sets gcloud project.
    """
    subprocess.call(
        f"gcloud config set project {os.environ['GCP_PROJECT']}",
        shell=True,
        stderr=subprocess.DEVNULL,
    )


def verify_environment():
    """
    This function verifies if your environment is ready to deploy.
    """
    if subprocess.getoutput("git status --porcelain"):
        raise SystemExit("Exit : Uncomitted changes in the repository.")

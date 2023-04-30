"""
This module contains main endpoints of default services.
"""
import os

from dotenv import load_dotenv

load_dotenv()

from restAPI.config import create_app


app = create_app(
    __name__, os.environ["MATHIFLO_API_KEY_HEADER"], os.environ["MATHIFLO_API_KEY"]
)


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

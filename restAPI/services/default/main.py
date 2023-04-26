"""
This module contains main endpoints of default services.
"""
from restAPI.config import create_app


app = create_app(__name__)


if __name__ == "__main__":
    app.run(host="localhost", port=8080, debug=True)

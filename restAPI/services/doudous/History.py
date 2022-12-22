"""
This module contains History class.
"""
from typing import Optional
from firebase_admin import firestore

import constants
from FirestoreManager import fclient

class History:
    """
    This class represents an history.
    """

    def __init__(self, history_data:dict):
        """
        This method creates an instance of an History object.
        Raises : \n
        - KeyError : if missing key in history_data.
        - TypeError : if some types are not respected.
        """
        self.history_data = self.__verify_history_data(history_data)

    @staticmethod
    def get_latest_history(nb_night:Optional[int] = constants.LIMIT_NIGHT_IN_A_ROW):
        """
        This method returns a list that contains the <LIMIT_NIGHT_IN_A_ROW> latest history.
        """
        # pylint: disable=no-member
        query = fclient.history.order_by("date", direction=firestore.Query.DESCENDING) \
            .limit(nb_night).stream()
        return [ History(doc.to_dict()) for doc in query ]

    @property
    def florent(self):
        """
        This method returns a list that contains which contains
        the cuddly toys with which Florent has sleeped this night.
        """
        cuddly_toys = self.history_data["cuddly_toys"]
        return [cuddly_toy_id for cuddly_toy_id, human in cuddly_toys.items() if human == "Florent"]

    @property
    def mathilde(self):
        """
        This method returns a list that contains which contains
        the cuddly toys with which Mathilde has sleeped this night.
        """
        cuddly_toys = self.history_data["cuddly_toys"]
        return [cuddly_toy_id for cuddly_toy_id, human in cuddly_toys.items() if human == "Mathilde"]

    def add_database(self):
        """
        This method adds history in database
        """
        fclient.history.add(self.history_data)

    def to_dict(self) -> dict:
        """
        This method returns a dict that represents the history information.
        """
        cuddly_toy = fclient.get_cuddly_toys_name()
        cuddly_toys = { cuddly_toy[cuddly_toy_id]: human for cuddly_toy_id, human in self.history_data["cuddly_toys"].items() }
        return {
            "date": self.history_data["date"],
            "cuddly_toys": cuddly_toys
        }

    def __verify_history_data(self, history_data:dict) -> dict:
        cuddly_toys = history_data["cuddly_toys"]

        for cuddly_toy_id, human in cuddly_toys.items():
            if not isinstance(cuddly_toy_id, str):
                raise TypeError("keys of cuddly_toys should be str.")
            if human != "Florent" and human != "Mathilde":
                raise ValueError("human should be 'Florent' or 'Mathilde'.")

        if "date" not in history_data:
            history_data["date"] = firestore.SERVER_TIMESTAMP # pylint: disable=no-member

        return history_data

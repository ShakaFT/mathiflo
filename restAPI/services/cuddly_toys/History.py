"""
This module contains History class.
"""
from collections import defaultdict

import random
from time import time
from typing import Any

from firebase_admin import firestore

import constants

from restAPI.FirestoreClient import FirestoreClient

# from FirestoreClient import database


class History:
    """
    This class represents an history.
    """

    def __init__(
        self,
        database: FirestoreClient,
        history_data: dict[str, Any],
        history_token: str | None = None,
    ):
        """
        This method creates an instance of an History object.
        """
        self.__check_data(history_data)
        self.__database = database
        self.__history_data = history_data
        self.__history_token = history_token

    @classmethod
    def from_token(cls, database: FirestoreClient, token: str | None = None):
        """
        This method creates an instance of history from token.
        Raises :
        - TypeError if token is invalid.
        """
        query = (
            database.collection(constants.COLLECTION_HISTORY)
            .order_by("timestamp", direction=firestore.Query.DESCENDING)  # type: ignore
            .limit(1)
        )

        if token:
            snapshot = database.document(constants.COLLECTION_HISTORY, token).get()
            query = query.start_after(snapshot)

        latest_history = next(query.stream())
        return cls(database, latest_history.to_dict() or {}, latest_history.id)

    @classmethod
    def new_night(cls, database: FirestoreClient):
        """
        This method creates an instance by generation a new night.
        """
        florent, mathilde = cls.__get_obligation(database)
        florent, mathilde = cls.__generate_night(database, florent, mathilde)
        florent, mathilde = cls.__Bukowski_Martha(florent, mathilde)
        return cls(
            database,
            {"Florent": florent, "Mathilde": mathilde, "timestamp": int(time())},
        )

    @property
    def florent(self) -> list[str]:
        """
        This method returns a list that contains the cuddly
        toys with which Florent has sleeped this night.
        """
        return self.__history_data["Florent"]

    @property
    def mathilde(self) -> list[str]:
        """
        This method returns a list that contains the cuddly
        toys with which Mathilde has sleeped this night.
        """
        return self.__history_data["Mathilde"]

    @property
    def timestamp(self) -> int:
        """
        This method returns timestamp.
        """
        return self.__history_data["timestamp"]

    def update_database(self):
        """
        This method adds history in database.
        """
        if self.__history_token:
            self.__database.update(
                constants.COLLECTION_HISTORY, self.__history_token, self.__history_data
            )
        else:
            self.__database.collection(constants.COLLECTION_HISTORY).add(
                self.__history_data
            )

    def to_dict(self) -> dict[str, Any]:
        """
        This method returns a dict that represents the history information.
        """
        snapshot = self.__database.document(
            constants.COLLECTION_HISTORY, self.__history_token  # type: ignore
        ).get()
        query = (
            self.__database.collection(constants.COLLECTION_HISTORY)
            .order_by("timestamp", direction=firestore.Query.DESCENDING)  # type: ignore
            .limit(1)
            .start_after(snapshot)
        )

        for _ in query.stream():
            has_more = True
            break
        else:
            has_more = False

        return {
            "Florent": self.florent,
            "hasMore": has_more,
            "Mathilde": self.mathilde,
            "timestamp": self.timestamp,
            "token": self.__history_token,
        }

    @staticmethod
    def __Bukowski_Martha(
        florent: list[str], mathilde: list[str]
    ) -> tuple[list[str], list[str]]:
        """
        This static method reorders night because Bukowski
        can only sleep with Martha unkess Bukowski or Martha
        is alone with a human.
        """
        if (
            # Bukowski or Martha sleeps alone with Florent
            (len(florent) == 1 and florent[0] in ["Bukowski", "Martha"])
            # Bukowski or Martha sleeps alone with Mathilde
            or (len(mathilde) == 1 and mathilde[0] in ["Bukowski", "Martha"])
            # Bukowski and Martha sleeps with Florent
            or ("Bukowski" in florent and "Martha" in florent)
            # Bukowski and Martha sleeps with Mathilde
            or ("Bukowski" in mathilde and "Martha" in mathilde)
        ):
            return florent, mathilde

        random_human = random.choice(["Florent", "Mathilde"])

        if (len(florent) < len(mathilde)) or (
            len(florent) == len(mathilde) and random_human == "Florent"
        ):
            # Florent sleeps with Bukowski and Martha
            try:
                florent.append(mathilde.pop(mathilde.index("Bukowski")))
            except ValueError:
                # Bukowski isn't in list
                florent.append(mathilde.pop(mathilde.index("Martha")))
        else:
            # Mathilde sleeps with Bukowski and Martha
            try:
                mathilde.append(florent.pop(florent.index("Bukowski")))
            except ValueError:
                # Bukowski isn't in list
                mathilde.append(florent.pop(florent.index("Martha")))

        return florent, mathilde

    @staticmethod
    def __generate_night(
        database: FirestoreClient, florent: list[str], mathilde: list[str]
    ) -> tuple[list[str], list[str]]:
        """
        This static method fills florent mathilde lists.
        """
        cuddly_toys_data = database.get(
            constants.COLLECTION_CUDDLY_TOYS, constants.DOCUMENT_CUDDLY_TOYS
        )

        if not cuddly_toys_data:
            raise ValueError("Missing cuddly toys from database.")

        cuddly_toys = cuddly_toys_data["cuddly_toys"]

        mathilde_min = len(mathilde) if mathilde else 1
        mathilde_max = (
            len(cuddly_toys) - len(florent) if florent else len(cuddly_toys) - 1
        )

        mathilde_nb_cuddly_toys = random.randint(mathilde_min, mathilde_max)

        random.shuffle(cuddly_toys)
        while cuddly_toys:
            cuddly_toy = cuddly_toys.pop()
            if cuddly_toy in florent or cuddly_toy in mathilde:
                # He has already been assigned
                continue

            if len(mathilde) < mathilde_nb_cuddly_toys:
                mathilde.append(cuddly_toy)
            else:
                florent.append(cuddly_toy)

        return florent, mathilde

    @staticmethod
    def __get_latest_histories(database: FirestoreClient) -> list:
        """
        This static method returns a list that contains latest history.
        """
        query = (
            database.collection(constants.COLLECTION_HISTORY)
            .order_by("timestamp", direction=firestore.Query.DESCENDING)  # type: ignore
            .limit(constants.LIMIT_NIGHT_IN_A_ROW)
            .stream()
        )
        return [History(database, doc.to_dict() or {}, doc.id) for doc in query]

    @staticmethod
    def __get_obligation(database: FirestoreClient) -> tuple[list[str], list[str]]:
        """
        This method returns a tuple that contains 2 lists :
        - tuple[0] : The cuddly toys that must necessarily sleep with Florent
        - tuple[1] : The cuddly toys that must necessarily sleep with Mathilde
        """
        latest_histories = History.__get_latest_histories(database)

        # Get the number of times we slept with each cuddly toys
        # in latest nights
        florent_counter = defaultdict(int)
        mathilde_counter = defaultdict(int)

        for history in latest_histories:
            for cuddly_toy in history.florent:
                florent_counter[cuddly_toy["name"]] += 1
            for cuddly_toy in history.mathilde:
                mathilde_counter[cuddly_toy["name"]] += 1

        return (
            [
                cuddly_toy
                for cuddly_toy, number in mathilde_counter.items()
                if number == constants.LIMIT_NIGHT_IN_A_ROW
            ],
            [
                cuddly_toy
                for cuddly_toy, number in florent_counter.items()
                if number == constants.LIMIT_NIGHT_IN_A_ROW
            ],
        )

    def __check_data(self, data: dict):
        if "Florent" not in data or "Mathilde" not in data or "timestamp" not in data:
            raise ValueError("Invalid payload")

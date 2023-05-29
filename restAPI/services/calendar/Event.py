"""
This module contains Event class.
"""
from typing import Any

from google.cloud.firestore_v1.base_query import FieldFilter

import constants

from restAPI.FirestoreClient import FirestoreClient


class Event:
    """
    This class represents a calendar event.
    """

    def __init__(
        self, database: FirestoreClient, event_id: str, event_data: dict[str, Any]
    ):
        self.__database = database
        self.__id = event_id
        self.__event__data = {
            "title": str(event_data["title"]),
            "start_timestamp": int(event_data["start_timestamp"]),
            "end_timestamp": int(event_data["end_timestamp"]),
        }

    @classmethod
    def from_database(cls, database: FirestoreClient, event_id: str):
        """
        This method creates an instance of Event by fetching database. \n
        It returns None if there is no event with {event_id}.
        """
        if event_data := database.get(constants.COLLECTION_CALENDAR, event_id):
            return cls(database, event_id, event_data)

    @staticmethod
    def paging_events(
        database: FirestoreClient, start_timestamp: int, end_timestamp: int
    ) -> list[dict[str, Any]]:
        """
        This method returns paging events.
        """
        query = database.collection(constants.COLLECTION_CALENDAR).where(
            filter=FieldFilter("end_timestamp", ">=", start_timestamp)
        )
        return [
            document.to_dict() | {"id": document.id}  # type: ignore
            for document in query.stream()
            if document.to_dict()["start_timestamp"] <= end_timestamp  # type: ignore
        ]

    @property
    def exists(self) -> bool:
        """
        This method returns True if event already exists, else False.
        """
        return self.__database.exists(constants.COLLECTION_CALENDAR, self.__id)

    @property
    def end_timestamp(self) -> int:
        """
        This method returns event end_timestamp.
        """
        return self.__event__data["end_timestamp"]

    @end_timestamp.setter
    def end_timestamp(self, new_end_timestamp: int):
        """
        This function set event end_timestamp to {new_end_timestamp}.
        """
        self.__event__data["end_timestamp"] = new_end_timestamp

    @property
    def start_timestamp(self) -> int:
        """
        This method returns event start_timestamp.
        """
        return self.__event__data["start_timestamp"]

    @start_timestamp.setter
    def start_timestamp(self, new_start_timestamp: int):
        """
        This function set event start_timestamp to {new_start_timestamp}.
        """
        self.__event__data["start_timestamp"] = new_start_timestamp

    @property
    def title(self) -> str:
        """
        This method returns event title.
        """
        return self.__event__data["title"]

    @title.setter
    def title(self, new_title: str):
        """
        This function set event title to {new_title}.
        """
        self.__event__data["title"] = new_title

    def delete(self):
        """
        This method deletes event from database.
        """
        self.__database.delete(constants.COLLECTION_CALENDAR, self.__id)

    def update_database(self):
        """
        This method updates event from database.
        """
        self.__database.update(
            constants.COLLECTION_CALENDAR, self.__id, self.__event__data
        )

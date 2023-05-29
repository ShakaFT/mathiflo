"""
This module contains Item class.
"""
from typing import Any

from google.cloud.firestore_v1.base_query import FieldFilter

import constants

from restAPI.FirestoreClient import FirestoreClient


class Item:
    """
    This class represents a Groceries Item.
    """

    def __init__(
        self, database: FirestoreClient, item_id: str, item_data: dict[str, Any]
    ):
        self.__database = database
        self.__id = item_id
        self.__item__data = {
            "name": str(item_data["name"]),
            "quantity": int(item_data["quantity"]),
        }

    @classmethod
    def from_database(cls, database: FirestoreClient, item_id: str):
        """
        This method creates an instance of Item by fetching database. \n
        It returns None if there is no item with {item_id}.
        """
        if item_data := database.get(constants.COLLECTION_GROCERIES, item_id):
            return cls(database, item_id, item_data)

    @staticmethod
    def delete_all(database: FirestoreClient):
        """
        This method deletes all groceries items from database.
        """
        for document in database.collection(constants.COLLECTION_GROCERIES).stream():
            document.reference.delete()

    @staticmethod
    def groceries_items(database: FirestoreClient) -> list[dict[str, Any]]:
        """
        This method returns the list of groceries items.
        """
        return [
            (item.to_dict() or {}) | {"id": item.id}
            for item in database.collection(constants.COLLECTION_GROCERIES).stream()
        ]

    @property
    def exists(self) -> bool:
        """
        This method returns True if item already exists, else False.
        """
        return self.__database.exists(constants.COLLECTION_GROCERIES, self.__id)

    @property
    def equivalent_exists(self) -> bool:
        """
        This method returns True if there is already an item with same name, else False.
        """
        query = self.__database.collection(constants.COLLECTION_GROCERIES).where(
            filter=FieldFilter("name", "==", self.name)
        )
        return next(query.stream(), None) is not None

    @property
    def name(self) -> str:
        """
        This method returns item name.
        """
        return self.__item__data["name"]

    @name.setter
    def name(self, new_name: str):
        """
        This function set item name to {new_name}.
        """
        self.__item__data["name"] = new_name

    @property
    def quantity(self) -> int:
        """
        This method returns item quantity.
        """
        return self.__item__data["quantity"]

    @quantity.setter
    def quantity(self, new_quantity: int):
        """
        This function set item quantity to {new_quantity}.
        """
        self.__item__data["quantity"] = new_quantity

    def delete(self):
        """
        This method deletes item from database.
        """
        self.__database.delete(constants.COLLECTION_GROCERIES, self.__id)

    def update_database(self):
        """
        This method updates item from database.
        """
        self.__database.update(
            constants.COLLECTION_GROCERIES, self.__id, self.__item__data
        )

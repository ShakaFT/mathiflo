"""
This module contains instance of database.
"""
from firebase_admin import initialize_app
from google.cloud import firestore_v1

import constants


class FirestoreClient(firestore_v1.client.Client): # type: ignore
    """
    This class allows to use utils methods to interact with Firestore.
    """

    @staticmethod
    def start():
        """
        This method initializes and returns an instance of database.
        """
        initialize_app()
        return FirestoreClient()

    def __init__(self):
        firestore_v1.client.Client.__init__(self) # type: ignore

    @property
    def groceries(self):
        """
        This method return an instance of groceries_list document.
        """
        return self.collection(constants.COLLECTION_GROCERIES)

    def groceries_item_exists(self, name: str) -> bool:
        """
        This method return True if there is already an item
        with this name, else False.
        """
        query = self.groceries.where("name", "==", name).stream()
        for _ in query:
            return True
        return False


database = FirestoreClient.start()

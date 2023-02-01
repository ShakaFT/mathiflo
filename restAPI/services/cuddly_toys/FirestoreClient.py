"""
This module contains instance of database.
"""
from firebase_admin import initialize_app
from google.cloud import firestore_v1

import constants


class FirestoreClient(firestore_v1.client.Client):
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
        firestore_v1.client.Client.__init__(self)

    @property
    def cuddly_toys(self) -> list[str]:
        """
        This method returns cuddly toys list from database.
        """
        return (
            self.document(
                constants.COLLECTION_CUDDLY_TOYS, constants.DOCUMENT_CUDDLY_TOYS
            )
            .get()
            .to_dict()["cuddly_toys"]
        )

    @property
    def history(self):
        """
        This method returns the cuddly_toys_history Firestore collection.
        """
        return self.collection(constants.COLLECTION_HISTORY)


database = FirestoreClient.start()

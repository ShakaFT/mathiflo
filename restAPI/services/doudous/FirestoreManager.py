"""
This module contains FirestoreManager class.
"""
import os

from firebase_admin import credentials, firestore, initialize_app

import constants

class FirestoreManager:
    """
    This class allows to interact with Firestore.
    """
    __path_cred = os.path.join(__file__, os.pardir, os.pardir, "keys/discord-368718-f2cfa77c9439.json")

    def __init__(self):
        if os.getenv('GAE_ENV', '').startswith('standard'):
            # Production in the standard environment
            initialize_app()
        else:
            # Local development server
            cred = credentials.Certificate(self.__path_cred)
            initialize_app(cred)

        self.client = firestore.client()

    def __collection(self, collection_name:str):
        return self.client.collection(collection_name)

    @property
    def cuddly_toys(self):
        """
        This method returns Firestore collection cuddly_toys.
        """
        return self.__collection(constants.COLLECTION_CUDDLY_TOYS)

    @property
    def history(self):
        """
        This method returns the Firestore collection history.
        """
        return self.__collection(constants.COLLECTION_HISTORY)

    @property
    def cuddly_toys_total_number(self):
        """
        This method returns the number of teddy.
        """
        list_cuddly_teddy = self.cuddly_toys.get()
        return len(list_cuddly_teddy)

    def get_cuddly_toys_dict(self) -> dict:
        """
        This method returns a dict that contains cuddly toys.
        """
        docs = self.cuddly_toys.stream()
        return { doc.id: doc.to_dict() for doc in docs }

    def get_cuddly_toys_name(self) -> dict:
        """
        This method returns a dict that contains the cuddly toys id in key and the name in value.
        """
        stream = self.cuddly_toys.stream()
        return { doc.id: doc.to_dict()["name"] for doc in stream }

fclient = FirestoreManager()

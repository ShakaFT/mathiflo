"""
This module contains FirestoreManager class.
"""
import os

from firebase_admin import credentials, firestore, initialize_app


class FirestoreManager:
    """
    This class allows to interact with Firestore.
    """
    __path_cred = os.path.join(os.path.dirname(os.path.realpath(__file__)), "keys/discord-368718-f2cfa77c9439.json")

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
    def groceries(self):
        """
        This method returns Firestore collection groceries.
        """
        return self.__collection("groceries")


fclient = FirestoreManager()

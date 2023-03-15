"""
This module creates a backup of database (fix Fastlane bug).
"""
import firebase_admin
from firebase_admin import credentials, firestore
from pick import pick

credentials = credentials.Certificate("python_scripts/credentials.json")
app = firebase_admin.initialize_app(credentials)
database = firestore.client(app=app)

_, index = pick(["Create backup", "Restore backup"])

match index:
    case 0:
        if database.document("groceries_backup", "groceries_list").get().exists:
            raise SystemError("There is already a backup.")

        groceries = database.document("groceries", "groceries_list").get().to_dict()
        database.collection("groceries_backup").document("groceries_list").set(groceries)
        database.document("groceries", "groceries_list").delete()

    case 1:
        if not database.document("groceries_backup", "groceries_list").get().exists:
            raise SystemError("There is no backup to restore.")

        groceries_backup = database.document("groceries_backup", "groceries_list").get().to_dict()
        database.document("groceries", "groceries_list").set(groceries_backup)
        database.document("groceries_backup", "groceries_list").delete()

    case _:
        raise SystemError(f"Unknown choice number {index}")

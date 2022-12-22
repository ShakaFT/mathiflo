"""
This module contains CuddlyToy class.
"""
import random

import constants
from FirestoreManager import fclient
from History import History

class CuddlyToys:
    """
    This class represents cuddly toys.
    """

    def __init__(self):
        """
        This method creates an instance of CuddlyToys object.
        """
        self.__cuddly_toys = fclient.get_cuddly_toys_dict()
        self.__new_night = None

    def add_history(self):
        """
        This method adds history to database.
        """
        history = History({"cuddly_toys": self.__new_night})
        history.add_database()

    def new_night(self):
        """
        This method chooses which cuddly toy will sleep with which human.
        """
        obligation_dict = self.__get_obligation_dict()
        cuddly_toys_number = self.__get_cuddly_toys_number(obligation_dict)
        self.__new_night = self.__get_final_sleep_dict(obligation_dict, cuddly_toys_number)

    def to_dict(self):
        """
        This method returns a dict with this format : \n
        { \n
            <cuddly_toy_id>: { \n
                { \n
                    "name": <name>, \n
                    "human": <human> \n
                } \n
            } \n
        }
        """
        result = {}
        for cuddly_toy_id, cuddly_toy_data in self.__cuddly_toys.items():
            result[cuddly_toy_id] = {
                "name": cuddly_toy_data["name"],
                "human": self.__new_night[cuddly_toy_id]
            }

        return result

    def __get_obligation_dict(self):
        """
        This function returns a dict : \n
        - Keys : The cuddly toys id that must skeep with "Florent" or "Mathilde"
        - Values : "Florent" or "Mathilde"
        """
        florent_counter = {}
        mathilde_counter = {}
        obligation_dict = {}

        latest_history = History.get_latest_history()
        print(f"latest : {latest_history}")
        # initilization of counter dictionaries
        for cuddly_toy_id in self.__cuddly_toys:
            florent_counter[cuddly_toy_id] = 0
            mathilde_counter[cuddly_toy_id] = 0

        # filling of dictionaries
        for history in latest_history:
            # filling florent_counter
            for cuddly_toy_id in history.florent:
                florent_counter[cuddly_toy_id] += 1
            # filling mathilde_counter
            for cuddly_toy_id in history.mathilde:
                mathilde_counter[cuddly_toy_id] += 1
        print(f"counter flo : {florent_counter}")
        print(f"counter math : {mathilde_counter}")
        # filling obligation_dict
        for cuddly_toy_id, counter in florent_counter.items():
            if counter == constants.LIMIT_NIGHT_IN_A_ROW:
                # Florent must sleep with this cuddly_toy because he has sleeped 0 time
                obligation_dict[cuddly_toy_id] = "Mathilde"

        for cuddly_toy_id, counter in mathilde_counter.items():
            if counter == constants.LIMIT_NIGHT_IN_A_ROW:
                # Mathilde must sleep with this cuddly_toy because he has sleeped 0 time
                obligation_dict[cuddly_toy_id] = "Florent"

        return obligation_dict

    def __get_cuddly_toys_number(self, obligation_dict:dict) -> dict:
        """
        This function returns a dict that contains 2 keys :
        - Florent
        - Mathilde \n
        The values represents the number of cuddly toys per person. \n
        The sum of the 2 values is equal to the total number of cuddly toys.
        """
        florent_min = 0
        mathilde_min = 0
        print(f"o : {obligation_dict}")
        for human in obligation_dict.values():
            if human == "Florent":
                florent_min += 1
            if human == "Mathilde":
                mathilde_min += 1

        cuddly_toys_total_number = fclient.cuddly_toys_total_number

        # it's impossible to sleep with 0 cuddly toy.
        if florent_min == 0:
            florent_min = 1
        if mathilde_min == 0:
            mathilde_min = 1

        print(f" a : {mathilde_min}")
        print(f" b : {cuddly_toys_total_number}")
        print(f" c : {florent_min}")
        cuddly_toys_random_number = random.randint(mathilde_min, cuddly_toys_total_number - florent_min)
        return {
            "Florent": cuddly_toys_total_number - cuddly_toys_random_number,
            "Mathilde": cuddly_toys_random_number
        }

    def __get_final_sleep_dict(self, obligation_dict:dict, cuddly_toys_number:dict) -> dict:
        """
        This function returns a dict. The keys represent the cuddly toys id.
        The values are the human with which they are going to sleep.
        """
        cuddly_toys_id = fclient.get_cuddly_toys_dict()
        human_counter = {"Florent": 0, "Mathilde": 0}

        for cuddly_toy_id, human in obligation_dict.items():
            cuddly_toys_id.pop(cuddly_toy_id)
            human_counter[human] += 1

        list_cuddly_toys_id = list(cuddly_toys_id)

        for cuddly_toy_id in list_cuddly_toys_id:
            if human_counter["Florent"] == cuddly_toys_number["Florent"]:
                human = "Mathilde"
            elif human_counter["Mathilde"] == cuddly_toys_number["Mathilde"]:
                human = "Florent"
            else:
                human = random.choice(["Florent", "Mathilde"])

            obligation_dict[cuddly_toy_id] = human
            human_counter[human] += 1

        return obligation_dict

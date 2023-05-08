import 'package:flutter/material.dart';

const users = {
  "Florent": {"color": Colors.purple},
  "Mathilde": {"color": Colors.amber}
};

const int apiTimeout = 300;
const String unknownError =
    "Une erreur inconnue est survenue... Vérifie ta connexion internet.";

final Color mainColor = Colors.orange.shade700;
const Color errorColor = Colors.red;
final Color popupColor = Colors.grey.shade600;
const Color textColor = Colors.white;

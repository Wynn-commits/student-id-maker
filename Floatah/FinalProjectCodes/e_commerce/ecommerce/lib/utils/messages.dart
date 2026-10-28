import 'package:flutter/material.dart';

/// Shows a short snackbar message (replaces any message already showing).
void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

import 'package:flutter/material.dart';

// ignore: no_logic_in_create_state
class ConfirmActionWidget extends StatefulWidget {
  final String title;
  final String message;
  final String? confirmButtonText;
  final String cancelButtonText;

  const ConfirmActionWidget(
      {Key? key,
      this.confirmButtonText,
      required this.title,
      required this.message,
      required this.cancelButtonText})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConfirmActionWidgetState createState() => _ConfirmActionWidgetState();
}

class _ConfirmActionWidgetState extends State<ConfirmActionWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(widget.cancelButtonText),
        ),
        widget.confirmButtonText == null
            ? SizedBox.shrink()
            : ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(widget.confirmButtonText!),
              )
      ],
    );
  }
}

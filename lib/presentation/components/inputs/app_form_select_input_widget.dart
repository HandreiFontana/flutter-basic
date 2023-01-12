import 'package:basic/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// ignore: must_be_immutable
class FormSelectInput extends StatefulWidget {
  FormSelectInput({
    super.key,
    required this.label,
    required this.authDataValue,
    required this.authDateLabel,
    this.hintText,
    required this.controllerValue,
    required this.controllerLabel,
    required this.itemsCallback,
    required this.onSaved,
    this.clear,
    this.isVisible,
    this.isRequired,
    this.isDisabled,
  });

  final String label;
  final String authDataValue;
  final String authDateLabel;
  final String? hintText;
  final TextEditingController controllerValue;
  final TextEditingController controllerLabel;
  final Future<Iterable<Map<String, String>>> Function(String value) itemsCallback;
  final Function(
    String value,
    String label,
    TextEditingController controllerValue,
    TextEditingController controllerLabel,
    Map<String, String> suggestion,
  ) onSaved;
  bool? clear = false;
  final bool? isVisible;
  final bool? isRequired;
  final bool? isDisabled;

  @override
  State<FormSelectInput> createState() => _FormSelectInputState();
}

class _FormSelectInputState extends State<FormSelectInput> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible ?? true,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 4.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: AppColors.cardColor,
                      fontSize: 14,
                    ),
                  ),
                  widget.isRequired ?? false
                      ? Text(
                          ' *',
                          style: TextStyle(
                            color: AppColors.delete,
                            fontSize: 14,
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            SizedBox(
              height: 55,
              child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    suffixIcon: widget.clear ?? false
                        ? IconButton(
                            onPressed: () {
                              widget.onSaved(
                                widget.authDataValue,
                                widget.authDateLabel,
                                widget.controllerValue,
                                widget.controllerLabel,
                                <String, String>{
                                  'label': '',
                                  'value': '',
                                },
                              );
                            },
                            icon: Icon(Icons.close),
                          )
                        : null,
                  ),
                  controller: widget.controllerLabel,
                  enabled: widget.isDisabled != null ? !widget.isDisabled! : true,
                ),
                suggestionsCallback: (pattern) async => widget.itemsCallback(pattern),
                itemBuilder: (context, Map<String, String> suggestion) {
                  return ListTile(
                    title: Text(suggestion['label']!),
                  );
                },
                onSuggestionSelected: (Map<String, String> suggestion) => widget.onSaved(
                  widget.authDataValue,
                  widget.authDateLabel,
                  widget.controllerValue,
                  widget.controllerLabel,
                  suggestion,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

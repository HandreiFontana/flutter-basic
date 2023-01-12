import 'package:basic/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormTextInput extends StatefulWidget {
  const FormTextInput({
    super.key,
    required this.campo,
    required this.label,
    required this.controller,
    required this.onSaved,
    this.isVisible,
    this.isDisabled,
    this.onChanged,
    this.isRequired,
    this.inputFormatters,
    this.validator,
    this.keyboardType,
  });

  final String campo;
  final String label;
  final TextEditingController controller;
  final Function(String value)? onChanged;
  final Function(String campo, String? value) onSaved;
  final bool? isVisible;
  final bool? isDisabled;
  final bool? isRequired;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String val)? validator;
  final TextInputType? keyboardType;

  @override
  State<FormTextInput> createState() => _FormTextInputState();
}

class _FormTextInputState extends State<FormTextInput> {
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
              child: TextFormField(
                keyboardType: widget.keyboardType ?? TextInputType.text,
                enabled: widget.isDisabled != null ? !widget.isDisabled! : true,
                onChanged: (value) {
                  if (widget.onChanged != null) {
                    widget.onChanged!(value);
                  }
                },
                onSaved: (value) => widget.onSaved(widget.campo, value),
                controller: widget.controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
                inputFormatters: widget.inputFormatters,
                validator: (value) {
                  if (widget.validator != null) {
                    return widget.validator!(value ?? '');
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:basic/shared/utils/debouncer.dart';
import 'package:flutter/material.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({super.key, required this.onSearch});

  final void Function(String search) onSearch;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final _formKey = GlobalKey<FormState>();

  final _controller = TextEditingController();
  var _autoValidate = false;

  final _debouncer = Debouncer(milliseconds: 1000);

  void search(String value) {
    _debouncer.run(() {
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        widget.onSearch(value);
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    });
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    _controller.clear();
                    search('');
                  },
                  icon: Icon(Icons.clear),
                ),
                hintText: 'Busca...',
                border: OutlineInputBorder(),
                filled: true,
                errorStyle: TextStyle(fontSize: 15),
              ),
              onChanged: (value) => search(value),
            ),
          ],
        ),
      ),
    );
  }
}

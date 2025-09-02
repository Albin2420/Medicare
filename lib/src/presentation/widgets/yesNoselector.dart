import 'package:flutter/material.dart';

class YesNoSelector extends StatefulWidget {
  final void Function(bool) onChanged;

  const YesNoSelector({super.key, required this.onChanged});

  @override
  _YesNoSelectorState createState() => _YesNoSelectorState();
}

class _YesNoSelectorState extends State<YesNoSelector> {
  String? _selectedOption;

  void _handleChange(String? value) {
    setState(() {
      _selectedOption = value;
    });

    // Return true if value is "Yes" or null (default); otherwise false
    final result = value == null || value == 'Yes';
    widget.onChanged(result);
  }

  @override
  void initState() {
    super.initState();
    _selectedOption = 'Yes'; // ✅ Preselect "Yes"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged(true); // ✅ Trigger initial callback
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ['Yes', 'No'].map((option) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: option,
              groupValue: _selectedOption,
              onChanged: _handleChange,
            ),
            Text(option),
            SizedBox(width: 24),
          ],
        );
      }).toList(),
    );
  }
}

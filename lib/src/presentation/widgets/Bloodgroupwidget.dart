import 'package:flutter/material.dart';

class BloodGroupPicker extends StatefulWidget {
  final ValueChanged<String?> onChanged; // callback for selected value
  final List<String> items;

  const BloodGroupPicker({
    super.key,
    required this.onChanged,
    this.items = const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
  });

  @override
  _BloodGroupPickerState createState() => _BloodGroupPickerState();
}

class _BloodGroupPickerState extends State<BloodGroupPicker> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(45)),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFEBEBEF),
          borderRadius: BorderRadius.circular(45),
        ),
        padding: EdgeInsets.only(left: 22, right: 22),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            value: selectedValue,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, size: 20),
            style: TextStyle(color: Colors.black, fontSize: 16),
            hint: Text('Select an option'),
            items: widget.items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
      ),
    );
  }
}

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class BaseDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hintText;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemToString;

  const BaseDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.hintText,
    required this.onChanged,
    required this.itemToString,
  });

  get hintTextColor => null;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(left: 0, right: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        hint: Text(
          "Select",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.zero,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(Icons.keyboard_arrow_down),
        ),
        menuItemStyleData: const MenuItemStyleData(
          padding: EdgeInsets.symmetric(horizontal: 8),
          height: 36,
        ),
        style: themeData.textTheme.bodyLarge,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Container(
              padding: EdgeInsets.only(left: 4, top: 8, bottom: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: value == item ? Colors.grey.shade200 : Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                itemToString(item),
                style: themeData.textTheme.titleSmall,
              ),
            ),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return items.map((item) {
            return Text(
              itemToString(item),
              style: themeData.textTheme.titleSmall,
            );
          }).toList();
        },
        onChanged: onChanged,
      ),
    );
  }
}

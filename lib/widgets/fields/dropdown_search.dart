import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:turoudi/app_styles.dart';
import 'package:turoudi/generated/l10n.dart';

class DropdownSerach extends StatelessWidget {
  final String labelText;
  final String? selectedValue;
  final bool isEditMode;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final Future<List<String>>? futureItems;
  final bool displaySearch; // New flag to control search display
  final VoidCallback? onClear; // Add onClear callback for clearing the value
  final bool forceLTR; // New flag to force LTR direction
  final double maxHeight;

  const DropdownSerach({
    super.key,
    required this.labelText,
    required this.selectedValue,
    required this.isEditMode,
    required this.onChanged,
    required this.items,
    this.futureItems,
    this.displaySearch = true, // Default to true for showing search box
    this.onClear, // Add onClear callback
    this.forceLTR = false, // Default to false
    this.maxHeight = 300,
  });

  @override
  Widget build(BuildContext context) {
    final tr = S.of(context);

    return Row(
      children: [
        Expanded(
          child: futureItems != null
              ? FutureBuilder<List<String>>(
                  future: futureItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppStyles.primaryColor,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Error loading data'),
                      );
                    }
                    List<String> loadedItems = snapshot.data ?? [];
                    return _buildDropdownSearch(loadedItems, context);
                  },
                )
              : _buildDropdownSearch(items, context),
        ),
        if (selectedValue != null && selectedValue!.isNotEmpty)
          IconButton(
            icon: Icon(Icons.clear, color: AppStyles.unSelectedColor),
            onPressed: onClear, // Call the onClear callback
            tooltip: tr.clear_selection,
          ),
      ],
    );
  }

  Widget _buildDropdownSearch(
      List<String> dropdownItems, BuildContext context) {
    final tr = S.of(context);

    return Directionality(
      textDirection: forceLTR ? TextDirection.ltr : TextDirection.rtl,
      child: DropdownSearch<String>(
        items: dropdownItems,
        selectedItem: selectedValue,
        enabled: isEditMode,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(
              color: Theme.of(context).textTheme.labelLarge?.color,
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppStyles.primaryColor),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: AppStyles.primaryColor,
                )),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
        onChanged: onChanged,
        popupProps: PopupProps.menu(
          showSearchBox: displaySearch,
          fit: FlexFit.loose,
          constraints: BoxConstraints(
            maxHeight: maxHeight, // 👈 Set desired height of dropdown menu
          ),
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: tr.general_serach_hint,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue.shade300, width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
          ),
        ),
      ),
    );
  }
}

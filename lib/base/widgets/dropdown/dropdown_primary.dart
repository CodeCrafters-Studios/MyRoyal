import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';

class DropDownPrimary extends StatelessWidget {
  const DropDownPrimary({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    this.icon,
    this.borderColor,
    this.hintTextStyle,
    this.enabled = true,
    required this.items,
    required this.onChanged,
    this.searchable = false,
    this.searchHintText = 'Cari',
  });

  final String label;
  final String hintText;
  final String? value;
  final Widget? icon;
  final Color? borderColor;
  final TextStyle? hintTextStyle;
  final bool enabled;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;
  final bool searchable;
  final String searchHintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.isEmpty
            ? emptyBox
            : Text(
                label,
                style: TS.labelLarge,
              ),
        4.verticalSpace,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor ?? grey),
            color: white,
          ),
          child: searchable
              ? InkWell(
                  onTap: enabled ? () => _showSearchableMenu(context) : null,
                  child: _buildSelectedValue(),
                )
              : DropdownButtonHideUnderline(
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      disabledColor: enabled ? null : Colors.black,
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      icon: icon,
                      iconDisabledColor: Colors.black,
                      alignment: Alignment.centerLeft,
                      dropdownColor: white,
                      style: const TextStyle(color: Colors.black),
                      items: items,
                      selectedItemBuilder: (context) =>
                          (items ?? const []).map((item) {
                        final child = item.child;
                        if (child is Text) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              child.data ?? '',
                              style: child.style?.copyWith(
                                    color: Colors.black,
                                  ) ??
                                  const TextStyle(color: Colors.black),
                            ),
                          );
                        }
                        return child;
                      }).toList(),
                      hint: Text(
                        hintText,
                        style: hintTextStyle ??
                            TS.bodyMedium.copyWith(
                              color: grey,
                            ),
                      ),
                      value: value,
                      onChanged: enabled ? onChanged : null,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSelectedValue() {
    final selectedItem = items?.firstWhereOrNull((item) => item.value == value);

    final selectedChild = selectedItem?.child;

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: selectedChild is Text
                ? Text(
                    selectedChild.data ?? '',
                    style: selectedChild.style?.copyWith(
                          color: Colors.black,
                        ) ??
                        const TextStyle(
                          color: Colors.black,
                        ),
                  )
                : selectedChild ??
                    Text(
                      hintText,
                      style: hintTextStyle ??
                          TS.bodyMedium.copyWith(
                            color: grey,
                          ),
                    ),
          ),
          IconTheme(
            data: const IconThemeData(
              color: Colors.black,
            ),
            child: icon ??
                const Icon(
                  Icons.arrow_drop_down,
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSearchableMenu(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: white,
      builder: (context) => _SearchableDropdownSheet(
        items: items ?? const [],
        selectedValue: value,
        hintText: searchHintText,
      ),
    );

    if (selected != null) onChanged?.call(selected);
  }
}

class _SearchableDropdownSheet extends StatefulWidget {
  const _SearchableDropdownSheet({
    required this.items,
    required this.selectedValue,
    required this.hintText,
  });

  final List<DropdownMenuItem<String>> items;
  final String? selectedValue;
  final String hintText;

  @override
  State<_SearchableDropdownSheet> createState() =>
      _SearchableDropdownSheetState();
}

class _SearchableDropdownSheetState extends State<_SearchableDropdownSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredItems = widget.items.where((item) {
      final child = item.child;
      final label = child is Text ? child.data ?? '' : item.value ?? '';
      return label.toLowerCase().contains(query);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ListTile(
                    title: item.child,
                    trailing: item.value == widget.selectedValue
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () => Navigator.of(context).pop(item.value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

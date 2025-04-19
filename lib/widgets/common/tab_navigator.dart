import 'package:flutter/material.dart';

/// Widget de navegación por pestañas reutilizable
class TabNavigator extends StatelessWidget {
  final int selectedIndex;
  final List<TabItem> tabs;
  final Function(int) onTabTap;
  final Color? selectedColor;
  final Color? unselectedColor;

  const TabNavigator({
    super.key,
    required this.selectedIndex,
    required this.tabs,
    required this.onTabTap,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedColor ?? Theme.of(context).colorScheme.primary;
    final unselected = unselectedColor ?? Colors.grey;

    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: InkWell(
              onTap: () => onTabTap(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? selected : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tabs[index].icon,
                      color: isSelected ? selected : unselected,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tabs[index].label,
                      style: TextStyle(
                        color: isSelected ? selected : unselected,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Modelo para un elemento de pestaña
class TabItem {
  final String label;
  final IconData icon;

  const TabItem({required this.label, required this.icon});
}

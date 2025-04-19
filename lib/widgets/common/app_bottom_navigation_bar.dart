import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<AppNavigationItem> items;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.selectedItemColor,
    this.unselectedItemColor,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items:
          items
              .map(
                (item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ),
              )
              .toList(),
      currentIndex: currentIndex,
      selectedItemColor:
          selectedItemColor ?? Theme.of(context).colorScheme.primary,
      unselectedItemColor: unselectedItemColor ?? Colors.grey,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
    );
  }
}

class AppNavigationItem {
  final IconData icon;
  final String label;
  final Widget? destination; // La pantalla a la que navegar

  const AppNavigationItem({
    required this.icon,
    required this.label,
    this.destination,
  });
}

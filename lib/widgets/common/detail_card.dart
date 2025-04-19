import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final List<DetailItem> items;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? padding;

  const DetailCard({
    super.key,
    required this.title,
    required this.items,
    this.actions,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            ...items.map((item) => item.build(context)),
          ],
        ),
      ),
      actions:
          actions ??
          [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
    );
  }
}

class DetailItem {
  final IconData? icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  DetailItem({this.icon, required this.title, this.subtitle, this.trailing});

  Widget build(BuildContext context) {
    return ListTile(
      leading: icon != null ? Icon(icon) : null,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
    );
  }
}

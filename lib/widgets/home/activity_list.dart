import 'package:flutter/material.dart';

class ActivityItem {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;

  ActivityItem({
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
  });
}

class ActivityList extends StatelessWidget {
  final List<ActivityItem> activities;
  final Function(ActivityItem) onActivityTap;

  const ActivityList({
    super.key,
    required this.activities,
    required this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: activity.color,
            child: Icon(activity.icon, color: Colors.white),
          ),
          title: Text(activity.title),
          subtitle: Text(activity.description),
          trailing: Text(activity.time),
          onTap: () => onActivityTap(activity),
        );
      },
    );
  }
}

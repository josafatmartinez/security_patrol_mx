import 'package:flutter/material.dart';
import 'action_card.dart';

class AdminActionsGrid extends StatelessWidget {
  final VoidCallback onManageGuards;
  final VoidCallback onConfigureCheckpoints;
  final VoidCallback onViewReports;
  final VoidCallback onViewActivities;
  final VoidCallback onManageUsers;
  final VoidCallback onScheduleRounds;

  const AdminActionsGrid({
    super.key,
    required this.onManageGuards,
    required this.onConfigureCheckpoints,
    required this.onViewReports,
    required this.onViewActivities,
    required this.onManageUsers,
    required this.onScheduleRounds,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        ActionCard(
          title: 'Guardias',
          icon: Icons.security,
          color: Colors.blue,
          onTap: onManageGuards,
        ),
        ActionCard(
          title: 'Checkpoints',
          icon: Icons.location_on,
          color: Colors.orange,
          onTap: onConfigureCheckpoints,
        ),
        ActionCard(
          title: 'Reportes',
          icon: Icons.summarize,
          color: Colors.green,
          onTap: onViewReports,
        ),
        ActionCard(
          title: 'Actividades',
          icon: Icons.history,
          color: Colors.purple,
          onTap: onViewActivities,
        ),
        ActionCard(
          title: 'Usuarios',
          icon: Icons.people,
          color: Colors.indigo,
          onTap: onManageUsers,
        ),
        ActionCard(
          title: 'Rondas',
          icon: Icons.route,
          color: Colors.teal,
          onTap: onScheduleRounds,
        ),
      ],
    );
  }
}

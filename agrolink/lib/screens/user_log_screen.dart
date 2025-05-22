import 'package:flutter/material.dart';
import '../models/activity_log.dart';
import '../services/log_service.dart';
import 'package:intl/intl.dart';

class UserLogScreen extends StatelessWidget {
  final String userId;

  const UserLogScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final logService = LogService();

    return Scaffold(
      appBar: AppBar(title: const Text('Mi bitácora')),
      body: StreamBuilder<List<ActivityLog>>(
        stream: logService.getLogsForUser(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Error');
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final logs = snapshot.data!;
          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (_, i) {
              final log = logs[i];
              return ListTile(
                title: Text(log.title),
                subtitle: Text('${log.description}\nFecha: ${DateFormat('yyyy-MM-dd HH:mm').format(log.timestamp)}'),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../services/zone_service.dart';
import '../models/zone.dart';

class ZoneListScreen extends StatelessWidget {
  final ZoneService zoneService = ZoneService();

  ZoneListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Zonas Registradas')),
      body: StreamBuilder<List<Zone>>(
        stream: zoneService.getZones(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Text('Error al cargar zonas');
          if (!snapshot.hasData) return const CircularProgressIndicator();

          final zones = snapshot.data!;
          return ListView.builder(
            itemCount: zones.length,
            itemBuilder: (_, index) {
              final zone = zones[index];
              return ListTile(
                title: Text(zone.name),
                subtitle: Text('${zone.cropType} - ${zone.status}'),
              );
            },
          );
        },
      ),
    );
  }
}
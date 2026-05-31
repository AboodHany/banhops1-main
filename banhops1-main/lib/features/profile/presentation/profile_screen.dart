import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/demo_transit_catalog.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/state/auth_controller.dart';
import '../../../core/services/trip_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text(localization.translate('profile'))),
      body: FutureBuilder<int>(
        future: TripRepository().countCompletedTrips(),
        builder: (context, snapshot) {
          final completedTrips = snapshot.data ?? DemoTransitCatalog.history.where((trip) => getTripStatusLabel(trip.status) == 'COMPLETED').length;
          final profile = auth.profile;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 28, child: Icon(Icons.person_rounded)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profile?.name ?? 'BanHops User', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text(profile?.email ?? 'guest@banhops.local'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(localization.translate('completed_trip_count'), style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('$completedTrips', style: Theme.of(context).textTheme.displaySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.settings_rounded),
                      title: Text('Settings'),
                    ),
                    SwitchListTile(
                      value: profile?.isGuest ?? true,
                      onChanged: (_) {},
                      title: const Text('Guest mode'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.read<AuthController>().signOut(),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign out'),
              ),
            ],
          );
        },
      ),
    );
  }
}

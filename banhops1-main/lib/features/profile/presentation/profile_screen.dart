import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_routes.dart';
import '../../../core/data/demo_transit_catalog.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/state/app_state.dart';
import '../../../core/state/auth_controller.dart';
import '../../../core/services/trip_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();
    final appState = context.watch<AppState>();

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
                    ListTile(
                      leading: const Icon(Icons.settings_rounded),
                      title: Text(localization.translate('settings')),
                    ),
                    ListTile(
                      leading: const Icon(Icons.language_rounded),
                      title: Text(localization.translate('language')),
                      trailing: Text(
                        appState.locale?.languageCode == 'ar' ? 'العربية' : 'English',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        final nextLang = appState.locale?.languageCode == 'ar' ? 'en' : 'ar';
                        appState.setLocale(nextLang);
                      },
                    ),
                    SwitchListTile(
                      value: profile?.isGuest ?? true,
                      onChanged: (_) {},
                      title: Text(localization.translate('guest_mode')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(localization.translate('sign_out_title')),
                        content: Text(localization.translate('sign_out_confirm')),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(localization.translate('cancel')),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(localization.translate('sign_out')),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && context.mounted) {
                      await context.read<AuthController>().signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (route) => false,
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: Text(localization.translate('sign_out')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.errorContainer,
                    foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

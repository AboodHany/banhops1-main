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
                    ListTile(
                      leading: Icon(
                        appState.themeMode == ThemeMode.dark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                      ),
                      title: Text(localization.translate('theme')),
                      trailing: Text(
                        appState.themeMode == ThemeMode.dark
                            ? localization.translate('dark_mode')
                            : localization.translate('light_mode'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        appState.toggleThemeMode();
                      },
                    ),
                    SwitchListTile(
                      value: profile?.isGuest ?? true,
                      onChanged: (_) {},
                      title: Text(localization.translate('guest_mode')),
                    ),
                    ListTile(
                      leading: const Icon(Icons.people_alt_rounded),
                      title: Text(localization.translate('credits')),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CreditsScreen()),
                        );
                      },
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

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final names = [
      'Abdelrahman Hany Hanafy Mohamed',
      'Abdallah Ashraf Hassanein Hussein',
      'Ali Mohamed Fakhry Mohamed',
      'Mahmoud Mohamed Morsy Afifi',
      'Mohamed Hany Mohamed El-Sayed',
      'Mostafa Ibrahim Sayed Talba',
      'Rofaida Khaled Ibrahim Mohamed',
      'Hager Ehab Ibrahim Mohamed',
      'Reem Ashraf El-Sayed Mohamed',
    ];

    final arabicNames = [
      'عبد الرحمن هاني حنفي محمد',
      'عبد الله أشرف حسنين حسين',
      'علي محمد فخري محمد',
      'محمود محمد مرسي عفيفي',
      'محمد هاني محمد السيد',
      'مصطفى إبراهيم سيد طلبة',
      'رفيدة خالد إبراهيم محمد',
      'هاجر إيهاب إبراهيم محمد',
      'ريم أشرف السيد محمد',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: Text(localization.translate('project_credits')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.people_alt_rounded,
                color: Color(0xFF0F4C81),
                size: 64,
              ),
              const SizedBox(height: 12),
              Text(
                localization.translate('project_development_team'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F4C81),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                localization.translate('faculty_and_university'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 0.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F4C81).withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Color(0xFF0F4C81),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    names[index],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    arabicNames[index],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                localization.translate('under_supervision'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0F4C81),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

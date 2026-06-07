import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/app_routes.dart';
import '../../../core/data/demo_transit_catalog.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/state/trip_planner_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getLocalizedLocationTypeLabel(BuildContext context, TransitLocationType type) {
    final loc = AppLocalizations.of(context);
    return switch (type) {
      TransitLocationType.university => loc.translate('type_university'),
      TransitLocationType.hospital => loc.translate('type_hospital'),
      TransitLocationType.station => loc.translate('type_station'),
      TransitLocationType.hub => loc.translate('type_hub'),
      TransitLocationType.cafe => loc.translate('type_cafe'),
      TransitLocationType.restaurant => loc.translate('type_restaurant'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final planner = context.watch<TripPlannerController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('home')),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.history),
          ),
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F4C81), Color(0xFF1B998B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.translate('smart_insight'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  localization.translate('smart_insight_subtitle'),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SearchCard(
            planner: planner,
            localization: localization,
          ),
          const SizedBox(height: 18),
          Text(localization.translate('popular_zones'), style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final zone in DemoTransitCatalog.quickZones)
                _ZoneCard(
                  zoneName: localization.translateLocation(zone.name),
                  zoneType: _getLocalizedLocationTypeLabel(context, zone.type),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) {
                        return SafeArea(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Text(
                                  localization.translate('popular_zones_sheet_title'),
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                ...planner.benhaDestinations.map((dest) {
                                  return ListTile(
                                    leading: const Icon(Icons.place_rounded, color: Color(0xFF0F4C81)),
                                    title: Text(localization.translateLocation(dest.name)),
                                    subtitle: dest.alias != null
                                        ? Text(localization.translateLocation(dest.alias!))
                                        : null,
                                    onTap: () {
                                      planner.setOrigin(zone);
                                      planner.setDestination(dest);
                                      planner.planTrip(localeCode: localization.locale.languageCode);
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed(
                                        AppRoutes.routeResults,
                                        arguments: {
                                          'originLabel': localization.translateLocation(zone.name),
                                          'destinationLabel': localization.translateLocation(dest.name),
                                          'origin': zone,
                                          'destination': dest,
                                        },
                                      );
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(localization.translate('train_lines'), style: Theme.of(context).textTheme.titleLarge),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.train),
                child: Text(localization.translate('train_map')),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _MiniActionTile(
            icon: Icons.route_rounded,
            title: localization.translate('view_recommended_routes_title'),
            subtitle: localization.translate('view_recommended_routes_subtitle'),
            onTap: () {
              planner.planTrip(localeCode: localization.locale.languageCode);
              Navigator.of(context).pushNamed(
                AppRoutes.routeResults,
                arguments: {
                  'originLabel': localization.translateLocation(planner.selectedOriginCity.name),
                  'destinationLabel': localization.translateLocation(planner.selectedBenhaDestination.name),
                  'origin': planner.selectedOriginCity,
                  'destination': planner.selectedBenhaDestination,
                },
              );
            },
          ),
          const SizedBox(height: 10),
          _MiniActionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: localization.translate('open_ai_assistant_title'),
            subtitle: localization.translate('open_ai_assistant_subtitle'),
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.aiChat),
          ),
        ],
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({required this.planner, required this.localization});

  final TripPlannerController planner;
  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final cities = planner.getLocationsForGovernorate(planner.selectedOriginGovernorate);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localization.translate('plan_trip'), style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            
            // 1. Governorate Dropdown
            DropdownButtonFormField<String>(
              value: planner.selectedOriginGovernorate,
              decoration: InputDecoration(labelText: localization.translate('select_governorate')),
              items: planner.governorates
                  .map((gov) => DropdownMenuItem(
                        value: gov,
                        child: Text(localization.translateLocation(gov)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  planner.setSelectedOriginGovernorate(value);
                }
              },
            ),
            const SizedBox(height: 12),

            // 2. City Dropdown
            DropdownButtonFormField<int>(
              value: planner.selectedOriginCity.id,
              decoration: InputDecoration(labelText: localization.translate('select_city')),
              items: cities
                  .map((location) => DropdownMenuItem(
                        value: location.id,
                        child: Text(localization.translateLocation(location.name)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  final city = cities.firstWhere((city) => city.id == value);
                  planner.setSelectedOriginCity(city);
                }
              },
            ),
            const SizedBox(height: 12),

            // 3. Destination Dropdown (restricted to Benha Destinations)
            DropdownButtonFormField<int>(
              value: planner.selectedBenhaDestination.id,
              decoration: InputDecoration(labelText: localization.translate('select_destination_in_benha')),
              items: planner.benhaDestinations
                  .map((location) => DropdownMenuItem(
                        value: location.id,
                        child: Text(localization.translateLocation(location.name)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  final dest = planner.benhaDestinations.firstWhere((dest) => dest.id == value);
                  planner.setSelectedBenhaDestination(dest);
                }
              },
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: planner.swapEndpoints,
                    icon: const Icon(Icons.swap_vert_rounded),
                    label: Text(localization.translate('swap')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      planner.planTrip(localeCode: localization.locale.languageCode);
                      Navigator.of(context).pushNamed(
                        AppRoutes.routeResults,
                        arguments: {
                          'originLabel': localization.translateLocation(planner.selectedOriginCity.name),
                          'destinationLabel': localization.translateLocation(planner.selectedBenhaDestination.name),
                          'origin': planner.selectedOriginCity,
                          'destination': planner.selectedBenhaDestination,
                        },
                      );
                    },
                    child: Text(localization.translate('get_routes')),
                  ),
                ),
              ],
            ),
            if (planner.latestPlan != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF6F2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(planner.latestPlan!.summary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ZoneCard extends StatelessWidget {
  const _ZoneCard({required this.zoneName, required this.zoneType, required this.onTap});

  final String zoneName;
  final String zoneType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.place_rounded, color: Color(0xFF0F4C81)),
                const SizedBox(height: 18),
                Text(zoneName, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(zoneType, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniActionTile extends StatelessWidget {
  const _MiniActionTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFEAF2FF),
          child: Icon(icon, color: const Color(0xFF0F4C81)),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/transit_route_option.dart';
import '../../../core/models/location_node.dart';
import '../../../core/models/transit_enums.dart';
import '../../../core/state/trip_planner_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../app/app_routes.dart';

/// RouteResultsScreen - Pages 46-48: Search & Results Layout
/// Triggered after picking origin/destination
/// Queries live Supabase TRIPS and ROUTES tables
/// Displays multi-modal travel options (Microbus vs Train) sorted by cost or time
class RouteResultsScreen extends StatefulWidget {
  const RouteResultsScreen({
    super.key,
    required this.originLabel,
    required this.destinationLabel,
    required this.origin,
    required this.destination,
  });

  final String originLabel;
  final String destinationLabel;
  final LocationNode origin;
  final LocationNode destination;

  @override
  State<RouteResultsScreen> createState() => _RouteResultsScreenState();
}

class _RouteResultsScreenState extends State<RouteResultsScreen> {
  late TripPlannerController _tripPlanner;
  bool _isLoadingRoutes = false;
  List<TransitRouteOption> _routes = [];
  // Default sorting to cost since duration calculation is disabled
  String? _selectedMode; // 'ALL', 'MICROBUS', 'TRAIN', 'PUBLIC_BUS'

  @override
  void initState() {
    super.initState();
    _tripPlanner = context.read<TripPlannerController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRoutes();
    });
  }

  Future<void> _loadRoutes() async {
    setState(() => _isLoadingRoutes = true);
    try {
      _tripPlanner.setOrigin(widget.origin);
      _tripPlanner.setDestination(widget.destination);

      final result = _tripPlanner.planTrip(localeCode: AppLocalizations.of(context).locale.languageCode);
      if (mounted) {
        setState(() {
          _routes = result.routes;
          _isLoadingRoutes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingRoutes = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading routes: $e')),
        );
      }
    }
  }

  List<TransitRouteOption> _getFilteredAndSortedRoutes() {
    var filtered = _routes;

    if (_selectedMode != null && _selectedMode != 'ALL') {
      filtered = filtered
          .where((route) => getTransitModeLabel(route.mode) == _selectedMode)
          .toList();
    }

    filtered.sort((a, b) => a.estimatedCost.compareTo(b.estimatedCost));

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final filteredRoutes = _getFilteredAndSortedRoutes();

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.translate('transportation_options')),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
      ),
      body: _isLoadingRoutes
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0F4C81)),
            )
          : Column(
              children: [
                Container(
                  color: const Color(0xFF0F4C81).withValues(alpha: 0.05),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 20, color: Color(0xFF0F4C81)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${localization.translate('from')}: ${widget.originLabel}',
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 20, color: Color(0xFF1B998B)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${localization.translate('to')}: ${widget.destinationLabel}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localization.translate('sort_and_filter'),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [

                            _FilterChip(
                              label: localization.translate('all_modes'),
                              selected: _selectedMode == null || _selectedMode == 'ALL',
                              onSelected: () =>
                                  setState(() => _selectedMode = null),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: localization.translate('microbus'),
                              selected: _selectedMode == 'MICROBUS',
                              onSelected: () =>
                                  setState(() => _selectedMode = 'MICROBUS'),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: localization.translate('train'),
                              selected: _selectedMode == 'TRAIN',
                              onSelected: () =>
                                  setState(() => _selectedMode = 'TRAIN'),
                            ),
                            if (_routes.any((r) => r.mode == TransitMode.borderBus)) ...[
                              const SizedBox(width: 8),
                              _FilterChip(
                                label: localization.translate('border_bus'),
                                selected: _selectedMode == 'BORDER_BUS',
                                onSelected: () =>
                                    setState(() => _selectedMode = 'BORDER_BUS'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: filteredRoutes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.route_outlined,
                                  size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                localization.translate('no_routes_available'),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                localization.translate('try_adjusting_filters'),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredRoutes.length,
                          itemBuilder: (context, index) {
                            final route = filteredRoutes[index];
                            return _RouteCard(
                              route: route,
                              localization: localization,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.tripDetails,
                                  arguments: {
                                    'route': route,
                                    'origin': widget.originLabel,
                                    'destination': widget.destinationLabel,
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: const Color(0xFF0F4C81),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(
        color: selected ? const Color(0xFF0F4C81) : Colors.grey[300]!,
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.localization,
    required this.onTap,
  });

  final TransitRouteOption route;
  final AppLocalizations localization;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      route.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (route.isRecommended)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B998B).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '⭐ ${localization.translate('recommended')}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B998B),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _InfoPill(
                    icon: Icons.payments_outlined,
                    label: '${route.estimatedCost} ${localization.translate('egp')}',
                  ),
                  const SizedBox(width: 12),
                  _InfoPill(
                    icon: Icons.swap_vert,
                    label: route.transfers == 1
                        ? '1 ${localization.translate('transfer')}'
                        : '${route.transfers} ${localization.translate('transfers_plural')}',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(localization.translate('view_details')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F4C81).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0F4C81)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/city_provider.dart';
import '../providers/solar_forecast_provider.dart';
import '../widgets/forecast_timeline.dart';
import 'settings_screen.dart';

/// Home screen displaying today's solar forecast
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// Refresh the forecast data
  Future<void> _refreshForecast() {
    ref.invalidate(todaysSolarForecastProvider);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: 'Sol',
            children: [
              TextSpan(
                text: 'ER',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            tooltip: l10n.settings,
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshForecast,
        child: Consumer(
          builder: (context, ref, child) {
            final selectedCityAsync = ref.watch(selectedCityProvider);

            return selectedCityAsync.when(
              loading: () => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          '${l10n.loading}...',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              error: (error, stackTrace) => ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_off,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.error,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              data: (city) {
                if (city == null) {
                  return _buildCitySelection(context);
                }

                final forecastAsync = ref.watch(todaysSolarForecastProvider);
                return forecastAsync.when(
                  // Loading state
                  loading: () => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 120),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              '${l10n.loading}...',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Error state
                  error: (error, stackTrace) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      const SizedBox(height: 80),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_off,
                              size: 64,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              l10n.error,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _refreshForecast,
                              icon: const Icon(Icons.refresh),
                              label: Text(l10n.pullToRefresh),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Success state
                  data: (forecastData) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        ForecastHeader(
                          forecastData: forecastData,
                          cityName: city.name,
                        ),
                        const Divider(),
                        SizedBox(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ForecastTimeline(forecastData: forecastData),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Solar Energy Tips',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              _buildTipItem(
                                'Peak Hours',
                                'Solar radiation is highest between 10 AM and 3 PM',
                                Icons.wb_sunny,
                                context,
                              ),
                              _buildTipItem(
                                'Plan Ahead',
                                'Schedule high-energy tasks during peak forecast hours',
                                Icons.schedule,
                                context,
                              ),
                              _buildTipItem(
                                'Monitor Usage',
                                'Check back regularly for updated forecasts',
                                Icons.analytics,
                                context,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCitySelection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                l10n.selectCity,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, child) {
                  final query = ref.watch(citySearchQueryProvider);
                  final resultsAsync = ref.watch(
                    citySearchResultsProvider(query),
                  );
                  return Column(
                    children: [
                      TextField(
                        onChanged: (query) {
                          ref.read(citySearchQueryProvider.notifier).state =
                              query;
                        },
                        decoration: InputDecoration(
                          labelText: l10n.search,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      resultsAsync.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) {
                          return Center(child: Text('${l10n.error}: $error'));
                        },
                        data: (cities) {
                          if (cities.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  l10n.noCitySelected,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: cities.length,
                            itemBuilder: (context, index) {
                              final city = cities[index];
                              return ListTile(
                                title: Text(city.name),
                                subtitle: Text(
                                  '${city.admin1}, ${city.country}',
                                ),
                                onTap: () {
                                  ref
                                      .read(selectedCityProvider.notifier)
                                      .setCity(city);
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(
    String title,
    String description,
    IconData icon,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

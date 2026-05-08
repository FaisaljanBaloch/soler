import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/location_provider.dart';
import '../providers/solar_forecast_provider.dart';
import '../widgets/forecast_timeline.dart';

/// Home screen displaying today's solar forecast
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _permissionRequested = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  /// Request location permission on app startup
  Future<void> _requestLocationPermission() async {
    if (_permissionRequested) return;
    _permissionRequested = true;

    try {
      final granted = await ref.read(locationPermissionProvider.future);
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is required to show solar forecast'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Permission request error: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Refresh the forecast data
  Future<void> _refreshForecast() {
    ref.invalidate(todaysSolarForecastProvider);
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SolER - Solar Forecast'),
        elevation: 0,
        backgroundColor: Colors.amber.shade50,
        foregroundColor: Colors.black87,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshForecast,
        child: Consumer(
          builder: (context, ref, child) {
            final forecastAsync = ref.watch(todaysSolarForecastProvider);

            return forecastAsync.when(
              // Loading state
              loading: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Fetching solar forecast...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),

              // Error state
              error: (error, stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Unable to Load Forecast',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _refreshForecast,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Success state
              data: (forecastData) => SingleChildScrollView(
                child: Column(
                  children: [
                    ForecastHeader(forecastData: forecastData),
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
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 12),
                          _buildTipItem(
                            'Peak Hours',
                            'Solar radiation is highest between 10 AM and 3 PM',
                            Icons.wb_sunny,
                          ),
                          _buildTipItem(
                            'Plan Ahead',
                            'Schedule high-energy tasks during peak forecast hours',
                            Icons.schedule,
                          ),
                          _buildTipItem(
                            'Monitor Usage',
                            'Check back regularly for updated forecasts',
                            Icons.analytics,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshForecast,
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black87,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildTipItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber, size: 20),
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
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

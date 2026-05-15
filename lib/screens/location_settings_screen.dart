import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/city.dart';
import '../providers/city_provider.dart';

class LocationSettingsScreen extends ConsumerWidget {
  const LocationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCityAsync = ref.watch(selectedCityProvider);
    final query = ref.watch(citySearchQueryProvider);
    final resultsAsync = ref.watch(citySearchResultsProvider(query));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.location)),
      body: selectedCityAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (selectedCity) => ListView(
          children: [
            const SizedBox(height: 8),
            if (selectedCity != null)
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(selectedCity.name),
                subtitle: _buildCitySubtitle(selectedCity),
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l10n.search,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) {
                  ref.read(citySearchQueryProvider.notifier).setQuery(value);
                },
              ),
            ),
            const SizedBox(height: 12),
            resultsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(error.toString()),
              ),
              data: (results) {
                if (query.trim().length < 2) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(l10n.pullToRefresh),
                  );
                }

                if (results.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(l10n.noCitySelected),
                  );
                }

                return Column(
                  children: results
                      .map(
                        (city) => ListTile(
                          leading: const Icon(Icons.location_city),
                          title: Text(city.name),
                          subtitle: _buildCitySubtitle(city),
                          trailing: const Icon(Icons.add),
                          onTap: () {
                            ref
                                .read(selectedCityProvider.notifier)
                                .setCity(city);
                            Navigator.of(context).maybePop();
                          },
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget? _buildCitySubtitle(City city) {
    final parts = <String>[];
    if (city.admin1 != null && city.admin1!.isNotEmpty) {
      parts.add(city.admin1!);
    }
    if (city.country != null && city.country!.isNotEmpty) {
      parts.add(city.country!);
    }

    if (parts.isEmpty) {
      return null;
    }

    return Text(parts.join(', '));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/city_provider.dart';

class CitySelectionView extends ConsumerWidget {
  const CitySelectionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final query = ref.watch(citySearchQueryProvider);
    final resultsAsync = ref.watch(citySearchResultsProvider(query));

    return ListView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24 + bottomInset),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.selectCity,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          onChanged: (query) {
            ref.read(citySearchQueryProvider.notifier).state = query;
          },
          decoration: InputDecoration(
            labelText: l10n.search,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        const SizedBox(height: 12),
        resultsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
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
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                return ListTile(
                  title: Text(
                    city.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '${city.admin1}, ${city.country}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    ref.read(selectedCityProvider.notifier).setCity(city);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

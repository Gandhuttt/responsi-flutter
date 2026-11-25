import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../services/favorites_service.dart';
import '../services/geocoding_service.dart';
import '../viewmodels/favorites_view_model.dart';
import '../viewmodels/location_search_view_model.dart';

class LocationSearchScreen extends StatelessWidget {
  const LocationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => LocationSearchViewModel(GeocodingService()),
      ),
      ChangeNotifierProvider(
        create: (_) => FavoritesViewModel(FavoritesService()),
      ),
    ],
    child: const _SearchView(),
  );
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    FocusScope.of(context).unfocus();
    context.read<LocationSearchViewModel>().search(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<LocationSearchViewModel>();
    final favorites = context.watch<FavoritesViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Cari lokasi')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => ListView(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth > 680
                  ? (constraints.maxWidth - 648) / 2
                  : 16,
              vertical: 16,
            ),
            children: [
              TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  labelText: 'Nama kota',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    tooltip: 'Cari',
                    onPressed: _search,
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Favorit', style: Theme.of(context).textTheme.titleLarge),
              if (favorites.loading)
                const Center(child: CircularProgressIndicator())
              else if (favorites.hasError)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Tidak dapat membaca atau menyimpan favorit.'),
                )
              else if (favorites.locations.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Belum ada lokasi favorit.'),
                )
              else
                ...favorites.locations.map(
                  (location) => _locationTile(location, favorites),
                ),
              const SizedBox(height: 24),
              Text(
                'Hasil pencarian',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              switch (search.status) {
                SearchStatus.initial => const Text(
                  'Masukkan nama kota untuk mencari.',
                ),
                SearchStatus.loading => const Center(
                  child: CircularProgressIndicator(),
                ),
                SearchStatus.empty => const Text('Lokasi tidak ditemukan.'),
                SearchStatus.error => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pencarian gagal. Periksa koneksi dan coba lagi.',
                    ),
                    TextButton(
                      onPressed: _search,
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
                SearchStatus.success => Column(
                  children: search.locations
                      .map((location) => _locationTile(location, favorites))
                      .toList(),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationTile(Location location, FavoritesViewModel favorites) {
    final details = [
      location.admin1,
      location.country,
    ].whereType<String>().where((value) => value.isNotEmpty).join(', ');
    final isFavorite = favorites.isFavorite(location);
    return Card(
      child: ListTile(
        title: Text(location.name),
        subtitle: details.isEmpty ? null : Text(details),
        onTap: () => Navigator.of(context).pop(location),
        trailing: IconButton(
          tooltip: isFavorite ? 'Hapus favorit' : 'Tambah favorit',
          onPressed: favorites.loading
              ? null
              : () => favorites.toggle(location),
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
        ),
      ),
    );
  }
}

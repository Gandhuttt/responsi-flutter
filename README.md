# Responsi Flutter

Aplikasi cuaca Android berbasis Flutter menggunakan Open-Meteo. Saat ini proyek masih menampilkan aplikasi bawaan Flutter; fitur cuaca belum diimplementasikan.

## Menjalankan proyek

```sh
flutter pub get
flutter run
```

Pilih perangkat Android atau emulator saat menjalankan aplikasi.

## Rancangan arsitektur MVVM

Kode fitur dipisahkan berdasarkan tanggung jawab berikut:

- `lib/models/`: model lokasi dan cuaca serta parsing JSON. Model lokasi juga dapat diserialisasi untuk penyimpanan lokal.
- `lib/views/`: screen dan widget untuk menampilkan state dan menerima interaksi pengguna.
- `lib/viewmodels/`: state dan logika presentasi untuk pencarian lokasi, cuaca, dan favorit. View mengamati perubahan melalui Provider.
- `lib/services/`: request HTTP ke Open-Meteo dan penyimpanan favorit dengan SharedPreferences.

View memanggil ViewModel; ViewModel menggunakan service untuk mengambil atau menyimpan data dan menyediakan model serta state kepada View. Model sudah diimplementasikan; View, ViewModel, dan service cuaca akan dibuat pada langkah berikutnya.

## Sumber data

- [Open-Meteo Geocoding API](https://open-meteo.com/en/docs/geocoding-api) untuk pencarian lokasi.
- [Open-Meteo Weather Forecast API](https://open-meteo.com/en/docs) untuk data cuaca.

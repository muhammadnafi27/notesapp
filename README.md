# My Notes

Aplikasi catatan modern berbasis Flutter dengan desain dark theme minimalis, warna dominan abu-abu kehitaman dan oranye menyala sebagai aksen utama. Dibangun dengan arsitektur bersih, responsif untuk desktop dan mobile, serta siap produksi.

---

## Tampilan

- Kartu catatan berwarna oranye cerah dengan teks putih yang kontras
- Efek glow oranye pada kartu dan tombol aksi
- Background gelap `#0F0F0F` dengan elemen permukaan `#1A1A1A` dan `#242424`
- Tipografi Google Fonts Inter untuk keterbacaan optimal
- Animasi halus menggunakan Flutter Animate

---

## Fitur Utama

### Halaman Beranda
- Searchbar interaktif dengan efek border oranye saat fokus dan pencarian realtime
- Badge jumlah catatan di samping judul aplikasi
- Tampilan kosong dengan ikon animasi pulse saat belum ada catatan
- Grid responsif: 3 kolom di desktop, 2 kolom di tablet dan mobile
- Floating Action Button oranye dengan efek glow dan animasi elastic saat muncul

### Kartu Catatan
- Background gradient oranye cerah pada setiap kartu
- Menampilkan judul catatan, waktu realtime (hari, tanggal, jam detik-per-detik), dan cuplikan isi
- Hover effect dengan intensitas glow yang meningkat di desktop
- Isi catatan dibersihkan dari marker format sebelum ditampilkan sebagai preview
- Animasi fade dan slide masuk saat kartu pertama kali dimuat

### Editor Catatan
- Input judul bold berukuran besar dengan divider oranye sebagai pemisah
- Area tulis bebas multi-baris tanpa batas
- Auto save otomatis saat menekan tombol kembali atau navigasi keluar
- Tombol kembali bergradient oranye dengan label "Kembali" dan efek tekan
- Badge "Auto Save" di pojok kanan atas sebagai indikator

### Toolbar Format
Toolbar format tersedia di bawah area tulis, tepat di atas keyboard saat mengetik.

| Tombol | Format | Contoh |
|--------|--------|--------|
| B | Bold | `**teks**` |
| I | Italic | `_teks_` |
| U | Underline | `__teks__` |
| S | Strikethrough | `~~teks~~` |
| Bullet | Daftar poin | `• item` |
| Numbered | Daftar bernomor | `1. item` |
| Checklist | Daftar tugas | `☐ item` |

Perilaku format:
- Jika ada teks yang diseleksi, marker langsung membungkus teks tersebut
- Jika tidak ada seleksi, marker disisipkan di posisi kursor siap diisi
- Numbered list otomatis melanjutkan nomor dari baris sebelumnya
- Checklist dapat di-toggle: `☐` menjadi `☑`, ketuk lagi untuk menghapus prefix
- Setiap tombol list bersifat toggle: ketuk saat prefix sudah ada akan menghapusnya

### Mode Seleksi
- Long press pada kartu untuk masuk ke mode seleksi dengan animasi slide-in action bar
- Action bar di bagian atas menampilkan jumlah catatan yang dipilih
- Tombol "Pilih Semua" untuk memilih atau membatalkan semua sekaligus
- Tombol hapus dengan dialog konfirmasi sebelum menghapus permanen
- Tombol tutup untuk keluar dari mode seleksi tanpa menghapus

### Transisi Halaman
- Animasi slide dari kanan ke kiri saat berpindah ke editor
- Fade-in bersamaan dengan slide untuk efek yang lebih halus
- Durasi transisi 350ms dengan kurva `easeInOutCubic`

---

## Teknologi yang Digunakan

| Paket | Kegunaan |
|-------|----------|
| `provider` | State management dengan ChangeNotifier |
| `shared_preferences` | Penyimpanan lokal catatan dalam format JSON |
| `google_fonts` | Tipografi Inter |
| `flutter_animate` | Animasi fade, slide, scale, dan elastic |
| `uuid` | Generate ID unik untuk setiap catatan |

---

## State Management

Seluruh state dikelola oleh `CatatanProvider` yang meng-extend `ChangeNotifier`:

- `catatanTersaring` - daftar catatan yang sudah difilter berdasarkan pencarian
- `modusSeleksi` - status apakah sedang dalam mode multi-seleksi
- `catatanTerpilih` - daftar catatan yang sedang dipilih
- `kueriPencarian` - teks pencarian aktif
- `jumlahCatatan` - total catatan yang tersimpan

---

## Penyimpanan Data

Catatan disimpan secara lokal menggunakan `SharedPreferences` dalam format JSON. Setiap catatan memiliki struktur:

```json
{
  "id": "uuid-v4",
  "judul": "Judul catatan",
  "isi": "Isi catatan dengan **format**",
  "tanggalDibuat": "2026-01-01T00:00:00.000",
  "tanggalDiperbarui": "2026-01-01T00:00:00.000"
}
```

---

## Cara Menjalankan

Pastikan Flutter SDK sudah terinstal. Kemudian jalankan perintah berikut:

```bash
# Install semua dependensi
flutter pub get

# Jalankan di perangkat yang terhubung (mobile atau desktop)
flutter run -t lib/utama.dart

# Jalankan khusus di Windows desktop
flutter run -t lib/utama.dart -d windows

# Build rilis untuk Windows
flutter build windows --target lib/utama.dart
```

---

## Persyaratan

- Flutter SDK versi terbaru (disarankan 3.27 ke atas)
- Dart SDK 3.5 ke atas
- Untuk Windows desktop: Visual Studio dengan workload "Desktop development with C++"
- Untuk Android: Android Studio dan emulator atau perangkat fisik
- Untuk iOS/macOS: Xcode (hanya tersedia di macOS)

---

## Kompatibilitas Platform

| Platform | Status |
|----------|--------|
| Windows | Didukung penuh |
| Android | Didukung penuh |
| iOS | Didukung penuh |
| macOS | Didukung |
| Linux | Didukung |
| Web | Didukung (dengan keterbatasan SharedPreferences) |

---

## Catatan Pengembangan

- Entry point aplikasi ada di `lib/utama.dart`, bukan `lib/main.dart`
- Seluruh penamaan file, kelas, variabel, dan fungsi menggunakan Bahasa Indonesia
- Tidak ada kode deprecated yang digunakan
- Null safety aktif penuh
- Tema gelap didefinisikan secara terpusat di `lib/inti/tema.dart`
- Routing menggunakan named routes dengan transisi kustom di `lib/rute/rute_aplikasi.dart`

---

## Lisensi

Proyek ini bersifat privat dan tidak dipublikasikan ke pub.dev.

# Kumpulan Script LINUX (Debian & Ubuntu)

Repo ini menyimpan sekumpulan skrip shell yang ditujukan untuk mengotomasi tugas administrasi dan pemeliharaan pada sistem berbasis Debian/Ubuntu.

Fungsi umum skrip di repo ini:
- Menginstal paket dan dependensi yang sering dipakai pada mesin pengembang atau server.
- Menghapus atau mengembalikan paket dan konfigurasi jika diperlukan.
- Mengelola runtime dan packaging layer (mis. Flatpak) serta memperbaiki masalah terkait lingkungan pengguna.
- Menyediakan alat bantu untuk menangani modul kernel atau modul host pihak ketiga (direktori sumber tersedia untuk kompilasi bila diperlukan).
- Tugas pemeliharaan lain seperti resize partisi, memperbaiki instalasi virtualisasi, dan pembersihan sistem.

Panduan singkat penggunaan:
1. Baca isi skrip sebelum menjalankan untuk memahami dampaknya.
``` sh
nano <nama-skrip>.sh
```
2. Beri izin eksekusi jika diperlukan:.
``` sh
chmod +x <nama-skrip>.sh
```
3. Jalankan skrip dengan hak yang sesuai (sering membutuhkan `sudo`):.
``` sh
sudo ./<nama-skrip>.sh
```


Praktik aman:
- Selalu tinjau skrip yang diunduh atau modifikasi sebelum mengeksekusi.
- Lakukan cadangan (backup) konfigurasi penting sebelum menjalankan skrip yang memodifikasi disk atau partisi.
- Periksa apakah skrip memerlukan koneksi internet atau paket tambahan.

Menjelajahi repo:
- Lihat daftar skrip di root repo untuk mengetahui fungsi umum yang tersedia.
- Direktori sumber modul kernel/host (jika ada) berisi bahan untuk kompilasi; baca file instruksi di dalamnya jika ingin membangun modul.

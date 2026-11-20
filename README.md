# DKKT Portal

Portal publik dan CMS Dewan Kesenian dan Kebudayaan Kota Tasikmalaya. Aplikasi menggunakan Next.js App Router dan MariaDB melalui konektor Node.js `mariadb`, sehingga dapat dipasang pada layanan Web/Cloud Hosting Hostinger.

## Perubahan database

- Lapisan database PostgreSQL/Prisma ORM 8 sudah diganti dengan koneksi MariaDB.
- Semua pemanggilan data aplikasi tetap menggunakan facade `db.orm.public` agar halaman dan API CMS tidak perlu diubah satu per satu.
- Skema database disediakan pada `database/schema.mariadb.sql`.
- Skema mencakup 29 tabel, indeks, primary key, dan foreign key dari kontrak database proyek.
- Script seed tetap tersedia untuk membuat role, permission, komite awal, akun Super Admin, dan kategori berita.

**Catatan data:** file sumber yang diberikan berisi kode dan kontrak struktur database, bukan dump/backup isi database PostgreSQL. Karena itu, paket ini menyiapkan struktur MariaDB dan seed awal, tetapi tidak memindahkan berita, agenda, galeri, dokumen, akun, atau data lama dari server PostgreSQL. Data lama perlu diekspor dari PostgreSQL dan dikonversi/import secara terpisah.

## Prasyarat

- Node.js 22 atau lebih baru.
- npm.
- Database MariaDB/MySQL Hostinger yang sudah dibuat dan user database sudah terhubung ke website.
- Akses phpMyAdmin untuk membuat tabel.

Hostinger Web dan Cloud Hosting menggunakan MariaDB. Nama menu di hPanel tetap ditampilkan sebagai MySQL Database.

## 1. Siapkan database Hostinger

Di hPanel:

1. Buka **Websites → Manage → Databases → Management**.
2. Pastikan database dan user yang digunakan adalah `u866957779_dkktportal`.
3. Buka phpMyAdmin untuk database tersebut.
4. Pilih database yang benar, lalu buka tab **SQL**.
5. Import atau jalankan isi file `database/schema.mariadb.sql` satu kali pada database yang masih kosong.

File SQL membuat tabel dan relasi. File ini tidak berisi perintah `DROP TABLE` atau `DROP DATABASE`. Jalankan hanya satu kali pada database kosong. Jangan jalankan ulang setelah foreign key sudah terbentuk.

## 2. Konfigurasi environment

ZIP menyertakan `.env` untuk pengujian lokal sesuai detail koneksi yang diberikan. File `.env` masuk `.gitignore`, sehingga tidak ikut terkirim ke GitHub.

Untuk aplikasi yang berjalan di Hostinger, masukkan environment variable berikut melalui pengaturan environment Web App di hPanel. Gunakan nilai **MySQL Host** yang ditampilkan di hPanel. Pada Web/Cloud Hosting Hostinger, host umumnya `localhost`; file `.env` dalam ZIP mengikuti host `127.0.0.1` yang diberikan.

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=u866957779_dkktportal
DB_NAME=u866957779_dkktportal
DB_PASSWORD=PASSWORD_DATABASE_HOSTINGER
DB_CONNECTION_LIMIT=5
DATABASE_URL="mysql://u866957779_dkktportal:PASSWORD_DATABASE_HOSTINGER@localhost:3306/u866957779_dkktportal"

ADMIN_NAME=Super Admin DKKT
ADMIN_EMAIL=admin@dkkt.or.id
ADMIN_USERNAME=superadmin
ADMIN_PASSWORD=PASSWORD_ADMIN_YANG_KUAT
AUTH_SECRET=SECRET_RANDOM_MINIMAL_32_BYTE
NEXT_PUBLIC_SITE_URL=https://dkkt.or.id
UPLOAD_STORAGE_DRIVER=local
RATE_LIMIT_ALLOW_MEMORY_FALLBACK=true
```

Jika password berisi karakter khusus seperti `@`, `#`, `/`, `:` atau `%`, gunakan nilai asli pada `DB_PASSWORD`, tetapi URL-encode password saat menuliskannya di `DATABASE_URL`. Aplikasi memakai `DB_*` sebagai sumber koneksi utama.

**Penting:** jangan mengunggah `.env` ke GitHub. Masukkan nilai environment secara langsung di hPanel. Karena kredensial database pernah dibagikan dalam percakapan, sebaiknya ganti password database setelah pengujian pertama, lalu perbarui `DB_PASSWORD` dan `DATABASE_URL`.

## 3. Instalasi dan build

Di root project:

```bash
npm ci
npm run build
npm run start
```

Untuk Hostinger Web App, pilih aplikasi **Node.js/Next.js**, bukan static website. Gunakan:

- Node.js: 22.x atau versi lebih baru yang tersedia.
- Install command: `npm ci`
- Build command: `npm run build`
- Start command: `npm run start`

## 4. Uji koneksi dan isi data awal

Jalankan perintah ini dari terminal aplikasi setelah environment tersedia dan skema SQL sudah di-import:

```bash
npm run db:check
npm run db:seed
npm run db:seed-news-categories
```

`db:check` menampilkan versi server dan nama database yang berhasil diakses. `db:seed` membuat role, permission, komite awal, dan akun Super Admin berdasarkan environment `ADMIN_*`. `db:seed-news-categories` membuat kategori berita awal.

Gunakan `ADMIN_EMAIL` dan `ADMIN_PASSWORD` yang telah diatur untuk masuk ke CMS. Seed tidak mengganti password akun yang sudah ada.

## 5. Rate limit dan upload

- Untuk pengujian pada satu instance Hostinger, `RATE_LIMIT_ALLOW_MEMORY_FALLBACK=true` mengizinkan rate limit memakai memori proses jika Upstash Redis belum diatur. Hitungan akan reset saat proses restart dan tidak dibagikan antar-instance.
- Untuk penggunaan produksi, lebih baik konfigurasi Upstash Redis melalui `UPSTASH_REDIS_REST_URL` dan `UPSTASH_REDIS_REST_TOKEN`, lalu set `RATE_LIMIT_ALLOW_MEMORY_FALLBACK=false`.
- `UPLOAD_STORAGE_DRIVER=local` menyimpan file di `public/uploads`. Untuk penyimpanan jangka panjang atau deployment multi-instance, gunakan object storage S3-compatible dan isi environment `UPLOAD_STORAGE_*`.

## Smoke test setelah deploy

- Halaman publik `/` terbuka.
- Halaman berita, agenda, komite, seniman, kelompok, galeri, dan dokumen dapat memuat data dari MariaDB.
- Login Super Admin berhasil.
- Login dengan password salah ditolak.
- Halaman `/admin` terproteksi.
- Tambah, ubah, dan hapus satu data uji dari CMS berhasil.
- Upload gambar dan dokumen berhasil.
- Form kontak menerima pesan dan rate limit berjalan.

## Struktur file penting

```text
app/                     Next.js App Router dan API
components/              Komponen UI
lib/db.ts                Koneksi MariaDB dan kompatibilitas query facade
lib/db-schema.ts         Allowlist model/kolom untuk query aman
database/schema.mariadb.sql
                         Struktur tabel MariaDB
prisma/seed.ts           Seed role, permission, komite, dan Super Admin
prisma/seed-news-categories.ts
                         Seed kategori berita
scripts/check-db.ts      Tes koneksi database
.env                     Konfigurasi lokal, tidak untuk GitHub
.env.example             Template environment tanpa kredensial
```

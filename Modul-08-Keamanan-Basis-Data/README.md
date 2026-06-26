# Modul 8 – Keamanan Basis Data (Akses Pengguna)

## Capaian Pembelajaran
1. Mahasiswa mampu menjelaskan keamanan basis data
2. Mahasiswa mampu mengatur akses pada setiap pengguna basis data dengan benar

## Ringkasan Materi
Aspek keamanan basis data sangat penting untuk mencegah penyalahgunaan data. SQL menyediakan 9 hak akses: SELECT, INSERT, DELETE, UPDATE, REFERENCES, USAGE, TRIGGER, EXECUTE, dan UNDER. Modul ini membahas:

- **User Management** – Membuat dan mengelola pengguna database
- **GRANT** – Memberikan hak akses kepada pengguna
- **REVOKE** – Mencabut hak akses dari pengguna
- **RBAC** (Role-Based Access Control) – Memberikan hak akses berdasarkan peran

## Praktikum

### 1. Setup Database
Membuat database `db_perpustakaan` dan tabel `mahasiswa` dengan data dummy.

### 2. User Management
Membuat 3 user: `user_admin`, `user_mhs`, `user_dosen` dengan password masing-masing.

### 3. GRANT & REVOKE
- `user_admin` → ALL PRIVILEGES
- `user_mhs` → SELECT only
- `user_dosen` → SELECT + INSERT (INSERT lalu di-REVOKE)

### 4. RBAC
Membuat role `role_mhs` dengan hak SELECT, lalu diberikan ke `user_mhs`.

## Tugas Modul 8

### Soal
1. Buat role baru: `role_keuangan` yang hanya bisa SELECT dan UPDATE tabel `tagihan`
2. Buat user baru: `user_keu` dan tetapkan role tersebut padanya
3. Uji coba: pastikan user hanya bisa SELECT dan UPDATE, tidak bisa INSERT atau DELETE

### Implementasi SQL

```sql
-- 1. Buat role dengan hak SELECT dan UPDATE
CREATE ROLE 'role_keuangan';
GRANT SELECT, UPDATE ON db_keuangan.tagihan TO 'role_keuangan';

-- 2. Buat user dan berikan role
CREATE USER 'user_keu'@'localhost' IDENTIFIED BY 'keuangan123';
GRANT 'role_keuangan' TO 'user_keu'@'localhost';
SET DEFAULT ROLE 'role_keuangan' TO 'user_keu'@'localhost';
FLUSH PRIVILEGES;
```

### Hasil Pengujian

| Operasi | Hasil | Keterangan |
|---------|-------|------------|
| `SELECT * FROM tagihan;` | ✅ Berhasil | Sesuai hak akses |
| `UPDATE tagihan SET status='LUNAS' WHERE id=2;` | ✅ Berhasil | Sesuai hak akses |
| `INSERT INTO tagihan VALUES (...);` | ❌ Gagal | Tidak punya hak INSERT |
| `DELETE FROM tagihan WHERE id=1;` | ❌ Gagal | Tidak punya hak DELETE |

## File
- `tugas_modul_8.sql` – Script SQL lengkap (setup database, user management, GRANT/REVOKE, RBAC, dan tugas)

## Referensi
1. Connolly, T., & Begg, C. Database Systems: A Practical Approach to Design, Implementation, and Management.
2. Garcia-Molina, H., Ullman, J. D., & Widom, J. (2009). Database Systems: The Complete Book (2nd ed.).

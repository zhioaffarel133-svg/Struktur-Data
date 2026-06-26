-- Modul 8: Keamanan Basis Data (Akses Pengguna)
-- User Management, GRANT, REVOKE, RBAC

-- =============================================
-- PRAKTIKUM LANGKAH 1: Setup Database & Tabel
-- =============================================

CREATE DATABASE IF NOT EXISTS db_perpustakaan;
USE db_perpustakaan;

CREATE TABLE mahasiswa (
    npm VARCHAR(10) PRIMARY KEY,
    nama VARCHAR(50),
    jurusan VARCHAR(30),
    no_hp VARCHAR(15)
);

INSERT INTO mahasiswa VALUES
('001', 'Ahmad', 'TI', '081234567890'),
('002', 'Budi', 'TI', '081234567891'),
('003', 'Citra', 'SI', '081234567892'),
('004', 'Dewi', 'SI', '081234567893');

SELECT * FROM mahasiswa;

-- =============================================
-- PRAKTIKUM LANGKAH 2: User Management
-- =============================================

-- Membuat 3 user baru
CREATE USER 'user_admin'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'user_mhs'@'localhost' IDENTIFIED BY 'mhs123';
CREATE USER 'user_dosen'@'localhost' IDENTIFIED BY 'dosen123';

-- =============================================
-- PRAKTIKUM LANGKAH 3: GRANT & REVOKE
-- =============================================

-- Memberikan hak akses penuh ke user_admin
GRANT ALL PRIVILEGES ON db_perpustakaan.* TO 'user_admin'@'localhost';

-- Memberikan hak akses SELECT saja ke user_mhs
GRANT SELECT ON db_perpustakaan.* TO 'user_mhs'@'localhost';

-- Memberikan hak akses SELECT dan INSERT ke user_dosen
GRANT SELECT, INSERT ON db_perpustakaan.* TO 'user_dosen'@'localhost';

-- Terapkan perubahan
FLUSH PRIVILEGES;

-- Melihat hak akses masing-masing user
SHOW GRANTS FOR 'user_admin'@'localhost';
SHOW GRANTS FOR 'user_mhs'@'localhost';
SHOW GRANTS FOR 'user_dosen'@'localhost';

-- Contoh REVOKE (mencabut hak akses INSERT dari user_dosen)
REVOKE INSERT ON db_perpustakaan.* FROM 'user_dosen'@'localhost';
FLUSH PRIVILEGES;

-- =============================================
-- PRAKTIKUM LANGKAH 4: RBAC (Role-Based Access Control)
-- =============================================

-- Membuat role
CREATE ROLE IF NOT EXISTS 'role_mhs';

-- Memberikan hak akses pada role
GRANT SELECT ON db_perpustakaan.* TO 'role_mhs';

-- Memberikan role kepada user
GRANT 'role_mhs'@'%' TO 'user_mhs'@'localhost';

-- Aktifkan role default (MySQL 8.0+)
SET DEFAULT ROLE 'role_mhs' TO 'user_mhs'@'localhost';
FLUSH PRIVILEGES;

-- =============================================
-- TUGAS MODUL 8: Role Keuangan
-- =============================================

-- Buat database untuk tugas
CREATE DATABASE IF NOT EXISTS db_keuangan;
USE db_keuangan;

-- Buat tabel tagihan
CREATE TABLE tagihan (
    id_tagihan INT AUTO_INCREMENT PRIMARY KEY,
    npm VARCHAR(10),
    nama VARCHAR(50),
    semester INT,
    jumlah DECIMAL(12,2),
    status ENUM('LUNAS', 'BELUM LUNAS', 'CICIL') DEFAULT 'BELUM LUNAS',
    tanggal_jatuh_tempo DATE
);

-- Insert sample data
INSERT INTO tagihan (npm, nama, semester, jumlah, status, tanggal_jatuh_tempo) VALUES
('001', 'Ahmad', 1, 2500000, 'LUNAS', '2025-01-15'),
('002', 'Budi', 1, 2500000, 'BELUM LUNAS', '2025-03-15'),
('003', 'Citra', 3, 2500000, 'CICIL', '2025-02-28'),
('004', 'Dewi', 5, 3000000, 'BELUM LUNAS', '2025-04-10');

SELECT * FROM tagihan;

-- Soal 1: Buat role_keuangan (hanya SELECT dan UPDATE pada tabel tagihan)
CREATE ROLE IF NOT EXISTS 'role_keuangan';
GRANT SELECT, UPDATE ON db_keuangan.tagihan TO 'role_keuangan';

-- Soal 2: Buat user_keu dan berikan role_keuangan
CREATE USER IF NOT EXISTS 'user_keu'@'localhost' IDENTIFIED BY 'keuangan123';
GRANT 'role_keuangan' TO 'user_keu'@'localhost';
SET DEFAULT ROLE 'role_keuangan' TO 'user_keu'@'localhost';
FLUSH PRIVILEGES;

-- Lihat hak akses role dan user
SHOW GRANTS FOR 'role_keuangan';
SHOW GRANTS FOR 'user_keu'@'localhost';

-- =============================================
-- PENGUJIAN (jalankan setelah login sebagai user_keu)
-- =============================================

-- Sebagai user_keu, uji perintah berikut di terminal terpisah:
-- mysql -u user_keu -p
-- USE db_keuangan;

-- 1. SELECT: Seharusnya BERHASIL ✅
-- SELECT * FROM tagihan;

-- 2. UPDATE: Seharusnya BERHASIL ✅
-- UPDATE tagihan SET status = 'LUNAS' WHERE id_tagihan = 2;

-- 3. INSERT: Seharusnya GAGAL ❌
-- INSERT INTO tagihan VALUES (NULL, '005', 'Eve', 1, 2500000, 'BELUM LUNAS', '2025-05-01');

-- 4. DELETE: Seharusnya GAGAL ❌
-- DELETE FROM tagihan WHERE id_tagihan = 1;

-- =============================================
-- DROPS (untuk membersihkan jika diperlukan)
-- =============================================
-- DROP USER 'user_admin'@'localhost';
-- DROP USER 'user_mhs'@'localhost';
-- DROP USER 'user_dosen'@'localhost';
-- DROP USER 'user_keu'@'localhost';
-- DROP ROLE 'role_mhs';
-- DROP ROLE 'role_keuangan';
-- DROP DATABASE db_perpustakaan;
-- DROP DATABASE db_keuangan;

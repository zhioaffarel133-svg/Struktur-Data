-- Tugas Modul 9: Stored Procedure, Function, dan Trigger
-- Sistem Toko Buku Online

-- 1. Create Tables
CREATE TABLE buku (
    id_buku INT AUTO_INCREMENT PRIMARY KEY,
    judul VARCHAR(100),
    penulis VARCHAR(100),
    harga DECIMAL(10,2),
    stok INT
);

CREATE TABLE pelanggan (
    id_pelanggan INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100),
    total_belanja DECIMAL(10,2) DEFAULT 0,
    status_member ENUM('REGULER', 'GOLD', 'PLATINUM') DEFAULT 'REGULER'
);

CREATE TABLE transaksi (
    id_transaksi INT AUTO_INCREMENT PRIMARY KEY,
    id_pelanggan INT,
    id_buku INT,
    jumlah INT,
    total_harga DECIMAL(10,2),
    tanggal_transaksi DATE,
    FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan),
    FOREIGN KEY (id_buku) REFERENCES buku(id_buku)
);

-- 2. FUNCTION: Hitung Diskon
DELIMITER //
CREATE FUNCTION hitung_diskon(total_belanja DECIMAL(10,2))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE diskon DECIMAL(5,2);
    IF total_belanja < 1000000 THEN
        SET diskon = 0.00;
    ELSEIF total_belanja < 5000000 THEN
        SET diskon = 0.05;
    ELSE
        SET diskon = 0.10;
    END IF;
    RETURN diskon;
END //
DELIMITER ;

-- 3. STORED PROCEDURE: Tambah Transaksi
DELIMITER //
CREATE PROCEDURE tambah_transaksi(p_id_pelanggan INT, p_id_buku INT, p_jumlah INT)
BEGIN
    DECLARE v_harga DECIMAL(10,2);
    DECLARE v_stok INT;
    DECLARE v_total_harga DECIMAL(10,2);

    -- Check stock and get price
    SELECT harga, stok INTO v_harga, v_stok FROM buku WHERE id_buku = p_id_buku;

    IF v_stok < p_jumlah THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Stok tidak mencukupi';
    ELSE
        -- Update stock
        UPDATE buku SET stok = stok - p_jumlah WHERE id_buku = p_id_buku;
        
        -- Calculate total
        SET v_total_harga = v_harga * p_jumlah;
        
        -- Insert transaction
        INSERT INTO transaksi (id_pelanggan, id_buku, jumlah, total_harga, tanggal_transaksi)
        VALUES (p_id_pelanggan, p_id_buku, p_jumlah, v_total_harga, CURDATE());
        
        -- Update pelanggan
        UPDATE pelanggan SET total_belanja = total_belanja + v_total_harga WHERE id_pelanggan = p_id_pelanggan;
        
        SELECT 'Transaksi berhasil' AS pesan;
    END IF;
END //
DELIMITER ;

-- 4. TRIGGER: Update Status Member Otomatis
DELIMITER //
CREATE TRIGGER update_status_member
AFTER UPDATE ON pelanggan
FOR EACH ROW
BEGIN
    DECLARE v_status ENUM('REGULER', 'GOLD', 'PLATINUM');
    IF NEW.total_belanja >= 5000000 THEN
        SET v_status = 'PLATINUM';
    ELSEIF NEW.total_belanja >= 1000000 THEN
        SET v_status = 'GOLD';
    ELSE
        SET v_status = 'REGULER';
    END IF;

    IF NEW.status_member <> v_status THEN
        UPDATE pelanggan SET status_member = v_status WHERE id_pelanggan = NEW.id_pelanggan;
    END IF;
END //
DELIMITER ;

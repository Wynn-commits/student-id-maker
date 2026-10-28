-- =====================================================
-- EL PUEBLO DORMITORY DATABASE SCHEMA
-- =====================================================
-- This is your complete database structure
-- Import this file into phpMyAdmin in AMPPS

CREATE DATABASE IF NOT EXISTS elpueblo_dorm;
USE elpueblo_dorm;

-- -----------------------------------------------------
-- Table: admins
-- Stores admin login information
-- -----------------------------------------------------
CREATE TABLE admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insert default admin (password: admin123)
INSERT INTO admins (username, email, password_hash, full_name) VALUES
('admin', 'admin@elpueblo.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrator');

-- -----------------------------------------------------
-- Table: users (tenants/students)
-- Stores user registration and login information
-- -----------------------------------------------------
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    gender ENUM('male', 'female') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample users
INSERT INTO users (email, password_hash, full_name, phone, gender) VALUES
('rolando.agra@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Rolando Agra', '09876543210', 'male'),
('erwin.orq@email.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Erwin Orq', '09123456789', 'male');

-- -----------------------------------------------------
-- Table: rooms
-- Available rooms in the dormitory
-- -----------------------------------------------------
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type ENUM('male', 'female') NOT NULL,
    capacity INT NOT NULL DEFAULT 1,
    current_occupancy INT DEFAULT 0,
    price_per_month DECIMAL(10,2) NOT NULL,
    status ENUM('available', 'occupied', 'maintenance') DEFAULT 'available',
    floor INT,
    description TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample rooms
INSERT INTO rooms (room_number, room_type, capacity, price_per_month, status, floor) VALUES
('101', 'male', 2, 850.00, 'available', 1),
('102', 'male', 2, 850.00, 'available', 1),
('103', 'male', 1, 950.00, 'available', 1),
('201', 'female', 2, 850.00, 'available', 2),
('202', 'female', 2, 850.00, 'available', 2),
('203', 'female', 1, 950.00, 'available', 2),
('204', 'male', 2, 850.00, 'occupied', 2),
('305', 'male', 2, 850.00, 'available', 3);

-- -----------------------------------------------------
-- Table: bookings (reservations)
-- All booking/reservation records
-- -----------------------------------------------------
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    reservation_code VARCHAR(20) UNIQUE NOT NULL,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE,
    monthly_amount DECIMAL(10,2) NOT NULL,
    total_paid DECIMAL(10,2) DEFAULT 0,
    status ENUM('pending', 'confirmed', 'canceled', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample bookings
INSERT INTO bookings (reservation_code, user_id, room_id, check_in_date, check_out_date, monthly_amount, status) VALUES
('R-1024', 1, 4, '2024-04-25', NULL, 850.00, 'confirmed'),
('R-1023', 2, 8, '2024-04-25', NULL, 850.00, 'pending');

-- -----------------------------------------------------
-- Table: messages (contact form & reservation chat)
-- Stores all messages from contact form and chat
-- -----------------------------------------------------
CREATE TABLE messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_type ENUM('user', 'guest', 'admin') NOT NULL,
    sender_id INT,
    sender_name VARCHAR(100) NOT NULL,
    sender_email VARCHAR(100) NOT NULL,
    sender_phone VARCHAR(20),
    message_text TEXT NOT NULL,
    booking_id INT,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- -----------------------------------------------------
-- Table: payments
-- Track all payments made by users
-- -----------------------------------------------------
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('cash', 'bank_transfer', 'gcash', 'other') DEFAULT 'cash',
    receipt_number VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- USEFUL VIEWS FOR QUICK ACCESS
-- =====================================================

-- View: Active bookings with user and room details
CREATE VIEW active_bookings_view AS
SELECT 
    b.booking_id,
    b.reservation_code,
    u.full_name AS guest_name,
    u.email,
    u.phone,
    r.room_number,
    b.check_in_date,
    b.check_out_date,
    b.monthly_amount,
    b.status,
    b.created_at
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN rooms r ON b.room_id = r.room_id
WHERE b.status IN ('pending', 'confirmed');

-- View: Room availability
CREATE VIEW room_availability_view AS
SELECT 
    room_id,
    room_number,
    room_type,
    capacity,
    current_occupancy,
    (capacity - current_occupancy) AS available_slots,
    price_per_month,
    status
FROM rooms
WHERE status = 'available' AND current_occupancy < capacity;

-- =====================================================
-- END OF DATABASE SCHEMA
-- =====================================================

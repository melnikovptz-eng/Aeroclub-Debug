CREATE DATABASE IF NOT EXISTS kd_pilot
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE kd_pilot;

CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  email VARCHAR(190) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('pilot','instructor','dispatcher','admin') NOT NULL DEFAULT 'pilot',
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pilots (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NULL,
  display_name VARCHAR(160) NOT NULL,
  phone VARCHAR(40) NULL,
  telegram VARCHAR(100) NULL,
  max_flight_level VARCHAR(100) NULL,
  notes TEXT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_pilots_user (user_id),
  CONSTRAINT fk_pilots_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS spots (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(160) NOT NULL,
  description VARCHAR(500) NULL,
  latitude DECIMAL(10,7) NULL,
  longitude DECIMAL(10,7) NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_spots_name (name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS flights (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  title VARCHAR(190) NOT NULL,
  flight_date DATE NOT NULL,
  time_from TIME NULL,
  time_to TIME NULL,
  spot_id BIGINT UNSIGNED NULL,
  wind_text VARCHAR(160) NULL,
  discipline VARCHAR(120) NULL,
  is_competition TINYINT(1) NOT NULL DEFAULT 0,
  participant_limit SMALLINT UNSIGNED NULL,
  status ENUM('planned','confirmed','completed','cancelled') NOT NULL DEFAULT 'planned',
  initiator_pilot_id BIGINT UNSIGNED NULL,
  description TEXT NULL,
  created_by BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_flights_date_status (flight_date, status),
  CONSTRAINT fk_flights_spot FOREIGN KEY (spot_id) REFERENCES spots(id) ON DELETE SET NULL,
  CONSTRAINT fk_flights_initiator FOREIGN KEY (initiator_pilot_id) REFERENCES pilots(id) ON DELETE SET NULL,
  CONSTRAINT fk_flights_creator FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS flight_participants (
  flight_id BIGINT UNSIGNED NOT NULL,
  pilot_id BIGINT UNSIGNED NOT NULL,
  participation_status ENUM('invited','going','declined','arrived') NOT NULL DEFAULT 'invited',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (flight_id, pilot_id),
  CONSTRAINT fk_fp_flight FOREIGN KEY (flight_id) REFERENCES flights(id) ON DELETE CASCADE,
  CONSTRAINT fk_fp_pilot FOREIGN KEY (pilot_id) REFERENCES pilots(id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT IGNORE INTO spots (name, description) VALUES
('п. Куликово (Склон)', 'Рабочий сектор: С/СВ'),
('п. Донское (Склон)', 'Рабочий сектор: СЗ/З'),
('п. Янтарный (Склон)', 'Рабочий сектор: ЮЗ/З'),
('Аэродром «Северный» (Лебёдка)', 'Лебёдка'),
('п. Сокольники (Поле)', 'Мотор / наземная подготовка');

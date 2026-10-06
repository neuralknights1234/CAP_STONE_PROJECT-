-- ==========================================================
-- SmartAgri OS - Database Initialization Script
-- MySQL 8.x+
-- ==========================================================

CREATE DATABASE IF NOT EXISTS smartagri_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE smartagri_db;

-- Foundation verification query
SELECT 'SmartAgri OS Database successfully initialized' AS status;
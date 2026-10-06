-- ===================================================================
-- SmartAgri OS - Database Schema Architecture
-- Target Database: smartagri_os (MySQL 8.0+)
-- Charset: utf8mb4 | Collation: utf8mb4_unicode_ci
-- ===================================================================

CREATE DATABASE IF NOT EXISTS smartagri_os CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE smartagri_os;

-- 1. ROLES TABLE
CREATE TABLE IF NOT EXISTS roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_roles_name (name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 2. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(30) UNIQUE,
    status VARCHAR(30) DEFAULT 'ACTIVE',
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_email (email),
    INDEX idx_users_phone (phone_number),
    INDEX idx_users_status (status),
    INDEX idx_users_deleted (is_deleted)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- USER ROLES JUNCTION TABLE
CREATE TABLE IF NOT EXISTS user_roles (
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 3. SUBSCRIPTIONS TABLE
CREATE TABLE IF NOT EXISTS subscriptions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    plan_tier VARCHAR(50) NOT NULL DEFAULT 'FREE_TIER',
    billing_cycle VARCHAR(30) NOT NULL DEFAULT 'MONTHLY',
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    max_farms INT DEFAULT 2,
    max_acreage DECIMAL(10, 2) DEFAULT 500.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_subscriptions_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    INDEX idx_subscriptions_user (user_id),
    INDEX idx_subscriptions_status (status)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 4. FARMS TABLE
CREATE TABLE IF NOT EXISTS farms (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    name VARCHAR(150) NOT NULL,
    location VARCHAR(255),
    area DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_acreage DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    farm_type VARCHAR(100) DEFAULT 'Commercial',
    ownership VARCHAR(100) DEFAULT 'Owned',
    soil_type VARCHAR(100),
    irrigation_method VARCHAR(100) DEFAULT 'Drip Irrigation',
    is_active BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_farms_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT,
    INDEX idx_farms_user (user_id),
    INDEX idx_farms_deleted (is_deleted)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 5. FIELDS TABLE
CREATE TABLE IF NOT EXISTS fields (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farm_id BIGINT NOT NULL,
    name VARCHAR(100) NOT NULL,
    area DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    acreage DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    crop_id BIGINT NULL,
    crop_name VARCHAR(100) NULL,
    soil_type VARCHAR(100) NULL,
    irrigation_method VARCHAR(100) DEFAULT 'Drip Irrigation',
    planting_date DATE NULL,
    expected_harvest_date DATE NULL,
    growth_stage VARCHAR(50) DEFAULT 'Vegetative',
    health_percentage INT DEFAULT 90,
    boundary_geojson JSON,
    soil_ph DECIMAL(4, 2),
    organic_matter_pct DECIMAL(5, 2),
    irrigation_type VARCHAR(50) DEFAULT 'Drip Irrigation',
    is_active BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_fields_farm FOREIGN KEY (farm_id) REFERENCES farms (id) ON DELETE CASCADE,
    INDEX idx_fields_farm (farm_id),
    INDEX idx_fields_crop (crop_id),
    INDEX idx_fields_deleted (is_deleted)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 6. CROPS TABLE
CREATE TABLE IF NOT EXISTS crops (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150),
    variety VARCHAR(100),
    category VARCHAR(50) NOT NULL,
    optimal_gdd DECIMAL(8, 2),
    days_to_maturity INT,
    water_requirement_mm DECIMAL(8, 2),
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_crops_category (category),
    INDEX idx_crops_name (name)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 7. CROP PLANS TABLE
CREATE TABLE IF NOT EXISTS crop_plans (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    field_id BIGINT NOT NULL,
    crop_id BIGINT NOT NULL,
    season VARCHAR(50) NOT NULL,
    target_yield DECIMAL(10, 2),
    planned_sowing_date DATE NOT NULL,
    planned_harvest_date DATE,
    actual_sowing_date DATE,
    actual_harvest_date DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'PLANNED',
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_crop_plans_field FOREIGN KEY (field_id) REFERENCES fields (id) ON DELETE CASCADE,
    CONSTRAINT fk_crop_plans_crop FOREIGN KEY (crop_id) REFERENCES crops (id) ON DELETE RESTRICT,
    INDEX idx_crop_plans_field (field_id),
    INDEX idx_crop_plans_crop (crop_id),
    INDEX idx_crop_plans_status (status),
    INDEX idx_crop_plans_season (season)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 8. CROP ACTIVITIES TABLE
CREATE TABLE IF NOT EXISTS crop_activities (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    crop_plan_id BIGINT NOT NULL,
    activity_type VARCHAR(50) NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    scheduled_date DATE NOT NULL,
    completed_date DATE,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    cost DECIMAL(10, 2) DEFAULT 0.00,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_crop_activities_plan FOREIGN KEY (crop_plan_id) REFERENCES crop_plans (id) ON DELETE CASCADE,
    INDEX idx_crop_activities_plan (crop_plan_id),
    INDEX idx_crop_activities_scheduled (scheduled_date),
    INDEX idx_crop_activities_status (status)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 9. EXPENSES TABLE
CREATE TABLE IF NOT EXISTS expenses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farm_id BIGINT NOT NULL,
    field_id BIGINT,
    category VARCHAR(50) NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'USD',
    transaction_date DATE NOT NULL,
    receipt_url VARCHAR(255),
    notes TEXT,
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_expenses_farm FOREIGN KEY (farm_id) REFERENCES farms (id) ON DELETE CASCADE,
    CONSTRAINT fk_expenses_field FOREIGN KEY (field_id) REFERENCES fields (id) ON DELETE SET NULL,
    INDEX idx_expenses_farm (farm_id),
    INDEX idx_expenses_category (category),
    INDEX idx_expenses_date (transaction_date),
    INDEX idx_expenses_deleted (is_deleted)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 10. REVENUES TABLE
CREATE TABLE IF NOT EXISTS revenues (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farm_id BIGINT NOT NULL,
    crop_plan_id BIGINT,
    crop_name VARCHAR(100) NOT NULL,
    quantity_sold DECIMAL(10, 2) NOT NULL,
    unit VARCHAR(30) NOT NULL DEFAULT 'TONS',
    price_per_unit DECIMAL(10, 2) NOT NULL,
    total_revenue DECIMAL(12, 2) NOT NULL,
    transaction_date DATE NOT NULL,
    buyer_name VARCHAR(150),
    is_deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_revenues_farm FOREIGN KEY (farm_id) REFERENCES farms (id) ON DELETE CASCADE,
    CONSTRAINT fk_revenues_plan FOREIGN KEY (crop_plan_id) REFERENCES crop_plans (id) ON DELETE SET NULL,
    INDEX idx_revenues_farm (farm_id),
    INDEX idx_revenues_date (transaction_date),
    INDEX idx_revenues_deleted (is_deleted)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 11. WEATHER DATA TABLE
CREATE TABLE IF NOT EXISTS weather_data (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farm_id BIGINT NOT NULL,
    recorded_at TIMESTAMP NOT NULL,
    temperature_c DECIMAL(5, 2) NOT NULL,
    humidity_pct DECIMAL(5, 2),
    precipitation_mm DECIMAL(6, 2) DEFAULT 0.00,
    wind_speed_kmh DECIMAL(5, 2),
    solar_radiation_wm2 DECIMAL(7, 2),
    et0_mm DECIMAL(5, 2),
    condition_code VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_weather_farm FOREIGN KEY (farm_id) REFERENCES farms (id) ON DELETE CASCADE,
    INDEX idx_weather_farm (farm_id),
    INDEX idx_weather_recorded (recorded_at)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 12. FERTILIZER SCHEDULES TABLE
CREATE TABLE IF NOT EXISTS fertilizer_schedules (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    crop_plan_id BIGINT NOT NULL,
    nutrient_type VARCHAR(50) NOT NULL,
    target_amount_kg_ha DECIMAL(8, 2) NOT NULL,
    stage_trigger VARCHAR(50) NOT NULL,
    scheduled_date DATE NOT NULL,
    status VARCHAR(30) DEFAULT 'PENDING',
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_fert_schedule_plan FOREIGN KEY (crop_plan_id) REFERENCES crop_plans (id) ON DELETE CASCADE,
    INDEX idx_fert_schedule_plan (crop_plan_id),
    INDEX idx_fert_schedule_date (scheduled_date)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 13. FERTILIZER APPLICATIONS TABLE
CREATE TABLE IF NOT EXISTS fertilizer_applications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    schedule_id BIGINT,
    field_id BIGINT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    nitrogen_n DECIMAL(5, 2) DEFAULT 0.00,
    phosphorus_p DECIMAL(5, 2) DEFAULT 0.00,
    potassium_k DECIMAL(5, 2) DEFAULT 0.00,
    quantity_applied_kg DECIMAL(10, 2) NOT NULL,
    application_date DATE NOT NULL,
    operator_name VARCHAR(100),
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_fert_app_schedule FOREIGN KEY (schedule_id) REFERENCES fertilizer_schedules (id) ON DELETE SET NULL,
    CONSTRAINT fk_fert_app_field FOREIGN KEY (field_id) REFERENCES fields (id) ON DELETE CASCADE,
    INDEX idx_fert_app_field (field_id),
    INDEX idx_fert_app_date (application_date)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 14. INVENTORY TABLE
CREATE TABLE IF NOT EXISTS inventory (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farm_id BIGINT NOT NULL,
    item_name VARCHAR(150) NOT NULL,
    sku VARCHAR(100),
    category VARCHAR(50) NOT NULL,
    current_stock DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    minimum_stock DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    unit VARCHAR(30) NOT NULL,
    unit_cost DECIMAL(10, 2) DEFAULT 0.00,
    storage_location VARCHAR(150),
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_farm FOREIGN KEY (farm_id) REFERENCES farms (id) ON DELETE CASCADE,
    INDEX idx_inventory_farm (farm_id),
    INDEX idx_inventory_category (category)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 15. INVENTORY TRANSACTIONS TABLE
CREATE TABLE IF NOT EXISTS inventory_transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    inventory_id BIGINT NOT NULL,
    transaction_type VARCHAR(30) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    unit_cost DECIMAL(10, 2) NOT NULL,
    reference_id VARCHAR(100),
    transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inv_tx_inventory FOREIGN KEY (inventory_id) REFERENCES inventory (id) ON DELETE CASCADE,
    INDEX idx_inv_tx_inventory (inventory_id),
    INDEX idx_inv_tx_date (transaction_date)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 16. YIELD PREDICTIONS TABLE
CREATE TABLE IF NOT EXISTS yield_predictions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    crop_plan_id BIGINT NOT NULL,
    predicted_yield_tons DECIMAL(10, 2) NOT NULL,
    confidence_score DECIMAL(5, 4) NOT NULL,
    lower_bound_tons DECIMAL(10, 2),
    upper_bound_tons DECIMAL(10, 2),
    model_version VARCHAR(50) NOT NULL DEFAULT 'v1.0-rf',
    prediction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    features_json JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_yield_plan FOREIGN KEY (crop_plan_id) REFERENCES crop_plans (id) ON DELETE CASCADE,
    INDEX idx_yield_plan (crop_plan_id),
    INDEX idx_yield_date (prediction_date)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 17. NOTIFICATIONS TABLE
CREATE TABLE IF NOT EXISTS notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL DEFAULT 'INFO',
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    link_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    INDEX idx_notifications_user (user_id),
    INDEX idx_notifications_unread (user_id, is_read)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 18. FARM TASKS TABLE
CREATE TABLE IF NOT EXISTS farm_tasks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    farm_id BIGINT NOT NULL,
    assigned_to_user_id BIGINT,
    field_id BIGINT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    priority VARCHAR(30) NOT NULL DEFAULT 'MEDIUM',
    due_date DATE,
    completed_at TIMESTAMP NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'TODO',
    is_deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_tasks_farm FOREIGN KEY (farm_id) REFERENCES farms (id) ON DELETE CASCADE,
    CONSTRAINT fk_tasks_user FOREIGN KEY (assigned_to_user_id) REFERENCES users (id) ON DELETE SET NULL,
    CONSTRAINT fk_tasks_field FOREIGN KEY (field_id) REFERENCES fields (id) ON DELETE SET NULL,
    INDEX idx_tasks_farm (farm_id),
    INDEX idx_tasks_assigned (assigned_to_user_id),
    INDEX idx_tasks_status (status),
    INDEX idx_tasks_due (due_date)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 19. AI CONVERSATIONS TABLE
CREATE TABLE IF NOT EXISTS ai_conversations (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    session_id VARCHAR(100) NOT NULL,
    title VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_ai_conv_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    INDEX idx_ai_conv_session (session_id),
    INDEX idx_ai_conv_user (user_id),
    INDEX idx_ai_conv_updated (updated_at)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 20. AI MESSAGES TABLE
CREATE TABLE IF NOT EXISTS ai_messages (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    conversation_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    role VARCHAR(30) NOT NULL,
    content TEXT NOT NULL,
    answer TEXT,
    related_farm_data TEXT,
    recommendation TEXT,
    reason TEXT,
    data_used VARCHAR(255),
    disclaimer TEXT,
    is_high_risk BOOLEAN DEFAULT FALSE,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ai_msg_conv FOREIGN KEY (conversation_id) REFERENCES ai_conversations (id) ON DELETE CASCADE,
    CONSTRAINT fk_ai_msg_user FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    INDEX idx_ai_msg_conv (conversation_id),
    INDEX idx_ai_msg_user (user_id),
    INDEX idx_ai_msg_time (timestamp)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Seed Default Security Roles
INSERT IGNORE INTO
    roles (id, name, description)
VALUES (
        1,
        'ROLE_SUPER_ADMIN',
        'Platform System Administrator'
    ),
    (
        2,
        'ROLE_FARM_OWNER',
        'Commercial Farm Operator & Owner'
    ),
    (
        3,
        'ROLE_AGRONOMIST',
        'Precision Agricultural Specialist'
    ),
    (
        4,
        'ROLE_OPERATOR',
        'Field Tractor & Chores Operator'
    );
# SmartAgri OS - Database Configuration

## Overview
SmartAgri OS uses **MySQL 8.0+** as its primary relational database. The persistence layer is orchestrated via **Spring Data JPA** and **Hibernate**.

## Database Name
- **Target Schema**: `smartagri_os`
- **Character Set**: `utf8mb4`
- **Collation**: `utf8mb4_unicode_ci`

## Connection Parameters
The database connection is defined via environment variables with developer-friendly defaults in `backend/src/main/resources/application.properties`:

| Environment Variable | Description | Default |
|----------------------|-------------|---------|
| `DB_HOST` | MySQL hostname or IP | `localhost` |
| `DB_PORT` | MySQL listening port | `3306` |
| `DB_NAME` | Database schema name | `smartagri_os` |
| `DB_USERNAME` | Database username | `root` |
| `DB_PASSWORD` | Database user password | `root` |
| `JPA_DDL_AUTO` | Hibernate schema management | `update` (dev) / `validate` (prod) |

## Quick Setup

### 1. Using MySQL CLI
```bash
mysql -u root -p < database/schema.sql
```

### 2. Architecture Tables (19 Core Tables)
1. `users` — System accounts, contact info, security hashes, and soft delete.
2. `roles` & `user_roles` — Granular role-based access control (RBAC).
3. `subscriptions` — Multi-tenant tier limits (max farms, max acreage).
4. `farms` — Physical enterprise agricultural holdings.
5. `fields` — Subdivided parcels with acreage, soil pH, and boundary GeoJSON.
6. `crops` — Cultivar genetic profiles, thermal GDD needs, and maturity days.
7. `crop_plans` — Sowing and harvest milestones per field season.
8. `crop_activities` — Operational chores, soil tillage, and scoutings.
9. `expenses` — Input expenses (fertilizer, diesel, seed bags, labor).
10. `revenues` — Grain marketing sales, forward contracts, and receipts.
11. `weather_data` — Hyper-local telemetry, solar radiation, rainfall, and ET0.
12. `fertilizer_schedules` — Prescribed nutrient applications by growth stage.
13. `fertilizer_applications` — Traceable chemical/organic application audit log.
14. `inventory` — Warehouse stock balances, reorder points, and storage sheds.
15. `inventory_transactions` — Warehouse receipt and depletion audit entries.
16. `yield_predictions` — AI machine learning forecasts with confidence intervals.
17. `notifications` — High-priority hazard and chore alerts.
18. `farm_tasks` — Field chore board linked to operators and parcel coordinates.
19. `ai_conversations` — Conversational agronomist chat sessions and token tracking.

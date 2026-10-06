# SmartAgri OS - System Architecture

## 1. System Vision & Overview
**SmartAgri OS** is an AI-powered digital operating system designed for precision agriculture, farm management, and operational decision support.

The operational backbone of the platform is centered on the **Core Product Loop**:
```
PLAN  -->  GROW  -->  MONITOR  -->  PREDICT  -->  ACT  -->  PROFIT
```

---

## 2. High-Level Technology Stack

### Frontend Application
- **Runtime & Build**: React 18 / 19, Vite (ESM bundler)
- **Styling & Design System**: Tailwind CSS with custom Agricultural Technology theme (Forest/Emerald, Soft Cream, Sage, Warm Slate)
- **Navigation & Routing**: React Router v6 with desktop sidebar & mobile bottom navigation
- **Visualization**: Recharts (for yield analytics, expense tracking, weather trends)
- **Icons**: Lucide React
- **HTTP Client**: Axios with centralized request/response interceptors

### Backend Service
- **Runtime**: Java 21 LTS
- **Framework**: Spring Boot 3.3.x (Spring Web, Spring Security 6, Spring Data JPA, Jakarta Bean Validation)
- **Security Engine**: Stateless JWT (JSON Web Tokens) with BCrypt password hashing
- **Persistence**: Hibernate ORM with MySQL 8.0+
- **Architecture**: Domain-Driven Layered Clean Architecture (Controller -> Service -> Repository -> Database)

---

## 3. Layered Clean Architecture

```
┌────────────────────────────────────────────────────────┐
│                   React + Vite SPA                     │
│  (Desktop Sidebar, Mobile Bottom Bar, Lucide, Recharts)│
└───────────────────────────┬────────────────────────────┘
                            │ REST / JSON (JWT in Header)
┌───────────────────────────▼────────────────────────────┐
│                Spring Boot REST Gateway                │
│                 (/api/v1 - Port 8080)                  │
├────────────────────────────────────────────────────────┤
│  Security Layer       │  SecurityFilterChain, JWT Auth │
│  Web / Controller     │  @RestController, Validation   │
│  DTO & Mapper Layer   │  Request/Response DTOs, Mappers│
│  Service Layer        │  Domain Business Logic (Tx)    │
│  Repository Layer     │  Spring Data JPA Interfaces    │
│  Entity Layer         │  BaseAuditEntity, JPA Entities │
├───────────────────────────┬────────────────────────────┤
│     MySQL 8.0+ Database   │ (smartagri_db, utf8mb4)    │
└───────────────────────────┴────────────────────────────┘
```

---

## 4. Key Architectural Rules Enforced
1. **Zero Direct Entity Exposure**: JPA Entities never leak to controllers or clients. All payloads use strictly typed Request/Response DTOs.
2. **Centralized Exception Handling**: `@RestControllerAdvice` converts exceptions into standardized `ErrorResponse` objects with HTTP status codes and timestamps.
3. **Stateless Authentication**: No HTTP sessions stored in memory; all authentication uses cryptographic JWT tokens.
4. **Environment Isolation**: Database credentials, JWT secrets, and port bindings are externalized to environment variables with fallback defaults.
5. **Farmer-Centric UX**: High contrast, legible typography, generous spacing, intuitive desktop and mobile navigation layouts.

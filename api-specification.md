# SmartAgri OS - API Specification & Endpoint Directory

Base URL: `http://localhost:8080/api/v1`

## 1. System & Health Endpoints (Active in Foundation Phase)

### Health Status Check
- **Endpoint**: `GET /api/v1/health`
- **Access**: Public
- **Description**: Inspects JVM memory, runtime parameters, active profile, and system status.
- **Response**:
```json
{
  "success": true,
  "message": "SmartAgri OS backend is healthy and running",
  "data": {
    "application": "smartagri-backend",
    "version": "1.0.0-SNAPSHOT",
    "status": "UP",
    "environment": "dev",
    "timestamp": "2026-09-30T16:30:00Z",
    "details": {
      "jvmVersion": "21.0.12.1",
      "availableProcessors": 12,
      "freeMemoryMb": 182,
      "totalMemoryMb": 256
    }
  },
  "timestamp": "2026-09-30T16:30:00Z"
}
```

### Ping Handshake
- **Endpoint**: `GET /api/v1/ping`
- **Access**: Public
- **Response**:
```json
{
  "success": true,
  "message": "SmartAgri OS API v1",
  "data": "pong",
  "timestamp": "2026-09-30T16:30:00Z"
}
```

---

## 2. Planned Domain Modules & Controller Endpoints

| Domain | Controller | Base Path | Methods |
|---|---|---|---|
| **Authentication** | `AuthController` | `/api/v1/auth` | `POST /register`, `POST /login`, `POST /refresh` |
| **Farms & Fields** | `FarmController` | `/api/v1/farms` | `GET /`, `POST /`, `GET /{id}`, `PUT /{id}`, `GET /{id}/fields` |
| **Crop Planner** | `CropCycleController` | `/api/v1/crop-cycles` | `GET /`, `POST /`, `GET /{id}`, `PUT /{id}/stage` |
| **Fertilizer Plans** | `FertilizerController` | `/api/v1/fertilizer` | `GET /schedules`, `POST /applications`, `GET /history` |
| **Weather Telemetry** | `WeatherController` | `/api/v1/weather` | `GET /current`, `GET /forecast`, `GET /alerts` |
| **Yield Modeling** | `YieldController` | `/api/v1/yield` | `POST /predict`, `GET /analytics/{cropCycleId}` |
| **Financial Ledger** | `FinanceController` | `/api/v1/finances` | `GET /transactions`, `POST /transactions`, `GET /analytics` |
| **Inventory** | `InventoryController` | `/api/v1/inventory` | `GET /`, `POST /`, `PUT /{id}`, `POST /{id}/adjust` |
| **Tasks** | `TaskController` | `/api/v1/tasks` | `GET /`, `POST /`, `PATCH /{id}/status` |
| **Farm Intelligence** | `IntelligenceController` | `/api/v1/intelligence` | `GET /insights`, `POST /ai/chat` |

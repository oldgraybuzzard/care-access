# API Documentation

## Base URL

- Development: `http://localhost:3000`
- Production: `https://your-api.railway.app`

## Authentication

All endpoints (except `/auth/login`) require a JWT token in the Authorization header:

```
Authorization: Bearer <access_token>
```

### POST /auth/login

Login with email and password.

**Request:**
```json
{
  "email": "admin@fcf.org",
  "password": "admin123"
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGc...",
  "refreshToken": "eyJhbGc...",
  "user": {
    "id": "uuid",
    "email": "admin@fcf.org",
    "name": "Admin User",
    "roles": ["admin"]
  }
}
```

### POST /auth/refresh

Refresh access token using refresh token.

**Request:**
```json
{
  "refreshToken": "eyJhbGc..."
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGc..."
}
```

### POST /auth/logout

Logout and invalidate tokens.

## Clients

### GET /clients

Get all clients with pagination and filtering.

**Query Parameters:**
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 20)
- `search` (string): Search by name
- `status` (string): Filter by status

**Response:**
```json
{
  "data": [
    {
      "id": "uuid",
      "firstName": "John",
      "lastName": "Doe",
      "dob": "1990-01-15",
      "status": "active",
      "createdAt": "2024-01-01T00:00:00Z"
    }
  ],
  "meta": {
    "total": 100,
    "page": 1,
    "limit": 20,
    "totalPages": 5
  }
}
```

### GET /clients/:id

Get client details by ID.

**Response:**
```json
{
  "id": "uuid",
  "firstName": "John",
  "lastName": "Doe",
  "dob": "1990-01-15",
  "status": "active",
  "cases": [...],
  "createdAt": "2024-01-01T00:00:00Z"
}
```

## Cases

### GET /cases

Get all cases with pagination and filtering.

**Query Parameters:**
- `page`, `limit`: Pagination
- `clientId`: Filter by client
- `programId`: Filter by program
- `status`: Filter by status
- `workerId`: Filter by assigned worker

### GET /cases/:id

Get case details including activities and services.

## Reports

### POST /reports/caseload-by-worker

Generate caseload by worker report.

**Request:**
```json
{
  "programId": "uuid",
  "asOfDate": "2024-01-08"
}
```

**Response:**
```json
{
  "data": [
    {
      "workerId": "uuid",
      "workerName": "Jane Smith",
      "activeCases": 15,
      "cases": [...]
    }
  ]
}
```

### POST /reports/active-cases-by-program

Generate active cases by program/status report.

### POST /reports/intakes-vs-closures

Generate intakes vs closures trend report.

**Request:**
```json
{
  "startDate": "2024-01-01",
  "endDate": "2024-12-31",
  "programId": "uuid"
}
```

### POST /reports/custom

Execute custom report query.

**Request:**
```json
{
  "select": ["client.firstName", "case.status"],
  "from": "cases",
  "joins": ["client"],
  "where": {
    "status": "active",
    "programId": "uuid"
  },
  "groupBy": ["status"],
  "orderBy": [{"field": "createdAt", "direction": "desc"}]
}
```

## KPIs

### GET /kpis/daily

Get daily KPI rollups.

**Query Parameters:**
- `startDate`: Start date (YYYY-MM-DD)
- `endDate`: End date (YYYY-MM-DD)
- `programId`: Filter by program
- `workerId`: Filter by worker

**Response:**
```json
{
  "data": [
    {
      "date": "2024-01-08",
      "activeCases": 150,
      "intakes": 5,
      "closures": 3,
      "programId": "uuid",
      "workerId": null
    }
  ]
}
```

### GET /kpis/current

Get current KPIs (real-time).

## Error Responses

All errors follow this format:

```json
{
  "statusCode": 400,
  "message": "Error message",
  "error": "Bad Request"
}
```

Common status codes:
- `400`: Bad Request
- `401`: Unauthorized
- `403`: Forbidden
- `404`: Not Found
- `500`: Internal Server Error


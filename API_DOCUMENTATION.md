# FlowUp Backend API Documentation

## Overview

FlowUp is a money management mobile application backend built with **NestJS** and **TypeORM**. This API provides comprehensive endpoints for tracking income, expenses, savings goals, investments, and categories.

### Base Information

- **Framework**: NestJS v11.0.1 (TypeScript)
- **Database**: PostgreSQL with TypeORM
- **Authentication**: JWT Bearer Token
- **Default Port**: 3000 (configurable via `PORT` environment variable to 8000)
- **Base URL**: `http://localhost:8000` (or configured port)
- **Content-Type**: `application/json`

### Authentication

Most endpoints require JWT authentication. After logging in, include the JWT token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

**Public Endpoints** (No authentication required):
- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/forgot-password`
- `POST /api/auth/reset-password`

**Protected Endpoints**: All other endpoints require authentication.

---

## Table of Contents

1. [Authentication](#1-authentication)
2. [Transactions](#2-transactions)
3. [Goals](#3-goals)
4. [Ingresos (Income)](#4-ingresos-income)
5. [Gastos (Expenses)](#5-gastos-expenses)
6. [Ahorros (Savings)](#6-ahorros-savings)
7. [Inversiones (Investments)](#7-inversiones-investments)
8. [Categorías (Categories)](#8-categorías-categories)
9. [Dashboard](#9-dashboard)

---

## 1. Authentication

### 1.1 Register User

**Endpoint**: `POST /api/auth/register`

**Authentication**: None (Public)

**Request Body**:
```json
{
  "name": "string",
  "email": "string (valid email)",
  "password": "string"
}
```

**Example Request**:
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response**: User object with authentication token

---

### 1.2 Login

**Endpoint**: `POST /api/auth/login`

**Authentication**: None (Public)

**Request Body**:
```json
{
  "email": "string (valid email)",
  "password": "string"
}
```

**Example Request**:
```json
{
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response**: Authentication token and user information

---

### 1.3 Forgot Password

**Endpoint**: `POST /api/auth/forgot-password`

**Authentication**: None (Public)

**Request Body**:
```json
{
  "email": "string (valid email)"
}
```

**Example Request**:
```json
{
  "email": "john@example.com"
}
```

**Response**: Password reset instructions

---

### 1.4 Reset Password

**Endpoint**: `POST /api/auth/reset-password`

**Authentication**: None (Public)

**Request Body**:
```json
{
  "token": "string",
  "newPassword": "string"
}
```

**Example Request**:
```json
{
  "token": "reset-token-from-email",
  "newPassword": "newSecurePassword123"
}
```

**Response**: Success confirmation

---

## 2. Transactions

### 2.1 List All Transactions

**Endpoint**: `GET /api/transactions`

**Authentication**: Required

**Query Parameters**:
- `type` (optional): Filter by type - `"income"` or `"expense"`
- `category` (optional): Filter by category name
- `q` (optional): Search query string
- `skip` (optional): Number of records to skip (default: 0)
- `limit` (optional): Number of records to return (default: 100)

**Example Request**:
```
GET /api/transactions?type=expense&category=Food&skip=0&limit=20
```

**Response**: Array of transaction objects

---

### 2.2 Create Transaction

**Endpoint**: `POST /api/transactions`

**Authentication**: Required

**Request Body**:
```json
{
  "type": "income" | "expense",
  "amount": "string (numeric format, e.g., '100.50')",
  "currency": "string (optional, default: 'USD')",
  "category": "string (optional)",
  "description": "string (optional)",
  "isRecurring": "boolean (optional)",
  "date": "string (ISO date format, optional)"
}
```

**Example Request**:
```json
{
  "type": "expense",
  "amount": "45.99",
  "currency": "USD",
  "category": "Food",
  "description": "Grocery shopping",
  "isRecurring": false,
  "date": "2025-11-10T10:00:00Z"
}
```

**Response**: Created transaction object

---

### 2.3 Get Transaction by ID

**Endpoint**: `GET /api/transactions/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Transaction UUID

**Example Request**:
```
GET /api/transactions/123e4567-e89b-12d3-a456-426614174000
```

**Response**: Transaction object

---

### 2.4 Update Transaction

**Endpoint**: `PUT /api/transactions/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Transaction UUID

**Request Body**: Same as Create Transaction (all fields optional)

**Example Request**:
```json
{
  "amount": "50.00",
  "description": "Updated grocery shopping total"
}
```

**Response**: Updated transaction object

---

### 2.5 Delete Transaction

**Endpoint**: `DELETE /api/transactions/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Transaction UUID

**Example Request**:
```
DELETE /api/transactions/123e4567-e89b-12d3-a456-426614174000
```

**Response**: Success confirmation

---

## 3. Goals

### 3.1 List All Goals

**Endpoint**: `GET /api/goals`

**Authentication**: Required

**Query Parameters**:
- `status` (optional): Filter by status - `"ACTIVE"`, `"COMPLETED"`, or `"PAUSED"`
- `q` (optional): Search query string
- `skip` (optional): Number of records to skip (default: 0)
- `take` (optional): Number of records to return (default: 100)

**Example Request**:
```
GET /api/goals?status=ACTIVE&skip=0&take=10
```

**Response**: Array of goal objects

---

### 3.2 Create Goal

**Endpoint**: `POST /api/goals`

**Authentication**: Required

**Request Body**:
```json
{
  "title": "string (max 100 chars)",
  "targetAmount": "string (numeric format)",
  "deadline": "string (ISO date format, optional)",
  "status": "ACTIVE" | "COMPLETED" | "PAUSED" (optional, default: "ACTIVE")
}
```

**Example Request**:
```json
{
  "title": "Save for vacation",
  "targetAmount": "5000.00",
  "deadline": "2025-12-31",
  "status": "ACTIVE"
}
```

**Response**: Created goal object

---

### 3.3 Get Goal by ID

**Endpoint**: `GET /api/goals/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Goal UUID

**Example Request**:
```
GET /api/goals/123e4567-e89b-12d3-a456-426614174000
```

**Response**: Goal object with current progress

---

### 3.4 Update Goal (PATCH)

**Endpoint**: `PATCH /api/goals/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Goal UUID

**Request Body**: Partial goal update (all fields optional)

**Example Request**:
```json
{
  "status": "COMPLETED"
}
```

**Response**: Updated goal object

---

### 3.5 Update Goal (PUT)

**Endpoint**: `PUT /api/goals/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Goal UUID

**Request Body**: Same as PATCH (all fields optional)

**Response**: Updated goal object

---

### 3.6 Delete Goal

**Endpoint**: `DELETE /api/goals/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Goal UUID

**Response**: Success confirmation

---

### 3.7 Add Contribution to Goal

**Endpoint**: `POST /api/goals/:id/contributions`

**Authentication**: Required

**URL Parameters**:
- `id`: Goal UUID

**Request Body**:
```json
{
  "amount": "string (numeric format)",
  "notes": "string (max 200 chars, optional)"
}
```

**Example Request**:
```json
{
  "amount": "250.00",
  "notes": "Monthly savings contribution"
}
```

**Response**: Created contribution object

---

### 3.8 List Goal Contributions

**Endpoint**: `GET /api/goals/:id/contributions`

**Authentication**: Required

**URL Parameters**:
- `id`: Goal UUID

**Example Request**:
```
GET /api/goals/123e4567-e89b-12d3-a456-426614174000/contributions
```

**Response**: Array of contribution objects for the specified goal

---

## 4. Ingresos (Income)

### 4.1 List All Income

**Endpoint**: `GET /api/ingresos`

**Authentication**: Required

**Query Parameters**:
- `q` (optional): Search query string
- `category` (optional): Filter by category
- `skip` (optional): Number of records to skip (default: 0)
- `limit` (optional): Number of records to return (default: 100)
- `from` (optional): Start date filter (ISO format)
- `to` (optional): End date filter (ISO format)

**Example Request**:
```
GET /api/ingresos?category=Salary&from=2025-01-01&to=2025-12-31&limit=50
```

**Response**: Array of income objects

---

### 4.2 Search Income

**Endpoint**: `GET /api/ingresos/search`

**Authentication**: Required

**Query Parameters**:
- `query`: Search string

**Example Request**:
```
GET /api/ingresos/search?query=salary
```

**Response**: Array of matching income objects

---

### 4.3 Get Total Income

**Endpoint**: `GET /api/ingresos/total`

**Authentication**: Required

**Query Parameters**:
- `from` (optional): Start date filter (ISO format)
- `to` (optional): End date filter (ISO format)

**Example Request**:
```
GET /api/ingresos/total?from=2025-01-01&to=2025-12-31
```

**Response**: Total income amount for the specified period

---

### 4.4 Get Income by ID

**Endpoint**: `GET /api/ingresos/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Income UUID

**Response**: Income object

---

### 4.5 Create Income

**Endpoint**: `POST /api/ingresos`

**Authentication**: Required

**Request Body**:
```json
{
  "amount": "string (numeric format)",
  "currency": "string (optional, default: 'USD')",
  "category": "string (optional)",
  "description": "string (optional)",
  "date": "string (ISO date format, optional)"
}
```

**Example Request**:
```json
{
  "amount": "3500.00",
  "currency": "USD",
  "category": "Salary",
  "description": "Monthly salary November 2025",
  "date": "2025-11-01T00:00:00Z"
}
```

**Response**: Created income object

---

### 4.6 Update Income

**Endpoint**: `PUT /api/ingresos/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Income UUID

**Request Body**: Same as Create Income (all fields optional)

**Response**: Updated income object

---

### 4.7 Delete Income

**Endpoint**: `DELETE /api/ingresos/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Income UUID

**Response**: Success confirmation

---

## 5. Gastos (Expenses)

### 5.1 List All Expenses

**Endpoint**: `GET /api/gastos`

**Authentication**: Required

**Query Parameters**:
- `q` (optional): Search query string
- `category` (optional): Filter by category
- `skip` (optional): Number of records to skip (default: 0)
- `limit` (optional): Number of records to return (default: 100)
- `from` (optional): Start date filter (ISO format)
- `to` (optional): End date filter (ISO format)

**Example Request**:
```
GET /api/gastos?category=Food&from=2025-11-01&to=2025-11-30&limit=50
```

**Response**: Array of expense objects

---

### 5.2 Search Expenses

**Endpoint**: `GET /api/gastos/search`

**Authentication**: Required

**Query Parameters**:
- `query`: Search string

**Example Request**:
```
GET /api/gastos/search?query=coffee
```

**Response**: Array of matching expense objects

---

### 5.3 Get Total Expenses

**Endpoint**: `GET /api/gastos/total`

**Authentication**: Required

**Query Parameters**:
- `from` (optional): Start date filter (ISO format)
- `to` (optional): End date filter (ISO format)

**Example Request**:
```
GET /api/gastos/total?from=2025-01-01&to=2025-12-31
```

**Response**: Total expense amount for the specified period

---

### 5.4 Get Expense by ID

**Endpoint**: `GET /api/gastos/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Expense UUID

**Response**: Expense object

---

### 5.5 Create Expense

**Endpoint**: `POST /api/gastos`

**Authentication**: Required

**Request Body**:
```json
{
  "amount": "string (numeric format)",
  "currency": "string (optional, default: 'USD')",
  "category": "string (optional)",
  "description": "string (optional)",
  "date": "string (ISO date format, optional)"
}
```

**Example Request**:
```json
{
  "amount": "125.50",
  "currency": "USD",
  "category": "Food",
  "description": "Weekly groceries",
  "date": "2025-11-10T15:30:00Z"
}
```

**Response**: Created expense object

---

### 5.6 Update Expense

**Endpoint**: `PUT /api/gastos/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Expense UUID

**Request Body**: Same as Create Expense (all fields optional)

**Response**: Updated expense object

---

### 5.7 Delete Expense

**Endpoint**: `DELETE /api/gastos/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Expense UUID

**Response**: Success confirmation

---

## 6. Ahorros (Savings)

### 6.1 List All Savings Goals

**Endpoint**: `GET /api/ahorros`

**Authentication**: Required

**Example Request**:
```
GET /api/ahorros
```

**Response**: Array of savings goal objects

---

### 6.2 Get Savings Goal by ID

**Endpoint**: `GET /api/ahorros/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Savings goal UUID

**Response**: Savings goal object

---

### 6.3 Create Savings Goal

**Endpoint**: `POST /api/ahorros`

**Authentication**: Required

**Request Body**:
```json
{
  "title": "string",
  "targetAmount": "string (numeric format)",
  "deadline": "string (ISO date format, optional)"
}
```

**Example Request**:
```json
{
  "title": "Emergency Fund",
  "targetAmount": "10000.00",
  "deadline": "2025-12-31"
}
```

**Response**: Created savings goal object

---

### 6.4 Update Savings Goal

**Endpoint**: `PUT /api/ahorros/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Savings goal UUID

**Request Body**: Same as Create Savings Goal (all fields optional)

**Response**: Updated savings goal object

---

### 6.5 Delete Savings Goal

**Endpoint**: `DELETE /api/ahorros/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Savings goal UUID

**Response**: Success confirmation

---

### 6.6 Add Contribution to Savings

**Endpoint**: `POST /api/ahorros/:id/contribuciones`

**Authentication**: Required

**URL Parameters**:
- `id`: Savings goal UUID

**Request Body**:
```json
{
  "amount": "string (numeric format)",
  "date": "string (ISO date format, optional)",
  "description": "string (optional)",
  "category": "string (optional)"
}
```

**Example Request**:
```json
{
  "amount": "500.00",
  "date": "2025-11-10",
  "description": "Monthly contribution",
  "category": "savings"
}
```

**Response**: Created contribution object

---

### 6.7 List Savings Contributions

**Endpoint**: `GET /api/ahorros/:id/contribuciones`

**Authentication**: Required

**URL Parameters**:
- `id`: Savings goal UUID

**Response**: Array of contribution objects for the savings goal

---

### 6.8 Get Savings Progress

**Endpoint**: `GET /api/ahorros/:id/progreso`

**Authentication**: Required

**URL Parameters**:
- `id`: Savings goal UUID

**Example Request**:
```
GET /api/ahorros/123e4567-e89b-12d3-a456-426614174000/progreso
```

**Response**: Progress information including current amount and percentage toward goal

---

## 7. Inversiones (Investments)

### 7.1 List All Investments

**Endpoint**: `GET /api/inversiones`

**Authentication**: Required

**Query Parameters**:
- `q` (optional): Search query string
- `category` (optional): Filter by category
- `skip` (optional): Number of records to skip (default: 0)
- `limit` (optional): Number of records to return (default: 100)
- `from` (optional): Start date filter (ISO format)
- `to` (optional): End date filter (ISO format)

**Example Request**:
```
GET /api/inversiones?category=ETF&from=2025-01-01&limit=50
```

**Response**: Array of investment objects

---

### 7.2 Search Investments

**Endpoint**: `GET /api/inversiones/search`

**Authentication**: Required

**Query Parameters**:
- `query`: Search string

**Example Request**:
```
GET /api/inversiones/search?query=S&P
```

**Response**: Array of matching investment objects

---

### 7.3 Get Total Investments

**Endpoint**: `GET /api/inversiones/total`

**Authentication**: Required

**Query Parameters**:
- `from` (optional): Start date filter (ISO format)
- `to` (optional): End date filter (ISO format)

**Example Request**:
```
GET /api/inversiones/total?from=2025-01-01&to=2025-12-31
```

**Response**: Total investment amount for the specified period

---

### 7.4 Get Investment by ID

**Endpoint**: `GET /api/inversiones/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Investment UUID

**Response**: Investment object

---

### 7.5 Create Investment

**Endpoint**: `POST /api/inversiones`

**Authentication**: Required

**Request Body**:
```json
{
  "amount": "string (numeric format)",
  "currency": "string (optional, default: 'USD')",
  "category": "string (max 60 chars, optional)",
  "description": "string (max 200 chars, optional)",
  "broker": "string (max 60 chars, optional)",
  "instrument": "string (max 60 chars, optional)",
  "date": "string (ISO date format, optional)"
}
```

**Example Request**:
```json
{
  "amount": "1500.00",
  "currency": "USD",
  "category": "ETF",
  "description": "S&P 500 Index Fund",
  "broker": "Interactive Brokers",
  "instrument": "ETF",
  "date": "2025-11-10T09:00:00Z"
}
```

**Response**: Created investment object

---

### 7.6 Update Investment

**Endpoint**: `PUT /api/inversiones/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Investment UUID

**Request Body**: Same as Create Investment (all fields optional)

**Response**: Updated investment object

---

### 7.7 Delete Investment

**Endpoint**: `DELETE /api/inversiones/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Investment UUID

**Response**: Success confirmation

---

## 8. Categorías (Categories)

### 8.1 List All Categories

**Endpoint**: `GET /api/categorias`

**Authentication**: Required

**Query Parameters**:
- `q` (optional): Search query string
- `scope` (optional): Filter by scope - `"INCOME"`, `"EXPENSE"`, `"SAVING"`, `"INVESTMENT"`, or `"GENERAL"`

**Example Request**:
```
GET /api/categorias?scope=EXPENSE
```

**Response**: Array of category objects

---

### 8.2 Get Category by ID

**Endpoint**: `GET /api/categorias/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Category UUID

**Response**: Category object

---

### 8.3 Create Category

**Endpoint**: `POST /api/categorias`

**Authentication**: Required

**Request Body**:
```json
{
  "name": "string (max 80 chars)",
  "scope": "INCOME" | "EXPENSE" | "SAVING" | "INVESTMENT" | "GENERAL",
  "color": "string (max 16 chars, optional, e.g., '#4F46E5')",
  "icon": "string (max 40 chars, optional, e.g., 'wallet')"
}
```

**Example Request**:
```json
{
  "name": "Groceries",
  "scope": "EXPENSE",
  "color": "#FF5733",
  "icon": "shopping-cart"
}
```

**Response**: Created category object

---

### 8.4 Update Category

**Endpoint**: `PUT /api/categorias/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Category UUID

**Request Body**: Same as Create Category (all fields optional except name and scope)

**Response**: Updated category object

---

### 8.5 Delete Category

**Endpoint**: `DELETE /api/categorias/:id`

**Authentication**: Required

**URL Parameters**:
- `id`: Category UUID

**Response**: Success confirmation

---

## 9. Dashboard

**Note**: Dashboard endpoints use `/dashboard` prefix (without `/api`)

### 9.1 Get Financial Summary

**Endpoint**: `GET /dashboard/summary`

**Authentication**: Required

**Description**: Returns a financial summary including total income, total expenses, and balance for the authenticated user.

**Example Request**:
```
GET /dashboard/summary
```

**Response Example**:
```json
{
  "income": "5000.00",
  "expenses": "3200.50",
  "balance": "1799.50"
}
```

---

### 9.2 Get Chart Data

**Endpoint**: `GET /dashboard/chart-data`

**Authentication**: Required

**Description**: Returns chart data for the last 30 days, grouping income and expenses by day.

**Example Request**:
```
GET /dashboard/chart-data
```

**Response Example**:
```json
{
  "labels": ["2025-10-11", "2025-10-12", "..."],
  "income": [100.00, 0, "..."],
  "expenses": [50.00, 75.00, "..."]
}
```

---

## Data Types and Enums

### Transaction Types (TxType)
- `"income"` - Income transaction
- `"expense"` - Expense transaction

### Goal Status
- `"ACTIVE"` - Goal is currently active
- `"COMPLETED"` - Goal has been completed
- `"PAUSED"` - Goal is paused

### Category Scopes (CategoryScope)
- `"INCOME"` - Category for income
- `"EXPENSE"` - Category for expenses
- `"SAVING"` - Category for savings
- `"INVESTMENT"` - Category for investments
- `"GENERAL"` - General purpose category

### Date Formats
All dates should be in ISO 8601 format:
- Example: `"2025-11-10T15:30:00Z"`
- Date only: `"2025-11-10"`

### Numeric Values
All monetary amounts should be sent as strings in numeric format:
- Valid: `"100.50"`, `"1000.00"`, `"99.99"`
- Invalid: `100.50` (number), `"$100.50"` (with symbol)

---

## Error Handling

The API uses standard HTTP status codes:

- **200 OK**: Request succeeded
- **201 Created**: Resource created successfully
- **400 Bad Request**: Invalid request data (validation error)
- **401 Unauthorized**: Missing or invalid authentication token
- **403 Forbidden**: Authenticated but not authorized
- **404 Not Found**: Resource not found
- **500 Internal Server Error**: Server error

**Error Response Format**:
```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "error": "Bad Request"
}
```

---

## Environment Configuration

### Required Environment Variables

Create a `.env` file with the following variables:

```env
# Server
PORT=8000

# Database
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=your_db_user
DATABASE_PASSWORD=your_db_password
DATABASE_NAME=flowup

# JWT
JWT_SECRET=your_secret_key_here
JWT_EXPIRES_IN=7d
```

---

## Getting Started

### 1. Install Dependencies
```bash
npm install
```

### 2. Set Up Database
```bash
# Using Docker Compose (recommended)
docker-compose up -d

# Or configure PostgreSQL manually
```

### 3. Configure Environment
```bash
cp .env.example .env
# Edit .env with your configuration
```

### 4. Run Database Migrations
```bash
npm run migration:run
```

### 5. Start the Server
```bash
# Development
npm run start:dev

# Production
npm run build
npm run start:prod
```

The API will be available at `http://localhost:8000` (or your configured port).

---

## Testing the API

### Using cURL

**Register a new user**:
```bash
curl -X POST http://localhost:8000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "password123"
  }'
```

**Login**:
```bash
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

**Create an expense** (with token):
```bash
curl -X POST http://localhost:8000/api/gastos \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "amount": "50.00",
    "category": "Food",
    "description": "Lunch"
  }'
```

---

## Additional Notes

### UUID Format
All IDs in the system use UUID v4 format:
- Example: `123e4567-e89b-12d3-a456-426614174000`

### Pagination
List endpoints support pagination via `skip` and `limit` (or `take`) query parameters:
- Default `skip`: 0
- Default `limit`/`take`: 100

### Date Filtering
Many endpoints support date range filtering with `from` and `to` query parameters.

### Search Functionality
Most list endpoints support a `q` query parameter for searching by text.

---

## Support

For issues, questions, or contributions, please refer to the project repository.

**Version**: 1.0.0
**Last Updated**: November 10, 2025

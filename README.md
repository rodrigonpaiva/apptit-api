
<p align="center">
  <a href="https://apptit.io" target="blank">
 <img style="max-width:400px;" src="https://previews.jumpshare.com/thumb/815bc01b796dd6f1733c957c5af19493367bedb244b33f008931a474dfac8d6f3e95bb639217e699707b7a59331f1a0080605dcab6e7ccad1e304e8a018401bb6128b5c7b8d34796378b19d348fbc76f"></a>
</p>

<p align="center">
  <b>Apptit API</b> – A microservice-oriented backend for collective catering management.  
  Built with <a href="http://nodejs.org" target="_blank">Node.js</a>, <a href="https://nestjs.com/" target="_blank">NestJS</a>, <a href="https://www.prisma.io/" target="_blank">Prisma</a>, and <a href="https://www.postgresql.org/" target="_blank">PostgreSQL</a>.
</p>

<p align="center">
<a href="https://www.npmjs.com/package/@nestjs/core" target="_blank"><img src="https://img.shields.io/npm/v/@nestjs/core.svg" alt="NestJS Version" /></a>
<a href="https://github.com/rodrigopaivadev/apptit-api" target="_blank"><img src="https://img.shields.io/github/license/rodrigopaivadev/apptit-api" alt="License" /></a>
<a href="https://circleci.com/gh/rodrigopaivadev/apptit-api" target="_blank"><img src="https://img.shields.io/circleci/build/github/rodrigopaivadev/apptit-api/master" alt="Build Status" /></a>
<a href="https://discord.gg/G7Qnnhy" target="_blank"><img src="https://img.shields.io/badge/community-discord-blue.svg" alt="Discord"/></a>
</p>

---

## 📖 Description

Apptit API is the backend of the **Apptit project**, an intelligent system for collective catering.  
It integrates with **Open Food Facts (OFF)** to fetch product information, validates data with **Zod**, and manages stock through **Prisma + PostgreSQL**.

Key modules implemented so far:
- **Open Food Facts Integration** (lookup products by barcode)
- **Inventory Management** (add products from OFF directly into stock)
- **Validation & Logging** with NestJS global pipes and interceptors

---

## 🛠️ Project setup

```bash
$ npm install
```

⸻

🚀 Compile and run the project

```bash
# development
$ npm run start

# watch mode
$ npm run start:dev

# production mode
$ npm run start:prod
```

⸻

🧪 Run tests

```bash
# unit tests
$ npm run test

# e2e tests
$ npm run test:e2e

# test coverage
$ npm run test:cov
```

⸻

📡 Endpoints implemented

🔍 Lookup Open Food Facts

```bash
GET /off/scan?barcode=5449000000996
```

Response:

```bash
{
  "status": 1,
  "code": "5449000000996",
  "products": [
    {
      "code": "5449000000996",
      "product_name": "Coca-Cola",
      "brands": "Coca-Cola",
      "categories": "Beverages, Sodas",
      "image_url": "https://...",
      "ecoscore_grade": "d",
      "allergens": "Gluten",
      "allergens_tags": ["en:gluten"]
    }
  ]
}
```

📥 Add Product to Inventory

```bash
POST /inventory/add-from-off
Content-Type: application/json
```

Request body:

```bash
{
  "barcode": "5449000000996",
  "quantity": 12,
  "unit": "un",
  "expirationDate": "2026-01-31",
  "location": "Cold Room 1",
  "batch": "LOT-ABC-123",
  "tenantId": "c3a6b1f8-9f5a-4c0a-9a23-9f1fb9d7a001",
  "kitchenId": "bcf6a5b0-3ab0-4d8d-8f77-9a1b2c3d4e55"
}
```
Response:
```bash
{
  "message": "Inventory updated",
  "product": { ... },
  "item": { ... }
}
```

⸻

📦 Database (Prisma + PostgreSQL)
	•	Product
	•	categories (mapped from DB column category using @map)
	•	ecoScore (mapped from DB column greenScore if needed)
	•	allergens (string)
	•	optional allergensTags String[] @db.Text[]
	•	InventoryItem (StockItem)
	•	Linked to Product
	•	Fields: tenantId, kitchenId, productId, qty, lot, expiresAt
	•	Composite unique: (tenantId, barcode)

⸻

🚀 Deployment

When deploying the Apptit API to production:
	•	Ensure migrations are applied: npx prisma migrate deploy
	•	Use environment variables for DB connection and OFF integration
	•	Run with a process manager (PM2, Docker, Kubernetes)

⸻

📚 Resources
	•	NestJS Documentation
	•	Prisma Documentation
	•	Open Food Facts API

⸻

👤 Author
	•	Rodrigo Paiva – GitHub · LinkedIn

⸻

📄 License

Apptit is MIT licensed.

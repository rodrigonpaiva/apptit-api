-- CreateEnum
CREATE TYPE "public"."Role" AS ENUM ('ADMIN', 'CHEF', 'MANAGER', 'STAFF');

-- CreateTable
CREATE TABLE "public"."User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "public"."Role" NOT NULL,
    "name" TEXT,
    "avatar" TEXT,
    "tenantId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Tenant" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "locale" TEXT NOT NULL DEFAULT 'fr-FR',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Tenant_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Product" (
    "id" TEXT NOT NULL,
    "barcode" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "brand" TEXT,
    "allergens" TEXT[],
    "nutrition" JSONB,
    "expiresAt" TIMESTAMP(3),
    "tenantId" TEXT NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."InventoryItem" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "qty" INTEGER NOT NULL,
    "location" TEXT,
    "batch" TEXT,
    "expiresAt" TIMESTAMP(3),
    "tenantId" TEXT NOT NULL,
    "createdBy" TEXT NOT NULL,

    CONSTRAINT "InventoryItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."HaccpLog" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "createdBy" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "HaccpLog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AuditLog" (
    "id" TEXT NOT NULL,
    "actorId" TEXT,
    "tenantId" TEXT,
    "action" TEXT NOT NULL,
    "entity" TEXT,
    "entityId" TEXT,
    "meta" JSONB,
    "at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Product_barcode_key" ON "public"."Product"("barcode");

-- CreateIndex
CREATE INDEX "Product_tenantId_idx" ON "public"."Product"("tenantId");

-- CreateIndex
CREATE INDEX "Product_expiresAt_idx" ON "public"."Product"("expiresAt");

-- CreateIndex
CREATE INDEX "InventoryItem_tenantId_idx" ON "public"."InventoryItem"("tenantId");

-- CreateIndex
CREATE INDEX "InventoryItem_productId_idx" ON "public"."InventoryItem"("productId");

-- CreateIndex
CREATE INDEX "InventoryItem_expiresAt_idx" ON "public"."InventoryItem"("expiresAt");

-- CreateIndex
CREATE INDEX "HaccpLog_tenantId_idx" ON "public"."HaccpLog"("tenantId");

-- CreateIndex
CREATE INDEX "HaccpLog_createdBy_idx" ON "public"."HaccpLog"("createdBy");

-- CreateIndex
CREATE INDEX "HaccpLog_type_idx" ON "public"."HaccpLog"("type");

-- CreateIndex
CREATE INDEX "HaccpLog_createdAt_idx" ON "public"."HaccpLog"("createdAt");

-- CreateIndex
CREATE INDEX "AuditLog_tenantId_idx" ON "public"."AuditLog"("tenantId");

-- CreateIndex
CREATE INDEX "AuditLog_actorId_idx" ON "public"."AuditLog"("actorId");

-- CreateIndex
CREATE INDEX "AuditLog_entity_entityId_idx" ON "public"."AuditLog"("entity", "entityId");

-- CreateIndex
CREATE INDEX "AuditLog_at_idx" ON "public"."AuditLog"("at");

-- AddForeignKey
ALTER TABLE "public"."User" ADD CONSTRAINT "User_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Product" ADD CONSTRAINT "Product_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItem" ADD CONSTRAINT "InventoryItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItem" ADD CONSTRAINT "InventoryItem_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."InventoryItem" ADD CONSTRAINT "InventoryItem_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."HaccpLog" ADD CONSTRAINT "HaccpLog_createdBy_fkey" FOREIGN KEY ("createdBy") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."HaccpLog" ADD CONSTRAINT "HaccpLog_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AuditLog" ADD CONSTRAINT "AuditLog_actorId_fkey" FOREIGN KEY ("actorId") REFERENCES "public"."User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AuditLog" ADD CONSTRAINT "AuditLog_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE SET NULL ON UPDATE CASCADE;

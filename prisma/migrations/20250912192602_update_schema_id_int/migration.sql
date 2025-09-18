/*
  Warnings:

  - The primary key for the `AuditLog` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `AuditLog` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `actorId` column on the `AuditLog` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `tenantId` column on the `AuditLog` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The `entityId` column on the `AuditLog` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `HaccpLog` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `HaccpLog` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `InventoryItem` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `InventoryItem` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Product` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Product` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Tenant` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `Tenant` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The `id` column on the `User` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - Changed the type of `createdBy` on the `HaccpLog` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `tenantId` on the `HaccpLog` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `productId` on the `InventoryItem` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `tenantId` on the `InventoryItem` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `createdBy` on the `InventoryItem` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `tenantId` on the `Product` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Changed the type of `tenantId` on the `User` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- DropForeignKey
ALTER TABLE "public"."AuditLog" DROP CONSTRAINT "AuditLog_actorId_fkey";

-- DropForeignKey
ALTER TABLE "public"."AuditLog" DROP CONSTRAINT "AuditLog_tenantId_fkey";

-- DropForeignKey
ALTER TABLE "public"."HaccpLog" DROP CONSTRAINT "HaccpLog_createdBy_fkey";

-- DropForeignKey
ALTER TABLE "public"."HaccpLog" DROP CONSTRAINT "HaccpLog_tenantId_fkey";

-- DropForeignKey
ALTER TABLE "public"."InventoryItem" DROP CONSTRAINT "InventoryItem_createdBy_fkey";

-- DropForeignKey
ALTER TABLE "public"."InventoryItem" DROP CONSTRAINT "InventoryItem_productId_fkey";

-- DropForeignKey
ALTER TABLE "public"."InventoryItem" DROP CONSTRAINT "InventoryItem_tenantId_fkey";

-- DropForeignKey
ALTER TABLE "public"."Product" DROP CONSTRAINT "Product_tenantId_fkey";

-- DropForeignKey
ALTER TABLE "public"."User" DROP CONSTRAINT "User_tenantId_fkey";

-- AlterTable
ALTER TABLE "public"."AuditLog" DROP CONSTRAINT "AuditLog_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "actorId",
ADD COLUMN     "actorId" INTEGER,
DROP COLUMN "tenantId",
ADD COLUMN     "tenantId" INTEGER,
DROP COLUMN "entityId",
ADD COLUMN     "entityId" INTEGER,
ADD CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "public"."HaccpLog" DROP CONSTRAINT "HaccpLog_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "createdBy",
ADD COLUMN     "createdBy" INTEGER NOT NULL,
DROP COLUMN "tenantId",
ADD COLUMN     "tenantId" INTEGER NOT NULL,
ADD CONSTRAINT "HaccpLog_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "public"."InventoryItem" DROP CONSTRAINT "InventoryItem_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "productId",
ADD COLUMN     "productId" INTEGER NOT NULL,
DROP COLUMN "tenantId",
ADD COLUMN     "tenantId" INTEGER NOT NULL,
DROP COLUMN "createdBy",
ADD COLUMN     "createdBy" INTEGER NOT NULL,
ADD CONSTRAINT "InventoryItem_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "public"."Product" DROP CONSTRAINT "Product_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "tenantId",
ADD COLUMN     "tenantId" INTEGER NOT NULL,
ADD CONSTRAINT "Product_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "public"."Tenant" DROP CONSTRAINT "Tenant_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "Tenant_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "public"."User" DROP CONSTRAINT "User_pkey",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
DROP COLUMN "tenantId",
ADD COLUMN     "tenantId" INTEGER NOT NULL,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");

-- CreateIndex
CREATE INDEX "AuditLog_tenantId_idx" ON "public"."AuditLog"("tenantId");

-- CreateIndex
CREATE INDEX "AuditLog_actorId_idx" ON "public"."AuditLog"("actorId");

-- CreateIndex
CREATE INDEX "AuditLog_entity_entityId_idx" ON "public"."AuditLog"("entity", "entityId");

-- CreateIndex
CREATE INDEX "HaccpLog_tenantId_idx" ON "public"."HaccpLog"("tenantId");

-- CreateIndex
CREATE INDEX "HaccpLog_createdBy_idx" ON "public"."HaccpLog"("createdBy");

-- CreateIndex
CREATE INDEX "InventoryItem_tenantId_idx" ON "public"."InventoryItem"("tenantId");

-- CreateIndex
CREATE INDEX "InventoryItem_productId_idx" ON "public"."InventoryItem"("productId");

-- CreateIndex
CREATE INDEX "Product_tenantId_idx" ON "public"."Product"("tenantId");

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

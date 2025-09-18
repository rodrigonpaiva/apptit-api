/*
  Warnings:

  - The primary key for the `HaccpLog` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `Product` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `brand` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the column `expiresAt` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the column `nutrition` on the `Product` table. All the data in the column will be lost.
  - The primary key for the `Tenant` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - The primary key for the `User` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the `AuditLog` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `InventoryItem` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[tenantId,barcode]` on the table `Product` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[tenantId,email]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `siteId` to the `HaccpLog` table without a default value. This is not possible if the table is not empty.

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

-- DropIndex
DROP INDEX "public"."HaccpLog_createdAt_idx";

-- DropIndex
DROP INDEX "public"."HaccpLog_createdBy_idx";

-- DropIndex
DROP INDEX "public"."HaccpLog_tenantId_idx";

-- DropIndex
DROP INDEX "public"."HaccpLog_type_idx";

-- DropIndex
DROP INDEX "public"."Product_barcode_key";

-- DropIndex
DROP INDEX "public"."Product_expiresAt_idx";

-- DropIndex
DROP INDEX "public"."Product_tenantId_idx";

-- DropIndex
DROP INDEX "public"."User_email_key";

-- AlterTable
ALTER TABLE "public"."HaccpLog" DROP CONSTRAINT "HaccpLog_pkey",
ADD COLUMN     "siteId" TEXT NOT NULL,
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ALTER COLUMN "createdBy" SET DATA TYPE TEXT,
ALTER COLUMN "tenantId" SET DATA TYPE TEXT,
ADD CONSTRAINT "HaccpLog_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "HaccpLog_id_seq";

-- AlterTable
ALTER TABLE "public"."Product" DROP CONSTRAINT "Product_pkey",
DROP COLUMN "brand",
DROP COLUMN "expiresAt",
DROP COLUMN "nutrition",
ADD COLUMN     "category" TEXT,
ADD COLUMN     "greenScore" TEXT,
ADD COLUMN     "imageUrl" TEXT,
ADD COLUMN     "unit" TEXT NOT NULL DEFAULT 'unit',
ALTER COLUMN "barcode" DROP NOT NULL,
ALTER COLUMN "allergens" SET DEFAULT ARRAY[]::TEXT[],
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ALTER COLUMN "tenantId" SET DATA TYPE TEXT,
ADD CONSTRAINT "Product_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "Product_id_seq";

-- AlterTable
ALTER TABLE "public"."Tenant" DROP CONSTRAINT "Tenant_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ADD CONSTRAINT "Tenant_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "Tenant_id_seq";

-- AlterTable
ALTER TABLE "public"."User" DROP CONSTRAINT "User_pkey",
ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "id" SET DATA TYPE TEXT,
ALTER COLUMN "tenantId" SET DATA TYPE TEXT,
ADD CONSTRAINT "User_pkey" PRIMARY KEY ("id");
DROP SEQUENCE "User_id_seq";

-- DropTable
DROP TABLE "public"."AuditLog";

-- DropTable
DROP TABLE "public"."InventoryItem";

-- CreateTable
CREATE TABLE "public"."Site" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "address" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Site_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Supplier" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "siret" TEXT,
    "contact" TEXT,
    "email" TEXT,
    "phone" TEXT,

    CONSTRAINT "Supplier_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."StockItem" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "siteId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "lot" TEXT,
    "qty" DECIMAL(14,3) NOT NULL,
    "unitCost" DECIMAL(14,4),
    "expiresAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "StockItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PurchaseOrder" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "supplierId" TEXT NOT NULL,
    "siteId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'DRAFT',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "PurchaseOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."PurchaseOrderLine" (
    "id" TEXT NOT NULL,
    "purchaseId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "qty" DECIMAL(14,3) NOT NULL,
    "unitPrice" DECIMAL(14,4) NOT NULL,

    CONSTRAINT "PurchaseOrderLine_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Site_tenantId_code_key" ON "public"."Site"("tenantId", "code");

-- CreateIndex
CREATE UNIQUE INDEX "Supplier_tenantId_name_key" ON "public"."Supplier"("tenantId", "name");

-- CreateIndex
CREATE INDEX "StockItem_tenantId_siteId_productId_idx" ON "public"."StockItem"("tenantId", "siteId", "productId");

-- CreateIndex
CREATE INDEX "HaccpLog_tenantId_siteId_type_createdAt_idx" ON "public"."HaccpLog"("tenantId", "siteId", "type", "createdAt");

-- CreateIndex
CREATE INDEX "Product_tenantId_name_idx" ON "public"."Product"("tenantId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Product_tenantId_barcode_key" ON "public"."Product"("tenantId", "barcode");

-- CreateIndex
CREATE UNIQUE INDEX "User_tenantId_email_key" ON "public"."User"("tenantId", "email");

-- AddForeignKey
ALTER TABLE "public"."Site" ADD CONSTRAINT "Site_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."User" ADD CONSTRAINT "User_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Supplier" ADD CONSTRAINT "Supplier_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Product" ADD CONSTRAINT "Product_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StockItem" ADD CONSTRAINT "StockItem_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StockItem" ADD CONSTRAINT "StockItem_siteId_fkey" FOREIGN KEY ("siteId") REFERENCES "public"."Site"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."StockItem" ADD CONSTRAINT "StockItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_supplierId_fkey" FOREIGN KEY ("supplierId") REFERENCES "public"."Supplier"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PurchaseOrder" ADD CONSTRAINT "PurchaseOrder_siteId_fkey" FOREIGN KEY ("siteId") REFERENCES "public"."Site"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PurchaseOrderLine" ADD CONSTRAINT "PurchaseOrderLine_purchaseId_fkey" FOREIGN KEY ("purchaseId") REFERENCES "public"."PurchaseOrder"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."PurchaseOrderLine" ADD CONSTRAINT "PurchaseOrderLine_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."HaccpLog" ADD CONSTRAINT "HaccpLog_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "public"."Tenant"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."HaccpLog" ADD CONSTRAINT "HaccpLog_siteId_fkey" FOREIGN KEY ("siteId") REFERENCES "public"."Site"("id") ON DELETE CASCADE ON UPDATE CASCADE;

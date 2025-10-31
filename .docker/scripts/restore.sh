#!/bin/bash

# ==========================================
# Database Restore Script
# ==========================================
# Restore MongoDB from backup
# ==========================================

set -e

# Check if backup name is provided
if [ -z "$1" ]; then
    echo "❌ Error: Backup name required"
    echo "Usage: ./restore.sh <backup_name>"
    echo ""
    echo "Available backups:"
    ls -1 /backups/backup_*.tar.gz 2>/dev/null || echo "  No backups found"
    exit 1
fi

BACKUP_NAME="$1"
BACKUP_DIR="/backups"
TEMP_DIR="/tmp/restore_${BACKUP_NAME}"

# MongoDB credentials
MONGO_USER="${MONGO_INITDB_ROOT_USERNAME:-admin}"
MONGO_PASS="${MONGO_INITDB_ROOT_PASSWORD:-admin123}"
MONGO_HOST="${MONGO_HOST:-mongodb}"
MONGO_PORT="${MONGO_PORT:-27017}"

# Check if backup exists
BACKUP_FILE="${BACKUP_DIR}/${BACKUP_NAME}.tar.gz"
if [ ! -f "$BACKUP_FILE" ]; then
    BACKUP_FILE="${BACKUP_DIR}/${BACKUP_NAME}"
    if [ ! -d "$BACKUP_FILE" ]; then
        echo "❌ Error: Backup not found: ${BACKUP_NAME}"
        exit 1
    fi
fi

echo "🔄 Starting MongoDB restore..."
echo "Backup: ${BACKUP_NAME}"

# Extract if compressed
if [[ "$BACKUP_FILE" == *.tar.gz ]]; then
    echo "📦 Extracting backup..."
    mkdir -p "${TEMP_DIR}"
    tar -xzf "${BACKUP_FILE}" -C "${TEMP_DIR}"
    RESTORE_DIR="${TEMP_DIR}/${BACKUP_NAME}"
else
    RESTORE_DIR="${BACKUP_FILE}"
fi

# Restore
echo "⚠️  WARNING: This will overwrite existing data!"
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Restore cancelled"
    rm -rf "${TEMP_DIR}"
    exit 1
fi

echo "🔄 Restoring database..."
mongorestore \
    --host="${MONGO_HOST}" \
    --port="${MONGO_PORT}" \
    --username="${MONGO_USER}" \
    --password="${MONGO_PASS}" \
    --authenticationDatabase=admin \
    --drop \
    "${RESTORE_DIR}"

# Cleanup
if [ -d "${TEMP_DIR}" ]; then
    rm -rf "${TEMP_DIR}"
fi

echo "✅ Restore completed successfully!"

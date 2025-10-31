// ==========================================
// MongoDB Initialization Script
// ==========================================
// This script runs when MongoDB container starts for the first time
// Use it to create initial users, indexes, or seed data
// ==========================================

// Switch to the application database
db = db.getSiblingDB('multitennat_ecommerce');

// Create application user with readWrite permissions
db.createUser({
  user: 'app_user',
  pwd: 'app_password',
  roles: [
    {
      role: 'readWrite',
      db: 'multitennat_ecommerce',
    },
  ],
});

// Create indexes for better performance
// Users collection indexes
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ createdAt: -1 });

// Categories collection indexes
db.categories.createIndex({ slug: 1 }, { unique: true });
db.categories.createIndex({ name: 1 });

// Media collection indexes
db.media.createIndex({ filename: 1 });
db.media.createIndex({ createdAt: -1 });

// Log successful initialization
print('✅ MongoDB initialization completed successfully!');
print('📦 Database: multitennat_ecommerce');
print('👤 User: app_user created with readWrite permissions');
print('🔍 Indexes created for users, categories, and media collections');

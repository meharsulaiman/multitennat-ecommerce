# 🛒 Multitennat E-commerce Platform

A modern, scalable multi-tenant e-commerce platform built with **Next.js 15**, **PayloadCMS 3**, **MongoDB**, and **Docker**.

## 🐳 Docker Setup

All Docker files are in the `.docker/` folder. See [.docker/README.md](.docker/README.md) for complete setup instructions.

## ✨ Features

- 🚀 **Next.js 15** with App Router
- 📦 **PayloadCMS 3** - Powerful headless CMS
- 🗄️ **MongoDB** - Flexible NoSQL database
- 🐳 **Fully Dockerized** - Development & Production ready
- 🎨 **TailwindCSS** - Modern UI styling
- 🔐 **TypeScript** - Type-safe codebase
- 📱 **Responsive Design** - Mobile-first approach
- 🔄 **Hot Reload** - Fast development experience
- 🎭 **tRPC** - Type-safe APIs

## 🚀 Quick Start with Docker

### Prerequisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed
- That's it! No Node.js or MongoDB required

### Setup

```bash
# 1. Clone the repository
git clone <your-repo-url>
cd multitennat-ecommerce

# 2. Copy environment file
cp env.example .env

# 3. Start development environment
docker-compose -f .docker/docker-compose.yml up -d

# 4. View logs (optional)
docker-compose -f .docker/docker-compose.yml logs -f
```

### Access Points
- **Application**: http://localhost:3000
- **Admin Panel**: http://localhost:3000/admin
- **Database UI**: http://localhost:8081
- **API Health**: http://localhost:3000/api/health

## 💻 Local Development (Without Docker)

If you prefer traditional development:

```bash
# Install dependencies
npm install

# Set up environment variables
cp env.example .env
# Edit .env with your MongoDB connection string

# Generate Payload types
npm run generate:types

# Start development server
npm run dev
```

## 🐳 Docker Commands

All Docker files are in the `.docker/` folder.

```bash
# Start containers
docker-compose -f .docker/docker-compose.yml up -d

# Stop containers
docker-compose -f .docker/docker-compose.yml down

# View logs
docker-compose -f .docker/docker-compose.yml logs -f

# Restart a service
docker-compose -f .docker/docker-compose.yml restart app

# Check status
docker-compose -f .docker/docker-compose.yml ps

# Rebuild
docker-compose -f .docker/docker-compose.yml up --build
```

## 📚 Documentation

- **[.docker/README.md](.docker/README.md)** - Complete Docker setup guide

## 🏗️ Project Structure

```
multitennat-ecommerce/
├── .docker/                   # All Docker files
│   ├── Dockerfile            # Multi-stage build
│   ├── docker-compose.yml    # Development
│   ├── docker-compose.prod.yml # Production
│   ├── mongodb/              # MongoDB configs
│   ├── nginx/                # Nginx configs
│   └── scripts/              # Utility scripts
├── src/
│   ├── app/                  # Next.js App Router
│   ├── collections/          # PayloadCMS collections
│   ├── components/           # React components
│   └── trpc/                 # tRPC setup
└── package.json
```

## 🔧 Available Scripts

```bash
npm run dev              # Start development server
npm run build            # Build for production
npm run start            # Start production server
npm run lint             # Run ESLint
npm run generate:types   # Generate Payload types
npm run db:fresh         # Fresh database migration
npm run db:seed          # Seed database
npm run db:reset         # Reset and seed database
```

## 🌐 Environment Variables

Create a `.env` file based on `env.example`:

```env
# Application
NODE_ENV=development
NEXT_PUBLIC_SERVER_URL=http://localhost:3000

# Payload CMS
PAYLOAD_SECRET=your-secret-key-here

# MongoDB (Docker)
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=admin123
DATABASE_URI=mongodb://admin:admin123@mongodb:27017/multitennat_ecommerce?authSource=admin
```

## 🚢 Production Deployment

### Using Docker (Recommended)

```bash
# 1. Create production environment file
cp env.example .env.production

# 2. Update production variables (use strong passwords!)
# Edit .env.production

# 3. Build and start production containers
docker-compose -f .docker/docker-compose.prod.yml up -d

# 4. Check status
docker-compose -f .docker/docker-compose.prod.yml ps
```

### Production Features
- ✅ Multi-stage optimized builds
- ✅ Nginx reverse proxy with rate limiting
- ✅ Health checks and monitoring
- ✅ Resource limits and security hardening
- ✅ Automated backups
- ✅ SSL/HTTPS ready

## 🗄️ Database Management

### Backup Database
```bash
docker.bat db:backup        # Windows
./docker.sh db:backup       # Mac/Linux
make db-backup              # Using Make
```

### Restore Database
```bash
docker.bat db:restore backup_20231201    # Windows
./docker.sh db:restore backup_20231201   # Mac/Linux
make db-restore BACKUP=backup_20231201   # Using Make
```

### Seed Database
```bash
docker-compose exec app npm run db:seed
```

## 🔍 Troubleshooting

**Port already in use?**
```bash
# Stop existing containers
docker-compose -f .docker/docker-compose.yml down

# Or edit .docker/docker-compose.yml to use different port
```

**Container won't start?**
```bash
# Check logs
docker-compose -f .docker/docker-compose.yml logs app

# Rebuild from scratch
docker-compose -f .docker/docker-compose.yml down -v
docker-compose -f .docker/docker-compose.yml up --build
```

See [.docker/README.md](.docker/README.md) for more help.

## 🧪 Testing

```bash
# Run tests (when available)
bun test

# Run tests in Docker
docker-compose -f .docker/docker-compose.yml exec app bun test
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🔗 Links

- [Next.js Documentation](https://nextjs.org/docs)
- [PayloadCMS Documentation](https://payloadcms.com/docs)
- [Docker Documentation](https://docs.docker.com/)
- [MongoDB Documentation](https://docs.mongodb.com/)

## 👥 Team

For team members joining the project:
- [.docker/README.md](.docker/README.md) - Docker setup guide

---

**Made with ❤️ by the team**

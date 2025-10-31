# 🐳 Docker Complete Guide for Students

> **ELI15 Version**: Learn Docker by understanding what it does, not just how to run commands!

## 📚 Table of Contents
1. [What is Docker?](#-what-is-docker)
2. [Why Use Docker?](#-why-use-docker)
3. [Docker Concepts Explained](#-docker-concepts-explained)
4. [Project Structure](#-project-structure)
5. [Development Setup](#-development-setup)
6. [Production Setup](#-production-setup)
7. [Common Commands](#️-common-commands)
8. [Troubleshooting](#-troubleshooting)

---

## 🤔 What is Docker?

Think of Docker like **shipping containers for your code**.

**Without Docker:**
- You write code on your computer
- Your friend tries to run it: "It doesn't work on my machine!"
- You need to install Node.js, MongoDB, configure everything
- Everyone's setup is different = different bugs

**With Docker:**
- You package your code + all dependencies in a "container"
- Anyone can run it the same way on any computer
- No more "works on my machine" problems!
- One command to start everything

### Real World Analogy 🚢
Imagine you're shipping a product:
- **Without containers**: Pack items loosely in a truck. Different trucks need different packing.
- **With containers**: Pack everything in a standard shipping container. Any truck/ship can carry it.

Docker does the same for your code!

---

## 🎯 Why Use Docker?

### Problem You Had Before:
```
You: "Hey teammate, run my project"
Teammate: "What Node version?"
You: "18... or was it 20?"
Teammate: "MongoDB won't connect"
You: "Did you set the environment variables?"
Teammate: "What variables?"
😫 2 hours later...
```

### With Docker:
```
You: "Run: docker-compose up"
Teammate: "It works!"
😊 30 seconds later
```

### Benefits:
1. **Consistency**: Same environment everywhere (your PC, friend's PC, server)
2. **Isolation**: Doesn't mess with your computer's setup
3. **Easy Setup**: One command instead of 10 installation steps
4. **Easy Cleanup**: Delete containers, nothing left behind
5. **Production Ready**: Dev and production use the same setup

---

## 📖 Docker Concepts Explained

### 1. Container 📦
**What**: A running instance of your application
**Like**: A running program on your computer
**Example**: Your Next.js app running in isolation

```bash
# Start a container
docker-compose up

# Stop a container
docker-compose down
```

Think of it as a **mini-computer inside your computer** that runs your app.

### 2. Image 🖼️
**What**: A blueprint/template for containers
**Like**: A recipe for making a cake
**Example**: Instructions to build your Next.js app

The `Dockerfile` is the recipe. The built image is like the cake mix. The container is the baked cake!

### 3. Volume 💾
**What**: Persistent storage for containers
**Like**: A USB drive connected to your mini-computer
**Why**: Containers are temporary, volumes keep your data safe

```yaml
volumes:
  - mongodb_data:/data/db  # Database data survives restarts!
```

**Without volumes**: Delete container = lose all data 😱
**With volumes**: Delete container = data is safe ✅

### 4. Network 🌐
**What**: Allows containers to talk to each other
**Like**: A local WiFi network for your containers
**Example**: App container talks to MongoDB container

```
┌─────────┐      network      ┌─────────┐
│   App   │ ←───────────────→ │ MongoDB │
└─────────┘                    └─────────┘
```

### 5. Docker Compose 🎼
**What**: Tool to run multiple containers together
**Like**: An orchestra conductor coordinating musicians
**Why**: Your app needs app + database + more = multiple containers

```yaml
services:
  app:       # Container 1: Your Next.js app
  mongodb:   # Container 2: Database
  nginx:     # Container 3: Web server
```

---

## 📁 Project Structure

```
.docker/
├── Dockerfile              # Recipe: How to build your app
├── docker-compose.yml      # Conductor: How to run everything (Dev)
├── docker-compose.prod.yml # Conductor: How to run everything (Production)
├── .dockerignore          # What files to ignore when building
├── mongodb/
│   └── init-mongo.js      # Database setup script
├── nginx/
│   └── nginx.conf         # Web server configuration
└── scripts/
    ├── backup.sh          # Backup database
    └── restore.sh         # Restore database
```

### Let's Explain Each File:

#### 1. `Dockerfile` - The Recipe 📝
```dockerfile
# Start with Bun (like choosing your ingredients)
FROM oven/bun:1-alpine

# Copy files (like gathering ingredients)
COPY package.json ./

# Install dependencies (like preparing ingredients)
RUN bun install

# Copy your code
COPY . .

# Start app (like cooking)
CMD ["bun", "run", "dev"]
```

**What it does**: Defines how to package your app into an image.

#### 2. `docker-compose.yml` - The Conductor 🎼
```yaml
services:
  mongodb:           # Database container
    image: mongo:latest
    ports:
      - "27017:27017"  # Map port 27017 on your PC to container
    
  app:               # Your Next.js app container
    build: .         # Build from Dockerfile
    ports:
      - "3000:3000"  # Map port 3000
    depends_on:
      - mongodb      # Start MongoDB first
```

**What it does**: Defines how to run multiple containers together.

#### 3. `.dockerignore` - The Filter 🚫
```
node_modules
.git
.env
```

**What it does**: Tells Docker "don't include these files when building"
**Why**: Makes builds faster, smaller, and more secure

---

## 🚀 Development Setup

### Understanding Development Mode

**What happens when you develop normally:**
```bash
1. Edit code in VS Code
2. Save file
3. App auto-reloads
4. See changes in browser
```

**What happens with Docker + Development:**
```bash
1. Edit code in VS Code (on your computer)
2. Save file
3. Code is shared with container (volume mounting)
4. App auto-reloads (inside container)
5. See changes in browser
```

Same experience, but everything runs in a container!

### Step-by-Step Setup

#### Step 1: Understand What Will Happen
When you run the development setup:
- ✅ Creates 3 containers: App, MongoDB, Mongo Express
- ✅ App runs on http://localhost:3000
- ✅ Database runs on port 27017
- ✅ Database UI runs on http://localhost:8081
- ✅ Your code is "mounted" (shared) with the container
- ✅ Changes you make auto-reload

#### Step 2: Start Everything
```bash
# Go to project folder
cd multitennat-ecommerce

# Start all containers
docker-compose -f .docker/docker-compose.yml up -d
```

**What `-d` means**: "Detached mode" = runs in background

#### Step 3: Verify It's Running
```bash
# Check status
docker-compose -f .docker/docker-compose.yml ps

# Should show:
# app         ✔️ Up
# mongodb     ✔️ Up (healthy)
# mongo-express ✔️ Up
```

#### Step 4: Access Your App
Open browser:
- **App**: http://localhost:3000
- **Admin**: http://localhost:3000/admin
- **Database UI**: http://localhost:8081

#### Step 5: Make Changes
1. Edit any file in `src/`
2. Save
3. Watch terminal: `✓ Compiled successfully`
4. Refresh browser: See changes!

**Magic**: You edit on your computer, app runs in container, changes sync automatically!

### How Development Volumes Work

```yaml
volumes:
  - ..:/app              # Maps your code to container
  - /app/node_modules    # Keeps node_modules separate
```

**What this means:**
```
Your Computer          Container
─────────────         ─────────
src/                → /app/src/
package.json        → /app/package.json
[your edits here]     [appear here instantly]
```

---

## 🏭 Production Setup

### Development vs Production - Key Differences

| Aspect | Development | Production |
|--------|------------|------------|
| **Purpose** | For coding | For users |
| **Speed** | Slower (features) | Faster (optimized) |
| **Size** | Bigger (~500MB) | Smaller (~200MB) |
| **Hot Reload** | ✅ Yes | ❌ No |
| **Debug Tools** | ✅ Included | ❌ Removed |
| **Security** | Relaxed | Strict |
| **Code Mounting** | ✅ Live code | ❌ Built code only |

### Multi-Stage Build Explained

Our `Dockerfile` has 4 stages (like building a house in stages):

#### Stage 1: Dependencies Stage
```dockerfile
FROM oven/bun:1-alpine AS deps
COPY package.json ./
RUN bun install
```
**Purpose**: Install all dependencies
**Like**: Gathering all tools before building

#### Stage 2: Builder Stage
```dockerfile
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN bun run build
```
**Purpose**: Build optimized production code
**Like**: Constructing the house

#### Stage 3: Runner Stage (Production)
```dockerfile
FROM node:20-alpine AS runner
COPY --from=builder /app/.next ./
CMD ["node", "server.js"]
```
**Purpose**: Small, optimized final image
**Like**: Clean finished house, no construction tools left

#### Stage 4: Development Stage
```dockerfile
FROM oven/bun:1-alpine AS development
COPY . .
CMD ["bun", "run", "dev"]
```
**Purpose**: Full featured development environment
**Like**: Construction site with all tools

### Production Deployment

#### Step 1: Prepare Environment
```bash
# Copy and edit production environment
cp env.example .env.production

# Edit .env.production with production values:
# - Strong passwords
# - Production URLs
# - Secret keys
```

#### Step 2: Build Production Image
```bash
docker-compose -f .docker/docker-compose.prod.yml build
```

**What happens**:
1. ✅ Installs dependencies
2. ✅ Builds optimized Next.js code
3. ✅ Removes development tools
4. ✅ Creates small image (~200MB)

#### Step 3: Start Production
```bash
docker-compose -f .docker/docker-compose.prod.yml up -d
```

**What runs**:
- ✅ App (optimized build)
- ✅ MongoDB (with resource limits)
- ✅ Nginx (reverse proxy)

#### Step 4: Monitor
```bash
# Check health
docker-compose -f .docker/docker-compose.prod.yml ps

# View logs
docker-compose -f .docker/docker-compose.prod.yml logs -f app
```

---

## 🛠️ Common Commands

### Container Management

#### Start Containers
```bash
# Start everything
docker-compose -f .docker/docker-compose.yml up -d

# What happens:
# 1. Creates network
# 2. Creates volumes
# 3. Starts MongoDB
# 4. Waits for MongoDB to be healthy
# 5. Starts App
# 6. Starts Mongo Express
```

#### Stop Containers
```bash
# Stop everything
docker-compose -f .docker/docker-compose.yml down

# What happens:
# 1. Stops all containers
# 2. Removes containers
# 3. Keeps volumes (data safe!)
# 4. Removes network
```

#### Stop and Remove Everything
```bash
# Nuclear option: Remove containers AND volumes
docker-compose -f .docker/docker-compose.yml down -v

# ⚠️ Warning: This deletes database data!
```

### Viewing Logs

#### See All Logs
```bash
docker-compose -f .docker/docker-compose.yml logs

# Shows logs from all containers
```

#### Follow Logs (Live)
```bash
docker-compose -f .docker/docker-compose.yml logs -f

# Like "tail -f" - shows logs as they happen
# Press Ctrl+C to stop
```

#### See Specific Container Logs
```bash
# App logs only
docker-compose -f .docker/docker-compose.yml logs app

# Database logs only
docker-compose -f .docker/docker-compose.yml logs mongodb
```

#### Last 50 Lines
```bash
docker-compose -f .docker/docker-compose.yml logs --tail=50 app
```

### Restarting Services

#### Restart One Container
```bash
docker-compose -f .docker/docker-compose.yml restart app

# When to use: After changing environment variables
```

#### Restart Everything
```bash
docker-compose -f .docker/docker-compose.yml restart

# Faster than down + up
```

#### Rebuild and Restart
```bash
docker-compose -f .docker/docker-compose.yml up --build -d

# When to use: After changing Dockerfile or package.json
```

### Running Commands Inside Containers

#### Access Container Shell
```bash
docker-compose -f .docker/docker-compose.yml exec app sh

# Now you're "inside" the container!
# Type 'exit' to leave
```

#### Run Single Command
```bash
# Seed database
docker-compose -f .docker/docker-compose.yml exec app bun run db:seed

# Check Node version
docker-compose -f .docker/docker-compose.yml exec app node --version

# Install new package
docker-compose -f .docker/docker-compose.yml exec app bun add lodash
```

#### Access MongoDB Shell
```bash
docker-compose -f .docker/docker-compose.yml exec mongodb mongosh -u admin -p admin123

# Now you can run MongoDB commands:
# > show databases
# > use multitennat_ecommerce
# > db.users.find()
```

### Database Operations

#### Seed Database
```bash
docker-compose -f .docker/docker-compose.yml exec app bun run db:seed

# Adds sample data to your database
```

#### Reset Database
```bash
docker-compose -f .docker/docker-compose.yml exec app bun run db:reset

# ⚠️ Deletes all data and reseeds
```

#### Backup Database
```bash
docker-compose -f .docker/docker-compose.yml exec mongodb \
  mongodump -u admin -p admin123 --out=/backups/backup_$(date +%Y%m%d)

# Creates backup in ./backups/ folder
```

#### Restore Database
```bash
docker-compose -f .docker/docker-compose.yml exec mongodb \
  mongorestore -u admin -p admin123 /backups/backup_20241031

# Restores from specific backup
```

---

## 🐛 Troubleshooting

### Problem 1: Port Already in Use

**Error**: `port is already allocated`

**Why**: Another program is using port 3000

**Solution 1**: Stop the other program
```bash
# Windows
netstat -ano | findstr :3000
taskkill /PID <number> /F

# Mac/Linux
lsof -i :3000
kill -9 <PID>
```

**Solution 2**: Change port in `docker-compose.yml`
```yaml
ports:
  - "3001:3000"  # Use 3001 on your computer, 3000 in container
```

### Problem 2: Container Won't Start

**Error**: Container exits immediately

**Solution**: Check logs
```bash
docker-compose -f .docker/docker-compose.yml logs app

# Look for error messages
```

**Common causes**:
- Missing environment variables
- Database not ready
- Syntax error in code

### Problem 3: Changes Not Showing

**Problem**: You edit code but nothing changes

**Causes**:
1. **Browser cache**: Hard refresh (Ctrl+Shift+R)
2. **Build cache**: Rebuild container
3. **Volume not mounted**: Check docker-compose.yml

**Solution**:
```bash
# Rebuild and restart
docker-compose -f .docker/docker-compose.yml up --build -d

# If still not working, nuclear option:
docker-compose -f .docker/docker-compose.yml down
docker-compose -f .docker/docker-compose.yml up --build
```

### Problem 4: Database Connection Failed

**Error**: `MongooseServerSelectionError`

**Solution**: Check MongoDB health
```bash
docker-compose -f .docker/docker-compose.yml ps

# mongodb should show: "Up (healthy)"
```

**If not healthy**:
```bash
# Check MongoDB logs
docker-compose -f .docker/docker-compose.yml logs mongodb

# Restart MongoDB
docker-compose -f .docker/docker-compose.yml restart mongodb
```

### Problem 5: Out of Disk Space

**Error**: `no space left on device`

**Why**: Docker images/containers/volumes accumulate

**Solution**: Clean up
```bash
# Remove unused containers
docker container prune

# Remove unused images
docker image prune -a

# Remove unused volumes (⚠️ may delete data)
docker volume prune

# Nuclear option: Remove everything
docker system prune -a --volumes
```

### Problem 6: "Cannot Find Module" Error

**Error**: `Cannot find module 'xyz'`

**Why**: Dependencies not installed in container

**Solution**: Rebuild container
```bash
docker-compose -f .docker/docker-compose.yml down
docker-compose -f .docker/docker-compose.yml up --build
```

---

## 🎓 Understanding Port Mapping

### What are Ports?

Think of ports like **apartment numbers** in a building:
- Building = Your computer
- Apartment = Application
- Port number = Apartment number

**Examples**:
- Port 3000 = Next.js apartment
- Port 27017 = MongoDB apartment
- Port 8081 = Mongo Express apartment

### Port Mapping Explained

```yaml
ports:
  - "3000:3000"
    ↑     ↑
    │     └─ Port inside container
    └─────── Port on your computer
```

**Translation**: 
- "When you visit localhost:3000 on your computer"
- "Send the request to port 3000 inside the container"

**Example**: If you change it to `"8000:3000"`:
- Visit `localhost:8000` on your computer
- Goes to port 3000 in container
- Useful when port 3000 is already taken!

---

## 🎯 Quick Reference

### Daily Development Commands
```bash
# Start work
./dev.sh start

# See what's happening
./dev.sh logs

# End work
./dev.sh stop
```

### Check Status
```bash
docker-compose -f .docker/docker-compose.yml ps
```

### View Logs
```bash
docker-compose -f .docker/docker-compose.yml logs -f app
```

### Run Commands
```bash
docker-compose -f .docker/docker-compose.yml exec app <command>
```

### Emergency Reset
```bash
docker-compose -f .docker/docker-compose.yml down -v
docker-compose -f .docker/docker-compose.yml up --build
```

---

## 🌐 Access Points

- **Application**: http://localhost:3000
- **Admin Panel**: http://localhost:3000/admin
- **Database UI**: http://localhost:8081
  - Username: `admin`
  - Password: `admin123`
- **MongoDB**: `mongodb://localhost:27017`

---

## 📝 Best Practices

### Development
1. ✅ Always use `docker-compose.yml` for dev
2. ✅ Keep `.env` file for local configs
3. ✅ Use volume mounting for live reload
4. ✅ Check logs when something breaks
5. ✅ Commit `Dockerfile` and `docker-compose.yml` to git
6. ❌ Don't commit `.env` files

### Production
1. ✅ Use `docker-compose.prod.yml`
2. ✅ Use strong passwords
3. ✅ Enable health checks
4. ✅ Set resource limits
5. ✅ Regular backups
6. ✅ Monitor logs

---

## 🎉 Congratulations!

You now understand:
- ✅ What Docker is and why it's useful
- ✅ Key concepts: containers, images, volumes, networks
- ✅ How to run your app in development
- ✅ How to deploy to production
- ✅ How to troubleshoot common issues

**Next Steps**:
1. Practice starting/stopping containers
2. Try making code changes and seeing them reload
3. Explore MongoDB in Mongo Express UI
4. Check container logs to understand what's happening

**Remember**: Docker is just a tool. You already know how to code - Docker just packages it nicely!

---

**Questions?** Check the logs first: `docker-compose -f .docker/docker-compose.yml logs -f`

**Still stuck?** That's normal! Docker has a learning curve, but you'll get it! 🚀

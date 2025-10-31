# ==========================================
# Multi-stage Dockerfile for Next.js + PayloadCMS
# Supports both development and production builds
# ==========================================

# ==========================================
# Stage 1: Base - Install dependencies only when needed
# ==========================================
FROM oven/bun:1-alpine AS base

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app

# Install dependencies using Bun
COPY package.json bun.lock* bun.lockb* ./
RUN bun install --frozen-lockfile

# ==========================================
# Stage 2: Builder - Rebuild the source code only when needed
# ==========================================
FROM base AS builder
WORKDIR /app

# Copy dependencies from deps stage
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Set environment variable for build
ENV NEXT_TELEMETRY_DISABLED=1

# Build arguments for environment variables needed at build time
ARG DATABASE_URI
ARG PAYLOAD_SECRET
ARG NEXT_PUBLIC_SERVER_URL

# Set build-time environment variables
ENV DATABASE_URI=${DATABASE_URI}
ENV PAYLOAD_SECRET=${PAYLOAD_SECRET}
ENV NEXT_PUBLIC_SERVER_URL=${NEXT_PUBLIC_SERVER_URL}

# Generate Payload types
RUN bun run generate:types

# Build Next.js application
RUN bun run build

# ==========================================
# Stage 3: Runner - Production image, copy all the files and run next
# ==========================================
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# Create a non-root user for security
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy public assets
COPY --from=builder /app/public ./public

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Copy built application
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Copy source files needed for Payload CMS
COPY --from=builder --chown=nextjs:nodejs /app/src ./src
COPY --from=builder --chown=nextjs:nodejs /app/payload-types.ts ./payload-types.ts

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD node -e "require('http').get('http://localhost:3000/api/health', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

CMD ["node", "server.js"]

# ==========================================
# Stage 4: Development - For local development with hot reload
# ==========================================
FROM oven/bun:1-alpine AS development
WORKDIR /app

# Install additional development tools
RUN apk add --no-cache git

# Copy package files
COPY package.json bun.lock* bun.lockb* ./

# Install all dependencies (including devDependencies)
RUN bun install

# Copy all source files
COPY . .

# Expose port for Next.js dev server
EXPOSE 3000

# Development command
CMD ["bun", "run", "dev"]

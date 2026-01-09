# Railway CLI Guide

## Installation

The Railway CLI is already installed. Verify with:
```bash
railway --version
```

## Authentication

### Login
```bash
railway login
```
This will open your browser to authenticate with Railway.

### Check Login Status
```bash
railway whoami
```

## Project Setup

### Link to Your Project
```bash
# From the repository root
railway link

# Select your project from the list
# This creates a .railway directory with project configuration
```

### Check Project Status
```bash
railway status
```

## Managing Services

### List All Services
```bash
railway service
```

### Switch to API Service
```bash
cd services/api
railway link
# Select the API service
```

### Switch to Worker Service
```bash
cd services/worker
railway link
# Select the Worker service
```

## Environment Variables

### List Variables
```bash
railway variables
```

### Set a Variable
```bash
railway variables --set JWT_SECRET=your-secret-here
```

### Set Multiple Variables from .env File
```bash
railway variables --set-from-file .env
```

## Deployments

### Deploy Current Service
```bash
# Make sure you're in the service directory (services/api or services/worker)
railway up
```

### Deploy with Detached Mode
```bash
railway up --detach
```

### View Deployment Logs
```bash
railway logs
```

### Follow Logs in Real-time
```bash
railway logs --follow
```

## Database Management

### Connect to PostgreSQL
```bash
railway connect postgres
```

### Run Prisma Migrations
```bash
# From services/api directory
railway run npx prisma migrate deploy
```

### Run Prisma Studio
```bash
# From services/api directory
railway run npx prisma studio
```

## Running Commands

### Run Any Command in Railway Environment
```bash
railway run <command>
```

### Examples
```bash
# Run database seed
railway run npm run prisma:seed

# Check Node version
railway run node --version

# Run tests
railway run npm test
```

## Troubleshooting

### View Build Logs
```bash
railway logs --build
```

### View Deployment Logs
```bash
railway logs --deployment
```

### Redeploy Last Deployment
```bash
railway redeploy
```

## Quick Fix for Current Build Issue

Since the build is failing because Railway is building from the wrong directory:

1. **Login to Railway CLI**:
   ```bash
   railway login
   ```

2. **Link to your project**:
   ```bash
   railway link
   ```

3. **Go to the Railway dashboard** and manually set the Root Directory:
   - Go to https://railway.app/dashboard
   - Select your project
   - Click on the API service
   - Go to Settings
   - Set "Root Directory" to `services/api`
   - Click "Redeploy"

Unfortunately, the Railway CLI doesn't currently support changing the root directory setting directly. This must be done through the web dashboard.

## Useful Commands Reference

| Command | Description |
|---------|-------------|
| `railway login` | Authenticate with Railway |
| `railway link` | Link to a Railway project |
| `railway status` | Show project and service status |
| `railway up` | Deploy current directory |
| `railway logs` | View service logs |
| `railway logs -f` | Follow logs in real-time |
| `railway variables` | List environment variables |
| `railway run <cmd>` | Run command in Railway environment |
| `railway connect postgres` | Connect to PostgreSQL database |
| `railway open` | Open service in browser |
| `railway domain` | Manage custom domains |

## Next Steps

After logging in:
1. Run `railway link` to connect to your project
2. Fix the Root Directory setting in the web dashboard
3. Use `railway logs -f` to monitor the deployment


# PROJECT.md

Project-specific facts and configuration. Unlike CLAUDE.md (agent instructions), this file describes the project state.

## Services

### Development (local watch mode)

| Service | URL | Port | Health Check |
|---------|-----|------|--------------|
| API Server | http://localhost:3000 | 3000 | /api/health |
| Web App | http://localhost:5173 | 5173 | / |

**Watch mode:** Services auto-reload on file changes. Do not start test instances.

### Production

| Service | URL | Notes |
|---------|-----|-------|
| API | https://api.example.com | Use only for smoke tests |
| Web | https://example.com | |

## Testing

### Commands

```bash
# Run test suite
bun test

# Run specific test file
bun test src/utils/validate.test.ts
```

### Puppeteer Configuration

```
Base URL: http://localhost:5173
Headless: false (interactive) | true (auto mode)
```

### Integration Test Targets

- User flows: login, signup, dashboard
- API endpoints: /api/users, /api/auth

## Environment

### Running Services

Check what's running before starting new instances:

```bash
# Near-term: Port checking
lsof -i :3000  # API
lsof -i :5173  # Web

# Near-term: tmux session check
tmux ls | grep mgr-ProjectName
```

### tmux Naming Convention

If using Manager, services run in tmux with pattern: `mgr-<project>-<service>`

Example:
- `mgr-Manager-server` — API server
- `mgr-Manager-web` — Vite dev server

### Future: Manager API

```bash
# Long-term: Query Manager for service status
curl http://localhost:3000/api/services
```

## Tech Stack

- **Runtime:** Bun / Node
- **Framework:** React + Vite
- **API:** Hono
- **Database:** SQLite / Postgres
- **Testing:** Vitest + Puppeteer

## Project-Specific Notes

<!-- Add notes specific to this project -->

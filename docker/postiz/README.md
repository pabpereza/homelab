# Postiz

Social media scheduler (https://postiz.com), public at https://postiz.pabpereza.dev.

Runs on the tower with Docker Compose, deployed by doco-cd: Postiz app, PostgreSQL (shared with
Temporal), Redis, Temporal and Elasticsearch (Temporal visibility: SQL visibility caps Text search
attributes at 3 and Postiz needs more). The cluster only keeps the Ingresses in `kubernetes/postiz`,
pointing to the tower.

## Secrets (manual, never in git)

Two env files on the tower, in `/opt/secrets/postiz/` (created by `infraestructure/castle.yml`).
Use URL-safe values (hex), the Postgres password is embedded in `DATABASE_URL`:

```bash
# db.env
POSTGRES_PASSWORD=<hex>
POSTGRES_PWD=<same value>

# app.env
DATABASE_URL=postgresql://postiz:<same value>@postgres:5432/postiz
JWT_SECRET=<hex>
# Social network credentials, names as in the Postiz configuration reference
LINKEDIN_CLIENT_ID=...
LINKEDIN_CLIENT_SECRET=...
```

After changing them, recreate the app: `docker compose -p postiz up -d --force-recreate postiz`
from a checkout of `docker/postiz`, or wait for the next doco-cd change.

## Registration

Registration is disabled (`DISABLE_REGISTRATION: "true"` in `compose.yml`). To add another
account, temporarily set it to `"false"`, register, then revert.

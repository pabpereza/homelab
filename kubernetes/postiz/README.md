# Postiz

Social media scheduler (https://postiz.com), public at https://postiz.pabpereza.dev.

Components (namespace `postiz`): Postiz app, PostgreSQL (shared with Temporal), Redis,
Temporal and Elasticsearch (Temporal visibility: SQL visibility caps Text search attributes
at 3 and Postiz needs more). The official Helm chart is not used: it predates the Temporal requirement
(Postiz >= v2.12), depends on Bitnami images and forces secrets into Helm values.

## Secrets (manual, never in git)

Use URL-safe values (hex), the Postgres password is embedded in `DATABASE_URL`:

```bash
kubectl create namespace postiz
kubectl -n postiz create secret generic postiz-secrets \
  --from-literal=postgres-password="$(openssl rand -hex 24)" \
  --from-literal=jwt-secret="$(openssl rand -hex 32)"
```

Optional social network credentials (variable names in the Postiz configuration reference):

```bash
kubectl -n postiz create secret generic postiz-providers \
  --from-literal=LINKEDIN_CLIENT_ID=... --from-literal=LINKEDIN_CLIENT_SECRET=...
kubectl -n postiz rollout restart deployment/postiz
```

## After the first login

Create your account, then set `DISABLE_REGISTRATION` to `"true"` in `deployment.yaml`.

# English Coach

Personal English coach for AI agents (https://github.com/pabpereza/english-coach), public at
https://english-coach.pabpereza.dev. It serves the web app, the remote MCP endpoint
(`/mcp/<secret>`) and stores its data as JSON in the english-coach git repository, committing
and pushing every change with a deploy key. The PVC only holds a working copy of that repository.

Image: `ghcr.io/pabpereza/english-coach` (linux/amd64 + linux/arm64, built by the english-coach
repository's CI), updated by argocd-image-updater on new digests.

## Secrets (manual, never in git)

1. Deploy key with write access to the english-coach repository only:

   ```bash
   ssh-keygen -t ed25519 -f english-coach-deploy-key -N "" -C english-coach@homelab
   gh repo deploy-key add english-coach-deploy-key.pub -R pabpereza/english-coach --allow-write -t homelab
   ```

2. Secret with the deploy key and the access secret (URL-safe, it is part of the MCP URL):

   ```bash
   kubectl create namespace english-coach
   kubectl -n english-coach create secret generic english-coach-secrets \
     --from-literal=coach-secret="$(openssl rand -hex 32)" \
     --from-file=deploy-key=english-coach-deploy-key
   rm english-coach-deploy-key english-coach-deploy-key.pub
   ```

3. GHCR pull secret (the image is private, like the repository), copied from another namespace:

   ```bash
   kubectl -n unir get secret ghcr-credentials -o json \
     | jq '{apiVersion, kind, type, data, metadata: {name: .metadata.name, namespace: "english-coach"}}' \
     | kubectl apply -f -
   ```

Read the access secret (web login and MCP URL) with:

```bash
kubectl -n english-coach get secret english-coach-secrets -o jsonpath='{.data.coach-secret}' | base64 -d
```

## DNS

Create the `english-coach.pabpereza.dev` DynHost in OVH and add it to the `hostnames` key of
`infra/ddns-credentials`.

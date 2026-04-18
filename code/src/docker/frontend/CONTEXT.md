# code/src/docker/frontend — Frontend Dockerfiles

One `Dockerfile.<env>` per environment.
Build context for all Dockerfiles is the **project root** — COPY paths are relative to it.

## Dockerfiles

| File                 | Runtime                 | Output                          |
| -------------------- | ----------------------- | ------------------------------- |
| `Dockerfile.dev`     | `node:24.15.0-alpine`   | `next dev` (hot-reload)         |
| `Dockerfile.test`    | `node:24.15.0-alpine`   | `pnpm run test` (Vitest)        |
| `Dockerfile.staging` | `nginx:alpine` (runner) | Next.js static export via Nginx |
| `Dockerfile.prod`    | `nginx:alpine` (runner) | Next.js static export via Nginx |

## Dev & test pattern

Dependencies are installed at `/workspace/node_modules` (pnpm workspace root).
The frontend source at `code/src/frontend/` is mounted as a volume in dev so the
dev server picks up changes live. An anonymous volume preserves the container's
`node_modules` so the volume mount does not overwrite them.

In test, the source is baked into the image and the container runs `pnpm run test`.
Run tests manually via:

```bash
docker compose -f code/src/docker/docker-compose.test.yml exec frontend-test pnpm run test
```

## Staging & prod pattern (multi-stage)

Stage 1 (`builder`) — `node:24.15.0-alpine`:

1. Enable corepack, activate pnpm 10.33.0
2. Copy workspace root files + `code/src/frontend/package.json`
3. `pnpm install --frozen-lockfile` (cached layer)
4. Copy frontend source
5. Inject `NEXT_PUBLIC_GRAPHQL_URL` build arg
6. `pnpm run build` → generates static export in `out/`

Stage 2 (`runner`) — `nginx:alpine`:

- Copies `out/` to `/usr/share/nginx/html`
- Uses `nginx/frontend-static.conf` for routing

**Requires `output: 'export'` in `next.config.ts`.**

## Build args (staging / prod)

| Arg                       | When required | Description                                             |
| ------------------------- | ------------- | ------------------------------------------------------- |
| `NEXT_PUBLIC_GRAPHQL_URL` | Build time    | Baked into the static export — cannot change at runtime |

Pass via compose `build.args` or `--build-arg` in CI.

## Ports

| Environment | Container port | Exposed as                 |
| ----------- | -------------- | -------------------------- |
| dev         | 3000           | internal (via nginx proxy) |
| test        | 3000           | internal (via nginx proxy) |
| staging     | 80             | `127.0.0.1:3001`           |
| prod        | 80             | `127.0.0.1:3001`           |

## Cross-references

- `code/src/docker/nginx/CONTEXT.md` — Nginx configs used by staging/prod runner
- `code/src/docker/CONTEXT.md` — environment overview
- `code/src/frontend/CONTEXT.md` — Next.js project structure and scripts

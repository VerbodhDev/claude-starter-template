# Tech Stack

> **TEMPLATE — fill this in when the project is initialized.**
> One section per deployable application/surface. Bullets, not prose.
> State *what is actually used and running*, with versions — not what you
> might use. Delete surfaces that don't exist. Re-verify on every major
> dependency or runtime change; an out-of-date stack doc misleads agents.

Canonical stack reference for the surfaces in this repo that the agent
should understand quickly.

---

## <Application 1 — e.g. Backend service> (`<root-path>`)

One-line description: _TODO — what this surface is and its runtime model._

### Core runtime
- **Language / version:** `<e.g. TypeScript / Node 20>`
- **Framework:** `<framework + version>`
- **Entrypoint:** `<path>`
- **Runtime model:** `<long-running server / serverless / batch / agent>`

### Data layer
- **Datastore:** `<engine + where it runs>`
- **Access:** `<ORM / driver>` — schema/migration model: `<…>`

### Authentication
- **Provider / scheme:** `<…>` — token verified where: `<…>`

### Cloud / platform integrations
- `<service>` — `<what for>`

### API, scheduling, app services
- `<…>`

### Tooling
- Build: `<…>` · Lint: `<…>` · Test: `<…>`

### Deployment
- **Runtime target:** `<e.g. containers on X / static host / functions>`
- **Pipeline:** `<CI workflow>` → `<artifact>` → `<rollout mechanism>`
- **Apply/migration gate, if any:** `<…>` (see
  `wiki/concepts/pipeline-and-deploy-reality.md`)

---

## <Application 2 — e.g. Frontend> (`<root-path>`)

One-line description: _TODO._

### Core runtime
- **Language / version:** `<…>`
- **Framework / build tool:** `<…>`

### Routing and app shell
- `<…>`

### Auth and user session
- `<…>`

### Data fetching / backend integration
- `<client + the single sanctioned API boundary>`

### UI stack
- `<component lib / styling system / design tokens>`

### Tooling
- Build: `<…>` · Lint: `<…>` · Test: `<…>`

### Deployment
- **Runtime target:** `<…>`
- **Pipeline:** `<CI workflow>` → `<artifact>` → `<rollout>`

---

## <Application 3 — e.g. Infrastructure / Agent> (`<root-path>`)

_(Repeat the section pattern above for any further surface, or delete.)_

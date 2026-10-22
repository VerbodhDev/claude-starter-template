# File Map

> **TEMPLATE — fill this in when the project is initialized.**
> Replace every `<…>` and example row with real paths. One row per path.
> The table says *what a file is for* — read the actual code for behaviour.
> Delete package sections that don't exist; add ones that do. Keep it
> current: a stale file-map is worse than none (it sends agents to the
> wrong file confidently).

Path-to-purpose quick reference covering the **<package A>**, **<package B>**,
and **<package C>** surfaces of this repo. Use this to find a file fast.

---

# <Package A — e.g. Backend> (`<root-path>`)

## App entry and composition

| Path | Purpose |
|---|---|
| `<root>/<entrypoint>` | _TODO: bootstrap — what it wires, what it starts._ |
| `<root>/<composition-root>` | _TODO: the module/DI graph root._ |

## <Subsystem — e.g. Authentication & identity>

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

## <Subsystem — e.g. Feature modules>

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

## <Subsystem — e.g. Shared infrastructure / data layer>

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

## Build, deploy, and config

| Path | Purpose |
|---|---|
| `<path>` | _TODO: Dockerfile / CI / env templates / IaC._ |

## Scripts

| Path | Purpose |
|---|---|
| `<path>` | _TODO: operator/automation scripts and what each does._ |

---

# <Package B — e.g. Frontend> (`<root-path>`)

## App entry and shell

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

## Pages / routes

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

## Components

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

## Hooks / state

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

## Libraries and API clients

| Path | Purpose |
|---|---|
| `<path>` | _TODO: the single sanctioned API-client boundary._ |

---

# <Package C — e.g. Infrastructure / Agent / Service> (`<root-path>`)

### Root files and state surfaces

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

### CLI / runtime composition

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

### Internal runtime packages

| Path | Purpose |
|---|---|
| `<path>` | _TODO._ |

---

# CI / Pipelines (`<ci-path e.g. .github/workflows/>`)

| Path | Purpose | Trigger |
|---|---|---|
| `<workflow-file>` | _TODO: what it builds/deploys._ | _TODO: push paths / dispatch / auto-redeploy?_ |

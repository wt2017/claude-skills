---
name: analyze-project
description: >
  Analyze a software project's codebase to produce architecture.html and
  deployment.html. Invoke this skill explicitly via /analyze_project or by
  asking "analyze this project" — it reads the full project structure,
  identifies frameworks, dependencies, data stores, and deployment patterns,
  then writes structured HTML documentation. If no deployment configuration is
  found, it also generates a complete Helm chart.
---

# Analyze Project Skill

When invoked, this skill analyzes a software project's codebase and produces
two files: `architecture.html` and `deployment.html`. If the project lacks
deployment configuration, it also generates a Helm chart.

## Workflow

### Phase 1: Project Discovery

Read the project structure to understand what you're working with:

1. **Top-level listing** — Read the root directory. Note `package.json`,
   `Cargo.toml`, `go.mod`, `pyproject.toml`, `pom.xml`, `build.gradle`,
   `CMakeLists.txt`, `Gemfile`, `mix.exs`, or similar.

2. **Language & framework identification** — From build files and source
   extensions, determine the primary language(s), framework, and runtime.

3. **Source tree** — Map `src/`, `lib/`, `app/`, `cmd/`, `internal/`, or
   analogous directories. Read key entry points (e.g., `main.go`, `app.js`,
   `main.py`, `App.tsx`, `routes/`, `api/`).

4. **Dependencies** — Read lock/manifest files for significant libraries:
   databases, message queues, caches, SDKs.

5. **Data layer** — Look for schema files, migration directories, ORM models,
   raw SQL files, seed data.

6. **Configuration** — Read config files (`.env.example`, `config/`,
   `settings` files) to understand environment variables, connection strings,
   and tunable parameters.

7. **Container & deployment** — Check for `Dockerfile`, `docker-compose.yml`,
   `Dockerfile.*`, `k8s/`, `deploy/`, `.github/workflows/`, `.gitlab-ci.yml`,
   `Jenkinsfile`, `skaffold.yaml`, `helm/` directories.

### Phase 2: Architecture Analysis

Produce `architecture.html` with these sections, using a clean dark-themed HTML page
with inline styles (no external dependencies):

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Architecture - <project-name></title>
<style>
  :root {
    --bg: #0d1117; --surface: #161b22; --border: #30363d;
    --text: #e6edf3; --muted: #8b949e; --accent: #58a6ff;
    --green: #3fb950; --orange: #d29922; --purple: #bc8cff;
  }
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif; background: var(--bg); color: var(--text); line-height: 1.6; padding: 2rem; }
  .container { max-width: 960px; margin: 0 auto; }
  h1 { font-size: 2rem; border-bottom: 1px solid var(--border); padding-bottom: .5rem; margin-bottom: 1.5rem; }
  h2 { font-size: 1.4rem; margin-top: 2rem; margin-bottom: .75rem; color: var(--accent); }
  h3 { font-size: 1.1rem; margin-top: 1.5rem; margin-bottom: .5rem; }
  table { width: 100%; border-collapse: collapse; margin: 1rem 0; }
  th, td { border: 1px solid var(--border); padding: .5rem .75rem; text-align: left; }
  th { background: var(--surface); color: var(--muted); font-weight: 600; }
  code { background: var(--surface); padding: .15em .4em; border-radius: 4px; font-size: .85em; }
  ul, ol { padding-left: 1.5rem; margin: .5rem 0; }
  li { margin: .25rem 0; }
  .tag { display: inline-block; background: var(--surface); border: 1px solid var(--border); padding: .1em .6em; border-radius: 12px; font-size: .8em; color: var(--muted); }
  .module { background: var(--surface); border: 1px solid var(--border); border-radius: 8px; padding: 1rem; margin: .75rem 0; }
  .module h4 { color: var(--green); margin-bottom: .25rem; }
  .module p { color: var(--muted); font-size: .9rem; }
</style>
</head>
<body>
<div class="container">

<h1>Architecture: <project-name></h1>

<h2>Overview</h2>
<p><!-- 1-2 paragraph description of what this project does --></p>

<h2>Tech Stack</h2>
<table>
  <tr><th>Category</th><th>Choice</th></tr>
  <tr><td>Language</td><td><!-- primary language(s) --></td></tr>
  <tr><td>Runtime</td><td><!-- Node/Python/Go/JVM/etc --></td></tr>
  <tr><td>Framework</td><td><!-- Express/Django/Spring/etc --></td></tr>
  <tr><td>Database</td><td><!-- PostgreSQL/MySQL/Redis/etc --></td></tr>
  <tr><td>Messaging</td><td><!-- Kafka/RabbitMQ/NATS/etc --></td></tr>
  <tr><td>Cache</td><td><!-- Redis/Memcached/etc --></td></tr>
  <tr><td>Frontend</td><td><!-- React/Vue/Astro/etc --></td></tr>
</table>

<h2>System Architecture</h2>
<p><!-- Describe the system architecture: monolith, microservices, event-driven, layered, hexagonal, etc. List major modules/components and their responsibilities. --></p>

<h2>Data Flow</h2>
<p><!-- Describe how data flows through the system, including key data structures and storage. --></p>

<h2>Key Modules</h2>

<div class="module">
  <h4><!-- module-name-1 --></h4>
  <p><strong>Purpose:</strong> <!-- purpose --></p>
  <p><strong>Entry point:</strong> <code><!-- path --></code></p>
  <p><strong>Key files:</strong> <!-- file list --></p>
</div>

<div class="module">
  <h4><!-- module-name-2 --></h4>
  <p><strong>Purpose:</strong> <!-- purpose --></p>
  <p><strong>Entry point:</strong> <code><!-- path --></code></p>
  <p><strong>Key files:</strong> <!-- file list --></p>
</div>

<h2>External Dependencies</h2>
<ul>
  <li><!-- external service / API / infrastructure --></li>
</ul>

<h2>Configuration</h2>
<p><!-- Key environment variables or config files. --></p>

</div>
</body>
</html>
```

Fill in the sections based on your analysis. Be specific — include actual
file paths, class/function names, database tables, API endpoints.

### Phase 3: Deployment Analysis

Produce `deployment.html` and **generate all necessary deployment files
directly into the project directory**. The principle is: document AND
generate — every YAML or chart file mentioned in deployment.html should
exist on disk.

### Phase 3a: Analyze existing deployment

Check what deployment configuration already exists:

- **Dockerfile / Docker Compose** — note build method, base image, exposed ports
- **K8s manifests** (`.yaml`, `k8s/`, `deploy/`) — read all, understand the
  resource types, configurations, and patterns
- **Helm charts** (`helm/`, `Chart.yaml`) — note the chart structure
- **CI/CD** (`.github/workflows`, `.gitlab-ci.yml`, `Jenkinsfile`)
- **Other** (Nomad, Ansible, shell scripts, docker-compose)

### Phase 3b: Generate deployment files

**CRITICAL RULE: Always generate the BEST available deployment format.**
Do not just document what exists — improve it by generating files.

| Existing config | Action |
|----------------|--------|
| Nothing | Generate full Helm chart |
| Only Dockerfile | Generate Helm chart + optionally docker-compose.yml |
| Only raw K8s YAML | Generate Helm chart (structured, parametrized) + preserve existing raw YAML |
| Only docker-compose | Generate Helm chart |
| Already has Helm | Document and improve if incomplete |

#### Case A: Generate a Helm chart (preferred)

This is the default choice unless the project is clearly not K8s-deployed.

**Analysis before generation:** Determine what infrastructure is needed:

- **Web/API service**: Deployment + Service + Ingress (always)
- **Database** (PostgreSQL, MySQL, etc.): StatefulSet or use `bitnami/postgresql`
  as a dependency. With PVC.
- **Redis**: Deployment with PVC or `bitnami/redis` dependency.
- **Queue/stream** (Kafka, RabbitMQ): StatefulSet with PVC, or bitnami dep.
- **Background workers**: Separate Deployment (no Service/Ingress needed, but
  may need a Service for internal metrics).
- **Cron jobs**: CronJob resource.
- **Static files / frontend**: Ingress with static file serving or CDN
  config, or nginx sidecar.

**CRITICAL: WRITE ALL FILES TO DISK.** Create the full Helm chart directory
structure under `helm/<project-name>/`:

```
helm/<project-name>/
├── Chart.yaml
├── values.yaml
├── templates/
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── configmap.yaml
│   ├── secret.yaml          (values reference only, no real secrets)
│   ├── pvc.yaml             (if stateful storage needed)
│   ├── hpa.yaml             (if resource specs are known)
│   └── NOTES.txt
├── .helmignore
```

**Key principles for Helm generation:**

- Write every file using the Write tool. Do NOT skip files.
- Make `values.yaml` the single source of truth. All template values
  reference `Values.*`.
- Use `_helpers.tpl` for shared name/render functions.
- Default resource requests/limits should be conservative (e.g., 256Mi RAM,
  200m CPU for small services).
- Image repository and tag should be configurable via `values.yaml`.
- Add `helm-docs`-compatible comments in `values.yaml` so the user can run
  `helm-docs` later.
- Database dependencies (PostgreSQL, Redis) should be optional via
  `values.yaml` flags so the user can point to an external instance.
- Include `.helmignore` with sensible defaults (`.git`, `*.md`, etc.).
- If existing raw K8s YAML exists, **preserve its logic** and translate
  configuration into the Helm templates — do NOT lose probes, resource
  limits, env vars, etc. Keep the original raw YAML file unchanged in the
  project root; the Helm chart is the improved alternative.

#### Case B: Non-K8s deployment (e.g., docker-compose only)

Generate `docker-compose.yml` and any supporting config files:

```
docker-compose.yml
.env.example
```

#### Case C: Existing raw K8s YAML

Keep the existing file unchanged. ALSO generate the Helm chart as the
improved, parametrized version. Reference both files in deployment.html.

### Phase 3c: Write deployment.html

Document what was generated and reference every file on disk:

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Deployment - <project-name></title>
<style>
  :root {
    --bg: #0d1117; --surface: #161b22; --border: #30363d;
    --text: #e6edf3; --muted: #8b949e; --accent: #58a6ff;
    --green: #3fb950; --orange: #d29922;
  }
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,Arial,sans-serif; background: var(--bg); color: var(--text); line-height: 1.6; padding: 2rem; }
  .container { max-width: 960px; margin: 0 auto; }
  h1 { font-size: 2rem; border-bottom: 1px solid var(--border); padding-bottom: .5rem; margin-bottom: 1.5rem; }
  h2 { font-size: 1.4rem; margin-top: 2rem; margin-bottom: .75rem; color: var(--accent); }
  h3 { font-size: 1.1rem; margin-top: 1.5rem; margin-bottom: .5rem; color: var(--green); }
  table { width: 100%; border-collapse: collapse; margin: 1rem 0; font-size: .9rem; }
  th, td { border: 1px solid var(--border); padding: .5rem .75rem; text-align: left; }
  th { background: var(--surface); color: var(--muted); font-weight: 600; }
  code { background: var(--surface); padding: .15em .4em; border-radius: 4px; font-size: .85em; }
  pre { background: var(--surface); border: 1px solid var(--border); border-radius: 8px; padding: 1rem; overflow-x: auto; margin: .75rem 0; }
  pre code { background: none; padding: 0; }
  ul, ol { padding-left: 1.5rem; margin: .5rem 0; }
  li { margin: .25rem 0; }
  .file-grid { display: grid; grid-template-columns: 1fr 2fr; gap: 0; border: 1px solid var(--border); border-radius: 8px; overflow: hidden; margin: 1rem 0; }
  .file-grid > div { padding: .5rem .75rem; border-bottom: 1px solid var(--border); font-size: .9rem; }
  .file-grid > div:nth-child(-n+2) { background: var(--surface); font-weight: 600; color: var(--muted); }
  .file-grid > div:last-child, .file-grid > div:nth-last-child(2) { border-bottom: none; }
</style>
</head>
<body>
<div class="container">

<h1>Deployment: <project-name></h1>

<h2>Architecture</h2>
<p><!-- Describe the deployment architecture — which components, how they connect. --></p>

<h2>Generated Files</h2>
<div class="file-grid">
  <div>File</div><div>Description</div>
  <div><code>helm/&lt;project-name&gt;/Chart.yaml</code></div><div>Helm chart metadata</div>
  <div><code>helm/&lt;project-name&gt;/templates/deployment.yaml</code></div><div>Main app Deployment</div>
  <div>...</div><div>...</div>
</div>

<h2>Prerequisites</h2>
<ul>
  <li>Kubernetes cluster 1.24+</li>
  <li>Helm 3.8+</li>
  <li><!-- if DB --> PVC support in the cluster</li>
  <li><!-- if TLS --> cert-manager or manual certificate</li>
</ul>

<h2>Quick Start</h2>
<pre><code># Install with Helm
helm upgrade --install &lt;project-name&gt; ./helm/&lt;project-name&gt;

# With custom values
helm upgrade --install &lt;project-name&gt; ./helm/&lt;project-name&gt; \
  --set image.tag=v1.0.0 \
  --set postgresql.enabled=true</code></pre>

<h2>Configuration</h2>
<table>
  <tr><th>Parameter</th><th>Description</th><th>Default</th></tr>
  <tr><td>...</td><td>...</td><td>...</td></tr>
</table>
<p>See <code>helm/&lt;project-name&gt;/values.yaml</code> for full configuration reference.</p>

<h2>Components</h2>
<table>
  <tr><th>Component</th><th>Type</th><th>Port</th><th>Storage</th></tr>
  <tr><td><!-- name --></td><td>Deployment/StatefulSet</td><td><!-- port --></td><td><!-- PVC if any --></td></tr>
</table>

<h2>Environment Variables</h2>
<table>
  <tr><th>Variable</th><th>Description</th><th>Required</th></tr>
  <tr><td>...</td><td>...</td><td>yes/no</td></tr>
</table>

<h2>Production Considerations</h2>
<ul>
  <li>Resource scaling (HPA thresholds)</li>
  <li>Backup strategy for persistent data</li>
  <li>Monitoring (prometheus rules, if applicable)</li>
  <li>TLS/certificate management</li>
  <li>Rolling update strategy</li>
</ul>

</div>
</body>
</html>
```

### Phase 4: Output

Write/update the following in the project's root directory:

- `architecture.html` — architecture documentation (HTML, dark themed, no external deps)
- `deployment.html` — deployment documentation referencing all generated files (HTML, dark themed, no external deps)
- `helm/<project-name>/` — full Helm chart (ALL files written to disk)

Present a summary with a file tree of generated content. Note that the
user should review `values.yaml` and fill in any placeholder secrets.

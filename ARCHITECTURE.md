# Architecture

High-level architecture of the current AI appliance.

## Overview

The appliance is built around a virtualized Ubuntu AI workload running on XCP-ng with direct GPU passthrough.

The main application stack consists of:

- Ollama for local model inference
- Open WebUI as the primary user interface
- SearXNG for web search
- Microsoft Entra ID for authentication
- MCP integrations for selected internal systems

## Platform Architecture

```text
Users
  │
  ▼
HTTPS / Reverse Proxy
  │
  ▼
Open WebUI
  │
  ├── Microsoft Entra ID
  │      └── User authentication
  │
  ├── Ollama
  │      └── Local LLM inference
  │
  ├── SearXNG
  │      └── Web search
  │
  └── MCP integrations
         ├── Outline
         └── Twenty CRM
```

## Infrastructure Layer

```text
Dell PowerEdge R740
  │
  ▼
XCP-ng 8.3
  │
  ▼
Ubuntu 24.04 AI VM
  │
  ├── 72 vCPUs
  ├── ~256 GB RAM
  ├── RTX 4000 Ada #1 ── PCI passthrough
  ├── RTX 4000 Ada #2 ── PCI passthrough
  │
  └── NVMe-backed virtual storage
```

The detailed physical hardware configuration is documented in [`HARDWARE.md`](HARDWARE.md).

## Application Layer

### Ollama

Ollama runs directly inside the Ubuntu VM as a systemd service.

It provides:

- local model inference,
- multi-GPU access,
- model lifecycle management,
- HTTP API on port `11434`.

Open WebUI accesses Ollama through:

```text
http://host.docker.internal:11434
```

The current systemd override is documented under:

```text
configs/ollama/override.conf
```

### Open WebUI

Open WebUI runs as a Docker container.

It provides:

- the main user-facing chat interface,
- model presets,
- authentication,
- web-search integration,
- MCP tool integration.

Persistent application data is stored under:

```text
/mnt/ai-data/openwebui
```

### SearXNG

SearXNG runs as a separate Docker container and provides web-search results to Open WebUI.

Open WebUI communicates with SearXNG over the internal Docker network:

```text
http://searxng:8080
```

The public SearXNG endpoint is exposed separately through the reverse proxy.

Persistent configuration is stored under:

```text
/mnt/ai-data/searxng
```

The repository contains a sanitized example configuration under:

```text
configs/searxng/settings.yml.example
```

## Authentication

Microsoft Entra ID is used for Open WebUI authentication through OpenID Connect.

Authentication configuration is supplied through Docker environment variables and secrets stored outside Git.

The production client secret and application secrets must never be committed to the repository.

## Internal Knowledge Integrations

### Outline

Status: **working**

Outline is connected through MCP and serves as the primary source for internal documentation, procedures, architecture notes, and company knowledge.

### Twenty CRM

Status: **working**

Twenty CRM is connected through MCP for access to customer, company, contact, opportunity, and sales context.

## Integrations on Hold

### Plane

MCP connectivity was technically validated, but the integration requires Plane Business.

The current environment uses Plane Pro, so this integration is not active.

### Xen Orchestra

An MCP integration was evaluated but is currently postponed because the available implementation does not support the required OAuth authentication model.

### Zabbix

Native MCP support is not currently available in the deployed Zabbix environment.

The integration remains planned for later evaluation.

## Storage

The AI VM is stored on an NVMe-backed XCP-ng Storage Repository.

Inside the VM, AI-related persistent data is stored under:

```text
/mnt/ai-data
```

This currently includes:

- Ollama models,
- Docker/container data,
- Open WebUI data,
- SearXNG configuration and data.

Storage architecture and performance measurements are documented in:

- [`HARDWARE.md`](HARDWARE.md)
- [`benchmarks/storage.md`](benchmarks/storage.md)

## Design Principles

The appliance follows several practical design principles:

- keep inference local,
- retain control over company data,
- prefer open and self-hosted components,
- separate secrets from repository configuration,
- use hardware passthrough where it provides measurable benefit,
- keep internal systems authoritative for company-specific data,
- document measured behavior rather than assumed performance,
- add components only when they solve a real operational need.

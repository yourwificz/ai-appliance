# AI Appliance

> A practical, self-hosted AI appliance for modern IT operations, built with open technologies.

![Status](https://img.shields.io/badge/status-active-success)
![License](https://img.shields.io/badge/license-Apache--2.0-blue)

---

## Overview

**AI Appliance** is an open engineering project documenting the design, implementation, benchmarking, and optimization of a self-hosted AI environment for real-world IT operations.

The project originated as the internal AI platform for **YOURWiFi** and **EXTIT** and is being developed around actual operational use cases including engineering, software development, IT operations, documentation, knowledge management, research, and business processes.

The objective is not to design an idealized reference architecture on paper. The appliance is built, operated, measured, changed, and documented as it evolves.

This repository publishes the parts of that work that are useful and reproducible: architecture, hardware configuration, deployment examples, tuning, benchmark methodology, measured results, and lessons learned.

---

## Project Goals

- Build a practical private AI platform for day-to-day IT operations
- Keep organizational knowledge and sensitive data under organizational control
- Reuse capable enterprise hardware where it makes technical and economic sense
- Prefer open technologies and interoperable standards
- Integrate AI with existing operational and knowledge systems
- Benchmark performance-sensitive architectural decisions
- Document both successful approaches and dead ends
- Provide a reproducible reference for similar deployments

---

## Reference Platform

The current reference implementation is based on a **Dell PowerEdge R740**.

| Component | Current configuration |
|---|---|
| Server | Dell PowerEdge R740 |
| CPU | 2 × Intel Xeon Gold 6140, 18C / 36T each |
| CPU resources | 36 physical cores / 72 logical processors |
| Memory | 384 GB DDR4 ECC RDIMM @ 2666 MT/s |
| GPUs | 2 × NVIDIA RTX 4000 Ada Generation |
| GPU memory | 40 GB GDDR6 ECC total, 20 GB per GPU |
| Hypervisor | XCP-ng 8.3 |
| AI guest OS | Ubuntu Server 24.04 LTS |
| AI VM | 72 vCPUs, ~256 GB RAM |
| GPU access | PCI passthrough of both GPUs |
| System storage | 2 × Dell SSD in RAID1 |
| AI storage | 4 × Samsung 990 EVO Plus 1 TB NVMe |
| NVMe adapter | QNAP QM2-4P-384 |
| NVMe adapter uplink | PCIe Gen3 x8 via ASMedia ASM2824 |
| RAID | Linux `mdadm` RAID10 |
| Usable AI storage | ~2 TB |

Detailed hardware and storage topology is documented in [`HARDWARE.md`](HARDWARE.md).

---

## Software Stack

### Infrastructure

- XCP-ng 8.3
- Ubuntu Server 24.04 LTS
- Docker
- Linux `mdadm`
- ext4

### AI Platform

- Ollama
- Open WebUI
- Model Context Protocol (MCP)

### Search and Knowledge

- SearXNG
- Outline
- Twenty CRM

### Authentication

- Microsoft Entra ID
- OpenID Connect

The current application and infrastructure architecture is documented in [`ARCHITECTURE.md`](ARCHITECTURE.md).

---

## Current Architecture

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
  │      └── Authentication
  │
  ├── Ollama
  │      └── Local LLM inference
  │
  ├── SearXNG
  │      └── Web search
  │
  └── MCP
         ├── Outline
         └── Twenty CRM
```

Ollama runs directly inside the Ubuntu VM. Open WebUI and SearXNG run as Docker containers.

Both NVIDIA GPUs are passed directly from XCP-ng to the AI VM.

---

## Integration Status

| Component | Status | Notes |
|---|:---:|---|
| Ollama | ✅ | Working |
| Open WebUI | ✅ | Working |
| Microsoft Entra ID SSO | ✅ | OpenID Connect authentication |
| SearXNG | ✅ | Integrated with Open WebUI |
| Outline MCP | ✅ | Primary internal documentation source |
| Twenty CRM MCP | ✅ | CRM integration |
| Plane MCP | ⏸️ | Technically validated; requires Plane Business, currently using Pro |
| Xen Orchestra MCP | ⏸️ | Postponed until an acceptable OAuth authentication path is available |
| Zabbix MCP | 🚧 | Awaiting native MCP support |
| OIKB | 🚧 | Planned evaluation |

### SearXNG note

The current Open WebUI release requires a temporary web-loader workaround in this deployment. Search itself is operational, but upstream search engines may independently apply CAPTCHA or rate limiting.

---

## Current Capabilities

The appliance currently provides:

- private local LLM inference,
- general-purpose internal AI assistance,
- organizational knowledge retrieval,
- Microsoft Entra ID authentication,
- web search through SearXNG,
- internal documentation access through Outline,
- CRM lookup through Twenty,
- GPU-accelerated inference,
- multi-model operation,
- MCP-based system integration.

The current user-facing Open WebUI setup intentionally remains simple, with separate **Assistant** and **Knowledge** interfaces rather than a large collection of specialized agents.

---

## Storage Architecture

AI workloads are stored on a four-drive NVMe RAID10 array.

```text
4 × Samsung 990 EVO Plus
          │
          ▼
   QNAP QM2-4P-384
          │
          ▼
     ASM2824 switch
          │
          ▼
      PCIe Gen3 x8
          │
          ▼
     mdadm RAID10
        /dev/md0
          │
          ▼
     XCP-ng EXT SR
          │
          ▼
         VHD
          │
          ▼
   Xen virtual disk
          │
          ▼
     Ubuntu AI VM
```

Persistent AI-related data is stored under `/mnt/ai-data`, including:

- Ollama models,
- Docker data,
- Open WebUI data,
- SearXNG configuration and data.

Storage benchmarking has also exposed a significant difference between host-level NVMe performance and storage throughput observed inside the Xen guest. The investigation and measurements are documented in [`benchmarks/storage.md`](benchmarks/storage.md).

---

## Benchmarks

Measured results are published when the test setup is sufficiently documented to make the numbers meaningful.

Current benchmark areas include:

- Ollama model inference and loading,
- NVMe and RAID10 performance,
- XCP-ng storage virtualization,
- host-to-guest storage performance.

See:

- [`benchmarks/ollama.md`](benchmarks/ollama.md)
- [`benchmarks/storage.md`](benchmarks/storage.md)

Benchmark scripts are kept under [`scripts/`](scripts/).

The aim is not to produce synthetic benchmark leaderboards, but to understand how architectural decisions affect the performance of the complete appliance.

---

## Configuration and Deployment

The repository contains selected configuration from the running appliance where it is useful and safe to publish.

### Ollama

Current systemd tuning:

[`configs/ollama/override.conf`](configs/ollama/override.conf)

### Open WebUI and SearXNG

Docker deployment:

[`docker/docker-compose.yaml`](docker/docker-compose.yaml)

Example environment configuration:

[`docker/.env.example`](docker/.env.example)

### SearXNG

Sanitized configuration example:

[`configs/searxng/settings.yml.example`](configs/searxng/settings.yml.example)

Production credentials, encryption keys, OAuth secrets, and other sensitive values are intentionally excluded from the repository.

---

## Repository Structure

Only directories containing actual project artifacts are created.

```text
.
├── benchmarks/
│   ├── ollama.md
│   └── storage.md
├── configs/
│   ├── ollama/
│   │   └── override.conf
│   └── searxng/
│       └── settings.yml.example
├── docker/
│   ├── docker-compose.yaml
│   └── .env.example
├── scripts/
│   ├── ollama-bench.sh
│   └── storage-bench.sh
├── ARCHITECTURE.md
├── CONTRIBUTING.md
├── HARDWARE.md
├── LICENSE
├── README.md
└── .gitignore
```

The repository structure will grow only as new artifacts are actually added.

---

## Design Principles

### Privacy First

Company data should remain under organizational control wherever practical.

### Open Technologies

Prefer open technologies, documented interfaces, and interoperable standards over unnecessary platform lock-in.

### Measure Before Optimizing

Performance assumptions are useful starting points, not conclusions. Important changes should be measured.

### Production Before Perfection

Solve real operational problems first and improve the architecture based on actual use.

### Reproducibility

Publish enough configuration and methodology for useful results to be independently understood or reproduced.

### Document the Journey

Unexpected limitations, failed approaches, and architectural compromises are part of the engineering record.

---

## Roadmap

### Core Platform

- [x] Enterprise server platform
- [x] GPU passthrough
- [x] XCP-ng virtualization
- [x] Ubuntu AI VM
- [x] Ollama
- [x] Open WebUI
- [x] Microsoft Entra ID authentication
- [x] SearXNG integration
- [x] Outline MCP integration
- [x] Twenty CRM MCP integration

### Platform Development

- [ ] Continue storage performance investigation
- [ ] Expand reproducible benchmark coverage
- [ ] Evaluate embedding models for Czech/English knowledge retrieval
- [ ] Build and evaluate the first dedicated RAG knowledge collection
- [ ] Evaluate OIKB
- [ ] Perform multi-user concurrency testing
- [ ] Continue model and inference optimization

### Integrations

- [ ] Plane MCP if licensing permits
- [ ] Xen Orchestra MCP when suitable OAuth support is available
- [ ] Zabbix MCP when native support becomes available
- [ ] Microsoft 365 knowledge connectors
- [ ] Additional operational MCP integrations where useful

---

## Contributing

Contributions, test results, corrections, and practical deployment experience are welcome.

See [`CONTRIBUTING.md`](CONTRIBUTING.md).

---

## Related Resources

### WiFiLab

**WiFiLab by YOURWiFi** is the engineering initiative under which this project and related technical work are published.

Engineering journal: **coming soon**

### YOURWiFi

https://yourwifi.cz

### GitHub

https://github.com/yourwificz

---

## License

Source code in this repository is licensed under the **Apache License 2.0**. See [`LICENSE`](LICENSE).

Documentation, benchmark data, and other non-code material may be published under separate terms where explicitly stated.

The **YOURWiFi**, **EXTIT**, and **WiFiLab** names and logos are not granted for use under the Apache License.

---

## About

**AI Appliance** is developed by **YOURWiFi** as part of **WiFiLab by YOURWiFi**.

The project explores practical approaches to private, self-hosted AI for modern IT operations using enterprise hardware, virtualization, local inference, open technologies, and integrations with real operational systems.

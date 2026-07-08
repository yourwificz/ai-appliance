# AI Appliance

> A practical, self-hosted AI appliance for modern IT operations, built with open technologies.

![Status](https://img.shields.io/badge/status-active-success)
![License](https://img.shields.io/badge/license-Apache--2.0-blue)

---

## Overview

**AI Appliance** is an open engineering project documenting the design, implementation and optimization of a production-grade, self-hosted AI platform.

Originally developed as the internal AI environment for **YOURWiFi** and **EXTIT**, the project is used daily to support engineering, software development, IT operations, documentation, knowledge management and business processes.

Rather than building a proof-of-concept, the goal is to create a practical AI appliance capable of supporting real business operations while openly documenting architectural decisions, benchmarks, optimizations and lessons learned.

---

# Project Goals

- Build a production-ready private AI appliance
- Keep company knowledge under organizational control
- Leverage enterprise hardware using open technologies
- Integrate AI into everyday IT operations
- Benchmark every architectural decision
- Share practical engineering experience
- Provide a reproducible reference implementation

---

# Reference Hardware

The current reference platform (**Generation 1**) consists of the following hardware.

| Component | Specification |
|-----------|---------------|
| Server | Dell PowerEdge R740 |
| CPU | 2 × Intel Xeon Gold 6140 (18C / 36T, 2.30 GHz, Turbo 3.70 GHz) |
| Total CPU Resources | 36 physical cores / 72 logical processors |
| Memory | 384 GB DDR4 ECC RDIMM @ 2666 MT/s |
| GPUs | 2 × NVIDIA RTX 4000 Ada Generation |
| GPU Memory | 40 GB GDDR6 ECC (20 GB ×2) |
| Hypervisor | XCP-ng 8.3 |
| AI Guest OS | Ubuntu Server 24.04 LTS |
| AI VM Resources | 72 vCPUs, 256 GB RAM |
| System Storage | Dell BOSS RAID1 SSD |
| AI Storage | 4 × Samsung 990 EVO Plus 1 TB |
| RAID | Linux mdadm RAID10 |
| NVMe Adapter | QNAP QM2-4P-384 *(Glotrends PA41 comparison planned)* |
| Usable AI Storage | ~2 TB RAID10 |

> **Note**
>
> This hardware represents the current reference implementation. Future generations of the appliance may use different hardware while preserving the overall software architecture.

---

# Software Stack

## Infrastructure

- XCP-ng 8.3
- Ubuntu Server 24.04 LTS
- Docker

## AI

- Ollama
- Open WebUI
- Model Context Protocol (MCP)
- SearXNG

## Authentication

- Microsoft Entra ID
- OpenID Connect (Single Sign-On)

---

# Integration Status

| Component | Status | Notes |
|-----------|:------:|-------|
| Ollama | ✅ | Production |
| Open WebUI | ✅ | Production |
| Microsoft Entra ID SSO | ✅ | OpenID Connect authentication |
| SearXNG | ✅ | Integrated *(temporary Open WebUI workaround)* |
| Outline MCP | ✅ | Primary internal knowledge base |
| Twenty CRM MCP | ✅ | Production |
| Plane MCP | ⏸️ | Requires Plane Business plan (currently using Pro) |
| Xen Orchestra MCP | ⏸️ | Postponed until OAuth authentication is supported |
| Zabbix MCP | 🚧 | Awaiting native MCP support (currently on the Zabbix roadmap) |
| OIKB | 🚧 | Planned evaluation |

---

# Current Capabilities

- Private AI assistant
- Internal knowledge assistant
- Enterprise authentication
- Local LLM inference
- Web search
- Technical documentation search
- CRM information lookup
- GPU-accelerated inference
- Multi-model environment

---

# Storage Architecture

The current storage architecture consists of:

- Dell BOSS RAID1 for the hypervisor
- Linux mdadm RAID10 for AI workloads
- Local EXT Storage Repository
- Ubuntu ext4 data volume
- Dedicated AI storage for:
  - Ollama models
  - Docker data root
  - SearXNG data
  - AI datasets

Storage performance, architecture decisions and benchmarking are documented throughout the project.

---

# Design Principles

- **Privacy First** — Company data stays under your control.
- **Open Technologies** — Minimize vendor lock-in.
- **Measure Before Optimizing** — Every optimization is benchmarked.
- **Reproducible Infrastructure** — Every configuration should be reproducible.
- **Production Before Perfection** — Solve real operational problems.
- **Document the Journey** — Publish both successes and failures.

---

# Repository Structure

```text
.
├── benchmarks/        # Benchmark results and methodology
├── configs/           # Configuration examples
├── diagrams/          # Architecture diagrams
├── docker/            # Docker Compose files
├── images/            # Screenshots and illustrations
├── scripts/           # Automation and benchmarking scripts
├── tools/             # Helper utilities
├── LICENSE
├── README.md
└── .gitignore
```

---

# Roadmap

## Core Platform

- [x] Enterprise hardware platform
- [x] GPU acceleration
- [x] XCP-ng virtualization
- [x] Ubuntu AI virtual machine
- [x] Ollama
- [x] Open WebUI
- [x] Microsoft Entra ID authentication
- [x] SearXNG integration
- [x] Outline MCP integration
- [x] Twenty CRM MCP integration

## Platform Optimization

- [ ] Storage optimization
- [ ] AI model optimization
- [ ] Automated benchmark suite
- [ ] OIKB evaluation
- [ ] Performance tuning

## Enterprise Integrations

- [ ] Plane MCP *(Business license required)*
- [ ] Xen Orchestra MCP *(pending OAuth support)*
- [ ] Zabbix MCP *(awaiting native MCP support)*
- [ ] Microsoft 365 knowledge connectors
- [ ] Additional MCP integrations

---

# Benchmarks

This repository publishes reproducible benchmarks covering:

- Large Language Models
- GPU performance
- Storage
- Virtualization
- AI inference
- MCP integrations

Whenever possible, benchmark methodology and raw data are published alongside the results.

---

# Philosophy

AI Appliance follows a few simple principles:

- Measure before optimizing.
- Build for production, not demonstrations.
- Share failures as well as successes.
- Prefer open standards over proprietary solutions.
- Document engineering decisions.
- Build systems that others can reproduce.

---

# Related Resources

### Engineering Journal

**WiFiLab** *(coming soon)*

### Company

https://yourwifi.cz

### GitHub

https://github.com/yourwificz

---

# License

The source code in this repository is licensed under the **Apache License 2.0**.

Documentation, benchmark results and other non-code content may use different licenses as specified in their respective directories.

The **YOURWiFi**, **EXTIT** and **WiFiLab** names and logos are trademarks of their respective owners and are not covered by this license.

---

# About

AI Appliance is developed by **YOURWiFi** as the flagship engineering project of **WiFiLab**.

The objective is to explore, benchmark and document practical approaches to deploying private AI for modern IT operations using enterprise hardware and open technologies.

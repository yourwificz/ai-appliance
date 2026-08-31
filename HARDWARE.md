# Hardware

Current hardware configuration of the AI appliance.

## Server

**Dell PowerEdge R740**

- 2× Intel Xeon Gold 6140
  - 18 cores / 36 threads each
  - 36 physical cores / 72 threads total
- 384 GB DDR4 ECC RDIMM
- Dell BOSS-S1 boot storage
- XCP-ng 8.3 hypervisor

## GPU

2× NVIDIA RTX 4000 Ada Generation

Per GPU:

- 20 GB GDDR6 ECC VRAM
- PCIe passthrough to the AI virtual machine

Total available GPU memory:

```text
40 GB VRAM
```

Both GPUs are exposed directly to the Ubuntu AI VM using PCI passthrough.

## NVMe Storage

4× Samsung 990 EVO Plus 1 TB NVMe SSD

Current adapter:

- QNAP QM2-4P-384
- ASMedia ASM2824 PCIe switch
- PCIe Gen3 x8 upstream link

Storage layout:

- Linux `mdadm` RAID10
- approximately 2 TB usable capacity
- 512 KiB chunk size
- XCP-ng Local EXT Storage Repository on `/dev/md0`

The complete AI VM is stored on this NVMe array.

A passive PA41 PCIe x16 NVMe adapter is available for later comparison, but benchmark results have not yet been added.

## AI Virtual Machine

- Ubuntu 24.04 LTS
- 72 vCPUs
- approximately 256 GB RAM
- 2× RTX 4000 Ada passed through directly
- 30 GB system disk
- 200 GB AI data disk mounted at `/mnt/ai-data`

The `/mnt/ai-data` volume currently stores:

- Ollama models
- Docker/container data
- Open WebUI data
- SearXNG configuration and data

## Storage Architecture

```text
4× Samsung NVMe
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
       │
       └── /mnt/ai-data
```

Storage and virtualization performance measurements are documented in [`benchmarks/storage.md`](benchmarks/storage.md).

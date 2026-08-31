# Storage Benchmarks

Storage performance measurements for the AI appliance running on XCP-ng.

## Storage Configuration

- 4× Samsung 990 EVO Plus 1 TB NVMe SSD
- QNAP QM2-4P-384 PCIe adapter
- ASMedia ASM2824 PCIe Gen3 switch
- PCIe Gen3 x8 upstream link
- Linux `mdadm` RAID10
- 512 KiB chunk size
- XCP-ng 8.3
- Local EXT SR on `/dev/md0`
- Ubuntu 24.04 AI VM
- Xen virtual block device (`xvdb`)

## Host Performance

### Raw RAID10

Sequential direct read from the RAID device:

```bash
dd if=/dev/md0 of=/dev/null bs=64M count=256 iflag=direct status=progress
```

Result:

```text
~5.0 GB/s
```

### VHD File

Sequential direct read of the AI VM VHD stored on the EXT SR:

```bash
dd if=/run/sr-mount/<sr-uuid>/<vdi-uuid>.vhd \
   of=/dev/null \
   bs=64M \
   iflag=direct
```

Result:

```text
~5.0 GB/s
```

The VHD file therefore reaches approximately the same throughput as the underlying RAID array.

## Guest Performance

The same storage accessed through the Xen virtual block device inside the Ubuntu VM reaches approximately:

```text
Sequential direct read: ~1.3 GB/s
Sequential direct write: ~560 MB/s
```

A `fio` sequential-read test with 256 KiB blocks, queue depth 64 and four jobs produced approximately:

```text
~1258 MiB/s
```

Increasing concurrency and queue depth did not materially improve throughput.

## Current Bottleneck

The measurements show a large difference between host and guest performance:

| Layer | Sequential read |
|---|---:|
| Raw RAID10 | ~5.0 GB/s |
| VHD file on XCP-ng host | ~5.0 GB/s |
| Xen virtual disk inside VM | ~1.3 GB/s |

This indicates that neither the NVMe array nor the EXT filesystem is the primary sequential-read bottleneck.

The performance limit appears between the VHD storage layer and the guest virtual block device.

One notable guest-side characteristic is:

```text
/sys/block/xvdb/queue/max_hw_sectors_kb = 44
/sys/block/xvdb/queue/max_sectors_kb    = 44
```

Attempts to increase `max_sectors_kb` are rejected by the Xen block frontend.

The exact cause of the approximately 1.3 GB/s guest ceiling has not yet been confirmed.

## Planned Comparison

A passive PCIe x16 NVMe adapter will be tested later to compare:

- PCIe topology
- RAID10 throughput
- VHD throughput
- guest virtual-disk throughput
- model cold-load performance

This will help separate physical-storage improvements from Xen virtualization overhead.

# Ollama Benchmarks

This document records measured inference performance of the AI appliance.

## Test Platform

- Dell PowerEdge R740
- 2× Intel Xeon Gold 6140
- 384 GB DDR4 ECC RAM
- 2× NVIDIA RTX 4000 Ada Generation 20 GB
- Ubuntu 24.04 LTS virtual machine on XCP-ng
- Ollama with both GPUs available
- `OLLAMA_NUM_PARALLEL=2`
- `OLLAMA_SCHED_SPREAD=false`
- `OLLAMA_FLASH_ATTENTION=1`

## Current Results

| Model | Cold load | Warm load | Generation |
|---|---:|---:|---:|
| Gemma 4 26B | ~30.3 s | ~0.48 s | ~78.5 tok/s |
| Qwen 3.6 35B Expert | ~43.6 s | ~0.32 s | ~68.3 tok/s |
| Gemma 4 E4B | — | — | ~75–77 tok/s |

## Gemma 4 26B — Storage Comparison

The Gemma 4 26B model was measured before and after moving the complete AI VM to the NVMe RAID10 storage pool.

| Storage | Cold load | Warm load | Generation |
|---|---:|---:|---:|
| Previous storage | ~37.8 s | ~0.54 s | ~79.7 tok/s |
| NVMe RAID10 | ~30.3 s | ~0.48 s | ~78.5 tok/s |

Moving the VM to NVMe storage reduced cold model loading time by approximately 7.5 seconds, or about 20%, while generation speed remained effectively unchanged.

This indicates that model loading is meaningfully affected by storage performance, while steady-state inference is primarily GPU-bound.

## Notes

These results are intended as practical appliance measurements rather than synthetic GPU benchmarks.

Results may vary with:

- model quantization,
- context size,
- prompt length,
- Ollama version,
- concurrent requests,
- GPU scheduling,
- storage state and caching,
- model residency in VRAM.

The benchmark methodology and scripts may evolve as the appliance develops.

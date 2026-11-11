# Oikonomia PAS: 3D Voxel Conformational Screening

Zero-copy DMA hardware pre-filtering on AWS EC2 f2.6xlarge to eliminate GPU VRAM fragmentation and batch OOM crashes across 10M+ compound libraries.

## Validated Hardware Telemetry (0xf000)
- **Execution Latency:** 102.22 µs DMA transfer across 4,096-byte coordinate blocks
- **Spatial Invariance:** 0.762 ms spatial evaluation (Lipschitz contraction verified)
- **Reliability:** 0% OOM failure rate during continuous 10M+ compound library streaming
- **Operating Profile:** 9 Watts steady-state internal voltage rail (Vccint)

## Ingestion Example (C++ XDMA)
```cpp
#include "oikonomia_pas.h"

// Stream 3D coordinate voxel blocks directly via 512-bit AXI4-Stream zero-copy DMA
OikonomiaPAS::stream_voxel_block(compound_coordinates, 4096);
```

## Zero-Touch Enclave Deployment
Use `deploy_enclave.tf` to provision an air-gapped, zero-egress evaluation sandbox in your AWS tenant.

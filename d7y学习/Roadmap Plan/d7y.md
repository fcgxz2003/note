# Dragonfly Roadmap

This document outlines the high-level roadmap for the Dragonfly project. The roadmap is subject to change and is not a commitment to deliver any specific features or timelines. The roadmap is updated every year, after a release.

## Releases

[GitHub milestones](https://github.com/dragonflyoss/Dragonfly2/milestones) are created for each release and are named after the release version. GitHub issues are assigned to a milestone to track the scope and progress of a release.

### Current Release

The current Dragonfly release is v2.1.0. Details can be found in the [release notes](https://github.com/dragonflyoss/Dragonfly2/releases/tag/v2.1.0).

### Next Release

The next release is v2.2.0 This release is currently in development. The [%这个地址要更新 release planning](https://d7y.io/docs/next/roadmap-v2.2/) contains the features and enhancements planned for this release.

### Future Releases

Features or important changes for future releases include:

**Manager:**
- Peer features are configurable. For example, you can make the peer can not be uploaded and can only be downloaded.
- Configure the weight of the scheduling.
- Add clearing P2P task cache.
- Display P2P traffic distribution.
- Peer information display, including CPU, Memory, etc.

**Scheduler:**
- Provide metadata storage to support file writing and seeding.
- Optimize scheduling algorithm and improve bandwidth utilization in the P2P network.

**Client:**
- Client written in Rust, reduce CPU usage and Memory usage.
- Supports RDMA for faster network transmission in the P2P network. It can better support the loading of AI inference models into memory.
- Supports file writing and seeding, it can be accessed in the P2P cluster without uploading to other storage. Helps AI models and AI datasets to be read and written faster in the P2P network.

**Others:**
- Defines the V2 of the P2P transfer protocol.

**Document:**
- Restructure the document to make it easier for users to use.
Enhance the landing page UI.

**AI Infrastructure:**
- Supports Triton Inference Server to accelerate model distribution, refer to dragonfly-repository-agent.
- Supports TorchServer to accelerate model distribution, refer to document.
- Supports HuggingFace to accelerate model distribution and dataset distribution, refer to document.
- Supports Git LFS to accelerate file distribution, refer to document.
- Supports JuiceFS to accelerate file downloads from object storage, JuiceFS read requests via peer proxy and write requests via the default client of object storage.
- Supports Fluid to accelerate model distribution.
- Support AI infrastructure to efficiently distribute models and datasets, and integrated with the AI ecosystem.

New ideas and improvements are always welcome. Please check the existing issues in the relevant Dragonfly repositories before submitting a new issue with your idea. New APIs or breaking changes to the Dragonfly runtime should be submitted as proposals in the [issues](https://github.com/dragonflyoss/Dragonfly2/issues).

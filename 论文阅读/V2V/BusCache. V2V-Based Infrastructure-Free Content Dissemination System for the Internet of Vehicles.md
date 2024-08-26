BusCache: V2V-Based Infrastructure-Free Content Dissemination System for the Internet of Vehicles

2024 IEEE Access 论文出处不好，所以pass 了，但是我认为思路很棒,所以记下


传统的P2P（Peer-to-Peer）内容共享系统采用完全分布式，相比结构化覆盖更有效地执行复杂的查询，并且不受约束，这使得它易于处理容易的网络流失，也易于构建和扩展。(有线网络)

车联网具有节点速度快、路由不可预测和高动态拓扑结构，很难在不进行修改的情况下使这些系统适应物联网网络。（ 频繁的查找失败）->非结构化更适合车联网

本文提出了BusCache，一个交通感知的车联网内容分发系统。其利用公共汽车作为覆盖网络上内容分发的跟踪器。（充分利用了Bus的道路是恒定的，也比较准时）

为了缓解Bus的压力，于是分簇，分簇的方式为依据Bus 行走过的路线
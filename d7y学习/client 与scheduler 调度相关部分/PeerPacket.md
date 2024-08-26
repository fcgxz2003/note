由scheduler/service_vi.go中的ScheduleParentAndCandidateParents 负责发送
（Used only in v1 version of the grpc）
具体来说,由如下的代码负责发送

```go
// Send PeerPacket to peer.
peer.Log.Info("send PeerPacket to peer")
if err := stream.Send(ConstructSuccessPeerPacket(peer, candidateParents[0], candidateParents[1:])); err != nil {
    n++
    peer.Log.Errorf("scheduling failed in %d times, because of %s", n, err.Error())

    if err := peer.Task.DeletePeerInEdges(peer.ID); err != nil {
        peer.Log.Errorf("peer deletes inedges failed: %s", err.Error())
        return
    }

    return
}
```

由client 端的peertask_conductor.go 负责接收，具体来说是receivePeerPacket 函数

```go
peerPacket, err = pt.peerPacketStream.Recv()
if err == io.EOF {
    pt.Debugf("peerPacketStream closed")
    break loop
}
```


并且由initDownloadPieceWorkers 来派遣有多少和哪几个节点来负责下载。
```go
if !firstPacketReceived {
    pt.initDownloadPieceWorkers(pieceRequestQueue)
    firstPeerSpan.SetAttributes(config.AttributeMainPeer.String(peerPacket.MainPeer.PeerId))
    firstPeerSpan.End()
}
```

d7y将下载的数量限定在4个上，这就是其局限性所在
```go
func (pt *peerTaskConductor) initDownloadPieceWorkers(pieceRequestQueue PieceDispatcher) {
	count := 4
	for i := int32(0); i < int32(count); i++ {
		go pt.downloadPieceWorker(i, pieceRequestQueue)
	}
}
```

修改这里的代码来指定分配的数量，这里可以使用scheduler 调度计算好后传输过去来分配。
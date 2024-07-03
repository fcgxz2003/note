## 这里需要实现一个trainer 与manager 交互，因为会有多个trainer，分布在每个集群中，所以需要这样来写。

单独写一个keepAlive with Trainer。

参考scheduler 与 manager 交互的代码

```go
// KeepAlive with manager.
func (s *managerServerV1) KeepAlive(stream managerv1.Manager_KeepAliveServer) error {
	req, err := stream.Recv()
	if err != nil {
		logger.Errorf("keepalive failed for the first time: %s", err.Error())
		return status.Error(codes.Internal, err.Error())
	}
	hostname := req.Hostname
	ip := req.Ip
	sourceType := req.SourceType
	clusterID := uint(req.ClusterId)

	log := logger.WithKeepAlive(hostname, ip, sourceType.Enum().String(), req.ClusterId)
	log.Info("keepalive for the first time")

	// Initialize active scheduler.
	if sourceType == managerv1.SourceType_SCHEDULER_SOURCE {
		scheduler := models.Scheduler{}
		if err := s.db.First(&scheduler, models.Scheduler{
			Hostname:           hostname,
			IP:                 ip,
			SchedulerClusterID: clusterID,
		}).Updates(models.Scheduler{
			State: models.SchedulerStateActive,
		}).Error; err != nil {
			return status.Error(codes.Internal, err.Error())
		}

		if err := s.cache.Delete(
			context.TODO(),
			pkgredis.MakeSchedulerKeyInManager(clusterID, hostname, ip),
		); err != nil {
			log.Warnf("refresh keepalive status failed: %s", err.Error())
		}
	}

	// Initialize active seed peer.
	if sourceType == managerv1.SourceType_SEED_PEER_SOURCE {
		seedPeer := models.SeedPeer{}
		if err := s.db.First(&seedPeer, models.SeedPeer{
			Hostname:          hostname,
			IP:                ip,
			SeedPeerClusterID: clusterID,
		}).Updates(models.SeedPeer{
			State: models.SeedPeerStateActive,
		}).Error; err != nil {
			return status.Error(codes.Internal, err.Error())
		}

		if err := s.cache.Delete(
			context.TODO(),
			pkgredis.MakeSeedPeerKeyInManager(clusterID, hostname, ip),
		); err != nil {
			log.Warnf("refresh keepalive status failed: %s", err.Error())
		}
	}

	for {
		_, err := stream.Recv()
		if err != nil {
			// Inactive scheduler.
			if sourceType == managerv1.SourceType_SCHEDULER_SOURCE {
				scheduler := models.Scheduler{}
				if err := s.db.First(&scheduler, models.Scheduler{
					Hostname:           hostname,
					IP:                 ip,
					SchedulerClusterID: clusterID,
				}).Updates(models.Scheduler{
					State: models.SchedulerStateInactive,
				}).Error; err != nil {
					return status.Error(codes.Internal, err.Error())
				}

				if err := s.cache.Delete(
					context.TODO(),
					pkgredis.MakeSchedulerKeyInManager(clusterID, hostname, ip),
				); err != nil {
					log.Warnf("refresh keepalive status failed: %s", err.Error())
				}
			}

			// Inactive seed peer.
			if sourceType == managerv1.SourceType_SEED_PEER_SOURCE {
				seedPeer := models.SeedPeer{}
				if err := s.db.First(&seedPeer, models.SeedPeer{
					Hostname:          hostname,
					IP:                ip,
					SeedPeerClusterID: clusterID,
				}).Updates(models.SeedPeer{
					State: models.SeedPeerStateInactive,
				}).Error; err != nil {
					return status.Error(codes.Internal, err.Error())
				}

				if err := s.cache.Delete(
					context.TODO(),
					pkgredis.MakeSeedPeerKeyInManager(clusterID, hostname, ip),
				); err != nil {
					log.Warnf("refresh keepalive status failed: %s", err.Error())
				}
			}

			if err == io.EOF {
				log.Info("keepalive closed")
				return nil
			}

			log.Errorf("keepalive failed: %s", err.Error())
			return status.Error(codes.Unknown, err.Error())
		}
	}
}

```

感觉后面补上更好一些。
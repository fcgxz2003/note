```go
ctx := context.Background()
var schedulers []models.Scheduler
if err := db.DB.WithContext(ctx).Where("state = ?", "active").Find(&schedulers).Error; err != nil {
    fmt.Println(err)
}
```

gorm.db 会自动根据Find的结构体去找对应的表，所以这里不需要表名，直接就能从scheduler找到状态为active的内容并且输出。牛逼。
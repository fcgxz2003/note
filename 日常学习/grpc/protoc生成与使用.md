## protoc生成与使用

安装教程
https://github.com/protocolbuffers/protobuf/blob/main/src/README.md

GG不成功，先下班

Golang gRPC 安装及使用实例（Window、Ubuntu）
https://www.jianshu.com/p/dea7e17966b2

全都是放屁 用这个就行。
https://grpc.io/docs/protoc-installation/

然后还要装protoc-gen-go，即可
 go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
 go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
 go install github.com/envoyproxy/protoc-gen-validate@latest

protoc --go_out=. --go-grpc_out=. --validate_out="lang=go:." hello.proto

具体实例为go_grpc_study文件夹里面
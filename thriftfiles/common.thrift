# 服务可共用的信息定义文件

namespace py etthrift.common
namespace php EtThrift.Common

# 无效参数错误
exception InvalidArgumentError {
    1:optional string message
}

# 服务器端发生错误
exception ServerError {
}

# 网站服务定义文件

include "common.thrift"

namespace py etthrift.upland
namespace php EtThrift.Upland

struct DistrictDef {
    1: required i32 id,
    2: required string name,
    3: required i32 parentId,
    4: required string path,
    5: required byte level,
    6: required byte isValid,
    7: required byte type,
    8: required string areaCode
}

service AreaService {
    void ping(),

    list<DistrictDef> getDistrictsByAreaCodes(1: required list<string> areaCodes)
        throws (1:common.ServerError se),

    list<DistrictDef> getSchools(1: required list<i32> school_ids)
        throws (1:common.ServerError se),

    list<DistrictDef> getDistrictByName(1: required string districtName)
        throws (1:common.ServerError se),

    string getAllDistrictData()
        throws (1:common.ServerError se),
}

struct UserDef {
    1: required i32 id,
    2: required string userName,
    3: required string realName,
    4: required string email,
    5: required string schoolName,
    6: required string grade,
    7: required string telephone,
    8: required string mobile,
    9: required string qq,
    10: required byte isIpUser,
    11: required byte userFigure,
    12: required string subject,
    13: required string areaCode
}

service UserService {

    list<UserDef> getByUserNames(1: required list<string> userNames)
        throws (1:common.ServerError se),

    void ping()
}

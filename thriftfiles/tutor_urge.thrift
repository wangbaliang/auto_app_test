include "common.thrift"

namespace py etthrift.tutor
namespace php EtThrift.Tutor


struct ClassInfoDef {
    1: required i32 id,
    2: required string gradeName,
    3: required i16 studentNum,
    4: optional i32 subjectId,
    5: optional i16 cycleDay,
    6: optional string startDay,
    7: optional list<string> students
}

struct ContinueApplyInfoDef {
    1: required string student,
    2: required i32 subjectId,
    3: required string expireTime,
    4: required string coach,
    5: required i32 classId
}

struct CancelApplyInfoDef {
    1: required string student,
    2: required i32 subjectId,
    3: required string cancelTime,
    4: required i16 cancelNum,
    5: optional string coach,
    6: optional i32 classId
}

service UrgeClassService {
    list<ClassInfoDef> getCoachClassInfo(1:required string coach)
        throws (1:common.ServerError se),

    list<ClassInfoDef> getClassDetailInfo(1:required i32 classId)
        throws (1:common.ServerError se),

    list<CancelApplyInfoDef> getCancelStudent(1:required string day)
        throws (1:common.ServerError se),

    list<ContinueApplyInfoDef> getNeedContinueStudent(1:required string day)
        throws (1:common.ServerError se),

    list<ContinueApplyInfoDef> getNotContinueStudent(1:required string day)
        throws (1:common.ServerError se),

    void ping()
}

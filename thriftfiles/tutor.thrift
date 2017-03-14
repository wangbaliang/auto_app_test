# 教练伴学服务定义文件

include "common.thrift"

namespace py etthrift.tutor
namespace php EtThrift.Tutor

exception ReturnFalse {
    1: required i16 returnCode,
    2: optional string message
}

struct PeriodDef {
    1: required i32 id,
    2: required i32 seasonId,
    3: required byte gradeType,
    4: required i16 startTime,
    5: required i16 endTime
}

struct SeasonDef {
    1: required i32 id,
    2: required i16 year,
    3: required byte seasonType,
    4: required string startDay,
    5: required string endDay,
    6: optional set<string> exceptDays,
    7: optional byte status
}

service SeasonService {
    void ping(),

    list<SeasonDef> getAll()
        throws (1:common.ServerError se),

    i32 addSeason(1:required SeasonDef season)
        throws (1:common.ServerError se),

    bool updateSeason(1:required SeasonDef season)
        throws (1:common.ServerError se),

    bool deleteSeason(1:required i32 seasonId)
        throws (1:common.ServerError se)
}

service PeriodService {
    void ping(),

    list<PeriodDef> getAll(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getAllCount()
        throws (1:common.ServerError se),

    list<PeriodDef> getBySeasonAndGradeType(1:required i32 seasonId, 2:required i32 gradeType)
        throws (1:common.ServerError se),

    i32 add(1:required PeriodDef period)
        throws (1:common.ServerError se),

    bool update(1:required PeriodDef period)
        throws (1:common.ServerError se),

    bool remove(1:required i32 periodId)
        throws (1:common.ServerError se)
}

struct ClassTemplateDef {
    1: required i32 id,
    2: required i32 seasonId,
    3: required i32 periodId,
    4: required i32 subjectId,
    5: required i16 grade,
    6: required i16 cycleDay,
    7: required i16 startTime,
    8: required i16 endTime,
    9: required i16 maxClassNum,
    10: required i16 maxStudentNum
}

struct EnlistDef {
    1: required i32 subjectId,
    2: required i32 classId,
    3: required i16 cycleDay,
    4: required i32 period_id,
}

struct ReservationTemplateDef{
    1: required i32 id,
    2: required i32 seasonId,
    3: required i32 periodId,
    4: required i32 subjectId,
    5: required i16 grade,
    6: required i16 cycleDay,
    7: required i16 startTime,
    8: required i16 endTime,
    9: required i16 maxClassNum,
    10: required i16 maxStudentNum,
    11: required i16 maxStudentInClass,
    12: required i32 minNeededCoachNumber,
    13: required i32 usableCoachNumber,
    14: required i32 allotStudentNumber,
    15: required i32 unallotStudentNumber,
    16: required i32 allStudentNumber
}

struct EnrollmentScheduleDef{
    1: required i32 templateId,
    2: required i32 seasonId,
    3: required i32 periodId,
    4: required i32 subjectId,
    5: required i16 grade,
    6: required i16 cycleDay,
    7: required i16 startTime,
    8: required i16 endTime,
    9: required i16 maxClassNum,
    10: required i16 maxStudentNum,
    11: required i32 totalNumber,  # 招生名额
    12: required i32 usedNumber,  # 占用名额报名
    13: required i32 currentClassNumber,  # 报名本次课的学员
    14: required i32 totalRestNumber,  # 剩余名额
    15: required i32 currentRestNumber,  # 本次课剩余名额
    16: required i32 lastClassContinueNumber,  # 上次课需续约数
    17: required i32 lastClassUnContinueNumber,  # 上次课未续约数
    18: required i32 currentContinueNumber,  # 需要在本次课续约数
    19: required i32 lastClassNewNumber,  # 上次课新约课总人数
    20: required i32 lastWeekTotalNumber  # 上周新约课总人数
}

service ClassTemplateService {
    void ping(),

    list<ClassTemplateDef> getAll(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getAllCount()
        throws (1:common.ServerError se),

    list<ClassTemplateDef> getFilteredData(
        1:required i32 limit,
        2:required i32 offset,
        3:required i32 seasonId,
        4:required i32 subjectId,
        5:required i16 grade,
        6:required i32 periodId
    )
        throws (1:common.ServerError se),

    i32 getReservationDataCount()
        throws (1:common.ServerError se),

    list<ReservationTemplateDef>getFilteredReservationData(
        1:required i32 limit,
        2:required i32 offset
    )
        throws (1:common.ServerError se),

    list<ClassTemplateDef> getFilteredDataByTemplateID(
        1:required i32 id
        )
        throws (1:common.ServerError se),

    list<EnrollmentScheduleDef> getEnrollmentSchedule(
        1:required i32 limit,
        2:required i32 offset
    ) throws (1:common.ServerError se),

    i32 getFilteredDataCount(
        1:required i32 seasonId,
        2:required i32 subjectId,
        3:required i16 grade,
        4:required i32 periodId
    )
        throws (1:common.ServerError se),

    i32 add(1:required ClassTemplateDef classTemplate)
        throws (1:common.ServerError se),

    bool update(1:required ClassTemplateDef classTemplate)
        throws (1:common.ServerError se),

    bool remove(1:required i32 classTemplateId)
        throws (1:common.ServerError se)
}

struct CoachDef {
    1: required string userName,
    2: required string realName,
    3: required string areaCode,
    4: required string schoolName,
    5: required byte gradeType,
    6: required i32 subjectId,
    7: required string phone,
    8: required string qq,
    9: required i16 jobStatus,
    10: required i16 jobStage,
    11: required byte isForbidCity,
    12: required i16 rank,
    13: optional string areaDisplay
}

struct CoachImportCheckResultDef {
    1: required list<string> imported,
    2: required list<string> notExists,
    3: required list<string> notTeacher
}

struct CoachAvailableTimeDef {
    1: required i32 id,
    2: required string coach,
    3: required i32 periodId,
    4: required i32 seasonId,
    5: required i16 cycleDay,
    6: required i16 startTime,
    7: required i16 endTime,
    8: required string startDay,
    9: required string endDay,
    10: required bool isUsed
}

struct FiredInfoDef{
    1: required string firedDate,
    2: required string firedReason,
    3: required string operator,
    4: required i16 operateType
}

struct CoachHiringDef {
    1: required string userName,
    2: required string realName,
    3: required string areaCode,
    4: required string schoolName,
    5: required byte gradeType,
    6: required i32 subjectId,
    7: required string phone,
    8: required string qq,
    9: optional string areaDisplay
}

service CoachService {

    list<FiredInfoDef> getFiredCoachInfoByUserName(1:required string userName)
        throws (1:common.ServerError se),

    list<CoachAvailableTimeDef> getAllUsablePeriod(1:required string userName)
        throws (1:common.ServerError se),

    list<CoachDef> getAll(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getAllCount()
        throws (1:common.ServerError se),

    list<CoachDef> getFilteredCoaches(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 getFilteredCoachesCount(
        1:required string condition)
        throws (1:common.ServerError se),

    CoachImportCheckResultDef importCheck(
        1:required list<string> coachNames)
        throws (1:common.ServerError se),

    bool importCoaches(1:required list<string> coachNames)
        throws (1:common.ServerError se),

    list<i32> getCoachClassIds(1:required string coachName)
        throws (1:common.ServerError se),

    bool dismissCoach(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool setCoachRetraining(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool setCoachTrial(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool setCoachPositive(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool cancelCoachRetraining(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    list<CoachAvailableTimeDef> getCoachAvailableTime(1:required string coachName)
        throws (1:common.ServerError se),

    list<CoachHiringDef> getFilteredHiringCoaches(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 getFilteredHiringCoachesCount(
        1:required string condition)
        throws (1:common.ServerError se),

    CoachImportCheckResultDef importHiringCheck(
        1:required list<string> coachNames)
        throws (1:common.ServerError se),

    bool importHiringCoaches(1:required list<string> coachNames)
        throws (1:common.ServerError se),

    bool setCoachReserve(
        1:required string coachName,
        2:required string opAdmin,
        3:required string remark)
        throws (1:common.ServerError se),

    bool setCoachClassNum(
        1:required string coachName,
        2:required i16 coachRank)
        throws (1:common.ServerError se),

    void ping()
}

struct StudentDef {
    1: required string userName,
    2: required string realName,
    3: required string areaCode,
    4: required string schoolName,
    5: required i16 grade,
    6: required string phone,
    7: required string qq,
    8: optional string areaDisplay,
    9: optional i16 giftServiceTotal,
    10: optional i16 usedServiceTotal,
    11: optional i16 buyServiceTotal
}

# 学生版本信息
# id=0 新增
struct StudentTextbookEditionDef {
    1: required i32 id,
    2: required byte gradeType,
    3: required i32 subjectId,
    4: required i16 edition,
}

# 快递地址
struct DeliveryAddressDef {
    1: required i32 id,
    2: required string name,
    3: required string phone,
    4: required string address,
    5: required string areaCode,
    6: required string province,
    7: required string city,
    8: required string area,
    9: required bool isDefault
}

service StudentService {

    list<StudentDef> getAll(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    list<EnlistDef> getEnlistResult(1:required string student_user_name)
        throws (1:common.ServerError se),

    list<EnlistDef> getClassList(1:required string student_user_name)
        throws (1:common.ServerError se),

    i32 getAllCount()
        throws (1:common.ServerError se),

    list<StudentDef> getFilteredStudents(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 getFilteredStudentsCount(
        1:required string condition)
        throws (1:common.ServerError se),

    # 获取学生版本信息
    # 判断学生的年级和约课卡的是否相同
    # 不相同，前端提示
    # 指定科目和年级类型，获取学生版本，没有则新增
    list<StudentTextbookEditionDef> getStudentTextbookEdition(
        1: required string student,
        # 不指定则获取全部
        2: optional i32 subjectId,
        3: optional byte gradeType
        )throws (1:common.ServerError se),

    # studentTextbookEdition.id=-1 新增
    # 不会考虑id
    bool addStudentTextbookEdition(
        1: required string student,
        2: required StudentTextbookEditionDef studentTextbookEdition,
        )throws (1:common.ServerError se),

    bool updateStudentTextbookEdition(
        1: required string student,
        2: required StudentTextbookEditionDef studentTextbookEdition,
        )throws (1:common.ServerError se),

    # 获取学员快递地址信息
    list<DeliveryAddressDef> getDeliveryAddress(
        1: required string student
        )throws (1:common.ServerError se),

    bool addDeliveryAddress(
        1: required string student,
        2: required DeliveryAddressDef deliveryAddress,
        )throws (1:common.ServerError se),

    # 更新快递地址
    bool updateDeliveryAddress(
        1: required string student,
        2: required DeliveryAddressDef deliveryAddress,
        )throws (1:common.ServerError se),

    void ping()
}

struct ClassCreateTaskDef {
    1: required i32 id,
    2: required i16 grade,
    3: required i32 subjectId,
    4: required i32 periodId,
    5: required string classDay,
    6: required i16 startTime,
    7: required i16 endTime,
    8: required i32 studentNum,
    9: required i16 remainNum,
    10: required i16 taskStatus,
    11: required i32 newClassNum,
    12: optional i32 acceptCoachNum,
    13: optional i32 testSuccessCoachNum
}

struct CoachInviteDef {
    1: required i32 id,
    2: required i32 taskId,
    3: required i32 classTemplateId,
    4: required string coach,
    5: required i16 inviteStatus,
    6: required i16 inviteType,
    7: required string expireTime,
    8: required string inviteTime,
    9: optional string coachPhone,
    10: optional string coachRealName
}

service ClassAdminService {

    list<ClassCreateTaskDef> getAllClassCreateTasks(1:required i32 limit, 2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getAllClassCreateTaskCount()
        throws (1:common.ServerError se),

    list<CoachInviteDef> getClassCreateTaskCoachInviteInfo(1:required i32 taskId)
        throws (1:common.ServerError se),

    list<StudentDef> getApplyStudentInfo(1:required i32 taskId)
        throws (1:common.ServerError se),

    i16 inviteCoach(1:required i32 taskId, 2:required string coachName)
        throws (1:common.ServerError se),

    bool cancelInvite(1:required i32 taskId, 2:required string coachName)
        throws (1:common.ServerError se),

    i16 startChangeClassCoach(
        1:required i32 classId,
        2:required string newCoachName,
        3:required i16 reasonType,
        4:required string remark
    )throws (1:common.ServerError se),

    i16 startTemporarySubstituteCoach(
        1:required i32 classId,
        2:required string newCoachName,
        3:required list<string> days,
        4:required string remark
    )throws (1:common.ServerError se),

    i32 ChangeStudentClass(
        1:required string student,
        2:required string original_class_id,
        3:required string target_class_id)
        throws (1:common.ServerError se),

    bool sendNotification(
        1:required i16 classId,
        2:required string notification,
        3:required list<i16> target
    )throws (1:common.ServerError se),

    i16 modifyStudentToAnotherClass(
        1:required string studentName,
        2:required i16 originClassId,
        3:required i16 targetClassId,
        4:required string op_admin,
        5:required string remark
    )throws (1:common.ServerError se),

    bool closeClass(1:required i32 classId)
        throws (1:common.ServerError se),

    void ping()
}

struct ServiceReservationDef {
    1: required i32 templateId,
    2: required string startTime,
    3: required string endTime,
    4: required i16 subjectId,
    5: required string subjectName,
    6: required string coachName,
    7: required i16 status,
    8: required i16 cycleDay,
    9: required i32 total,
    10: required i32 notCost,
    11: required i32 canCancelNum
    12: required i16 grade,
    13: required i32 seasonId,
    14: required i16 seasonType,
    15: optional string nextDay,
    16: optional i32 classId,
    17: optional i16 edition,
    18: optional string insertTime
}

struct ServiceDayPayInfoDef {
    1: required string day,
    2: required bool isRequired,
    3: required i16 price,
    4: required i32 totalPrice
}

struct ClassPlanDef {
    1: required string classDay,
    2: required i16 status,
    3: required i16 canChangeStatus,
    4: required i16 canCancelStatus
}

struct ServiceCostDef {
    1: required i16 totalNum,
    2: required i16 needPayMoney,
    3: required i16 useRemainNum,
    4: required i16 needPayNum
}


# 用户提交教练伴学服务订单
struct TutorOrderDef {
    1: required string userName,
    2: required i32 templateId,
    3: required i16 edition,
    4: required i16 classId,
    5: required string startTime,
    6: required string endTime,
    7: required i32 rechargeCardId
}

struct StudentAccountSummaryDef {
    1: required string userName,
    2: required i16 remainServiceNum,
    3: required i32 subjectId,
    4: required string nextLessonDay
}

struct StudentApplyClassInfoDef {
    1: required string userName,
    2: required i32 classId,
    3: required string coach,
    4: required string coachName,
    5: required i16 subjectId,
    6: required i16 edition,
    7: required string startTime,
    8: required string endTime,
    9: required i16 cycleDay
}

struct UserSoftTestInfoDef {
    1: required string userName,
    2: required bool isTested,
    3: required bool passTest
}

struct CancelReservationInfoDef {
    1: required string startTime,
    2: required string endTime
}

struct DailyServiceCostDetailDef {
    1: required string day,
    2: required string student,
    3: required i16 costNum,
    4: required i32 subjectId
}

struct OrderRecordDef {
    1:required string userName,
    2:required i32 subjectId,
    3:required string orderId,
    4:required i16 serviceNum,
    5:required double price,
    6:optional i16 cancelServiceNum,
    7:optional string orderTime
}

# 学季卡
struct SaleRechargeCardDef {
    1: required i32 id,
    2: required i32 seasonId,
    3: required i32 subjectId,
    4: required byte gradeType,
    5: required i16 serviceNum,
    6: required double price
    7: required byte isForSale,
    8: optional i16 totalServiceTime
}

struct ServiceDayInfoDef {
    1: required string day,
    2: required i16 status,
    3: optional i32 subjectId
}
# -5: 指定教练，正在该班上课，未过保留名额期，除最近一节课，后面的都不可约
# -3: 后面有已约时段，且间期不足学季卡标准次数
# -2: 已约课 -1:冲突 0:没有名额 1:可约
# 2:可约课，处于名额保留期

# 老状态
# status -4:已约该时段>1 -3:之后约了该时段 -2:已约课 -1:冲突 0:没有名额 1:可约

# 教练伴学服务信息，约课使用
struct CanApplyServiceInfoDef {
    1: required i32 templateId,
    2: required string startTime,
    3: required string endTime,
    4: required list<ServiceDayInfoDef> serviceDaysInfo,
    5: optional i32 classId
}

# 学生约课卡
struct StudentRechargeCardDef {
    1: required i32 cardId,
    2: required i32 seasonId,
    3: required i32 subjectId,
    4: required i16 remainNum,
    # -2:已过期 -1:已用完 1:可用
    5: required byte status,
    6: optional i16 originalNum
}

# 课表展示
struct StudentLessonScheduleDef {
    1: required i32 classId,
    2: required i32 templateId,
    3: required string classDay,
    4: required string startTime,
    5: required string endTime,
    6: required byte gradeType,
    7: required i32 subjectId,
    8: required string coachName,
    9: required i16 edition,
    # 请假状态
    10: required byte askLeaveStatus,
    # 0表示上完了 1表示还没上
    11: required byte status

}

 # 取消约课的课程详情
 struct CancelOrderInfoDef {
    1: required string orderId,
    2: required i32 subjectId,          # 课程的科目编号
    3: required i32 cancelServiceNum,
    4: required i32 rechargeCardId,       # 学季卡编号
}

# 取消约课价格明细信息
struct CancelPayPriceInfoDef {
    1: required list<CancelOrderInfoDef> cancelOrderInfo,
    2: required byte isMerged,
    3: required byte isOldOrder,
    4: required i32 totalCancelNum,           # 本次取消总数
    5: required i32 payServiceNum,           # 付费课次
    6: required i32 giftServiceNum,          # 赠送课次
    7: required double cancelMoney                 # 应退总价

}

# 订单包含课程信息
struct OrderServiceInfoDef {
    1: required i32 subjectId,
    2: required i32 seasonId,
    3: required i16 num,
}

# 订单信息
struct OrderDef {
    1: required list<OrderServiceInfoDef> serviceInfo,
    2: required string orderId,
    3: required string orderTime,
    4: required double originalCost,
    5: required i16 payServiceNum,
    6: required i16 giftServiceNum,
    7: required double actualCost,
    8: required byte status,
    9: optional list<string> combineOrderIds,
    10: optional i16 totalCombineServiceNum,
    11: optional string reachGiftPolicy
}

struct CombinePriceDef {         # 组合课，购物车，订单页获取组合价格信息
    1: required i16 totalServiceNum,        # 总次数
    2: required i16 giftSericeNum,         # 减免次数
    3: required double price            # 售价
}

struct BankRecordDef{
    1:required i32 id,
    2:required string bankName,
    3:required string bankCard,
    4:required string bankAddress,
    5:required string subBankName,
    6:required string beneficiaryName,
    7:required string phone,
    8:required byte isDefault,
}


service QuotaService {

    # 根据用户名得到是否有权限报名教练伴学(试运营期间)
    bool isAuthorized(
        1:required string student           # 学员用户名。
        )
        throws (1:common.ServerError se),

    # 获取学员预约的全部教练伴学服务信息
    # 修改为获取已约但未上完的课程，课表展示用另一个做
    list<ServiceReservationDef> getStudentAllServiceReservationInfo(
        1:required string student           # 学员用户名。
        )
        throws (1:common.ServerError se),

    # 获取当前可供约课的教练伴学服务信息，会根据学员本身约课情况有所不同。
    list<CanApplyServiceInfoDef> getAllServiceInfo(
        1:required string student,          # 学员用户名。
        2:required i32 rechargeCardId,
        3:optional i32 seasonId,             # 通用约课卡需传
        4:optional i32 subjectId
        )
        throws (1:common.ServerError se),

    list<CanApplyServiceInfoDef> getContinueServiceInfo(
        1:required string student,          # 学员用户名。
        2:required i32 classId,             # 续接的班级编号。
        )
        throws (1:common.ServerError se),

    # 根据学员选择的约课开始日期得到其约课的不同结束日期对应的需付费信息。
    # list<ServiceDayPayInfoDef>getFinishDayByStartDay
    # 根据学员选择的约课开始日期和约课卡信息得到上课日期
    list<string> getApplyServiceByStartDay(
        1:required string student,          # 学员用户名。
        2:required i32 classTemplateId,     # 学员约课的班型编号。
        3:required string startDay,         # 学员约课的开始日期。
        4:required i32 rechargeCardId,
        5:optional i32 classId,
        )
        throws (1:common.ServerError se),

    # 根据学员希望续的课得到其续该课的不同结束日期对应的需付费信息。
    list<ServiceDayPayInfoDef> getContinueClassInfo(
        1:required string student,          # 学员用户名。
        2:required i32 classId              # 续课的班级编号。
        )
        throws (1:common.ServerError se),

    # 获取学员约课详情
    StudentApplyClassInfoDef getStudentApplyClass(
        1:required string student,          # 学员用户名
        2:required i32 classId              # 已约课的班级编号。
        )
        throws (1:common.ServerError se, 2:ReturnFalse rf),

    # 根据起止时间和班型得到区间内的所有上课日期
    list<ClassPlanDef> getClassPlanByTemplate(
        1:required string student,          # 学员用户名
        2:required i32 templateId,          # 班型编号
        3:required string startDay,         # 开始日期
        4:required string endDay            # 结束日期
        )
        throws (1:common.ServerError se),

    # 根据起止时间和班级得到区间内的所有上课日期
    list<ClassPlanDef> getClassPlan(
        1:required string student,          # 学员用户名
        2:required i32 classId,             # 班级编号
        3:required string startDay,         # 开始日期
        4:required string endDay            # 结束日期
        )
        throws (1:common.ServerError se),

    #
    bool checkSameTemplateClass(
        1:required string student,
        2:required i32 classTemplateId,
        3:required string startTime,
        4:required string endTime,
        5:required i32 classId
        )
        throws (1:common.ServerError se),

    # 用户提交教练伴学服务
    # return值
    i16 submitTutorService(1: required TutorOrderDef order)
        throws (1:common.ServerError se),

    # 向学员账户添加服务次数
    bool addStudentAccountServiceNum(
        1: required string student,         # 学员用户名
        2: required i32 subjectId,          # 科目编号
        3: required i16 serviceNum,         # 服务次数
        4: required string orderId,         # 订单编号
        5: required string orderTime,       # 订单时间
        6: required double price,           # 单价
        7: required double cancel_price     # 退款单价
        )
        throws (1:common.ServerError se),

    # 同步用户信息（批量）
    bool syncUserInfo(
        1:required list<string> students    # 需要同步的用户名数组
        )
        throws (1:common.ServerError se),

    ServiceCostDef computeCost(
        1:required string student,
        2:required i32 classTemplateId,
        3:required string startDay,
        4:required string endDay)
        throws (1:common.ServerError se, 2:ReturnFalse rf),

    bool useClassTemplateQuota(
        1:required string student,
        2:required i32 classTemplateId,
        3:required string startDay,
        4:required string endDay)
        throws (1:common.ServerError se),

    bool cancelTemplatePlaceHold(
        1:required string student,
        2:required i32 classTemplateId,
        3:required string startDay,
        4:required string endDay)
        throws (1:common.ServerError se),

    # 获取服务单价
    list<i16> getPrice()
        throws (1:common.ServerError se),

    # 获取当前有效（可报名的）的学季信息
    list<SeasonDef> getAvailableSeasons()
        throws (1:common.ServerError se),

    list<StudentAccountSummaryDef> getStudentAccountSummaryInfo(1:required string student)
        throws (1:common.ServerError se),

    UserSoftTestInfoDef getUserSoftTestInfo(1:required string userName)
        throws (1:common.ServerError se),

    # 换课
    bool changeStudentReservation(
        1:required string student,
        2:required i32 classTemplateId,
        3:required string startTime,
        4:required string endTime)
        throws (1:common.ServerError se),

    bool addOrderRecord(
        1:required string userName,         # 用户名
        2:required i32 subjectId,           # 科目编号
        3:required string orderId,          # 订单编号
        4:required i16 serviceNum,          # 购买的服务次数
        5:required double price,            # 购买单价
        6:required double cancel_price      # 此订单退款时的单价
        )
        throws (1:common.ServerError se, 2:ReturnFalse rf),

    list<OrderRecordDef> getUserOrderRecode(
        1:required string userName
        )
        throws (1:common.ServerError se),

    # 取消退款
    bool cancelRefund(
        1:required string student,
        2:required list<CancelPayPriceInfoDef> cancelPriceInfo
        )
        throws (1:common.ServerError se),

    list<DailyServiceCostDetailDef> computeDailyTotalCost(1:required string day)
        throws (1:common.ServerError se),

    # 展示销售学季卡
    list<SaleRechargeCardDef> getAllSaleCard(
        1: required byte gradeType
        )throws (1:common.ServerError se),

    # 课表展示
    list<StudentLessonScheduleDef> getStudentClassScheduleByTime(
        1:required string student,
        2:optional string startTime,
        3:optional string endTime
        )throws (1:common.ServerError se),

    # 获取学员所有的约课卡
    list<StudentRechargeCardDef> getAllStudentCard(
        1: required string student,
        # -2:已过期 -1:已用完 1:可用
        2: required i16 flag
        )throws (1:common.ServerError se),

    # 获取学员所有的订单
    list<OrderDef> getStudentAllOrder(
        1: required string student
        )throws (1:common.ServerError se),

    # 计算退费
    list<CancelPayPriceInfoDef> computeCancelPay(
        1:required string student,
        2:required list<i32> cancelRechargeCards,                       # <card_id>
        3:required map<i32, CancelReservationInfoDef> cancelReservation          # <class_template_id, Def>
       )
       throws (1:common.ServerError se, 2:ReturnFalse rf),

    # 退费
    list<CancelPayPriceInfoDef> cancelPay(                           #(订单退费情况)
        1:required string student,
        2:required list<i32> cancelRechargeCardsInfo,                        # <card_id>
        3:required map<i32, CancelReservationInfoDef> cancelReservation           # <class_template_id, Def>
        )
        throws (1:common.ServerError se, 2:ReturnFalse rf),

    # 获取合并价格信息
    list<CombinePriceDef> getCombinePriceInfo(
        1:required list<i32> saleCardIds                    # 传参销售卡ids
        )throws (1:common.ServerError se),

    # 请假功能
    bool studentAskLeave(
        1:required string studentName,
        2:required i32 classTemplateId,
        3:required i32 classId,
        4:required string leaveStartTime
        )throws (1:common.ServerError se),

    # 添加银行卡记录
    bool addBankCard(
        1:required string userName,
        2:required string beneficiaryName,
        3:required string bankName,
        4:required string bankCard,
        5:required string bankAddress,
        6:required string subBankName,
        7:required string phone,
        )
        throws (1:common.ServerError se),

    # 获取用户退款银行信息
    list<BankRecordDef> getBankRecordInfo(
        1:required string userName,
        )
        throws (1:common.ServerError se),

    # 根据ID获取退款银行信息且设为默认选择
    BankRecordDef getBankRecordById(
        1:required string userName,
        2:required i32 cardId,
        )
        throws (1:common.ServerError se),

    # 获取学季信息
    list<SeasonDef> getSeason(
        1:required list<i16> seasonId
        )throws (1:common.ServerError se),

    void ping()
}

struct ClassDef{
    1: required i32 classID,
    2: required string startDate,
    3: required string endDate,
    4: required string coach,
    5: required i16 year,
    6: required i16 season,
    7: required i16 grade,
    8: required i32 subject,
    9: required i16 circleDay,
   10: required i16 startTime,
   11: required i16 endTime,
   12: required i16 maxOneClass,
   13: required i32 maxClass,
   14: required i16 numberOfPeople,
   15: required double percent,
   16: required i16 changeCoach,
   17: required string lessonPlan,
   18: required i16 isClosed
}

struct StudentInClassDef{
    1:required string userName,
    2:required string realName,
    3:required string phone,
    4:required string areaDisplay,
    5:required string firstClassDate,
    6:required string lastClassDate
}

# state
# 1-成功 2-失败，班级重复 3-失败，没有这个班级 4-失败，班级满了 5-不在平行班


struct ClassExchangeDef{
    1:required i32 oldClassID,
    2:required i32 newClassID,
    3:required i32 state
}

struct TemporarySubstituteInfoDef{
    1: required i32 classID,
    2: required string oldCoach,
    3: required i16 season,
    4: required i16 grade,
    5: required i32 subject,
    6: required i16 circleDay,
    7: required i16 startTime,
    8: required i16 endTime,
    9: required string newCoach,
   10: required list<string> dateTime,
   11: required i32 times,
   12: required i16 status
}

struct ClassChangeCoachStatusDef{
    1: required i32 classID,
    2: required string originCoach,
    3: required i16 seasonId,
    4: required i16 grade,
    5: required i32 subjectId,
    6: required i16 circleDay,
    7: required i16 startTime,
    8: required i16 endTime,
    9: required string newCoach,
    10: required string beginDate,
    11: required i16 status,
    12: required i16 periodId
}

struct ClassNumDef{
    1: required string rank,
    2: required i16 id,
    3: required i16 spring_base_num,
    4: required i16 spring_max_num,
    5: required i16 winter_base_num,
    6: required i16 winter_max_num
}

service ClassService {

    list<StudentInClassDef>getStudentInfoInClassById(
        1:required i32 classId
    )throws (1:common.ServerError se),

    list<ClassExchangeDef> modifyStudentToAnotherClass(
        1:required i32 studentId,
        2:required list<ClassExchangeDef> changeList
    )throws (1:common.ServerError se),

    list<ClassDef> getFilteredClass(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    list<ClassDef> getClassById(
        1:required i32 classId
        )
        throws (1:common.ServerError se),

    i32 getFilteredClassCount(
        1:required string condition)
        throws (1:common.ServerError se)

    list<TemporarySubstituteInfoDef> getFilteredTemporaryInfo(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 getFilteredTemporaryInfoCount(
        1:required string condition)
        throws (1:common.ServerError se),

    # 取出系统自动给班级更换老师的任务未完成的班级
    list<ClassChangeCoachStatusDef> getChangeClassCoachStatus(
        1:required i32 limit,
        2:required i32 offset)
        throws (1:common.ServerError se),

    i32 getChangeClassCoachStatusCount()
        throws (1:common.ServerError se),

    list<ClassNumDef> getRankClassNum()
        throws (1:common.ServerError se),

    bool updateRankClassNum(
        1:required string data)
        throws (1:common.ServerError se),

    void ping()
}

service TutorClientService {

    # 教练登陆客户端完成软件测试
    bool completeSoftwareTest(1:required string coach)
        throws (1:common.ServerError se),

    # 记录教练最新登陆客户端的时间
    bool logCoachLastLoginTime(1:required string coach)
        throws (1:common.ServerError se),

    # 根据日期获取所属学季信息
    SeasonDef getBelongSeasonInfo(1:required string day)
        throws (1:common.ServerError se),

    list<ServiceReservationDef> getStudentAllServiceReservationInfo(
        1:required string student           # 学员用户名。
        )
        throws (1:common.ServerError se),

    void ping()
}

service CoachClientService {
    # 接受邀请
    bool acceptInvite(1:required i32 inviteId)
        throws (1:common.ServerError se),

    # 拒绝邀请
    bool refuseInvite(1:required i32 inviteId)
        throws (1:common.ServerError se),

    list<string> getInviteClassDays(1:required i32 inviteId)
        throws (1:common.ServerError se),

    # 创建跨季续接班
    bool createContinueClass
    (
        1:required i32 periodId,    # 时段编号
        2:required i16 cycleDay,    # 循环日类型
        3:required string startDay, # 开始日期
        4:required string endDay,   # 结束日期
        5:required i16 grade,       # 年级编号
        6:required string coach     # 教练用户名
    ) throws (1:common.ServerError se),

    void ping()
}



struct MonitorCoachDef{
    1: required i32 classID,
    2: required i16 season,
    3: required i16 year,
    4: required i16 grade,
    5: required i32 subject,
    6: required i16 circleDay,
    7: required string startDate,
    8: required i16 startTime,
    9: required i16 endTime,
   10: required string coach,
   11: required string realName,
   12: required i16 coachStatus,
   13: required i16 coachOnline,
   14: required i32 disconnectTime,
   15: required string phone
}

struct MonitorStudentDef{
    1: required i32 classID,
    2: required i16 season,
    3: required i16 year,
    4: required i16 grade,
    5: required i32 subject,
    6: required i16 circleDay,
    7: required string startDate,
    8: required i16 startTime,
    9: required i16 endTime,
    10: required i16 studentNum,
    11: required i16 loginNum,
    12: required i16 notlogNum,
    13: required i16 onlineNum,
    14: required i16 offlineNum,
    15: required double loginPercent,
    16: required double onlinePercent
}

service MonitorService {
    void ping(),

    list<MonitorCoachDef> filterCoachClass(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    list<MonitorStudentDef> filterStudentClass(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 filterCoachClassCount(
        1:required string condition)
        throws (1:common.ServerError se),

    i32 filterStudentClassCount(
        1:required string condition)
        throws (1:common.ServerError se),

    list<MonitorCoachDef> filterUnusualCoach(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    list<MonitorStudentDef> filterUnusualStudent(
        1:required i32 limit,
        2:required i32 offset,
        3:required string condition)
        throws (1:common.ServerError se),

    i32 filterUnusualCoachCount(
        1:required string condition)
        throws (1:common.ServerError se),

    i32 filterUnusualStudentCount(
        1:required string condition)
        throws (1:common.ServerError se)
}


struct VerificationInfoDef{
    1: required i32 code,                           # 0：发送成功；   失败： -1: 30分钟内已发三次，-2: 一分钟内不能再发送
    2: required string verificationCode,
    3: required i32 timeLimit,                       # 可在多久时间后再次尝试
}

service VerificationCodeService {
    void ping(),

        # 获取验证码
    VerificationInfoDef getVerificationCode(  # return: 验证码
        1: required string studentName,
        2: required string phone,
        # 标识不同来源
        3: required byte type                                   # 1：退费
        )
        throws (1:common.ServerError se),

    # 退费短信验证
    bool checkRefundVerificationCode(      # return:   成功/验证码无效
        1: required string studentName,
        2: required string phone,
        3: required string verificationCode,
        4: required byte type                                     # 1：退费
        )
        throws (1:common.ServerError se),
}

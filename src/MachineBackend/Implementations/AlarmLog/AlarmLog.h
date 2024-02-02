#pragma once

#include "../ClassManager.h"
#include "AlarmLogSql.h"

class AlarmLog : public ClassManager
{
    Q_OBJECT
public:
    explicit AlarmLog(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;
    void reInitialize();

    AlarmLogSql *getPSqlInterface() const;
    void setPSqlInterface(AlarmLogSql *value);

    void emitSetAlarmLogCount(int count);
    void emitSetAlarmLogIsFull(bool value);

signals:
    void rowCountChanged(int count);

    void setAlarmLogCount(int count);
    void setAlarmLogIsFull(bool value);

private:
    AlarmLogSql *pSqlInterface = nullptr;

    int m_rowCount = 0;

};


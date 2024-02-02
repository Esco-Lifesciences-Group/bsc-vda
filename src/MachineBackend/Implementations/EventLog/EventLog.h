#pragma once

#include "../ClassManager.h"
#include "EventLogSql.h"

class EventLog : public ClassManager
{
    Q_OBJECT
public:
    explicit EventLog(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;
    void reInitialize();

    EventLogSql *getPSqlInterface() const;
    void setPSqlInterface(EventLogSql *value);

    void emitSetEventLogCount(int count);
    void emitSetEventLogIsFull(bool value);

signals:
    void rowCountChanged(int count);

    void setEventLogCount(int count);
    void setEventLogIsFull(bool value);

private:
    EventLogSql *pSqlInterface = nullptr;

    int m_rowCount = 0;

};


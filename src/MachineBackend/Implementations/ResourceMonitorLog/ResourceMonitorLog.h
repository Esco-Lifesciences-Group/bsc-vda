#pragma once

#include "../ClassManager.h"
#include "ResourceMonitorLogSql.h"

class ResourceMonitorLog : public ClassManager
{
    Q_OBJECT
public:
    explicit ResourceMonitorLog(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;
    void reInitialize();

    ResourceMonitorLogSql *getPSqlInterface() const;
    void setPSqlInterface(ResourceMonitorLogSql *value);

    void checkUSdCardIndustrialType();

    void emitSetResourceMonitorLogCount(int count);
    void emitSetResourceMonitorLogIsFull(bool value);

signals:
    void rowCountChanged(int count);
    void uSdCardIndustrialTypeChanged(bool value);

    void setResourceMonitorLogCount(int count);
    void setResourceMonitorLogIsFull(bool value);

private:
    ResourceMonitorLogSql *pSqlInterface = nullptr;

    int m_rowCount = 0;
};


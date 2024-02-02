#pragma once

#include "../ClassManager.h"
#include "DataLogSql.h"

class DataLog : public ClassManager
{
    Q_OBJECT
public:
    explicit DataLog(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;
    void reInitialize();

    DataLogSql *getPSqlInterface() const;
    void setPSqlInterface(DataLogSql *value);

    void emitSetDataLogCount(int count);
    void emitSetDataLogIsFull(bool value);

signals:
    void rowCountChanged(int count);

    void setDataLogCount(int count);
    void setDataLogIsFull(bool value);

private:
    DataLogSql *pSqlInterface = nullptr;

    int m_rowCount = 0;

};


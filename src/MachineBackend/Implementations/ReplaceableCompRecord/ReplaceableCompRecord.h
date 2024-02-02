#pragma once

#include "../ClassManager.h"
#include "ReplaceableCompRecordSql.h"

class ReplaceableCompRecord : public ClassManager
{
    Q_OBJECT
public:
    explicit ReplaceableCompRecord(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;
    void reInitialize();

    ReplaceableCompRecordSql *getPSqlInterface() const;
    void setPSqlInterface(ReplaceableCompRecordSql *value);

    bool getDataFromTableAtRowId(QStringList *data, short rowId);

    void setRpListSelected(QVariantList value);
    void setRpListSelected(short index, const QString &value);

    void emitSetReplaceableCompRecordCount(int count);
    void emitSetReplaceableCompRecordIsFull(bool value);

signals:
    void rowCountChanged(int count);

    void rpListSelectedChanged(QVariantList value);

    void setReplaceableCompRecordCount(int count);
    void setReplaceableCompRecordIsFull(bool value);

private:
    ReplaceableCompRecordSql *pSqlInterface = nullptr;

    int m_rowCount = 0;
    QVariantList m_rpListSelected;

};


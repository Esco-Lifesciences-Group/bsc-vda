#pragma once

#include <QSqlDatabase>
#include <QVariant>
#include <QSqlQuery>
#include <QSqlError>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>

class DataLogSqlGet : public QObject
{
public:
    DataLogSqlGet();
    ~DataLogSqlGet();

    bool init(const QString &uniqConnectionName = QString(), const QString &fileName = QString());
    bool queryInsert(const QVariantMap data);
    bool querySelect(QVariantList *data, const QString &dbQueryConfig = QString());
    bool queryDelete(const QString &dbQueryConfig = QString());
    bool queryCount(int *count);

    QString lastQueryErrorStr() const;

private:
    QString m_connectionName;
    QString m_dbLocation;
    QString m_queryLastErrorStr;

    enum TableHeaderEnum {
        TH_ROWID,
        TH_DATELOG,
        TH_TIMELOG,
        TH_TEMP,
        TH_IFA,
        TH_DFA,
        TH_ADC_IFA,
        TH_PRESSURE,
        TH_FAN_RPM,
        TH_FAN_DCY,
        TH_USERNAME,
        TH_USERFULLNAME
    };
};


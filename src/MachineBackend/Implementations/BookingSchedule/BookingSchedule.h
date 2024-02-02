#pragma once

#include "../ClassManager.h"
#include "BookingScheduleSql.h"

class BookingSchedule : public ClassManager
{
    Q_OBJECT
public:
    explicit BookingSchedule(QObject *parent = nullptr);

    void routineTask(int parameter = 0 ) override;
    void reInitialize();

    BookingScheduleSql *getPSqlInterface() const;
    void setPSqlInterface(BookingScheduleSql *value);

    void selectByDate(const QString &dateStr);

    QVariantList getTodaysSchedule() const;

signals:
    void hasInitialized();
    void rowCountChanged(int count);

    void selectHasDone(bool success, QVariantList logBuffer, int total);

private:
    BookingScheduleSql *pSqlInterface = nullptr;

    /// Save today schedule in this variable
    QVariantList m_logBuffer;
    //    bool m_lastDoneTransactionStatus = false;

    int m_rowCount = 0;

    enum TableHeaderEnum {
        TH_ROWID,
        TH_DATESCHEDULE,
        TH_TIMESCHEDULE,
        TH_BOOKTITLESCHEDULE,
        TH_BOOKBYSCHEDULE,
        TH_NOTEFIRSTSCHEDULE,
        TH_NOTESECONDSCHEDULE,
        TH_NOTETHIRDSCHEDULE,
        TH_CREATEDATSCHEDULE,
        TH_USERNAMESCHEDULE

    };
};


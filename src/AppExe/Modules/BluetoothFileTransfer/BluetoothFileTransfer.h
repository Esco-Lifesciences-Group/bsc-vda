/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QBluetoothLocalDevice>
#include <QBluetoothTransferManager>
#include <QBluetoothTransferReply>
#include <QFile>

class BluetoothFileTransfer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int progress
               READ getProgress
               NOTIFY progressChanged)
    Q_PROPERTY(bool transferring
               READ getTransferring
               WRITE setTransferring
               NOTIFY transferringChanged)

public:
    explicit BluetoothFileTransfer(QObject *parent = nullptr);

    int getProgress() const;
    bool getTransferring() const;
    void setTransferring(bool transferring);

public slots:
    void initTransfer(const QString name, const QString address, const QString fileName);
    void initTransferList(const QString name, const QString address, const QStringList fileName);
    void updateProgress(qint64 transferred, qint64 total);

private slots:
    void _pairingFinished(const QBluetoothAddress &address, QBluetoothLocalDevice::Pairing status);
    void _pairingError(QBluetoothLocalDevice::Error error);
    void _tranferFileFinished(QBluetoothTransferReply *reply);

signals:
    void progressChanged(int progress);

    void pairingStarted(const QString name, const QString address);
    void pairingFinished(bool paired, const QString name, const QString address);

    void tranferFileStarted(const QString address, const QString fileName);
    void tranferFilesStarted(const QString address, const QStringList fileName);
    void tranferFileFinished(bool complete, int error);

    void transferringChanged(bool transferring);

private:
    QBluetoothLocalDevice m_localDevice;
    QBluetoothTransferManager m_manager;
    QBluetoothTransferReply *reply;
    QFile *m_file;
    // QVector<QFile*> m_fileList;
    // QVector<QBluetoothTransferReply*> m_replyList;

    QString m_lastTargetName;
    QString m_lastTargetAddress;
    QString m_lastTargetFile;
    QStringList m_lastTargetFileList;
    QString m_address;
    int m_fileCount = 0;
    int m_progress;

    void doTransfer(const QString address, const QString fileName);
    void doTransfer(const QString address, const QStringList fileNameList);
    bool m_pairingDone;
    bool m_transferring;
};


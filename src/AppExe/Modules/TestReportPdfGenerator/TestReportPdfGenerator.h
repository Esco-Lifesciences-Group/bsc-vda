#pragma once

#include <QObject>
#include <QScopedPointer>
#include <QDebug>
#include <QUrl>
#include <QFile>
#include <QJsonObject>
#include <QJsonDocument>
#include <QTextStream>
#include <QString>

class TestReportPdfGenerator : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool initialized
               READ getInitialized
               //               WRITE setInitialized
               NOTIFY initializedChanged)

public:
    explicit TestReportPdfGenerator(QObject *parent = nullptr);

    bool getInitialized() const;
    void setInitialized(bool initialized);

    //void setWorkingMode(int mode);

public slots:
    void init();
    void generatePdfFile(const QString &sourceJson, const QString &outputFilename);
    void setOutputType(const QString &type);
    void setCabinetModel(const QString &model);
    void setCustomer(const QString &customer);
    void setCalibType(const QString &value);

    void installFont();
    void initTemplateFile();

    void setMeasurementUnit(int unit);

signals:
    void initializedChanged(bool initialized);
    void pdfExportFinished(bool done, const QString &path);

    void fontNotAvailable(bool noFont);
    void fontInstallingComplete(bool complete);

private:
    QThread *m_pThread = nullptr;
    QScopedPointer<TestReportPdfGenerator> m_pdfGen;
    bool m_initialized      = false;
    //    int m_workingMode = 0;
    int m_measurementUnit = 0;
    QString m_calibType = "FULL";
    QString m_outputType = "TR";
    QString m_customer = "WORLD";
    QString m_model = "LA2";

    bool m_fontAvailable = false;

    void htmlEditFile();

    //    void createDownflowGridImg();
    QJsonArray ObjectToArray(const QJsonObject &json_obj) const;
};

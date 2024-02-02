#pragma once

#include <QObject>
#include <QTranslator>

class QQmlEngine;

class TranslatorText : public QObject
{
    Q_OBJECT
public:
    explicit TranslatorText(QQmlEngine *qmlEngine, QObject *parent = nullptr);
    Q_INVOKABLE void selectLanguage(const QString &code);

signals:
    void languageChanged(bool change);

private:
    QTranslator *m_pTranslator;
//    QTranslator *m_pTranslator2;
    QQmlEngine *m_pQmlEngine;
};


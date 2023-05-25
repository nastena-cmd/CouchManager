#ifndef COUCHMANAGERSIMPLEBACKEND_H
#define COUCHMANAGERSIMPLEBACKEND_H

#include <QObject>
#include <QNetworkAccessManager>

class CouchManagerSimpleBackend : public QObject
{
    Q_OBJECT
public:
    explicit CouchManagerSimpleBackend(QObject *parent = nullptr);

    Q_INVOKABLE void createUser(const QString username, const QString password);
    Q_INVOKABLE void loginUser(const QString username, const QString password);

signals:
    void successRequest();
    void userAlreadyCreated();
    void forbiddenChars();

private:
    QNetworkAccessManager *manager { nullptr };
    void replyFromRequest(QNetworkReply *reply);
    const QString server() const;
    bool containsForbiddenChars(const QString& str);
};

#endif // COUCHMANAGERSIMPLEBACKEND_H

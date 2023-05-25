#include "couchmanagersimplebackend.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QNetworkReply>
#include <QUrlQuery>

CouchManagerSimpleBackend::CouchManagerSimpleBackend(QObject *parent)
    : QObject{parent}
{
    manager = new QNetworkAccessManager();

    QObject::connect(manager, &QNetworkAccessManager::finished,
                     this, &CouchManagerSimpleBackend::replyFromRequest);
}

void CouchManagerSimpleBackend::replyFromRequest(QNetworkReply *reply)
{
    if  (reply->error() == QNetworkReply::NoError)
        emit successRequest();
    else if (reply->error() == QNetworkReply::ContentConflictError)
        emit userAlreadyCreated();

    qDebug() << reply->readAll();
}

const QString CouchManagerSimpleBackend::server() const
{
    return "http://localhost:5984/";
}

void CouchManagerSimpleBackend::createUser(const QString username, const QString password)
{
    if (containsForbiddenChars(username) || containsForbiddenChars(password)) {
        emit forbiddenChars();
        return;
    }

    QNetworkRequest request(QUrl(QString("%1_users/org.couchdb.user:%2").arg(server(),username)));
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Content-Type", "application/json");

    QJsonObject user;
    user["name"] = username;
    user["password"] = password;
    user["roles"] = QJsonArray();
    user["type"] = "user";

    QJsonDocument body(user);

    manager->put(request, body.toJson());
}

void CouchManagerSimpleBackend::loginUser(const QString username, const QString password)
{
    if (containsForbiddenChars(username) || containsForbiddenChars(password)) {
        emit forbiddenChars();
        return;
    }

    QNetworkRequest request(QUrl(QString("%1_session").arg(server())));
    request.setRawHeader("Accept", "application/json");
    request.setRawHeader("Content-Type", "application/x-www-form-urlencoded");


    QUrlQuery postData;
    postData.addQueryItem("name", username);
    postData.addQueryItem("password", password);
    manager->post(request, postData.toString(QUrl::FullyEncoded).toUtf8());
}

bool CouchManagerSimpleBackend::containsForbiddenChars(const QString& str)
{
    QRegExp rx("[^a-zA-Z0-9_\\-]"); // регулярное выражение для поиска запрещенных символов
    return rx.indexIn(str) != -1; // возвращает true, если в строке найден запрещенный символ
}

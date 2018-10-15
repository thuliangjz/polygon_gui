#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "polygon_manager.h"
#include <QDebug>
#include <algorithm>
int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    qmlRegisterType<PolygonManager>("Polygon", 1, 0, "PolygonManager");
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    double d = -0.7;
    qDebug() << static_cast<int>(d);

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}

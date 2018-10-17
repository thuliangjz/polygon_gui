#ifndef POLYGON_MANAGER_H
#define POLYGON_MANAGER_H

#include <QtQuick/QQuickPaintedItem>
#include "polygon.h"
#include <vector>

using std::vector;
class PolygonManager : public QQuickPaintedItem
{
    Q_OBJECT
public:
    PolygonManager(QQuickItem *parent=nullptr);
    void paint(QPainter *painter);
    Q_INVOKABLE QString new_polygon_by_string(QString input);
private:
    void test_clip();
private:
    vector<Polygon> m_polygons;
    bool m_click_new_enabled;
    vector<pair<int, int>> m_click_new_trace;
};

#endif // POLYGON_MANAGER_H

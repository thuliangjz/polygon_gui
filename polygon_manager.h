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
    Q_PROPERTY(QPointF viewTranslate READ view_translate)
    Q_PROPERTY(qreal viewScale READ view_scale)
    Q_INVOKABLE void view_move(QPointF pt);
    Q_INVOKABLE void view_zoom(bool bigger);
    Q_INVOKABLE int get_click_id(qreal x, qreal y);
    Q_INVOKABLE void choose(int id);
    Q_INVOKABLE void translate(int id, QPointF pt);
    Q_INVOKABLE void unchoose_all();
    Q_INVOKABLE QPointF transform(QPointF pt);
    Q_INVOKABLE void rotate(int id, QPointF center, qreal angle);
    QPointF view_translate()const{return  m_view_translate;}
    qreal view_scale()const{return m_view_scale;}
private:
    void test_clip();
private:
    vector<Polygon> m_polygons;
    bool m_click_new_enabled;
    vector<pair<int, int>> m_click_new_trace;
    QPointF m_view_translate;
    qreal m_view_scale;
    vector<int> m_choosed_plg_id;
};

#endif // POLYGON_MANAGER_H

#ifndef POLYGON_H
#define POLYGON_H

#define PLG_INIT_SUCCESS 0

#include<vector>
#include<QString>
#include<QPainter>
using std::vector;
using std::pair;

typedef vector<vector<pair<int, int>>> plg_vertexs;
class Polygon
{
public:
    Polygon();
    QString init(const plg_vertexs& vertexes);
    void paint(QPainter* painter, pair<float, float> translate, float scale, bool choosed = false);
    vector<plg_vertexs> clip(const Polygon& plg);
    plg_vertexs get_vertex_copy()const;
    bool is_pt_inside(QPointF pt);
    void translate(QPointF pt);
    void rotate(QPointF center, qreal angle);
private:
    QPixmap paint_local_img(const plg_vertexs& vtxs_view, pair<int, int>& pt_belt, bool choosed = false);
private:
    plg_vertexs m_vertex;   //保存的是多边形顶点的逻辑坐标
    QColor m_color_edge;
    QColor m_color_inside;
};

#endif // POLYGON_H

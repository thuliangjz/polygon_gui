#include "polygon_manager.h"
#include <QPainter>
#include <QDebug>
#include <qregularexpression.h>
#include <map>
#include <QImage>

PolygonManager::PolygonManager(QQuickItem *parent): QQuickPaintedItem (parent), m_view_translate(0, 0),
    m_view_scale(1)
{
}

void PolygonManager::paint(QPainter *painter){
    //TODO:在此处加入绘制多边形代码
    int idx_plg = 0;
    for(auto &plg:m_polygons){
        bool choosed = std::find(m_choosed_plg_id.begin(), m_choosed_plg_id.end(), idx_plg) != m_choosed_plg_id.end();
        plg.paint(painter, pair<float, float>(m_view_translate.rx() - this->width() / 2 / m_view_scale,
                                              m_view_translate.ry() + this->height() / 2 / m_view_scale),
                  static_cast<float>(m_view_scale), choosed);
        ++idx_plg;
    }
}
void PolygonManager::set_color(int id, QColor edge, QColor inner){
    if(id < 0 || id > m_polygons.size())
        return;
    m_polygons[id].set_color(edge, inner);
}
QColor PolygonManager::get_edge_color(int id){
    if(id < 0 || id > m_polygons.size()){
        return QColor();
    }
    return m_polygons[id].get_edge_color();
}

QColor PolygonManager::get_inner_color(int id){
    if(id < 0 || id > m_polygons.size())
        return QColor();
    return m_polygons[id].get_inner_color();
}

QPointF PolygonManager::transform(QPointF pt){
    QPointF pt_logic;
    pt_logic.rx() = pt.x() / m_view_scale + m_view_translate.rx() - this->width() / 2 / m_view_scale;
    pt_logic.ry() = -pt.y() / m_view_scale + m_view_translate.ry() + this->height() / 2 / m_view_scale;
    return pt_logic;
}

void PolygonManager::rotate(int id, QPointF center, qreal angle){
    if(id < 0 || id > m_polygons.size())
        return;
    m_polygons[id].rotate(center, angle);
}

void PolygonManager::choose(int id){
    if(id < 0 || std::find(m_choosed_plg_id.begin(), m_choosed_plg_id.end(), id) != m_choosed_plg_id.end())
        return;
    m_choosed_plg_id.push_back(id);
}

void PolygonManager::unchoose_all(){
    m_choosed_plg_id.clear();
}

void PolygonManager::translate(int id, QPointF pt){
    if(id < 0 || id >= m_polygons.size())
        return;
    m_polygons[id].translate(pt);
}

int PolygonManager::get_click_id(qreal x, qreal y){
    QPointF pt_logic = transform(QPointF(x, y));
    int id = 0;
    for(auto &plg : m_polygons){
        if(plg.is_pt_inside(pt_logic))
            return id;
        ++id;
    }
    return -1;
}

void PolygonManager::view_move(QPointF pt){
    const qreal d = 10;
    m_view_translate.setX(d / m_view_scale * pt.rx() + m_view_translate.rx());
    m_view_translate.setY(d / m_view_scale * pt.ry() + m_view_translate.ry());
}

void PolygonManager::view_zoom(bool bigger){
    m_view_scale += bigger ? 0.25 : -0.25;
    m_view_scale = m_view_scale < 0.25 ? 0.25 : m_view_scale;
}

QString PolygonManager::new_polygon_by_string(QString input){
    input += "\n\n";
    QRegularExpression re("^((-?\\d+\\s+-?\\d+\n)+(\n)+)+$");
    QRegularExpressionMatch match = re.match(input);
    if (!match.hasMatch()){
        return "请按照提示要求的格式进行输入";
    }
    QRegularExpression re_num("-?\\d+");
    //获取每一个环上有多少个顶点
    vector<int> cnt_vtx_loop(1, 0);
    for(int i = 1; i < input.length(); ++i){
        if(input[i] == '\n' && input[i - 1] != '\n'){
            cnt_vtx_loop.back()++;
        }
        if(input[i] == '\n' && input[i - 1] == '\n' && cnt_vtx_loop.back() != 0){
            if(cnt_vtx_loop.back() < 3){
                return "至少每个环上至少应该有3个点";
            }
            cnt_vtx_loop.push_back(0);
        }
    }
    cnt_vtx_loop.pop_back();
    //生成顶点描述
    plg_vertexs vtx_description;
    QRegularExpressionMatchIterator it_num = re_num.globalMatch(input);
    for(int i = 0; i < static_cast<int>(cnt_vtx_loop.size()); ++i){
        vector<pair<int, int>> loop_tmp;
        for(int j = 0; j < cnt_vtx_loop[static_cast<size_t>(i)]; ++j){
            pair<int, int> vtx;
            vtx.first = it_num.next().captured().toInt();
            vtx.second = it_num.next().captured().toInt();
            loop_tmp.push_back(vtx);
        }
        vtx_description.push_back(loop_tmp);
    }
    Polygon plg;
    QString res = plg.init(vtx_description);
    if(res == "ok")
        m_polygons.push_back(plg);
    return res;
}

void PolygonManager::test_clip(){
    vector<plg_vertexs> plgs_clip = m_polygons[0].clip(m_polygons[1]);
    m_polygons.clear();
    for(auto& vtxs : plgs_clip){
        Polygon plg;
        QString s = plg.init(vtxs);
        if(s == "ok")
            m_polygons.push_back(plg);
        else
            qDebug() << "error occured when cliping" << s;
    }
}

#include "polygon_manager.h"
#include <QPainter>
#include <QDebug>
#include <qregularexpression.h>
#include <map>
#include <QImage>

PolygonManager::PolygonManager(QQuickItem *parent): QQuickPaintedItem (parent)
{
}

void PolygonManager::paint(QPainter *painter){
    //TODO:在此处加入绘制多边形代码
    for(auto &plg:m_polygons){
        plg.paint(painter, pair<float, float>(-this->width() / 2, this->height() / 2), 1);
    }
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
    if(m_polygons.size() >= 2)
        test_clip();
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

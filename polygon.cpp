#include "polygon.h"
#include <math.h>
#include <algorithm>
#include <list>

using std::list;
template <typename T>
double get_winding(pair<T, T> pt,const vector<pair<T, T>>& vtxs);

template <typename T>
inline T get_online_indicator(pair<pair<T, T>, pair<T, T>> line, pair<T, T> pt);

Polygon::Polygon():
    m_color_edge(0, 0, 0),
    m_color_inside(0, 0, 255)
{

}


QString Polygon::init(const plg_vertexs& vertexes){
    typedef pair<pair<int, int>, pair<int, int>> line_seg;  //起点为first终点为second
    typedef vector<pair<int, int>> vtxs_loop;
    const double epsilon = 1e-5;
    const QString err_intersect = "多边形任意两条边不能相交";
    const QString err_inside_pt_out = "多边形所有内点应该在外环围成区域的闭包内";
    const QString err_loop_vtx_dup = "多边形的每个环中不能包括相同坐标的顶点";
    const QString err_inner_pt_not_found = "依照当前算法无法有效找到某个环的内点";
    //检测除相邻两条边外，任意两条边不相交
    vtxs_loop vtx_total;
    vector<line_seg> edges_total;
    vector<pair<int, int>> adj_lst;    //adj_lst[i]记录了edges_total中第i号相邻的边的序号(first是和起点相邻,second和终点相邻)
    for(auto &loop : vertexes){
        int idx_loop_start = edges_total.size();
        vtxs_loop loop_it(loop);
        loop_it.push_back(loop_it.front());
        for(int i = 0; i < loop_it.size() - 1; ++i){
            edges_total.push_back(line_seg(loop_it[i], loop_it[i + 1]));
            adj_lst.push_back(pair<int, int>(edges_total.size() - 2, edges_total.size()));
        }
        adj_lst[idx_loop_start].first = edges_total.size() - 1;
        adj_lst[edges_total.size() - 1].second = idx_loop_start;
    }
    for(int i =0; i < edges_total.size() - 1; ++i){
        for(int j = i + 1; j < edges_total.size(); ++j){
            if(j == adj_lst[i].first || j == adj_lst[i].second)
                continue;
            int indicator1 = get_online_indicator<int>(edges_total[i], edges_total[j].first) *
                    get_online_indicator<int>(edges_total[i], edges_total[j].second),
                indicator2 = get_online_indicator<int>(edges_total[j], edges_total[i].first) *
                    get_online_indicator<int>(edges_total[j], edges_total[i].second);
            if(indicator1 <= 0 && indicator2 <= 0)
                return err_intersect;
        }
    }
    //检测所有内环上的点位于外环围成的区域的闭包中
    vector<line_seg> outer_loop_edge;
    for(int i = 0; i < vertexes[0].size() - 1; ++i){
        outer_loop_edge.push_back(line_seg(vertexes[0][i], vertexes[0][i + 1]));
    }
    outer_loop_edge.push_back(line_seg(vertexes[0].back(), vertexes[0].front()));
    for(int i = 1; i < vertexes.size(); ++i){
        for(auto pt : vertexes[i]){
            bool inside = false;
            //检测点是否落在外环上
            for(auto &edge : outer_loop_edge){
                bool online= (pt.first - edge.first.first) * (edge.second.second - edge.first.second) -
                        (pt.second - edge.first.second) * (edge.second.first - edge.first.first) == 0;
                bool middle = (pt.first - edge.first.first) * (pt.first - edge.second.first) +
                        (pt.second - edge.first.second) * (pt.second - edge.second.second) <= 0;
                if(online && middle){
                    inside = true;
                    break;
                }
            }
            if(inside)
                continue;
            //检查点是否落在环内
            double angle = get_winding<int>(pt, vertexes[0]);
            if(abs(angle) < epsilon){
                return err_inside_pt_out;
            }
        }
    }
    //同一个环中不能包含两个坐标相同的顶点（每一个环都是和圆周同胚）
    for(auto &loop:vertexes){
        for(int i = 0; i < loop.size(); ++i){
            for(int j = i + 1; j < loop.size(); ++j){
                if(loop[i] == loop[j])
                    return err_loop_vtx_dup;
            }
        }
    }
    //调整多边形顶点的环绕顺序，外环按照顺时针排列，内环按照逆时针排列

    for(int i = 0; i < vertexes.size(); ++i){
        //先找到一个位于环所围城的区域内部的点
        vtxs_loop loop_current(vertexes[i]);
        loop_current.push_back(loop_current.front());
        pair<int, int> pt = loop_current[0];
        for(auto &pt_it : loop_current){
            if(pt_it.second > pt.second)
                pt = pt_it;
        }
        double y = pt.second;
        vector<double> intersects;
        for(int j = 0; j < loop_current.size() - 1; ++j){
            double x1 = loop_current[j].first, y1 = loop_current[j].second,
                   x2 = loop_current[j + 1].first, y2 = loop_current[j + 1].second;
            if((y1 > y && y2 > y) || (y1 < y && y2 < y))
                continue;
            intersects.push_back(static_cast<double>(pt.first) + (x2 - x1) * (y - y1) / (y2 - y1));
        }
        std::sort(intersects.begin(), intersects.end());
        if(intersects.size() < 2 || abs(intersects[0] - intersects[1]) < epsilon)
            return err_inner_pt_not_found;

        pair<double, double> pt_double((intersects[0] + intersects[1]) / 2, pt.second - 0.5);  //这个点一定是在环的内部的
        vector<pair<double, double>>vtxs_double;
        for(auto & pt_it:loop_current){
            vtxs_double.push_back(pair<double, double>(pt_it.first, pt_it.second));
        }
        vtxs_double.pop_back();
        double angle = get_winding<double>(pt_double, vtxs_double);
        //angle大于0表示逆时针排列，小于0表示顺时针排列
        vtxs_loop loop_new(vertexes[i]);
        if((angle < 0 && i == 0) || (angle > 0 && i > 0))
            std::reverse(loop_new.begin(), loop_new.end());
        m_vertex.push_back(loop_new);
    }
    return "ok";
}
//局部辅助函数
template <typename T>
double get_winding(pair<T, T> pt,const vector<pair<T, T>>& vtxs){
    vector<pair<T, T>> vtx_loop(vtxs);
    vtx_loop.push_back(vtx_loop.front());
    double angle = 0;
    for(int j = 1; j < vtx_loop.size(); ++j){
        T dx0 = vtx_loop[j - 1].first - pt.first,
            dy0 = vtx_loop[j - 1].second - pt.second,
            dx1 = vtx_loop[j].first - pt.first,
            dy1 = vtx_loop[j].second - pt.second;
        T cross = dx0 * dy1 - dy0 * dx1, dot = dx0 * dx1 + dy0 * dy1;
        double length_product = sqrt(static_cast<double>(dx0) * dx0 + dy0 * dy0) *
                sqrt(static_cast<double>(dx1) * dx1 + dy1 * dy1);
        double delta = (cross > 0 ? 1 : -1) * acos(dot / length_product);
        angle += delta;
    }
    return angle;
}

template <typename T>
inline T get_online_indicator(pair<pair<T, T>, pair<T, T>> line, pair<T, T> pt){
    T x1 = line.first.first, y1 = line.first.second,
        x2 = line.second.first, y2 = line.second.second;
    T x = pt.first, y = pt.second;
    return (y2 - y1) * (x - x1) - (x2 - x1) * (y - y1);
}

QPixmap Polygon::paint_local_img(const plg_vertexs& vtxs_view){
    //vtxs_view是在屏幕坐标系下的坐标
    plg_vertexs vtxs_map(vtxs_view);
    int left = vtxs_view.front().front().first,
        top = vtxs_view.front().front().second,
        right = left, bottom = top;
    for(auto &loop:vtxs_view){
        for(auto &pt:loop){
            left = pt.first < left ? pt.first : left;
            right = pt.first > right ? pt.first : right;
            top = pt.second < top ? pt.second : top;
            bottom = pt.second > bottom ? pt.second : bottom;
        }
    }
    struct edge_entry{
        pair<int, int> start;
        pair<int, int> end;
        int current_x_int;
        double current_x_double;
        double delta_x;
        int current_y_int;
        edge_entry(pair<int, int> s, pair<int, int> e, int c_x_i, double c_x_d, double d_x, int c_y):
            start(s), end(e), current_x_int(c_x_i),current_x_double(c_x_d), delta_x(d_x), current_y_int(c_y){

        }
    };
    vector<vector<edge_entry>*> new_edge_table(bottom - top, nullptr);
    for(auto &loop:vtxs_map){
        loop.push_back(loop.front());
    }
    for(auto &loop:vtxs_map){
        for(int i = 0; i < loop.size() - 1; ++i){
            if(loop[i].second == loop[i + 1].second)
                continue;
            int net_idx;
            pair<int, int> start, end;
            if(loop[i].second < loop[i + 1].second){
                net_idx = loop[i].second; start = loop[i]; end = loop[i + 1];
            }
            else{
                net_idx = loop[i + 1].second; start = loop[i + 1]; end = loop[i];
            }
            new_edge_table[net_idx] = new_edge_table[net_idx] ? new_edge_table[net_idx] : (new vector<edge_entry>);
            new_edge_table[net_idx]->push_back(edge_entry(start, end, start.first, static_cast<double>(start.first),
                                                          static_cast<double>(end.first - start.first) / (end.second - start.second),
                                                          start.second));
        }
    }

    list<edge_entry> active_edge_list;
    QImage img_inside(right - left, bottom - top, QImage::Format_Mono);
    img_inside.setColor(0, qRgba(255, 255, 255, 0));
    img_inside.setColor(1, qRgb(m_color_inside.red(), m_color_inside.green(), m_color_inside.blue()));
    img_inside.fill(0);
    for(int y = top; y < bottom; ++y){
        if(new_edge_table[y]){
            //添加新边并进行填充操作
            for(auto &edge:(*new_edge_table[y])){
                for(auto it = active_edge_list.begin(); it != active_edge_list.end(); ++it){
                    if(edge.current_x_double < it->current_x_double || (edge.current_x_double == it->current_x_double && edge.delta_x < it->delta_x)){
                        it = active_edge_list.insert(it, edge);
                        break;
                    }
                }
            }
            //处理扫描线与顶点相交的问题
            vector<int> intersects;
            for(auto it = active_edge_list.begin(); it != active_edge_list.end(); ++it){
                intersects.push_back(it->current_x_int);
                if(it->current_y_int == it->start.second || it->current_y_int == it->end.second){
                    auto it_next = std::next(it);
                    pair<int, int> ref_pt_it = it->current_y_int == it->start.second ? it->end : it->start,
                            ref_pt_it_next = it_next->current_y_int == it_next->start.second ? it_next->end : it_next->start;
                    ++it;
                    if((ref_pt_it.second - y) * (ref_pt_it_next.second - y) > 0)
                        intersects.pop_back();
                }
            }
            //通过intersects进行上色
            for(auto it = intersects.begin(); it != intersects.end(); std::advance(it, 2)){
                int idx_row = y - top;
                int idx_col_l = *it - left,
                    idx_col_r = *std::next(it) - right;
                uchar* scan_line = img_inside.scanLine(idx_row);
                int cnt_bt = (idx_col_r >> 3) - ((idx_col_l >> 3) + 1);
                if(cnt_bt > 0){
                    memset(scan_line + (idx_col_l >> 3) + 1, 255, cnt_bt);
                }
                scan_line[idx_col_l >> 3] = scan_line[idx_col_l >> 3] | static_cast<uchar>((255 << ((((idx_col_l >> 3) + 1) << 3) - idx_col_l)) ^ 255);
                scan_line[idx_col_r >> 3] = scan_line[idx_col_r >> 3] | static_cast<uchar>(128 >> (idx_col_r - (idx_col_r >> 3)));
            }
            continue;
        }
        for(auto it = active_edge_list.begin(); it != active_edge_list.end(); std::advance(it, 2)){
            int idx_row = y - top;
            int idx_col_l = it->current_x_int - left,
                idx_col_r = std::next(it)->current_x_int - right;
            uchar* scan_line = img_inside.scanLine(idx_row);
            int cnt_bt = (idx_col_r >> 3) - ((idx_col_l >> 3) + 1);
            if(cnt_bt > 0){
                memset(scan_line + (idx_col_l >> 3) + 1, 255, cnt_bt);
            }
            scan_line[idx_col_l >> 3] = scan_line[idx_col_l >> 3] | static_cast<uchar>((255 << ((((idx_col_l >> 3) + 1) << 3) - idx_col_l)) ^ 255);
            scan_line[idx_col_r >> 3] = scan_line[idx_col_r >> 3] | static_cast<uchar>(128 >> (idx_col_r - (idx_col_r >> 3)));
        }
        for(auto it = active_edge_list.begin(); it != active_edge_list.end();){
            if(it->current_y_int >= it->end.second){
                it = active_edge_list.erase(it);
                continue;
            }
            it->current_x_double += it->delta_x;
            it->current_x_int = static_cast<int>(it->current_x_double);
            double rounding = it->current_x_double - it->current_x_int;
            it->current_x_int += rounding > 0.5 ? 1 : 0;
            it->current_x_int += rounding < -0.5 ? -1 : 0;
            ++(it->current_y_int);
            ++it;
        }
    }
    for(auto pt:new_edge_table){
        delete pt;
    }
    //绘制顶点
    QPixmap pixmap = QPixmap::fromImage(img_inside);
    QPainter painter_map(&pixmap);
    painter_map.setPen(m_color_edge);
    for(auto &loop:vtxs_map){
        for(int i = 0; i < loop.size() - 1; ++i){
            int x1 = loop[i].first - left, y1 = loop[i].second - top,
                x2 = loop[i + 1].first - left, y2 = loop[i].second - top;
            painter_map.drawLine(x1, y1, x2, y2);
        }
    }
    return pixmap;
}

#include "polygon.h"
#include <math.h>
#include <algorithm>
#include <list>
#include <QDebug>
using std::list;
template <typename T>
double get_winding(pair<T, T> pt,const vector<pair<T, T>>& vtxs);

template <typename T>
inline T get_online_indicator(pair<pair<T, T>, pair<T, T>> line, pair<T, T> pt);

pair<int, int> line_seg_intersect(const pair<int, int>& p1,
                                  const pair<int, int>& p2,
                                  const pair<int, int>& p3,
                                  const pair<int, int>& p4,
                                  bool& valid, bool& is_enter,
                                  double& t1, double& t2);
template <typename T>
inline int round(T x);

int get_cnt_ctx(plg_vertexs& vtxs);

pair<double, double> get_inner_point(const vector<pair<int, int>>& loop, bool& succeed);
double get_winding_d_i(pair<double, double> pt_d, vector<pair<int, int>>& vtxs_int);
float get_signed_area(const vector<pair<int, int>>& loop);

Polygon::Polygon():
    m_color_edge(0, 0, 0),
    m_color_inside(255, 85, 255)
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
    //检测任意两边不相交
    vector<line_seg> edge_total;
    plg_vertexs vertex_tmp(vertexes);
    for(auto &loop:vertex_tmp){
        loop.push_back(loop.front());
    }
    for(auto &loop:vertex_tmp){
        for(int i = 0; i + 1< loop.size(); ++i){
            edge_total.push_back(line_seg(loop[i], loop[i + 1]));
        }
    }
    for(int i = 0; i + 1< edge_total.size(); ++i){
        for(int j = i + 1; j < edge_total.size(); ++j){
            double t1 = 0, t2 = 0;
            bool valid, is_inter;
            line_seg_intersect(edge_total[i].first, edge_total[i].second,
                               edge_total[j].first, edge_total[j].second,
                               valid, is_inter, t1, t2);
            if(!valid || (valid && (t1 < epsilon || t2 < epsilon || t1 > 1 - epsilon || t2 > 1 - epsilon)))
                continue;
            return err_intersect;
        }
    }
    //检测所有内环上的点位于外环围成的区域的闭包中
    vector<line_seg> outer_loop_edge;
    for(int i = 0; i + 1< vertexes[0].size(); ++i){
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
        double y = pt.second - 0.5;
        vector<double> intersects;
        for(int j = 0; j + 1 < loop_current.size(); ++j){
            double x1 = loop_current[j].first, y1 = loop_current[j].second,
                   x2 = loop_current[j + 1].first, y2 = loop_current[j + 1].second;
            if((y1 > y && y2 > y) || (y1 < y && y2 < y) || (y1 == y && y2 == y))
                continue;
            intersects.push_back(x1 + (x2 - x1) * (y - y1) / (y2 - y1));
        }
        std::sort(intersects.begin(), intersects.end());
        if(intersects.size() < 2 || abs(intersects[0] - intersects[1]) < epsilon)
            return err_inner_pt_not_found;

        pair<double, double> pt_double((intersects[0] + intersects[1]) / 2, y);  //这个点一定是在环的内部的
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

template <typename T>
inline int round(T x){
    int xi = static_cast<int>(x);
    double r = static_cast<double>(x - xi);
    xi += r > 0.5 ? 1 : 0;
    xi -= r < -0.5 ? 1 : 0;
    return xi;
}

void Polygon::paint(QPainter* painter, pair<float, float> translate, float scale, bool choosed){
    //tanslate是窗口左上角在世界坐标系中的坐标，scale是显示的比例尺
    plg_vertexs vtxs_view(m_vertex);
    for(auto &loop:vtxs_view){
        for(auto &pt:loop){
            pt.first = round<float>(scale * (pt.first - translate.first));
            pt.second = round<float>(scale * (translate.second - pt.second));
        }
    }
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
    pair<int, int> pt_belt;
    QPixmap map = paint_local_img(vtxs_view, pt_belt, choosed);
    painter->drawPixmap(pt_belt.first, pt_belt.second, map);
}

QPixmap Polygon::paint_local_img(const plg_vertexs& vtxs_view, pair<int, int>&pt_belt, bool choosed){
    //在pt_belt中返回图片应该被绘制的点
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
        for(int i = 0; i + 1 < loop.size(); ++i){
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
            net_idx -= top;
            new_edge_table[net_idx] = new_edge_table[net_idx] ? new_edge_table[net_idx] : (new vector<edge_entry>);
            new_edge_table[net_idx]->push_back(edge_entry(start, end, start.first, static_cast<double>(start.first),
                                                          static_cast<double>(end.first - start.first) / (end.second - start.second),
                                                          start.second));
        }
    }

    list<edge_entry> active_edge_list;
    const int margin = 100;
    QImage img_inside(right - left + 2 * margin, bottom - top + 2 * margin, QImage::Format_Mono);
    pt_belt.first = left - margin;
    pt_belt.second = top - margin;
    img_inside.setColor(0, qRgba(255, 255, 255, 0));
    img_inside.setColor(1, qRgb(m_color_inside.red(), m_color_inside.green(), m_color_inside.blue()));
    img_inside.fill(0);
    for(int y = top; y < bottom; ++y){
        if(new_edge_table[y - top]){
            //添加新边并进行填充操作,
            //注意，这一部分写的较长，但是因为执行次数比较少，所以整体效率不会下降太多，后面的部分因为执行次数多所以应该尽量简洁
            for(auto &edge:(*new_edge_table[y - top])){
                bool inserted = false;
                for(auto it = active_edge_list.begin(); it != active_edge_list.end(); ++it){
                    if(edge.current_x_double < it->current_x_double || (edge.current_x_double == it->current_x_double && edge.delta_x < it->delta_x)){
                        it = active_edge_list.insert(it, edge);
                        inserted = true;
                        break;
                    }
                }
                if(!inserted)
                    active_edge_list.push_back(edge);
            }
        }
        const unsigned int mask = 0xffffffff;
        for(auto it = active_edge_list.begin(); it != active_edge_list.end(); std::advance(it, 2)){
            int idx_row = y - top + margin;
            int idx_col_l = it->current_x_int - left + margin,
                idx_col_r = std::next(it)->current_x_int - left + margin;
            uchar* scan_line = img_inside.scanLine(idx_row);
            int cnt_bt = (idx_col_r >> 3) - ((idx_col_l >> 3) + 1);
            if(cnt_bt > 0){
                memset(scan_line + (idx_col_l >> 3) + 1, 255, cnt_bt);
            }
            if((idx_col_l >> 3) < (idx_col_r >> 3)){
               scan_line[idx_col_l >> 3] = scan_line[idx_col_l >> 3] | static_cast<uchar>((255 << ((((idx_col_l >> 3) + 1) << 3) - idx_col_l)) ^ 255);
               scan_line[idx_col_r >> 3] = scan_line[idx_col_r >> 3] | static_cast<uchar>(0xffffffff << (8 - (idx_col_r & 7)));
            }
            else{
                scan_line[idx_col_l >> 3] = scan_line[idx_col_l >> 3] |  static_cast<uchar>((mask << (8 - (idx_col_l - ((idx_col_l >> 3) << 3)))) ^ (mask << (8 - (idx_col_r - ((idx_col_r >> 3) << 3)))));
            }
        }
        for(auto it = active_edge_list.begin(); it != active_edge_list.end();){
            it->current_x_double += it->delta_x;
            it->current_x_int = static_cast<int>(it->current_x_double);
            double rounding = it->current_x_double - it->current_x_int;
            it->current_x_int += rounding > 0.5 ? 1 : 0;
            it->current_x_int += rounding < -0.5 ? -1 : 0;
            ++(it->current_y_int);
            if(it->current_y_int >= it->end.second){
                it = active_edge_list.erase(it);
                continue;
            }
            ++it;
        }
    }
    for(auto pt:new_edge_table){
        delete pt;
    }
    //绘制顶点
    QPixmap pixmap = QPixmap::fromImage(img_inside);
    QPainter painter_map(&pixmap);
    QPen pen(choosed ? Qt::DashLine : Qt::SolidLine);
    pen.setColor(m_color_edge);
    pen.setWidth(3);
    painter_map.setPen(pen);
    for(auto &loop:vtxs_map){
        for(int i = 0; i + 1 < loop.size(); ++i){
            int x1 = loop[i].first - left + margin, y1 = loop[i].second - top + margin,
                x2 = loop[i + 1].first - left + margin, y2 = loop[i + 1].second - top + margin;
            painter_map.drawLine(x1, y1, x2, y2);
        }
    }
    return pixmap;
}

plg_vertexs Polygon::get_vertex_copy()const{
    return m_vertex;
}

int get_cnt_ctx(plg_vertexs& vtxs){
    int cnt = 0;
    for(auto &loop:vtxs){
        cnt += loop.size();
    }
    return cnt;
}


vector<plg_vertexs> Polygon::clip(const Polygon& plg){
    //this指向多边形作为裁剪多边形（窗口）
    plg_vertexs vertexs_main_plg = plg.get_vertex_copy(), vertexs_clip_plg = this->m_vertex;
    //逐边求交并对交点按照环绕顺序进行排序, 构建vec_intersect_main, vec_intersect_clip, id_intersect在结束时表示交点的总量
    struct intersect_vector_entry{
        pair<int, int> pt;    //由于舍入带来的误差可能导致最终得到的裁剪多边形不是一个合格的格点多边形
        int id;
        bool is_enter;
        double t;
        //intersect_vector_entry(){}
        intersect_vector_entry(pair<int, int> pt, int id, bool i_e, double t):pt(pt), id(id), is_enter(i_e), t(t){}
    };
    struct {
        bool operator() (intersect_vector_entry e1, intersect_vector_entry e2){return e1.t < e2.t;}
    }i_v_e_cmp;
    int cnt_vtx_main = get_cnt_ctx(vertexs_main_plg), cnt_vtx_clip = get_cnt_ctx(vertexs_clip_plg);
    vector<vector<intersect_vector_entry>> vec_intersect_main(cnt_vtx_main), vec_intersect_clip(cnt_vtx_clip);
    for(auto &loop:vertexs_clip_plg){
        loop.push_back(loop.front());
    }
    for(auto &loop:vertexs_main_plg){
        loop.push_back(loop.front());
    }
    int idx_vertex_main = 0;
    int id_intersect = 0;
    for(auto &loop_main:vertexs_main_plg){
        for(int i = 0; i + 1 < loop_main.size(); ++i, ++idx_vertex_main){
            int idx_vertex_clip = 0;
            for(auto &loop_clip:vertexs_clip_plg){
                for(int j = 0; j + 1 < loop_clip.size(); ++j, ++idx_vertex_clip){
                    bool valid, is_enter;
                    double t1 = 0, t2 = 0;
                    pair<int, int> intersect = line_seg_intersect(loop_main[i], loop_main[i + 1],
                            loop_clip[j], loop_clip[j + 1], valid, is_enter, t1, t2);
                    if(valid){
                        vec_intersect_main[idx_vertex_main].push_back(intersect_vector_entry(intersect, id_intersect, is_enter, t1));
                        vec_intersect_clip[idx_vertex_clip].push_back(intersect_vector_entry(intersect, id_intersect, is_enter, t2));
                        ++id_intersect;
                    }
                }
            }
        }
    }
    for(auto &vec_intersect:vec_intersect_main)
        std::sort(vec_intersect.begin(), vec_intersect.end(), i_v_e_cmp);
    for(auto &vec_intersect:vec_intersect_clip)
        std::sort(vec_intersect.begin(), vec_intersect.end(), i_v_e_cmp);
    for(auto &loop:vertexs_clip_plg)
        loop.pop_back();
    for(auto &loop:vertexs_main_plg)
        loop.pop_back();
    vector<bool> intersect_valid(id_intersect, true);
    const double epsilon = 1e-5;
    //排除掉所有很快进入又很快出去（或者相反）的交点对
    for(auto &intersects : vec_intersect_main){
        for(int i = 0; i + 1 < intersects.size(); ++i){
            if(abs(intersects[i].t - intersects[i + 1].t) < epsilon && intersects[i].is_enter != intersects[i + 1].is_enter){
                intersect_valid[intersects[i].id] = false;
                intersect_valid[intersects[i + 1].id] = false;
            }
        }
    }
    for(auto &intersects : vec_intersect_clip){
        for(int i = 0; i + 1 < intersects.size(); ++i){
            if(abs(intersects[i].t - intersects[i + 1].t) < epsilon && intersects[i].is_enter != intersects[i + 1].is_enter){
                intersect_valid[intersects[i].id] = false;
                intersect_valid[intersects[i + 1].id] = false;
            }
        }
    }

    //排序结束
    //构建顶点列表
    struct intersect_list_entry{
        bool is_vertex;
        bool is_enter;
        bool is_traversed;
        bool is_loop_last;  //为true时表明需要通过it_loop_head回到这个环的开头
        list<intersect_list_entry>::iterator it_dual;
        list<intersect_list_entry>::iterator it_loop_head;
        pair<int, int> pt;
        list<list<intersect_list_entry>::iterator>::iterator it_lst_left;
        intersect_list_entry(pair<int, int> pt, bool i_v=false):is_vertex(i_v), is_traversed(false), is_loop_last(false), pt(pt){}
    };
    vector<bool> lp_interseted_main(vertexs_main_plg.size(), false),
            lp_interseted_clip(vertexs_clip_plg.size(), false);
    list<list<intersect_list_entry>::iterator> lst_intersects_left;   //指向主多边形链表
    vector<list<intersect_list_entry>::iterator> dual_it_table(id_intersect);
    vector<list<list<intersect_list_entry>::iterator>::iterator> lst_left_it_table(id_intersect);   //在构建主多边形表过程中填写
    list<intersect_list_entry> lst_all_vertex_main, lst_all_vertex_clip;
    idx_vertex_main = 0;
    int idx_loop_main = 0;
    for(auto &loop : vertexs_main_plg){
        bool first_it_written = false;
        list<intersect_list_entry>::iterator it_loop_head;
        for(auto &pt : loop){
            lst_all_vertex_main.push_back(intersect_list_entry(pt, true));
            it_loop_head = !first_it_written ? std::next(lst_all_vertex_main.end(), -1) : it_loop_head;
            first_it_written = true;
            for(auto & intersect:vec_intersect_main[idx_vertex_main]){
                if(!intersect_valid[intersect.id])
                    continue;
                lst_all_vertex_main.push_back(intersect_list_entry(intersect.pt));
                auto &last = lst_all_vertex_main.back();
                auto it_last = std::next(lst_all_vertex_main.end(), -1);
                last.is_enter = intersect.is_enter;
                lst_intersects_left.push_back(it_last);
                lst_left_it_table[intersect.id] = std::next(lst_intersects_left.end(), -1); //记录lst_intersects_left指向它的指针
                last.it_lst_left = std::next(lst_intersects_left.end(), -1);
                dual_it_table[intersect.id] = it_last;
                lp_interseted_main[idx_loop_main] = true;
            }
            ++idx_vertex_main;
        }
        lst_all_vertex_main.back().is_loop_last = true;
        lst_all_vertex_main.back().it_loop_head = it_loop_head;
        ++idx_loop_main;
    }
    int idx_vertex_clip = 0, idx_loop_clip = 0;
    for(auto &loop : vertexs_clip_plg){
        bool first_it_written = false;
        list<intersect_list_entry>::iterator it_loop_head;
        for(auto &pt : loop){
            lst_all_vertex_clip.push_back(intersect_list_entry(pt, true));
            it_loop_head = !first_it_written ? std::next(lst_all_vertex_clip.end(), -1) : it_loop_head;
            first_it_written = true;
            for(auto &intersect : vec_intersect_clip[idx_vertex_clip]){
                if(!intersect_valid[intersect.id])
                    continue;
                lst_all_vertex_clip.push_back(intersect_list_entry(intersect.pt));
                auto &last = lst_all_vertex_clip.back();
                auto it_last = std::next(lst_all_vertex_clip.end(), -1);
                last.is_enter = intersect.is_enter;
                last.it_lst_left = lst_left_it_table[intersect.id]; //建立table的作用
                last.it_dual = dual_it_table[intersect.id]; //建立table的作用
                dual_it_table[intersect.id]->it_dual = it_last;
                lp_interseted_clip[idx_loop_clip] = true;
            }
            ++idx_vertex_clip;
        }
        lst_all_vertex_clip.back().is_loop_last = true;
        lst_all_vertex_clip.back().it_loop_head = it_loop_head;
        ++idx_loop_clip;
    }//顶点列表构建完成
    //至此，lst_all_vertex_clip和lst_all_vertex_main代表了原始算法中的顶点列表，lst_left_it_table中保留了剩下的交点迭代器在lst_all_vertex_main中的位置
    //以下开始求所有的包含交点的边界多边形
    plg_vertexs resulting_loops;
    typedef vector<pair<int,int>> loop_vtxs;
    while(!lst_intersects_left.empty()){
        loop_vtxs loop;
        auto it = *lst_intersects_left.begin();
        bool traversing_in_main = true;
        if(!it->is_enter){it = it->it_dual; traversing_in_main = false;}
        lst_intersects_left.erase(it->it_lst_left);
        auto entry1 = *it, entry2 = entry1;
        while(!it->is_traversed){
            loop.push_back(it->pt);
            it->is_traversed = true;
            it = it->is_loop_last ? it->it_loop_head : std::next(it);   //在当前链表中移动
            if(!it->is_vertex && it->is_enter != traversing_in_main){   //注意到可能会出现连着遇到两个入点或者出点的情况
                it = it->it_dual;   //切换链表
                traversing_in_main = !traversing_in_main;
                if(!it->is_traversed)   //避免删掉已经删除过的表项
                    lst_intersects_left.erase(it->it_lst_left);
            }
            entry2 = *it;
        }
        if(!loop.empty())
            resulting_loops.push_back(loop);
    }//交点多边形求解完成
    for(auto &loop:resulting_loops){    //删除那些相同的顶点
        loop_vtxs loop_tmp;
        loop_tmp.push_back(loop.front());
        for(int i = 1; i < loop.size();++i){
            if(loop[i].first == loop_tmp.back().first && loop[i].second == loop_tmp.back().second)
                continue;
            loop_tmp.push_back(loop[i]);
        }
        loop = loop_tmp;
    }
    //完成结果环之间的配对
    vector<loop_vtxs> loops_out, loops_in;
    for(auto &loop : resulting_loops){
        float area = get_signed_area(loop);
        if(area > 0)
            //因为是以最左侧点作为原点求面积的，大于零说明环绕方向为逆时针
            loops_out.push_back(loop);
        else
            loops_in.push_back(loop);
    }
    for(int i = 1; i < vertexs_main_plg.size(); ++i){
        if(!lp_interseted_main[i])
            loops_in.push_back(vertexs_main_plg[i]);
    }
    for(int i = 1; i < vertexs_clip_plg.size(); ++i){
        if(!lp_interseted_clip[i])
            loops_in.push_back(vertexs_clip_plg[i]);
    }
    if(loops_out.empty()){
        //需要将原先某个多边形的外环设置为新的外环
        bool succeed;
        pair<double, double> pt_main = get_inner_point(vertexs_main_plg[0], succeed),
                pt_clip = get_inner_point(vertexs_clip_plg[0], succeed);
        double winding_m_c = get_winding_d_i(pt_main, vertexs_clip_plg[0]),
               winding_c_m = get_winding_d_i(pt_clip, vertexs_main_plg[0]);
        if(abs(winding_c_m) < epsilon && abs(winding_m_c) < epsilon)
            return vector<plg_vertexs>();
        float area_main = abs(get_signed_area(vertexs_main_plg[0]));
        float area_clip = abs(get_signed_area(vertexs_clip_plg[0]));
        loop_vtxs &loop_out = area_main > area_clip ? vertexs_clip_plg[0] : vertexs_main_plg[0];
        //检查这个外环是否被包含在某个内环内部
        pair<double, double> pt_d = get_inner_point(loop_out, succeed);
        for(auto &loop : loops_in){
            double winding = get_winding_d_i(pt_d, loop);
            if(abs(winding) > epsilon){
                //或者内环包含在外环内或者外环包含在内环内
                float area_out = abs(get_signed_area(loop_out)),
                      area_in = abs(get_signed_area(loop));
                if(area_in > area_out){
                    return vector<plg_vertexs>();
                }
            }
        }
        loops_out.push_back(loop_out);
    }
    vector<bool> inner_loop_valid(loops_in.size(), true);
    for(int i = 0; i < loops_in.size(); ++i){
        bool b0;
        pair<double, double> pt_d = get_inner_point(loops_in[i], b0);
        for(int j = 0; j < loops_in.size(); ++j){
            if(j == i)
                continue;
            double winding = get_winding_d_i(pt_d, loops_in[j]);
            if(abs(winding) > epsilon){
                inner_loop_valid[i] = false;
            }
        }
    }
    //对每个内环确定外环归属
    vector<int> idx_loop_out_belonged(loops_out.size(), -1);
    int idx_loop_in = 0;
    for(auto& loop : loops_in){
        bool succeed;
        pair<double, double> pt = get_inner_point(loop, succeed);
        int idx_loop_out = 0;
        for(auto& loop_out_int : loops_out){
            vector<pair<double, double>> loop_out_double;
            for(auto &pt:loop_out_int){
                loop_out_double.push_back(pair<double, double>(pt.first, pt.second));
            }
            double winding = get_winding<double>(pt, loop_out_double);
            if(abs(winding) > epsilon){
                idx_loop_out_belonged[idx_loop_in] = idx_loop_out;
            }
            ++idx_loop_out;
        }
        ++idx_loop_in;
    }
    vector<plg_vertexs> result(loops_out.size());
    for(int i = 0; i < loops_out.size(); ++i){
        result[i].push_back(loops_out[i]);
    }
    for(int i = 0; i < loops_in.size(); ++i){
        if(inner_loop_valid[i] && idx_loop_out_belonged[i] != -1){
            result[idx_loop_out_belonged[i]].push_back(loops_in[i]);
        }
    }
    return result;
}

pair<int, int> line_seg_intersect(const pair<int, int>& p1, const pair<int, int>& p2,
                                  const pair<int, int>& p3, const pair<int, int>& p4,
                                  bool& valid, bool& is_enter, double& rt1, double& rt2){
    //判定线段p1p2与p3p4是否有交点，以及p1p2穿过p3p4是穿入边界还是穿出边界,同时返回交点到p1的长度(t)
    int x1 = p1.first, y1 = p1.second,
      x2 = p2.first, y2 = p2.second,
      x3 = p3.first, y3 = p3.second,
      x4 = p4.first, y4 = p4.second;
    int det = (x1 - x2) * (y4 - y3) - (x4 - x3) * (y1 - y2);
    pair<int, int> result;
    valid = true;
    if(det == 0)
        valid = false;
    double t1 = static_cast<double>( (y4 - y3) * (x1 - x3) + (x3 - x4) * (y1 - y3) ) / det;
    double t2 = static_cast<double>( (y2 - y1) * (x1 - x3) + (x1 - x2) * (y1 - y3) ) / det;
    if(!(t1 >= 0 && t1 <= 1 && t2 >= 0 && t2 <= 1))
        valid = false;
    result.first = round<double>(x1 + t1 * (x2 - x1));
    result.second = round<double>(y1 + t1 * (y2 - y1));
    is_enter = det > 0;
    rt1 = t1; rt2 = t2;
    return result;
}

pair<double, double> get_inner_point(const vector<pair<int, int>>& loop, bool &succeed){
    vector<pair<int, int>> loop_current = loop;
    loop_current.push_back(loop_current.front());
    pair<int, int> pt = loop_current[0];
    for(auto &pt_it : loop_current){
        if(pt_it.second > pt.second)
            pt = pt_it;
    }
    double y = pt.second - 0.5;
    vector<double> intersects;
    for(int j = 0; j + 1 < loop_current.size(); ++j){
        double x1 = loop_current[j].first, y1 = loop_current[j].second,
               x2 = loop_current[j + 1].first, y2 = loop_current[j + 1].second;
        if((y1 > y && y2 > y) || (y1 < y && y2 < y) || (y1 == y && y2 == y))
            continue;
        intersects.push_back(x1 + (x2 - x1) * (y - y1) / (y2 - y1));
    }
    double epsilon = 1e-5;
    std::sort(intersects.begin(), intersects.end());
    if(intersects.size() < 2 || abs(intersects[0] - intersects[1]) < epsilon){
        succeed = false;
        return pair<double, double>();
    }
    succeed = true;
    return pair<double, double>((intersects[0] + intersects[1]) / 2, y);
}

float get_signed_area(const vector<pair<int, int>>& loop){
    vector<pair<int, int>> loop_current = loop;
    loop_current.push_back(loop.front());
    pair<int, int> pt_left_most = loop_current[0];
    for(auto &pt_it : loop_current){
        if(pt_it.first < pt_left_most.first)
            pt_left_most = pt_it;
    }
    pt_left_most.first -= 100;
    float area = 0;
    for(int i = 0; i + 1 < loop_current.size(); ++i){
        int x1 = loop_current[i].first - pt_left_most.first, y1 = loop_current[i].second - pt_left_most.second,
            x2 = loop_current[i + 1].first - pt_left_most.first, y2 = loop_current[i + 1].second - pt_left_most.second;
        area += (x1 * y2 - x2 * y1) * 0.5;
    }
    return area;
}
double get_winding_d_i(pair<double, double> pt_d, vector<pair<int, int>>& vtxs_int){
    vector<pair<double, double>> vtxs_double;
    for(auto &pt:vtxs_int){
        vtxs_double.push_back(pair<double, double>(pt.first, pt.second));
    }
    return get_winding<double>(pt_d, vtxs_double);
}

bool Polygon::is_pt_inside(QPointF pt){
    const double epsilon = 1e-5;
    return abs(get_winding<int>(pair<int, int>(pt.rx(), pt.ry()), m_vertex[0])) > epsilon;
}

void Polygon::translate(QPointF pt){
    int dx = round<qreal>(pt.rx()), dy = round<qreal>(pt.ry());
    for(auto &loop : m_vertex){
        for(auto &pt : loop){
            pt.first += dx;
            pt.second += dy;
        }
    }
}

void Polygon::rotate(QPointF center, qreal angle){
    for(auto &loop : m_vertex){
        for(auto &pt : loop){
            pair<double, double> p_d(pt.first - center.x(), pt.second - center.y());
            double theta = 3.141592653589793 * angle / 180;
            double c = cos(theta), s = sin(theta);
            pt.first = round<double>(c * p_d.first - s * p_d.second);
            pt.second = round<double>(s * p_d.first + c * p_d.second);
        }
    }
}

void Polygon::flip(QString axis){
    pair<int, int> factor = axis == "x" ? pair<int, int>(1, -1) : pair<int, int>(-1, 1);
    for(auto &loop:m_vertex){
        for(auto &pt : loop){
            pt.first *= factor.first;
            pt.second *= factor.second;
        }
    }
}

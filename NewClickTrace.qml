import QtQuick 2.0

Item {
    id: click_new_trace
    anchors.fill: parent
    z: 1
    visible: new_info.click_enabled
    property variant pt_clicked: []
    property variant sep_pt_clicked: [] //用于分割pt_click中的点

    signal loopClosed()

    function traceClear(){
        click_new_trace.pt_clicked = []
        click_new_trace.sep_pt_clicked = []
        canvas_click_new.requestPaint()
    }

    function closeCurrentLoop(){
        var sep = click_new_trace.sep_pt_clicked.slice(0)
        var pt = click_new_trace.pt_clicked.slice(0)
        sep.push(click_new_trace.pt_clicked.length)
        if((sep.length === 1 && sep[0] < 3) ||
            (sep.length > 1 && sep[sep.length - 1] - sep[sep.length - 2] < 3)){
            return
        }
        click_new_trace.sep_pt_clicked = sep
        canvas_click_new.requestPaint()
        loopClosed()
    }

    MouseArea {
        id: ma_click_new
        anchors.fill: parent
        onClicked: {
            var pt = click_new_trace.pt_clicked
            pt.push(Qt.point(mouse.x, mouse.y))
            click_new_trace.pt_clicked = pt
            canvas_click_new.requestPaint()
        }
    }
    Canvas {
        id: canvas_click_new
        anchors.fill: parent
        onPaint: {
            var pt = click_new_trace.pt_clicked
            var sep = click_new_trace.sep_pt_clicked.slice(0)
            var ctx = canvas_click_new.getContext("2d")
            ctx.clearRect(0, 0, canvas_click_new.width, canvas_click_new.height)
            ctx.strokeStyle = Qt.rgba(0, 0, 0, 1)
            ctx.lineWidth = 2
            var r = 10
            //先绘制边再绘制点
            ctx.beginPath()
            sep.push(pt.length)
            var j = 0
            for(var i = 0; i < sep.length; ++i){
                var start = j
                for(; j < sep[i] - 1; ++j){
                    ctx.moveTo(pt[j].x, pt[j].y)
                    ctx.lineTo(pt[j + 1].x, pt[j + 1].y)
                }
                //不是最后一个多边形则封口
                if(i !== sep.length - 1){
                    ctx.moveTo(pt[j].x, pt[j].y)
                    ctx.lineTo(pt[start].x, pt[start].y)
                }
                ++j
            }
            for(i = 0;i < pt.length; ++i){
                ctx.ellipse(pt[i].x - r, pt[i].y - r, 2 * r, 2 * r)
            }
            ctx.stroke()
        }
    }
}

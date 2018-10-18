import QtQuick 2.0
import QtQuick.Dialogs 1.3
import QtQuick.Controls 2.4

Item {
    id: info_color
    anchors.fill: parent
    visible: false
    property int plg_id: -1
    property bool choosing_plg: false
    property string choosing_color_type: "no"

    signal colorSetOk(int id, color edge, color inner)

    function activate(){
        info_color.visible = true
    }

    function deactivate(){
        info_color.visible = false
    }

    function clickPlgHandler(plgManager){
        return function(mouse){
            info_color.choosing_plg = false
            var plgId = plgManager.get_click_id(mouse.x, mouse.y)
            if(plgId < 0){
                tf_color_select.text = ""
                info_color.plg_id = -1
                plgManager.unchoose_all()
                plgManager.update()
                rect_color_edge.color = "white"
                rect_color_inner.color = "white"
                return
            }
            info_color.plg_id = plgId
            tf_color_select.text = plgId.toString()
            plgManager.choose(plgId)
            rect_color_edge.color = plgManager.get_edge_color(plgId)
            rect_color_inner.color = plgManager.get_inner_color(plgId)
            plgManager.update()
        }
    }

    function colorSetOkHandler(plgManager){
        return function(id, edge, inner){
            plgManager.set_color(id, edge, inner)
            plgManager.update()
        }
    }

    TextField {
        id: tf_color_select
        x: 128
        y: 25
        width: 73
        height: 40
        text: qsTr("")
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
        id: txt_color_select
        x: -73
        width: 112
        height: 40
        text: qsTr("多边形编号")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        verticalAlignment: Text.AlignVCenter
        anchors.top: tf_color_select.top
        anchors.rightMargin: 0
        anchors.right: tf_color_select.left
        anchors.topMargin: 0
    }
    Button {
        id: bt_color_select
        width: 77
        height: 40
        visible: !info_color.choosing_plg
        text: qsTr("选择")
        anchors.left: tf_color_select.right
        anchors.leftMargin: 20
        anchors.top: tf_color_select.top
        anchors.topMargin: 0
        onClicked: {
            info_color.choosing_plg = true
        }
    }
    Text {
        id: txt_color_selecting
        x: 215
        y: 25
        width: 61
        height: 40
        text: qsTr("在右侧点击选择")
        visible: info_color.choosing_plg
        anchors.horizontalCenter: bt_color_select.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAnywhere
        font.pixelSize: 15
    }

    Text {
        id: txt_color_edge
        x: 9
        y: 95
        width: 98
        height: 29
        text: qsTr("边界颜色")
        anchors.verticalCenter: rect_color_edge.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
    }

    Rectangle {
        id: rect_color_edge
        x: 18
        width: 80
        height: 40
        color: "#ffffff"
        anchors.top: tf_color_select.bottom
        anchors.topMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        id: bt_color_edge
        y: 90
        width: 77
        height: 40
        text: qsTr("选择")
        anchors.verticalCenter: rect_color_edge.verticalCenter
        anchors.left: rect_color_edge.right
        anchors.leftMargin: 16
        onClicked: {
            if(info_color.choosing_plg)
                return
            choosing_color_type = "edge"
            dlg_color_choice.visible = true
        }
    }

    Text {
        id: txt_color_inner
        x: 18
        y: 167
        text: qsTr("内部颜色")
        anchors.verticalCenter: rect_color_inner.verticalCenter
        font.pixelSize: 20
    }

    Rectangle {
        id: rect_color_inner
        x: 17
        width: 80
        height: 40
        color: "#ffffff"
        anchors.top: rect_color_edge.bottom
        anchors.topMargin: 25
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        id: bt_color_inner
        y: 155
        width: 77
        height: 40
        text: qsTr("选择")
        anchors.leftMargin: 16
        anchors.left: rect_color_inner.right
        anchors.verticalCenter: rect_color_inner.verticalCenter
        onClicked: {
            if(info_color.choosing_plg)
                return
            choosing_color_type = "inner"
            dlg_color_choice.visible = true
        }
    }

    Button {
        id: btn_color_ok
        x: 101
        y: 229
        text: qsTr("确定")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        onClicked: {
            if(!info_color.choosing_plg && info_color.plg_id >= 0)
                info_color.colorSetOk(info_color.plg_id, rect_color_edge.color, rect_color_inner.color)
        }
    }
    ColorDialog {
        id: dlg_color_choice
        onAccepted: {
            switch(choosing_color_type){
            case "inner":
                rect_color_inner.color = dlg_color_choice.color
                break;
            case "edge":
                rect_color_edge.color = dlg_color_choice.color
                break
            default:
                break
            }
            choosing_color_type = "no"
        }
    }
}

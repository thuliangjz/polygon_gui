import QtQuick 2.0
import QtQuick.Controls 2.4

Item {
    id: info_rotate
    anchors.fill: parent
    visible: false
    property bool choosing_plg: false
    property bool choosing_center: false
    property int plg_id: -1
    property point rotate_center: Qt.point(0, 0)

    signal rotate(int plgId, point center, real angle)

    function activate(){
        info_rotate.visible = true
        info_rotate.choosing_plg = false
        plg_id = -1
        tf_rotate_select.text = ""
    }

    function deactivate(){
        info_rotate.visible = false
        choosing_plg = false
        plg_id = -1
        tf_rotate_select.text = ""
    }

    function clickPlgHandler(plgManager){
        return function(mouse){
            if(!choosing_plg)
                return;
            info_rotate.choosing_plg = false
            var plgId = plgManager.get_click_id(mouse.x, mouse.y)
            if(plgId < 0){
                tf_rotate_select.text = ""
                plg_id = -1;
                plgManager.unchoose_all()
                plgManager.update()
                return
            }
            info_rotate.plg_id = plgId
            tf_rotate_select.text = plgId.toString()
            plgManager.choose(plgId)
            plgManager.update()
        }
    }

    function clickCenterHandler(plgManager){
        return function(mouse){
            if(!info_rotate.choosing_center)
                return
            rotate_center = plgManager.transform(Qt.point(mouse.x, mouse.y))
            choosing_center = false
        }
    }

    function rotateOkHandler(plgManager){
        return function(plgId, center, angle){
            plgManager.rotate(plgId, center, angle)
            //plgManager.unchoose_all()
            plgManager.update()
        }
    }

    Slider {
        id: slider_rotate_angle
        x: 95
        y: 198
        width: 199
        height: 40
        to: 360
        value: 0
        stepSize: 0.1
        onValueChanged: {
        }
    }
    TextField {
        id: tf_rotate_select
        x: 128
        y: 25
        width: 73
        height: 40
        readOnly: true
        text: qsTr("")
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
        id: txt_rotate_select
        x: -73
        width: 112
        height: 40
        text: qsTr("多边形编号")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        verticalAlignment: Text.AlignVCenter
        anchors.top: tf_rotate_select.top
        anchors.rightMargin: 0
        anchors.right: tf_rotate_select.left
        anchors.topMargin: 0
    }
    Button {
        id: bt_rotate_select
        width: 77
        height: 40
        visible: !info_rotate.choosing_plg
        text: qsTr("选择")
        anchors.left: tf_rotate_select.right
        anchors.leftMargin: 20
        anchors.top: tf_rotate_select.top
        anchors.topMargin: 0
        onClicked: {
            info_rotate.choosing_plg = true
            info_rotate.choosing_center = false
        }
    }
    Text {
        id: txt_rotate_selecting
        x: 215
        y: 25
        width: 61
        height: 40
        text: qsTr("在右侧点击选择")
        visible: !bt_rotate_select.visible
        anchors.horizontalCenter: bt_rotate_select.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAnywhere
        font.pixelSize: 15
    }

    TextField {
        id: tf_rotate_center
        x: 95
        y: 121
        width: 111
        height: 40
        readOnly: true
        text: qsTr("(") + rotate_info.rotate_center.x.toString() + qsTr(", ") + rotate_center.y.toString() + qsTr(")")
    }

    Text {
        id: txt_rotate_center
        x: 8
        y: 121
        width: 90
        height: 40
        text: qsTr("旋转中心")
        anchors.right: tf_rotate_center.left
        anchors.rightMargin: -3
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
    }

    Button {
        id: bt_rotate_center
        x: 215
        y: 121
        width: 77
        height: 40
        visible: !choosing_center
        text: qsTr("选择")
        anchors.leftMargin: 9
        anchors.left: tf_rotate_center.right
        anchors.top: tf_rotate_center.top
        anchors.topMargin: 0
        onClicked: {
            info_rotate.choosing_center = true
            info_rotate.choosing_plg = false
        }
    }

    Text {
        id: txt_rotate_center_selecting
        x: 223
        y: 121
        width: 61
        height: 40
        visible: !bt_rotate_center.visible
        text: qsTr("在右侧点击选择")
        anchors.horizontalCenterOffset: 0
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 15
        anchors.horizontalCenter: bt_rotate_center.horizontalCenter
        wrapMode: Text.WrapAnywhere
    }

    Text {
        id: txt_rotate_angle
        x: 8
        y: 202
        text: qsTr("旋转角度")
        font.pixelSize: 20
    }

    Text {
        id: txt_rotate_angle_indicator
        x: 162
        y: 233
        width: 65
        height: 26
        text: slider_rotate_angle.value.toString().slice(0, 5) + qsTr("度")
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: slider_rotate_angle.horizontalCenter
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 15
    }
    Button {
        id: bt_rotate_ok
        x: 101
        y: 255
        text: qsTr("确定")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            if(!(!choosing_center && !choosing_plg && plg_id >= 0))
                return;
            rotate(plg_id, rotate_center, slider_rotate_angle.value)
        }
    }


}

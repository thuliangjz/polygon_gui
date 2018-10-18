import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2
Item {
    id: info_translate
    anchors.fill: parent
    visible: false
    property int plg_id_translate: -1
    property bool choosing_plg: false
    signal translate(int plgId, point pt)

    function activate(){
        info_translate.visible = true
        info_translate.choosing_plg = false
        tf_translate_plg_id.text = ""
    }

    function deactivate(){
        info_translate.visible = false
        info_translate.choosing_plg = false
        tf_translate_plg_id.text = ""
    }

    function clickChooseHandler(plgManager){
        return function(mouse){
            info_translate.choosing_plg = false
            var plgId = plgManager.get_click_id(mouse.x, mouse.y)
            if(plgId < 0){
                tf_translate_plg_id.text = ""
                plg_id_translate = -1
                plgManager.unchoose_all()
                return
            }
            info_translate.plg_id_translate = plgId
            tf_translate_plg_id.text = plgId.toString()
            plgManager.choose(plgId)
            plgManager.update()
        }
    }

    function translateOkHandler(plgManager){
        return function(plgId, pt){
            plgManager.translate(plgId, pt)
            plgManager.unchoose_all();
            plgManager.update()
        }
    }

    TextField {
        id: tf_translate_x
        x: 128
        y: 95
        width: 73
        height: 40
        text: qsTr("")
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: txt_translate_x
        x: -27
        width: 67
        height: 40
        text: qsTr("平移x")
        anchors.top: tf_translate_x.top
        anchors.topMargin: 0
        anchors.right: tf_translate_x.left
        anchors.rightMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
    }

    TextField {
        id: tf_translate_y
        x: 128
        y: 161
        width: 73
        height: 40
        text: qsTr("")
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: txt_translate_y
        x: 61
        width: 67
        height: 40
        text: qsTr("平移y")
        anchors.right: tf_translate_y.left
        anchors.rightMargin: 0
        anchors.top: tf_translate_y.top
        anchors.topMargin: 0
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        verticalAlignment: Text.AlignVCenter
    }

    TextField {
        id: tf_translate_plg_id
        x: 128
        y: 25
        width: 73
        height: 40
        text: qsTr("")
        anchors.horizontalCenter: parent.horizontalCenter
        readOnly: true
    }

    Text {
        id: txt_translate_plg_id
        x: -73
        width: 112
        height: 40
        text: qsTr("多边形编号")
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        verticalAlignment: Text.AlignVCenter
        anchors.top: tf_translate_plg_id.top
        anchors.rightMargin: 0
        anchors.right: tf_translate_plg_id.left
        anchors.topMargin: 0
    }

    Button {
        id: bt_translate_select_plg
        width: 77
        height: 40
        text: qsTr("选择")
        visible: !info_translate.choosing_plg
        anchors.left: tf_translate_plg_id.right
        anchors.leftMargin: 20
        anchors.top: tf_translate_plg_id.top
        anchors.topMargin: 0
        onClicked: {
            info_translate.choosing_plg = true
        }
    }
    Text {
        id: txt_choose
        x: 215
        y: 25
        width: 61
        height: 40
        text: qsTr("在右侧点击选择")
        visible: !bt_translate_select_plg.visible
        anchors.horizontalCenter: bt_translate_select_plg.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAnywhere
        font.pixelSize: 15
    }

    MessageDialog {
        id: dlg_error
        title: "平移遇到错误"
    }

    Button {
        id: btn_translate_ok
        x: 101
        y: 232
        text: qsTr("确定")
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            var translateX = parseInt(tf_translate_x.text)
            var translateY = parseInt(tf_translate_y.text)
            if(isNaN(translateX) || isNaN(translateY))
                return;
            var maxTranslate = 2000
            if(info_translate.plg_id_translate < 0)
                return
            if(Math.abs(translateX) > maxTranslate || Math.abs(translateY) > maxTranslate){
                dlg_error.visible = true
                dlg_error.text = "单次平移分量不能超过" + maxTranslate.toString()
                return
            }
            info_translate.translate(plg_id_translate, Qt.point(translateX, translateY))
        }
    }
}

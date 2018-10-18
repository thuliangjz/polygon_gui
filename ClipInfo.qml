import QtQuick 2.0
import QtQuick.Controls 2.4
Item {
    id: info_clip
    anchors.fill: parent
    visible: false
    property string plg_choosing_type: "no"
    property int id_plg_main: -1
    property int id_plg_clip: -1
    signal clip()
    function activate(){
        info_clip.visible = true
    }

    function deactivate(){
        info_clip.visible = false
    }

    function clickPlgHandler(plgManager){
        return function(mouse){
            if(plg_choosing_type == "no")
                return
            var plgId = plgManager.get_click_id(mouse.x, mouse.y)
            if(plgId < 0){
                id_plg_clip = -1
                id_plg_main = -1
                plgManager.unchoose_all()
                plgManager.update()
                return
            }
            switch(plg_choosing_type){
            case "main":
                id_plg_main = plgId
                break
            case "clip":
                id_plg_clip = plgId
                break
            default:
                break
            }
            plg_choosing_type = "no"
            plgManager.choose(plgId)
            plgManager.update()
        }
    }

    function clicpOkHandler(plgManager){
        return function(){
            plgManager.clip(id_plg_main, id_plg_clip)
            plgManager.update()
        }
    }

    TextField {
        id: tf_clip_select_main
        x: 128
        y: 25
        width: 73
        height: 40
        readOnly: true
        text: id_plg_main >= 0 ? id_plg_main.toString() : ""
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
        id: txt_clip_select_main
        x: 0
        y: 25
        width: 112
        height: 40
        text: qsTr("主多边形")
        anchors.verticalCenter: tf_clip_select_main.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        verticalAlignment: Text.AlignVCenter
        anchors.top: tf_clip_select_main.top
        anchors.rightMargin: 2
        anchors.right: tf_clip_select_main.left
        anchors.topMargin: 0
    }
    Button {
        id: bt_clip_select_main
        width: 77
        height: 40
        text: qsTr("选择")
        visible: plg_choosing_type != "main"
        anchors.verticalCenter: tf_clip_select_main.verticalCenter
        anchors.left: tf_clip_select_main.right
        anchors.leftMargin: 20
        anchors.top: tf_clip_select_main.top
        anchors.topMargin: 0
        onClicked: {
            plg_choosing_type = "main"
        }
    }
    Text {
        id: txt_clip_selecting_main
        x: 215
        y: 25
        width: 61
        height: 40
        text: qsTr("在右侧点击选择")
        visible: !bt_clip_select_main.visible
        anchors.horizontalCenter: bt_clip_select_main.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAnywhere
        font.pixelSize: 15
    }
    TextField {
        id: tf_clip_select_clip
        readOnly: true
        x: 128
        y: 100
        width: 73
        height: 40
        text: id_plg_clip < 0 ? "" : id_plg_clip.toString()
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Text {
        id: txt_clip_select_clip
        x: 0
        y: 88
        width: 112
        height: 40
        text: qsTr("裁剪多边形")
        anchors.verticalCenter: tf_clip_select_clip.verticalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20
        verticalAlignment: Text.AlignVCenter
        anchors.top: tf_clip_select_clip.top
        anchors.rightMargin: 2
        anchors.right: tf_clip_select_clip.left
        anchors.topMargin: 0
    }
    Button {
        id: bt_clip_select_clip
        y: 88
        width: 77
        height: 40
        text: qsTr("选择")
        visible: plg_choosing_type !== "clip"
        anchors.verticalCenter: tf_clip_select_clip.verticalCenter
        anchors.left: tf_clip_select_clip.right
        anchors.leftMargin: 20
        anchors.top: tf_clip_select_clip.top
        anchors.topMargin: 0
        onClicked: {
            plg_choosing_type = "clip"
        }
    }

    Text {
        id: txt_clip_selecting_clip
        x: 215
        y: 100
        width: 61
        height: 40
        text: qsTr("在右侧点击选择")
        anchors.verticalCenter: bt_clip_select_clip.verticalCenter
        anchors.horizontalCenterOffset: 0
        visible: !bt_clip_select_clip.visible
        anchors.horizontalCenter: bt_clip_select_clip.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WrapAnywhere
        font.pixelSize: 15
    }

    Button {
        id: button
        x: 101
        y: 218
        text: qsTr("确定")
        font.pixelSize: 20
        onClicked: {
            if(!(id_plg_clip >= 0 && id_plg_main >= 0 && id_plg_clip !== id_plg_main))
                return
            info_clip.clip()
        }
    }

}

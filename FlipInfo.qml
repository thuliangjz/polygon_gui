import QtQuick 2.0

Item {
    id: info_flip
    anchors.fill: parent
    visible: false
    property int id_plg: -1
    function activate(){
        info_flip.visible = true
    }
    function deactivate(){
        info_flip.visible = false
    }
    function clickPlgHandler(plgManager){
        return function(mouse){
            var plgId = plgManager.get_click_id(mouse.x, mouse.y)
            plgManager.unchoose_all()
            id_plg = plgId
            plgManager.choose(plgId)
            plgManager.update()
        }
    }
    function keyPressHandler(plgManager){
        return function(event){
            switch(event.key){
            case Qt.Key_X:
                plgManager.flip(id_plg, "x");
                break
            case Qt.Key_Y:
                plgManager.flip(id_plg, "y")
                break
            default:
                break;
            }
            plgManager.update()
        }
    }
    focus: visible
    Text {
        id: txt_flip
        text: qsTr("选中多边形后按x和y键即可沿相应坐标轴翻转多边形")
        verticalAlignment: Text.AlignTop
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        wrapMode: Text.WrapAnywhere
        font.pixelSize: 20
    }

}

import QtQuick 2.0
import QtQuick.Controls 2.4
Item {
            id: info_navagate
            anchors.fill: parent
            visible: false
            function activate(){
                info_navagate.visible = true
                focus = true
            }
            function deactivate(){
                info_navagate.visible = false
                focus = false
            }
            function keyPressedHandler(plgManager){
                return function(event){
                    switch(event.key){
                    case Qt.Key_Left:
                        plgManager.view_move(Qt.point(-1, 0))
                        break
                    case Qt.Key_Right:
                        plgManager.view_move(Qt.point(1, 0))
                        break
                    case Qt.Key_Up:
                        plgManager.view_move(Qt.point(0, 1))
                        break
                    case Qt.Key_Down:
                        plgManager.view_move(Qt.point(0, -1))
                        break
                    }
                    var ptTranslateCurrent = plgManager.viewTranslate
                    var t = "(" + ptTranslateCurrent.x.toString() + ", " + ptTranslateCurrent.y.toString() + ")"
                    text_navagate.text_translate = t
                    plgManager.update()
                }
            }
            function wheelHandler(plgManager){
                return function(wheel){
                    plgManager.view_zoom(wheel.angleDelta.y > 0)
                    text_navagate.text_scale = plgManager.viewScale.toString()
                    plgManager.update()
                }
            }

            TextArea {
                property string text_translate: qsTr("(0, 0)")
                property string text_scale: qsTr("1")
                id: text_navagate
                height: 100
                text: qsTr("按方向键移动视口中心\n滑动滚轮进行缩放\n当前坐标:") + text_translate + qsTr(" \n当前放大比例:") + text_scale
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                readOnly: true
            }
}

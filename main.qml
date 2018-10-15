import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2
import Polygon 1.0
ApplicationWindow{
    id: applicationWindow
    visible: true
    minimumWidth: 640
    minimumHeight: 480
    width: 640
    height: 480
    color: "#f1f1f1"
    title: qsTr("Polygon")

    Item {
        id: operation_panel
        height: 223
        visible: true
        anchors.right: rect_info.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0

        Grid {
            id: grid_op_panel
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            spacing: 27
            columns: 3

            ToolButton {
                id: bt_new
                width: 72
                text: qsTr("新建")
                icon.source: "qrc:/resources/op_new.png" //"resources/op_new.png"
            }

            ToolButton {
                id: bt_color
                text: qsTr("设置颜色")
                icon.source:"resources/op_color.png"
            }

            ToolButton {
                id: bt_clip
                text: qsTr("裁剪")
                icon.source: "resources/op_clip.png"
            }

        }

    }
    Rectangle {
        id: rect_info
        x: 2
        y: 132
        width: 302
        height: 311
        color: "#d3d3d3"
        visible: true
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        z: 1
        NewInfo {
            id: new_info
            z:1
        }
    }

    Rectangle {
        id: rect_canvas
        color: "#ffffff"
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: operation_panel.right
        anchors.leftMargin: 0
        PolygonManager{
            id: polygon_manager
            anchors.fill: parent
        }
        NewClickTrace {
            id: click_new_trace
        }
    }

    Component.onCompleted: {
        bt_new.clicked.connect(new_info.activate)
        bt_color.clicked.connect(new_info.deactivate)

        new_info.polygonInputOk.connect(new_info.polygonInputResponse(polygon_manager))
        new_info.clickNewClose.connect(click_new_trace.closeCurrentLoop)
        new_info.clickNewCancel.connect(click_new_trace.traceClear)


    }
}

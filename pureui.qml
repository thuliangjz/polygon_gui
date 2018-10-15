import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
ApplicationWindow {
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
                icon.source: "resources/op_new.png"
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
        z: 0
        Item {
            id: info_new
            visible: true
            anchors.fill: parent
            z:1

            TabButton {
                id: tab_new_input
                width: 150
                height: 40
                text: qsTr("输入新多边形")
                z: 2
                checked: !tab_new_click.checked
                font.capitalization: Font.MixedCase
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
            }

            TabButton {
                id: tab_new_click
                width: tab_new_input.width
                height: 40
                text: qsTr("点击新多边形")
                z: 1
                checked: true
                anchors.left: tab_new_input.right
                anchors.topMargin: 0
                anchors.leftMargin: 0
                anchors.top: parent.top
            }

            Item {
                id: group_input
                visible: false
                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: tab_new_input.bottom
                anchors.topMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0


                ScrollView {
                    id: scroll_input
                    x: 71
                    width: 268
                    height: 156
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 60

                    TextArea {
                        id: edit_input
                        text: qsTr("Text Edit")
                        placeholderText: ""
                        anchors.fill: parent
                        font.pixelSize: 20
                    }
                }
                Rectangle {
                    id: rect_input_bg
                    x: scroll_input.x
                    y: scroll_input.y
                    width: scroll_input.width
                    height: scroll_input.height
                    color: "#ffffff"
                    z: -1
                }

                Text {
                    id: text_input_info
                    x: 85
                    width: parent.width - 20
                    text: qsTr("输入格式：每一行包括两个用空格隔开的数字，表示多边形的一个顶点，相邻的行表示的顶点构成一个环，第一个环是外环，以后是内环")
                    wrapMode: Text.WrapAnywhere
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                }

                Button {
                    id: bt_input_ok
                    text: qsTr("确认")
                    anchors.right: parent.right
                    anchors.rightMargin: 17
                    anchors.bottomMargin: 8
                    anchors.bottom: parent.bottom
                }
                Button {
                    id: bt_input_example
                    text: qsTr("填入样例")
                    anchors.left: parent.left
                    anchors.leftMargin: 17
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                }


            }

            Item {
                id: group_click
                x: 0
                y: 0
                visible: true
                anchors.top: tab_new_input.bottom
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.topMargin: 0

                ScrollView{
                    z: 1
                    anchors.topMargin: 50
                    anchors.bottomMargin: 50
                    anchors.fill: parent
                    TextArea {
                        id: edit_click
                        text: qsTr("Text Edit")
                        anchors.fill: parent
                        font.pixelSize: 12
                        readOnly: true
                    }
                }

                Text {
                    id: txt_click
                    text: qsTr("Text")
                    horizontalAlignment: Text.AlignHCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 1
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    font.pixelSize: 20
                }

                Button {
                    id: bt_click_ok
                    x: 101
                    y: 221
                    width: 80
                    text: qsTr("Button")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: bt_click_close
                    x: 222
                    y: 221
                    width: 80
                    text: qsTr("Button")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                }

                Button {
                    id: bt_click_cancel
                    y: 218
                    width: 80
                    text: qsTr("Button")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                }

                Rectangle {
                    id: rect_edit_clk_bg
                    color: "#ffffff"
                    anchors.bottomMargin: 50
                    anchors.topMargin: 50
                    anchors.fill: parent
                }
            }
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

        MouseArea {
            id: mousearea_canvas
            anchors.fill: parent
        }
    }

}

/*##^## Designer {
    D{i:26;anchors_height:100;anchors_width:100}
}
 ##^##*/

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
            transformOrigin: Item.Center
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            spacing: 20
            columns: 3

            ToolButton {
                id: bt_new
                width: 72
                text: qsTr("新建")
                icon.source: "resources/op_new.png"
            }

            ToolButton {
                id: bt_color
                text: qsTr("颜色")
                icon.source:"resources/op_color.png"
            }

            ToolButton {
                id: bt_clip
                text: qsTr("裁剪")
                icon.source: "resources/op_clip.png"
            }
            ToolButton {
                id: bt_navagate
                text: qsTr("视口")
                icon.source: "resources/op_navagate.png"
            }

            ToolButton {
                id: bt_translate
                text: qsTr("平移")
                icon.source: "resources/op_translate.png"
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
            visible: false
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

        Item {
            id: info_navagate
            visible: false
            anchors.fill: parent

            TextArea {
                id: text_navagate
                height: 100
                text: qsTr("按方向键移动视口中心\n滑动滚轮进行缩放\n当前坐标:(128, 128)\n当前放大比例:5")
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

        Item {
            id: info_translate
            anchors.fill: parent

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
                id: btn_translate_ok
                x: 101
                y: 232
                text: qsTr("确定")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                id: bt_translate_select_plg
                width: 77
                height: 40
                text: qsTr("选择")
                anchors.left: tf_translate_plg_id.right
                anchors.leftMargin: 20
                anchors.top: tf_translate_plg_id.top
                anchors.topMargin: 0
            }

            Text {
                id: txt_choose
                x: 215
                y: 25
                width: 61
                height: 40
                text: qsTr("在右侧点击选择")
                anchors.horizontalCenter: bt_translate_select_plg.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAnywhere
                font.pixelSize: 15
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
    D{i:38;anchors_x:206;anchors_y:25}
}
 ##^##*/

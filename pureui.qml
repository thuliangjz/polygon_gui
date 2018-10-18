import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.0
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

            ToolButton {
                id: bt_rotate
                text: qsTr("旋转")
                icon.source: "resources/op_rotate.png"
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
            visible: false
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
                id: txt_translate_choose
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


        Item {
            id: info_rotate
            anchors.fill: parent
            visible: false
            Slider {
                id: slider_rotate_angle
                x: 95
                y: 198
                width: 199
                height: 40
                to: 360
                value: 6
            }
            TextField {
                id: tf_rotate_select
                x: 128
                y: 25
                width: 73
                height: 40
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
                text: qsTr("选择")
                anchors.left: tf_rotate_select.right
                anchors.leftMargin: 20
                anchors.top: tf_rotate_select.top
                anchors.topMargin: 0
            }
            Text {
                id: txt_rotate_selecting
                x: 215
                y: 25
                width: 61
                height: 40
                text: qsTr("在右侧点击选择")
                visible: false
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
                text: qsTr("选择")
                anchors.leftMargin: 9
                anchors.left: tf_rotate_center.right
                anchors.top: tf_rotate_center.top
                anchors.topMargin: 0
            }

            Text {
                id: txt_rotate_center_selecting
                x: 223
                y: 121
                width: 61
                height: 40
                text: qsTr("在右侧点击选择")
                anchors.horizontalCenterOffset: 0
                visible: false
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
            }


        }


        Item {
            id: info_color
            anchors.fill: parent
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
                text: qsTr("选择")
                anchors.left: tf_color_select.right
                anchors.leftMargin: 20
                anchors.top: tf_color_select.top
                anchors.topMargin: 0
            }
            Text {
                id: txt_color_selecting
                x: 215
                y: 25
                width: 61
                height: 40
                text: qsTr("在右侧点击选择")
                visible: false
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
            }

            Button {
                id: btn_color_ok
                x: 101
                y: 229
                text: qsTr("确定")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 40
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
    D{i:38;anchors_x:206;anchors_y:25}D{i:62;anchors_y:90}D{i:63;anchors_x:207}D{i:65;anchors_y:163}
D{i:66;anchors_x:207}
}
 ##^##*/

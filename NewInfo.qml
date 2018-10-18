import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2
Item {
            id: info_new
            visible: false
            anchors.fill: parent
            property alias click_enabled: group_click.visible
            property int countClick: 0
            function activate(){
                //完成初始化
                info_new.visible = true
                tab_new_input.checked = true
                edit_input.text = edit_input.input_prompt
            }

            function deactivate(){
                info_new.visible = false
            }

            function polygonInputResponse(manager){
                return function(result){
                    var r = manager.new_polygon_by_string(result)
                    if(r === "ok"){
                        manager.update()
                        return
                    }
                    dlg_input_prompt.visible = true
                    dlg_input_prompt.text = r
                }
            }

            function txtMouseMoveResponse(manager){
                return function(mouse){
                    var pt_transformed = manager.transform(mouse)
                    txt_click.text += qsTr("当前坐标：(") + Number(pt_transformed.x).toLocaleString(Qt.locale("de_DE"))
                        + ", " +Number(pt_transformed.y).toLocaleString(Qt.locale("de_DE")) + ")";
                }
            }

            function clickTxtLoopCloseSlot(){
                txt_click.text = qsTr("点击输入内环, 当前内环为第") + Number(txt_click.innerLoopCount).toString() + qsTr("个内环")
                ++txt_click.innerLoopCount
            }

            signal polygonInputOk(string result)    //每一行由两个空格隔开的数构成，表示点，相邻的行表示一个环，第一个环是外环，剩下的是内环
            signal clickNewOk()
            signal clickNewCancel()
            signal clickNewClose()

            MessageDialog {
                id: dlg_input_prompt
                title: "新建多边形时遇到了错误"
                onAccepted: {info_new.activate()}
            }

            TabButton {
                id: tab_new_input
                width: 150
                height: 40
                text: qsTr("输入新多边形")
                z: 2
                visible: false
                checked: !tab_new_click.checked
                font.capitalization: Font.MixedCase
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
            }

            TabButton {
                id: tab_new_click
                visible: false
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
                visible: tab_new_input.checked
                anchors.fill:parent
                Text {
                    id: text_input_info
                    x: 85
                    width: parent.width - 20
                    text: qsTr("输入格式：每一行包括两个用空格隔开的数字，表示多边形的一个顶点，相邻的行表示的顶点构成一个环，第一个环是外环，以后是内环")
                    wrapMode: Text.WrapAnywhere
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 15
                }

                ScrollView {
                    id: scroll_input
                    x: 71
                    width: 268
                    height: 150
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 100

                    TextArea {
                        id: edit_input
                        anchors.fill: parent
                        font.pixelSize: 20
                        property string input_prompt: qsTr("请在此输入顶点")
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


                Button {
                    id: bt_input_ok
                    text: qsTr("确认")
                    anchors.right: parent.right
                    anchors.rightMargin: 17
                    anchors.bottomMargin: 8
                    anchors.bottom: parent.bottom
                    onClicked: {info_new.polygonInputOk(edit_input.text)}
                }

                Button {
                    id: bt_input_example
                    text: qsTr("填入样例")
                    anchors.left: parent.left
                    anchors.leftMargin: 17
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 8
                    onClicked: {
                        edit_input.text= "-10   -10\n10   -10\n10   10\n-10   10"
                    }
                }


            }

            Item {
                id: group_click
                x: 0
                y: 0
                visible: tab_new_click.checked
                anchors.top: tab_new_input.bottom
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.topMargin: 0

                ScrollView{
                    id: scroll_click
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
                Rectangle {
                    id: rect_edit_clk_bg
                    color: "#ffffff"
                    x: scroll_click.x
                    y: scroll_click.y
                    width: scroll_click.width
                    height: scroll_click.height
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
                    property string state: ""
                    property variant state_lst: ["outer_loop", "inner_loop"]
                    property int innerLoopCount:0
                }

                Button {
                    id: bt_click_ok
                    x: 101
                    y: 221
                    width: 80
                    text: qsTr("完成")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin:10
                    anchors.left: parent.left
                    anchors.leftMargin:0
                    onClicked: {info_new.clickNewOk()}
                }

                Button {
                    id: bt_click_close
                    x: 222
                    y: 221
                    width: 100
                    text: qsTr("闭合当前环")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {info_new.clickNewClose()}
                }

                Button {
                    id: bt_click_cancel
                    y: 218
                    width: 80
                    text: qsTr("取消")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    onClicked: {info_new.clickNewCancel()}
                }

            }

            Component.onCompleted: {
                bt_click_cancel.clicked.connect(function(){
                    txt_click.text = qsTr("点击输入外环")
                    txt_click.innerLoopCount = -1
                })
            }

}

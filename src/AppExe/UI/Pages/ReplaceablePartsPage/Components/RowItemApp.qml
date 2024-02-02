/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.7
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1

Item {
    id: control
    visible: enabled
    //    width: view.width
    //    height: 50

    property real viewContentY: 0
    property real viewSpan: 0

    property bool inView: y >= (viewContentY - height) && y + height <= (viewSpan + height)

    //    property string label
    //    property string value
    property int indexOnList: 0

    property alias loaderActive: paramaterLoader.active

    property bool filterFragmant: false

    property int rowNo: 1
    property bool viewOnly: false

    property var modelColumn: [
        "Part name",
        "Item Code",
        "QTY",
        "Serial Number",
        "Size",
        "Airflow",
        "PD",
        false]
    property var modelColumnTitle: [
        qsTr("Part Name"),
        qsTr("Item Code"),
        qsTr("Quantity"),
        qsTr("Serial Number"),
        qsTr("Size"),
        qsTr("Airflow"),
        qsTr("PD"),
        qsTr("Check")]

    signal loaded()
    signal unloaded()

    signal itemShiftUpClicked()
    signal itemShiftDownClicked()
    signal itemClearAllClicked()
    signal partNameAccepted(string value)
    signal itemCodeAccepted(string value)
    signal itemCodePressedAndHold()
    signal quantityAccepted(int value)
    signal serialNumber1Accepted(string value)
    signal serialNumber2Accepted(string value)
    signal softwareConstAccepted(string value)
    signal filterAirflowAccepted(string value)
    signal checkedChanged(bool value)
    signal incompleteData()
    signal invalidInput()

    function refreshAll(){
        /// In order to make all parameter are updated
        paramaterLoader.active = false
        paramaterLoader.active = true
    }

    onItemClearAllClicked: {
        refreshAll()
    }//

    //    Timer{
    //        id: timerLoaded
    //        interval: 1000
    //        repeat: false
    //        onTriggered: {
    //            control.refreshAll()
    //        }
    //    }

    Loader {
        id: paramaterLoader
        anchors.fill: parent
        asynchronous: true
        active: control.inView
        sourceComponent: Item {
            Rectangle {
                anchors.fill: parent
                color: "#440F2952"
                radius: 5
            }

            RowLayout {
                anchors.fill: parent
                spacing: 2
                Item {
                    Layout.fillHeight: true
                    Layout.minimumWidth: 50
                    Image{
                        enabled: !control.viewOnly
                        opacity: ma01.pressed ? 0.5 : 1
                        width: parent.width
                        height: 50
                        anchors.centerIn: parent
                        source: "qrc:/UI/Pictures/rp_no.png"
                        TextApp{
                            id: text_id
                            height: parent.height
                            width: parent.width
                            text: control.rowNo
                            fontSizeMode: Text.Fit
                            minimumPixelSize: 20
                            //elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        MouseArea{
                            id: ma01
                            anchors.fill: parent
                            //preventStealing: true
                            onPressAndHold: {
                                itemOptionLoader.active = true
                            }//
                        }//
                    }//
                }//
                Item {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    TextFieldApp {
                        id: txf1
                        anchors.centerIn: parent
                        enabled: !control.viewOnly
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        text: control.modelColumn[0]
                        padding: 5
                        opacity: txf1MArea.pressed ? 0.5 : 1

                        onAccepted: {
                            control.partNameAccepted(text)
                            control.refreshAll()
                        }//
                        MouseArea{
                            id: txf1MArea
                            enabled: !itemOptionLoader.active
                            anchors.fill: parent
                            onClicked: {
                                KeyboardOnScreenCaller.openKeyboard(txf1,  "%1 - %2".arg(control.modelColumn[0]).arg(control.modelColumnTitle[0]))
                            }//
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.minimumWidth: control.modelColumnTitle.length == 8 ? 100 : 150
                    Image {
                        enabled: !control.viewOnly
                        height: 50
                        width: parent.width
                        source: "qrc:/UI/Pictures/rp_itemcode.png"
                        opacity: txf2MArea.pressed ? 0.5 : 1
                        anchors.centerIn: parent

                        TextApp{
                            height: parent.height
                            width: parent.width
                            padding: 5
                            text: txf2.text
                            fontSizeMode: Text.Fit
                            minimumPixelSize: 20
                            //elide: Text.ElideRight
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        MouseArea{
                            id: txf2MArea
                            enabled: !itemOptionLoader.active
                            anchors.fill: parent
                            onClicked: {
                                KeyboardOnScreenCaller.openKeyboard(txf2,  "%1 - %2".arg(control.modelColumn[0]).arg(control.modelColumnTitle[1]))
                            }//
                            onPressAndHold: {
                                control.itemCodePressedAndHold()
                            }
                        }//
                    }
                    TextFieldApp {
                        id: txf2
                        visible: false
                        anchors.centerIn: parent
                        enabled: !control.viewOnly
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: control.modelColumn[1]
                        padding: 5
                        colorBorder: "#27ae60"
                        opacity: txf2MArea.pressed ? 0.5 : 1

                        onAccepted: {
                            control.itemCodeAccepted(text)
                            control.refreshAll()
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.minimumWidth: 50
                    TextFieldApp {
                        id: txf3
                        anchors.centerIn: parent
                        enabled: !control.viewOnly
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: Number(control.modelColumn[2]) > 0 ? control.modelColumn[2] : ""
                        padding: 5
                        opacity: txf3MArea.pressed ? 0.5 : 1

                        onAccepted: {
                            const num = Number(text)
                            if(!isNaN(num) && num >= 0)
                                control.quantityAccepted(text)
                            else
                                control.invalidInput()
                            control.refreshAll()
                        }//
                        MouseArea{
                            id: txf3MArea
                            enabled: !itemOptionLoader.active
                            anchors.fill: parent
                            onClicked: {
                                KeyboardOnScreenCaller.openNumpad(txf3,  "%1 - %2".arg(control.modelColumn[0]).arg(control.modelColumnTitle[2]))
                            }//
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.minimumWidth: sn2Item.visible ? 125 : 200
                    visible: control.modelColumnTitle.length > 4
                    TextFieldApp {
                        id: txf4
                        anchors.centerIn: parent
                        enabled: !control.viewOnly
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        text: control.modelColumn[3]
                        padding: 5
                        opacity: txf4MArea.pressed ? 0.5 : 1

                        onAccepted: {
                            control.serialNumber1Accepted(text)
                            control.refreshAll()
                        }//
                        MouseArea{
                            id: txf4MArea
                            enabled: !itemOptionLoader.active
                            anchors.fill: parent
                            onClicked: {
                                KeyboardOnScreenCaller.openKeyboard(txf4,  "%1 - %2".arg(control.modelColumn[0]).arg(control.modelColumnTitle[3]))
                            }//
                        }//
                    }//
                }//

                Item {
                    id: sn2Item
                    Layout.fillHeight: true
                    Layout.minimumWidth: 125
                    visible: control.modelColumnTitle.length >= 7
                    TextFieldApp {
                        id: txf41
                        anchors.centerIn: parent
                        enabled: !control.viewOnly
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        text: control.modelColumn[4]
                        padding: 5
                        opacity: txf41MArea.pressed ? 0.5 : 1

                        onAccepted: {
                            control.serialNumber2Accepted(text)
                            control.refreshAll()
                        }//
                        MouseArea{
                            id: txf41MArea
                            enabled: !itemOptionLoader.active
                            anchors.fill: parent
                            onClicked: {
                                KeyboardOnScreenCaller.openKeyboard(txf41,  "%1 - %2".arg(control.modelColumn[0]).arg(control.modelColumnTitle[4]))
                            }//
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.minimumWidth: sn2Item.visible ? 100 : 150
                    visible: control.modelColumnTitle.length > 5
                    TextFieldApp {
                        id: txf5
                        anchors.centerIn: parent
                        enabled: !control.viewOnly
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        text: sn2Item.visible ? control.modelColumn[5] : control.modelColumn[4]
                        padding: 5
                        opacity: txf5MArea.pressed ? 0.5 : 1
                        onAccepted: {
                            control.softwareConstAccepted(text)
                            control.refreshAll()
                        }//
                        MouseArea{
                            id: txf5MArea
                            enabled: !itemOptionLoader.active
                            anchors.fill: parent
                            onClicked: {
                                const title = sn2Item.visible ? control.modelColumnTitle[5] : control.modelColumnTitle[4]
                                KeyboardOnScreenCaller.openKeyboard(txf5, "%1 - %2".arg(control.modelColumn[0]).arg(title))
                            }//
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.minimumWidth: 100
                    enabled: control.modelColumnTitle.length == 8
                    visible: enabled
                    TextFieldApp {
                        id: txf6
                        anchors.centerIn: parent
                        enabled: !control.viewOnly
                        height: 50
                        width: parent.width
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        text: enabled ? control.modelColumn[6]
                                      : control.modelColumn[2]
                        padding: 5
                        opacity: txf6MArea.pressed ? 0.5 : 1
                        onAccepted: {
                            control.filterAirflowAccepted(text)
                            control.refreshAll()
                        }//
                        MouseArea{
                            id: txf6MArea
                            enabled: !itemOptionLoader.active
                            anchors.fill: parent
                            onClicked: {
                                const title = control.modelColumnTitle[6]
                                KeyboardOnScreenCaller.openKeyboard(txf6, "%1 - %2".arg(control.modelColumn[0]).arg(title))
                            }//
                        }//
                    }//
                }//

                Item {
                    Layout.fillHeight: true
                    Layout.minimumWidth: 50
                    CheckBox {
                        anchors.centerIn: parent
                        width: 40
                        height: 40
                        font.pixelSize: 20
                        checked: control.modelColumn[control.modelColumn.length-1]

                        property bool valid: ((!itemOptionLoader.active
                                               && String(control.modelColumn[0]) != String("")
                                               && String(control.modelColumn[1]) != String("")
                                               && Number(control.modelColumn[2]) > 0
                                               && (control.filterFragmant ? String(control.modelColumn[4]) != String("") : true))
                                              || checked)  && !control.viewOnly
                        onClicked:{
                            //console.debug("onClicked", checked)
                            if(!valid) {
                                if(checked) checked = false
                            }
                            control.checkedChanged(checked)
                            control.refreshAll()
                        }//
                        onPressed: {
                            if(!valid){
                                if(checked) checked = false
                                control.checkedChanged(checked)
                                control.refreshAll()
                                incompleteData()
                            }
                        }
                    }//
                }//
            }//

            Loader{
                id: itemOptionLoader
                anchors.fill: parent
                active: false
                sourceComponent: Item {
                    Rectangle {
                        anchors.fill: parent
                        color: "#bb000000"
                    }//
                    Rectangle{
                        width: 30
                        height: 15
                        color: "transparent"
                        MouseArea{
                            anchors.fill: parent
                            //preventStealing: true
                            onClicked: {
                                itemOptionLoader.active = false
                            }
                        }
                    }
                    Row{
                        anchors.centerIn: parent
                        spacing: 50
                        TextApp{
                            text: qsTr("Shift Up")
                            opacity: ma1.pressed ? 0.5 : 1
                            font.bold: true
                            MouseArea{
                                id: ma1
                                anchors.fill: parent
                                //preventStealing: true
                                onClicked: {
                                    control.itemShiftUpClicked()
                                    itemOptionLoader.active = false
                                }
                            }
                        }
                        TextApp{
                            text: qsTr("Shift Down")
                            opacity: ma2.pressed ? 0.5 : 1
                            font.bold: true
                            MouseArea{
                                id: ma2
                                anchors.fill: parent
                                //preventStealing: true
                                onClicked: {
                                    control.itemShiftDownClicked()
                                    itemOptionLoader.active = false
                                }
                            }
                        }
                        TextApp{
                            text: qsTr("Clear All")
                            opacity: ma3.pressed ? 0.5 : 1
                            font.bold: true
                            MouseArea{
                                id: ma3
                                anchors.fill: parent
                                //preventStealing: true
                                onClicked: {
                                    control.itemClearAllClicked()
                                    itemOptionLoader.active = false
                                }
                            }//
                        }//
                        TextApp{
                            text: qsTr("Cancel")
                            opacity: ma4.pressed ? 0.5 : 1
                            font.bold: true
                            MouseArea{
                                id: ma4
                                anchors.fill: parent
                                //preventStealing: true
                                onClicked: {
                                    itemOptionLoader.active = false
                                }
                            }
                        }//
                    }//
                }//
            }//

            Component.onDestruction: {
                control.unloaded()
            }//
        }//

        onLoaded: {
            control.loaded()
        }
    }//
    Component.onCompleted: {
        //        control.initialization = false
    }
}//

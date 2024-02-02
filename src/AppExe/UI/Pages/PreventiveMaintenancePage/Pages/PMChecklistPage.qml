/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "PM Checklist Page"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp {
        id: contentView
        height: viewApp.height
        width: viewApp.width

        /// just for development
        /// comment following line after release
        visible: true

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 5
            spacing: 5

            /// HEADER
            Item {
                id: headerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 60

                HeaderApp {
                    anchors.fill: parent
                    title: props.title
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                ColumnLayout{
                    anchors.fill: parent
                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.topMargin: 10
                        Layout.leftMargin: 20
                        ListView {
                            id: checkListview
                            anchors.fill: parent
                            flickableDirection: Flickable.VerticalFlick
                            clip: true
                            //model: props.checklist
                            delegate: Rectangle{
                                width: bodyItem.width
                                height: 40
                                color: "transparent"
                                RowLayout {
                                    anchors.fill: parent
                                    Item{
                                        Layout.fillHeight: true
                                        Layout.minimumWidth: 40
                                        CheckBox {
                                            id: policyCheckBox
                                            anchors.centerIn: parent
                                            enabled: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                                            /*!props.userIsAdmin
                                                     && (props.userIsSupv ? props.allowSupvToAcknowledge : true)*/
                                            font.pixelSize: 20
                                            onCheckedChanged: {
                                                props.calculateCheckState(index, checked)
                                            }
                                        }//
                                    }//

                                    Item{
                                        Layout.fillHeight: true
                                        Layout.fillWidth: true
                                        TextApp {
                                            width: parent.width
                                            height: parent.height
                                            text: modelData
                                            verticalAlignment: Text.AlignVCenter
                                        }//
                                    }//
                                }//
                            }
                        }//
                    }
                    Item{
                        id: body2
                        Layout.fillWidth: true
                        Layout.minimumHeight: bodyItem.height/3 //4
                        Layout.leftMargin: 20
                        Layout.rightMargin: 20
                        Rectangle{
                            anchors.fill: parent
                            color: "#55000000"
                            radius: 5
                        }
                        Column{
                            spacing: 5
                            Row{
                                spacing: 5
                                CheckBox {
                                    id: ackCbox
                                    enabled: (props.allChecked == props.checkState
                                              && (UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin))
                                    /*!props.userIsAdmin
                                             && (props.userIsSupv ? props.allowSupvToAcknowledge : true))*/
                                    opacity: enabled ? 1 : 0.5
                                    //anchors.centerIn: parent
                                    font.pixelSize: 20
                                    onCheckedChanged: {
                                        //props.calculateCheckState(index, checked)
                                        if(checked == props.acknowledge) return
                                        if(checked){
                                            showDialogAsk(props.title,
                                                          qsTr("By making this acknowledgment, you agree that you have completed the preventive maintenance according to the checklist provided."),
                                                          dialogAlert,
                                                          function onAccepted(){
                                                              MachineAPI.insertEventLog(qsTr("User: Acknowledge %1 checklist.").arg(props.title))
                                                              props.acknowledge = checked
                                                              MachineAPI.setAlarmPreventMaintStateAck(props.pmCode, checked, false)
                                                              showBusyPage(qsTr("Acknowledge..."), function onCallback(cycle){
                                                                  var intent = IntentApp.create(uri, {"message":""})
                                                                  finishView(intent)
                                                              })
                                                          },
                                                          function onRejected(){
                                                              checked = !checked
                                                          },
                                                          function onClosed(){},
                                                          false);
                                        }
                                    }
                                }//
                                TextApp{
                                    height: ackCbox.height
                                    opacity: props.allChecked == props.checkState ? 1: 0.5
                                    text: qsTr("Acknowledge")
                                    font.bold: true
                                    font.underline: true
                                    verticalAlignment: Text.AlignVCenter
                                }
                            }//
                            TextApp{
                                leftPadding: 10
                                rightPadding: 10
                                width: body2.width
                                //color: "#cccccc"
                                text: qsTr("Last preventive maintenance acknowledgment") + ": <b>%1</b>".arg(props.ackDate)
                            }
                            TextApp{
                                leftPadding: 10
                                rightPadding: 10
                                width: body2.width
                                //color: "#cccccc"
                                text: qsTr("Please carry out preventive maintenance before") + ": <b>%1</b>".arg(props.dueDate)
                            }//
                            Row{
                                id: remindRow
                                width: body2.width
                                TextApp{
                                    height: remindLeftTextFieldApp.height
                                    leftPadding: 10
                                    rightPadding: 10
                                    verticalAlignment: Text.AlignVCenter
                                    //width: body2.width
                                    //color: "#cccccc"
                                    //remind me when the due date is 10 days away or less
                                    text: qsTr("Remind me when the due date is")
                                }//

                                TextFieldApp{
                                    id: remindLeftTextFieldApp
                                    width: 80
                                    text: props.remindBefore
                                    horizontalAlignment: Text.AlignHCenter
                                    onPressed: {
                                        KeyboardOnScreenCaller.openNumpad(remindLeftTextFieldApp, props.title)
                                    }

                                    onAccepted: {
                                        const val = Number(text)
                                        if(isNaN(val)) return

                                        let valueValid = false

                                        switch(props.pid){
                                        case "daily":
                                            if((val >= 1) && (val <=23)) valueValid = true
                                            else valueValid = false
                                            break;
                                        case "weekly":
                                            if((val >= 1) && (val <=6)) valueValid = true
                                            else valueValid = false
                                            break;
                                        case "monthly":
                                            if((val >= 1) && (val <=29)) valueValid = true
                                            else valueValid = false
                                            break;
                                        case "quarterly":
                                            if((val >= 1) && (val <89)) valueValid = true
                                            else valueValid = false
                                            break;
                                        case "annually":
                                            if((val >= 1) && (val <=364)) valueValid = true
                                            else valueValid = false
                                            break;
                                        case "biennially":
                                            if((val >= 1) && (val <=729)) valueValid = true
                                            else valueValid = false
                                            break;
                                        case "quinquennially":
                                            if((val >= 1) && (val <=1824)) valueValid = true
                                            else valueValid = false
                                            break;
                                        case "canopy":
                                            if((val >= 1) && (val <=29)) valueValid = true
                                            else valueValid = false
                                            break;
                                        }

                                        if(!valueValid){
                                            viewApp.showDialogMessage(props.title,
                                                                      qsTr("Value is invalid!"),
                                                                      viewApp.dialogAlert,
                                                                      function(){}, false)
                                            props._refreshRemindTime()
                                            return
                                        }
                                        else
                                            props.remindBefore = val

                                        if(props.pid === "daily"){
                                            MachineAPI.setAlarmPreventMaintStateRemindBefore(props.pmCode, (props.remindBefore*3600))
                                            showBusyPage(qsTr("Setting up..."), function onCallback(cycle){
                                                if(MachineData.dailyPreventMaintRemindBefore === (props.remindBefore*3600))
                                                    closeDialog()
                                            })
                                        }
                                        else{
                                            MachineAPI.setAlarmPreventMaintStateRemindBefore(props.pmCode, props.remindBefore)
                                            showBusyPage(qsTr("Setting up..."), function onCallback(cycle){
                                                if((props.pid === "weekly") && (MachineData.weeklyPreventMaintRemindBefore === props.remindBefore))
                                                    closeDialog()
                                                else if((props.pid === "monthly") && (MachineData.monthlyPreventMaintRemindBefore === props.remindBefore))
                                                    closeDialog()
                                                else if((props.pid === "quarterly") && (MachineData.quarterlyPreventMaintRemindBefore === props.remindBefore))
                                                    closeDialog()
                                                else if((props.pid === "annually") && (MachineData.annuallyPreventMaintRemindBefore === props.remindBefore))
                                                    closeDialog()
                                                else if((props.pid === "biennially") && (MachineData.bienniallyPreventMaintRemindBefore === props.remindBefore))
                                                    closeDialog()
                                                else if((props.pid === "quinquennially") && (MachineData.quinquenniallyPreventMaintRemindBefore === props.remindBefore))
                                                    closeDialog()
                                                else if((props.pid === "canopy") && (MachineData.canopyPreventMaintRemindBefore === props.remindBefore))
                                                    closeDialog()
                                                else if(cycle >= MachineAPI.BUSY_CYCLE_3) closeDialog()
                                            })
                                        }
                                    }
                                }

                                TextApp{
                                    height: remindLeftTextFieldApp.height
                                    leftPadding: 10
                                    rightPadding: 10
                                    verticalAlignment: Text.AlignVCenter
                                    //width: body2.width
                                    //color: "#cccccc"
                                    text: ((props.pid !== "daily") ? qsTr("day(s) away or less") : qsTr("hour(s) away or less"))
                                }//
                            }
                        }//

                        Rectangle{
                            visible: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin
                            color: "transparent"
                            width: 150
                            height: parent.height - 40 //10
                            border.width: 1
                            border.color: "#effffd"
                            radius: 5
                            //anchors.bottom: parent.bottom
                            anchors.top: parent.top
                            anchors.right: parent.right
                            anchors.bottomMargin: 5
                            anchors.rightMargin: 5
                            ColumnLayout{
                                anchors.fill: parent
                                Item{
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    TextApp{
                                        width: parent.width
                                        height: parent.height
                                        text: qsTr("Reset Date")
                                        wrapMode: Text.WordWrap
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        padding: 5
                                    }
                                }
                                Item{
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    opacity: resetMA.pressed ? 0.5 : 1
                                    Rectangle{
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        color: "#0F2952"
                                        border.width: 1
                                        border.color: "#e3dac9"
                                        radius: 5
                                    }
                                    Image {
                                        anchors.centerIn: parent
                                        source: "qrc:/UI/Pictures/refresh.png"
                                    }
                                    MouseArea{
                                        id: resetMA
                                        anchors.fill: parent
                                        onClicked: {
                                            viewApp.showDialogAsk(props.title,
                                                                  qsTr("Are you sure you want to reset the acknowledgment date and due date?"),
                                                                  dialogAlert,
                                                                  function onAccepted(){
                                                                      MachineAPI.resetPreventMaintAckDate(props.pmCode)

                                                                      viewApp.showBusyPage(qsTr("Setting up..."),
                                                                                   function onCallback(cycle){})

                                                                      MachineAPI.insertEventLog(qsTr("User: Reset %1 date").arg(props.title))
                                                                  })
                                        }//
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "#0F2952"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBarApp {
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                        ButtonBarApp {
                            id: snoozeBtn
                            enabled: props.alarmActive
                                     && (UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin)/*!props.userIsAdmin && (props.userIsSupv ? props.allowSupvToAcknowledge : true)*/
                            visible: enabled
                            width: 194
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/alert-snooze.png"
                            text: qsTr("Snooze")

                            onClicked: {
                                MachineAPI.insertEventLog(qsTr("User: Snooze %1 reminder").arg(props.title))
                                MachineAPI.setAlarmPreventMaintStateAck(props.pmCode, true, true)
                                var intent = IntentApp.create(uri, {"message":""})
                                finishView(intent)
                            }
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property string title: ""
            property string pid: ""
            property var checklistTemp: []
            property var checklist: []

            property string ackDate: ""
            property string dueDate: ""
            property bool remindEn: false
            property bool alarmActive: false
            property int pmCode: 0

            property int allChecked: 0
            property int checkState: 0

            property bool acknowledge: false

            property bool userIsSupv: UserSessionService.roleLevel == UserSessionService.roleLevelSupervisor
            property bool userIsAdmin: UserSessionService.roleLevel == UserSessionService.roleLevelAdmin
            property bool allowSupvToAcknowledge: false

            property int remindBefore: 0

            function _refreshRemindTime(){
                if(props.pid == "daily") props.remindBefore = (MachineData.dailyPreventMaintRemindBefore/3600)
                else if(props.pid == "weekly") props.remindBefore = MachineData.weeklyPreventMaintRemindBefore
                else if(props.pid == "monthly") props.remindBefore = MachineData.monthlyPreventMaintRemindBefore
                else if(props.pid == "quarterly") props.remindBefore = MachineData.quarterlyPreventMaintRemindBefore
                else if(props.pid == "annually") props.remindBefore = MachineData.annuallyPreventMaintRemindBefore
                else if(props.pid == "biennially") props.remindBefore = MachineData.bienniallyPreventMaintRemindBefore
                else if(props.pid == "quinquennially") props.remindBefore = MachineData.quinquenniallyPreventMaintRemindBefore
                else if(props.pid == "canopy") props.remindBefore = MachineData.canopyPreventMaintRemindBefore

                remindLeftTextFieldApp.text = props.remindBefore
            }

            function calculateCheckState(bit, checked){
                if(checked)// bit set
                {
                    checkState |= 1 << bit;
                }
                else// bit clear
                {
                    checkState &= ~(1 << bit);
                }
            }//
            function onPreventMaintHasBeenReset(){
                viewApp.closeDialog()
                var intent = IntentApp.create(uri, {"message":""})
                finishView(intent)
            }

            onCheckStateChanged: {
                //console.debug("CheckState :", checkState)
            }
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            MachineData.preventMaintDateHasBeenReset.connect(props.onPreventMaintHasBeenReset)
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                let extradata = IntentApp.getExtraData(intent)
                if (extradata['pid'] !== undefined) {
                    props.pid = extradata['pid']
                    props.title = extradata['title'] || ""
                    props.checklistTemp = extradata['checklistReq'] || ""
                    for(let i=0; i<props.checklistTemp.length; i++){
                        if(props.checklistTemp[i] !== ""){
                            props.checklist.push(props.checklistTemp[i])
                            if(!props.allChecked)
                                props.allChecked |= 1
                            else
                                props.allChecked = (props.allChecked << 1) | 1
                        }//
                    }//
                    props.ackDate = extradata['ackDate'] || ""
                    props.dueDate = extradata['dueDate'] || ""
                    props.remindEn = extradata['remindEn'] || false
                    props.alarmActive = extradata['alarmActive'] || false
                    props.pmCode = extradata['pmCode'] || 0

                    //console.debug(props.checklist.length, props.allChecked)
                    //console.debug(props.ackDate, props.dueDate, props.remindEn)

                    props.allowSupvToAcknowledge = (props.pid == "daily"
                                                    || props.pid == "weekly"
                                                    || props.pid == "monthly"
                                                    || props.pid == "quarterly"
                                                    || props.pid == "canopy")

                    if(props.pid == "daily") props.remindBefore = (MachineData.dailyPreventMaintRemindBefore/3600)
                    else if(props.pid == "weekly") props.remindBefore = MachineData.weeklyPreventMaintRemindBefore
                    else if(props.pid == "monthly") props.remindBefore = MachineData.monthlyPreventMaintRemindBefore
                    else if(props.pid == "quarterly") props.remindBefore = MachineData.quarterlyPreventMaintRemindBefore
                    else if(props.pid == "annually") props.remindBefore = MachineData.annuallyPreventMaintRemindBefore
                    else if(props.pid == "biennially") props.remindBefore = MachineData.bienniallyPreventMaintRemindBefore
                    else if(props.pid == "quinquennially") props.remindBefore = MachineData.quinquenniallyPreventMaintRemindBefore
                    else if(props.pid == "canopy") props.remindBefore = MachineData.canopyPreventMaintRemindBefore
                    remindLeftTextFieldApp.text = props.remindBefore
                }

                //listviewLoader.active = true
                checkListview.model = props.checklist
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
                MachineData.preventMaintDateHasBeenReset.disconnect(props.onPreventMaintHasBeenReset)
            }
        }//
    }//
}//

//        MultiPointTouchArea {
//            anchors.fill: parent

//            touchPoints: [
//                TouchPoint {id: point1},
//                TouchPoint {id: point2},
//                TouchPoint {id: point3},
//                TouchPoint {id: point4},
//                TouchPoint {id: point5}
//            ]
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "red"
//            visible: point1.pressed
//            x: point1.x - (width / 2)
//            y: point1.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "green"
//            visible: point2.pressed
//            x: point2.x - (width / 2)
//            y: point2.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "blue"
//            visible: point3.pressed
//            x: point3.x - (width / 2)
//            y: point3.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "yellow"
//            visible: point4.pressed
//            x: point4.x - (width / 2)
//            y: point4.y - (height / 2)
//        }//

//        Rectangle {
//            width: 100; height: 100
//            radius: width
//            opacity: 0.7
//            color: "cyan"
//            visible: point5.pressed
//            x: point5.x - (width / 2)
//            y: point5.y - (height / 2)
//        }//

//        Column {
//            id: counter
//            anchors.centerIn: parent

//            TextApp {
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: props.count
//                font.pixelSize: 48

//                TapHandler {
//                    onTapped: {
//                        props.count = props.countDefault
//                        counterTimer.restart()
//                    }//
//                }//
//            }//

//            TextApp {
//                font.pixelSize: 14
//                text: "Press number\nto count!"
//            }//
//        }//

//        Timer {
//            id: counterTimer
//            interval: 1000; repeat: true
//            onTriggered: {
//                let count = props.count
//                if (count <= 0) {
//                    counterTimer.stop()
//                }//
//                else {
//                    count = count - 1
//                    props.count = count
//                }//
//            }//
//        }//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/

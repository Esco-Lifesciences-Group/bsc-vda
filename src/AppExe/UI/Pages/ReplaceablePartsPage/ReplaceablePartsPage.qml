/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author:
 *  - Ahmad Qodri
 *  - Heri Cahyono
**/

import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
//import QuickDatalog 1.0
import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ReplaceableCompRecordQmlApp 1.0

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Replaceable Components Record"

    background.sourceComponent: Item {}

    content.asynchronous: true
    content.sourceComponent: ContentItemApp{
        id: contentView
        height: viewApp.height
        width: viewApp.width

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
                    title: qsTr("Replaceable Components Record")
                }
            }

            /// BODY
            Item {
                id: contentItem
                Layout.fillHeight: true
                Layout.fillWidth: true


                RowLayout {
                    anchors.fill: parent
                    spacing: 5

                    ListView {
                        id: logListView
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: 1
                        clip: true

                        ScrollBar.vertical: scrollBarApp.scrollBar

                        property bool prevFlik: false
                        property bool nextFlik: false
                        property bool actionFlik: false

                        //
                        //  Slot called when the flick has started
                        //
                        onFlickStarted: {
                            //                        ////console.debug("onFlickStarted")
                            prevFlik = atYBeginning
                            nextFlik = atYEnd
                        }//

                        onVerticalOvershootChanged: {
                            let value = Math.abs(verticalOvershoot)
                            //////console.debug(value)
                            if(value > 70){
                                if(!actionFlik){
                                    actionFlik = true
                                }//
                            }//
                        }//

                        //
                        //  Slot called when the flick has finished
                        //
                        onFlickEnded: {
                            //                        ////console.debug("onFlickEnded")
                            if (atYBeginning && prevFlik) {
                                if(actionFlik) {
                                    actionFlik = false
                                    //                                    ////console.debug("Prev")
                                    logApp.prev()
                                }
                            }
                            else if (atYEnd && nextFlik) {
                                if(actionFlik) {
                                    actionFlik = false
                                    //                                    ////console.debug("Next")
                                    logApp.next()
                                }//
                            }//
                        }//

                        MouseArea {
                            anchors.fill: parent
                            propagateComposedEvents: false
                            z: 1

                            onReleased: {
                                if (!propagateComposedEvents) {
                                    propagateComposedEvents = true
                                }
                            }
                        }//

                        headerPositioning: ListView.OverlayHeader
                        header: Rectangle {
                            implicitHeight: 50
                            implicitWidth: parent.width
                            color: "#0F2952"
                            z: 100

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 1

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 70

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("No.")
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Date")
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Time (24h)")
                                    }
                                }

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: qsTr("Unit Model")
                                    }
                                }

                                // Rectangle{
                                //     Layout.minimumHeight: 0.8*parent.height
                                //     Layout.minimumWidth: 1
                                //     color: "#e3dac9"
                                // }//

                                // Item {
                                //     Layout.fillHeight: true
                                //     Layout.fillWidth: true

                                //     TextApp {
                                //         anchors.fill: parent
                                //         verticalAlignment: Text.AlignVCenter
                                //         horizontalAlignment: Text.AlignHCenter
                                //         wrapMode: Text.WordWrap
                                //         text: qsTr("Electrical Tester")
                                //     }//
                                // }//

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    //Layout.minimumWidth: 150

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideMiddle
                                        text: qsTr("User")
                                    }//
                                }//

                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 100

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideMiddle
                                        text: qsTr("Edit")
                                    }//
                                }//
                                Rectangle{
                                    Layout.minimumHeight: 0.8*parent.height
                                    Layout.minimumWidth: 1
                                    color: "#e3dac9"
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 100

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        elide: Text.ElideMiddle
                                        text: qsTr("Delete")
                                    }//
                                }//
                            }//
                        }//

                        delegate: Rectangle {
                            height: 80
                            width: logListView.width
                            color: "#34495e"
                            opacity: rowLogMA.pressed ? 0.6 : 1
                            MouseArea{
                                id: rowLogMA
                                anchors.fill: parent
                                propagateComposedEvents : true
                                onPressAndHold: {
                                    if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin){
                                        const rowId = ((logApp.pagesCurrentNumber * logApp.pagesItemPerPage)
                                                       - logApp.pagesItemPerPage) + index + 1
                                        MachineAPI.setReplaceablePartsSelected(rowId)
                                        showBusyPage(qsTr("Please wait..."), function(cycle){
                                            //                    ////console.debug(cycle + " : " + timeout)
                                            if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                const intent = IntentApp.create("qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsViewPage.qml",
                                                                                {"modelData": modelData})//
                                                startView(intent);
                                            }
                                        })
                                    }else{
                                        showDialogMessage(qsTr("Access Denied"),
                                                          qsTr("You do not have permission to perform this action!"),
                                                          dialogAlert)
                                    }
                                }
                                //                                onClicked: {
                                //                                    rowButton.visible = true
                                //                                }//
                            }//
                            //                            Row{
                            //                                id: rowButton
                            //                                visible: false
                            //                                anchors.right: parent.right
                            //                                anchors.rightMargin: 5
                            //                                spacing: 10
                            //                                Image {
                            //                                    source: "qrc:/UI/Pictures/edit-add-row.png"
                            //                                    MouseArea{
                            //                                        anchors.fill: parent
                            //                                        onClicked: {
                            //                                            if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin){
                            //                                                showDialogAsk(qsTr("Replaceable Components Record"),
                            //                                                              qsTr("Edit and add a record from this data?"),
                            //                                                              dialogInfo,
                            //                                                              function onAccepted(){
                            //                                                                  const rowId = ((logApp.pagesCurrentNumber * logApp.pagesItemPerPage)
                            //                                                                                 - logApp.pagesItemPerPage) + index + 1
                            //                                                                  MachineAPI.setReplaceablePartsSelected(rowId)
                            //                                                                  showBusyPage(qsTr("Please wait..."), function(cycle){
                            //                                                                      if(cycle >= MachineAPI.BUSY_CYCLE_1){
                            //                                                                          MachineAPI.setReplaceablePartsSettingsFromSelectedRecord();
                            //                                                                          const intent = IntentApp.create("qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsAddPage.qml",
                            //                                                                                                          {})//
                            //                                                                          startView(intent);
                            //                                                                      }
                            //                                                                  })
                            //                                                              },
                            //                                                              function onRejected(){
                            //                                                                  closeDialog()
                            //                                                              },
                            //                                                              function onClosed(){},
                            //                                                              true)
                            //                                            }else{
                            //                                                showDialogMessage(qsTr("Access Denied"),
                            //                                                                  qsTr("You do not have permission to perform this action!"),
                            //                                                                  dialogAlert)
                            //                                            }//
                            //                                            mouse.accepted = false
                            //                                        }//
                            //                                    }//
                            //                                }//
                            //                                Image {
                            //                                    source: "qrc:/UI/Pictures/delete-log-row.png"
                            //                                    MouseArea{
                            //                                        anchors.fill: parent
                            //                                        onClicked: {
                            //                                            if(UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin){
                            //                                                const rowId = ((logApp.pagesCurrentNumber * logApp.pagesItemPerPage)
                            //                                                               - logApp.pagesItemPerPage) + index
                            //                                                showDialogAsk(qsTr("Replaceable Components Record"),
                            //                                                              qsTr("Are you sure want to delete this data record?"),
                            //                                                              dialogAlert,
                            //                                                              function onAccepted(){
                            //                                                                  logApp.queryDeleteAtRowId(rowId)
                            //                                                                  showBusyPage(qsTr("Please wait..."), function(cycle){
                            //                                                                      if(cycle >= MachineAPI.BUSY_CYCLE_1){
                            //                                                                          closeDialog()
                            //                                                                      }
                            //                                                                  })
                            //                                                              },
                            //                                                              function onRejected(){
                            //                                                                  closeDialog()
                            //                                                              },
                            //                                                              function onClosed(){},
                            //                                                              true,
                            //                                                              3000,
                            //                                                              qsTr("Delete"),
                            //                                                              qsTr("Cancel"))
                            //                                            }else{
                            //                                                showDialogMessage(qsTr("Access Denied"),
                            //                                                                  qsTr("You do not have permission to perform this action!"),
                            //                                                                  dialogAlert)
                            //                                            }//
                            //                                            mouse.accepted = false
                            //                                        }//
                            //                                    }//
                            //                                }//
                            //                            }//
                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 1

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 70

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: ((logApp.pagesCurrentNumber * logApp.pagesItemPerPage)
                                               - logApp.pagesItemPerPage) + index + 1
                                    }//
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.date
                                    }//
                                }//

                                Item{
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.time
                                    }//
                                }//

                                Item{
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 130

                                    TextApp {
                                        anchors.fill: parent
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.unitModel
                                    }//
                                }//

                                Item{
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    //Layout.minimumWidth: 150

                                    TextApp {
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        text: modelData.userFullName.length ? modelData.userFullName : modelData.userName
                                    }//
                                }//

                                Item{
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 100
                                    Image {
                                        source: "qrc:/UI/Pictures/edit-add-row.png"
                                        anchors.centerIn: parent
                                        MouseArea{
                                            anchors.fill: parent
                                            onClicked: {
                                                if(UserSessionService.roleLevel >= UserSessionService.roleLevelService){
                                                    showDialogAsk(qsTr("Replaceable Components Record"),
                                                                  qsTr("Edit and add a record from this data?"),
                                                                  dialogInfo,
                                                                  function onAccepted(){
                                                                      const rowId = ((logApp.pagesCurrentNumber * logApp.pagesItemPerPage)
                                                                                     - logApp.pagesItemPerPage) + index + 1
                                                                      MachineAPI.setReplaceablePartsSelected(rowId)
                                                                      showBusyPage(qsTr("Please wait..."), function(cycle){
                                                                          if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                                              MachineAPI.setReplaceablePartsSettingsFromSelectedRecord();
                                                                              const intent = IntentApp.create("qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsAddPage.qml",
                                                                                                              {})//
                                                                              startView(intent);
                                                                          }
                                                                      })
                                                                  },
                                                                  function onRejected(){
                                                                      closeDialog()
                                                                  },
                                                                  function onClosed(){},
                                                                  true)
                                                }else{
                                                    showDialogMessage(qsTr("Access Denied"),
                                                                      qsTr("You do not have permission to perform this action!"),
                                                                      dialogAlert)
                                                }//
                                                mouse.accepted = false
                                            }//
                                        }//
                                    }//
                                }//

                                Item{
                                    Layout.fillHeight: true
                                    Layout.minimumWidth: 1
                                }//

                                Item {
                                    Layout.fillHeight: true
                                    Layout.fillWidth: false
                                    Layout.minimumWidth: 100
                                    Image {
                                        anchors.centerIn: parent
                                        source: "qrc:/UI/Pictures/delete-log-row.png"
                                        MouseArea{
                                            anchors.fill: parent
                                            onClicked: {
                                                if(UserSessionService.roleLevel >= UserSessionService.roleLevelService){
                                                    const rowId = ((logApp.pagesCurrentNumber * logApp.pagesItemPerPage)
                                                                   - logApp.pagesItemPerPage) + index
                                                    showDialogAsk(qsTr("Replaceable Components Record"),
                                                                  qsTr("Are you sure want to delete this data record?"),
                                                                  dialogAlert,
                                                                  function onAccepted(){
                                                                      MachineAPI.insertEventLog(qsTr("User: Delete RP form record at row %1 (was recorded on %2 %3)").arg(rowId).arg(modelData.date).arg(modelData.time))
                                                                      logApp.queryDeleteAtRowId(rowId)
                                                                      showBusyPage(qsTr("Please wait..."), function(cycle){
                                                                          if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                                              closeDialog()
                                                                          }
                                                                      })
                                                                  },
                                                                  function onRejected(){
                                                                      closeDialog()
                                                                  },
                                                                  function onClosed(){},
                                                                  true,
                                                                  3000,
                                                                  qsTr("Delete"),
                                                                  qsTr("Cancel"))
                                                }else{
                                                    showDialogMessage(qsTr("Access Denied"),
                                                                      qsTr("You do not have permission to perform this action!"),
                                                                      dialogAlert)
                                                }//
                                                mouse.accepted = false
                                            }//
                                        }//
                                    }//

                                }//
                            }//
                        }//

                        onContentYChanged: {
                            if (scrollDownNotifApp.visible){
                                scrollDownNotifApp.visible = false
                            }
                        }//

                        ScrollDownNotifApp {
                            id: scrollDownNotifApp
                            height: 60
                            width: 60
                            visible: false
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.bottom: parent.bottom
                        }//

                        Loader {
                            active: logListView.count == 0
                            anchors.centerIn: parent
                            sourceComponent: Column {
                                TextApp {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: qsTr("Oops!")
                                    font.pixelSize: 32

                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: logApp.prev()
                                    }//
                                }//

                                TextApp {
                                    text: qsTr("Seems like there's nothing in this record yet.")

                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked: logApp.prev()
                                    }//
                                }//

                                visible: false
                                Timer {
                                    running: true
                                    interval: 1000
                                    onTriggered: {
                                        parent.visible = true
                                    }//
                                }//
                            }//
                        }//
                    }//

                    ScrollBarApp {
                        id: scrollBarApp
                        Layout.fillWidth: false
                        Layout.minimumWidth: 15
                        Layout.fillHeight: true
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

                        Row {
                            anchors.right: parent.right
                            spacing: 5

                            ButtonBarApp {
                                width: 194
                                //enabled: UserSessionService.roleLevel >= UserSessionService.roleLevelService
                                visible: MachineData.replaceableCompRecordCount == 0
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/add-record.png"
                                text: qsTr("Add New Record")

                                onClicked: {
                                    if(UserSessionService.roleLevel >= UserSessionService.roleLevelService){
                                        const intent = IntentApp.create("qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsAddPage.qml",
                                                                        {})//
                                        startView(intent);
                                    }else{
                                        showDialogMessage(qsTr("Access Denied"),
                                                          qsTr("You do not have permission to perform this action!"),
                                                          dialogAlert)
                                    }
                                }//
                            }//

                            ButtonBarApp {
                                width: 194
                                anchors.verticalCenter: parent.verticalCenter

                                imageSource: "qrc:/UI/Pictures/settings-icon-35px.png"
                                text: qsTr("Options")

                                onClicked: {
                                    const intent = IntentApp.create("qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsOptions.qml",
                                                                    {
                                                                        "currentPage": Number((logApp.pagesCurrentNumber*logApp.pagesItemPerPage)/50).toFixed(),
                                                                        "totalPage": logApp.totalItem/*pagesTotal*/
                                                                    })//
                                    startView(intent);
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ReplaceableCompRecordQmlApp {
            id: logApp

            pagesItemPerPage: 50

            //delayEmitSignal: 500

            function prev(){
                props.showLoading(1)
                selectDescendingWithPagination(pagesPreviousNumber)
            }//

            function next() {
                props.showLoading(1)
                if(logListView.count < pagesItemPerPage) {
                    props.pageKeepScrollPosition = true
                }
                selectDescendingWithPagination(pagesNextNumber)
            }

            onInitializedChanged: {
                //                delayEmitSignal = 100
                //                //console.debug("AlarmLogQmlApp: " + initialized)
                next()
            }

            onDeleteHasDone: {
                MachineAPI.refreshLogRowsCount("replaceablecomprecord")

                showDialogMessage(qsTr(title), qsTr("The log has been deleted!"), dialogInfo,
                                  function onClosed(){
                                      next()
                                  })
            }//

            onSelectHasDone: {
                //                ////console.debug("onSelectHasDone: " + JSON.stringify(logBuffer[0]))
                //                //console.debug(logBuffer.length)
                if(total == 0){
                    logListView.model = logBuffer
                }
                else {
                    const contentYPosition = logListView.contentY
                    ////console.debug("contentYPosition: " + contentYPosition)

                    logListView.model = []
                    logListView.model = logBuffer

                    if(props.pageKeepScrollPosition) {
                        if(logBuffer.length >= logListView.count){
                            logListView.contentY = contentYPosition
                        }
                    }

                    if(props.pageKeepScrollPosition) props.pageKeepScrollPosition = false

                    if(!logListView.atYEnd) {
                        scrollDownNotifApp.visible = true
                    }
                }
                MachineAPI.refreshLogRowsCount("replaceablecomprecord")
                viewApp.closeDialog();
            }//

            //            onLogHasExported: {
            //                console.log("onLogHasExported")
            //                console.log(done)
            //            }

            Component.onCompleted: {
                props.showLoading(1)
                init();
            }//
        }//

        /// Put all private property inside here
        /// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property bool pageKeepScrollPosition: false

            function showLoading(timeout){
                showBusyPage(qsTr("Loading..."), function(cycle){
                    if(cycle >= timeout){
                        MachineAPI.refreshLogRowsCount("replaceablecomprecord")
                        viewApp.closeDialog();
                    }
                })
            }//

        }//

        //        /// called Once but after onResume
        //        Component.onCompleted: {
        //        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                logApp.prev()

                //MachineAPI.setPropogateComposeEventGesture(true)
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
                //MachineAPI.setPropogateComposeEventGesture(false)
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/

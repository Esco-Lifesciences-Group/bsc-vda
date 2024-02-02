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
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0
import ModulesCpp.ELSkeygen 1.0

ViewApp {
    id: viewApp
    title: "Software Start Failed"

    background.sourceComponent:
        Rectangle{
        color: "black"
    }

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
                RowLayout{
                    anchors.fill: parent
                    spacing: 5
                    Rectangle {
                        Layout.minimumWidth: parent.width/4
                        Layout.fillHeight: true
                        color: "transparent"
                        border.color: "#e3dac9"
                        border.width: 1
                        radius: 5
                        RowLayout{
                            anchors.fill: parent
                            clip: true
                            anchors.margins: 5
                            spacing: 5
                            Item{
                                Layout.fillHeight: true
                                Layout.minimumWidth: parent.width*0.70
                                Image{
                                    width: parent.width
                                    fillMode: Image.PreserveAspectFit
                                    anchors.verticalCenter: parent.verticalCenter
                                    source:"qrc:/UI/Pictures/logo/esco-logo-50px.png"
                                }
                            }
                            Item{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                TextApp{
                                    height: parent.height
                                    width: parent.width
                                    wrapMode: Text.WordWrap
                                    horizontalAlignment: Text.AlignHCenter
                                    verticalAlignment: Text.AlignVCenter
                                    text: MachineData.serialNumber.replace("-", "-\n")
                                    minimumPixelSize: 16
                                    fontSizeMode: Text.Fit
                                    //                                    font.family: "Courier";
                                }
                            }
                        }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "transparent"
                        border.color: "#e3dac9"
                        border.width: 1
                        radius: 5
                        TextApp{
                            height: parent.height
                            width: parent.width
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            text: "Software Start Failed"
                            font.bold: true
                            //                            font.family: "Courier";
                            font.pixelSize: 20
                        }
                    }
                    Rectangle {
                        Layout.minimumWidth: parent.width/4
                        Layout.fillHeight: true
                        color: "transparent"
                        border.color: "#e3dac9"
                        border.width: 1
                        radius: 5
                        TextApp{
                            id: topBarClockText
                            anchors.fill: parent
                            anchors.margins: 5
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            fontSizeMode: Text.Fit
                            text: "---"
                            //                            font.family: "Courier";
                        }//
                    }//
                }//
                Timer {
                    id: backgroundShutDownTimer
                    running: false
                    repeat: true
                    interval: 1000
                    onTriggered: {
                        if(--props.shutDownCountDownTimer === 0){
                            running = false
                            let exitCodePowerOff = 6
                            const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {
                                                                exitCode: exitCodePowerOff,
                                                                backgroundBlack: 1
                                                            })
                            startRootView(intent)
                        }//

                        var datetime = new Date();
                        //            dateText.text = Qt.formatDateTime(datetime, "dddd\nMMM dd yyyy")
                        let date = Qt.formatDateTime(datetime, "ddd MMM dd yyyy")

                        let timeFormatStr = "hh:mm"

                        let clock = Qt.formatDateTime(datetime, timeFormatStr)

                        topBarClockText.text = date + "<br>" + clock

                        props.dateString = date
                    }//
                }//

                Component.onCompleted: {
                    backgroundShutDownTimer.running = true
                }
            }//

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                Column{
                    spacing: 0
                    TextApp{
                        width: bodyItem.width * 0.95
                        topPadding: 40
                        leftPadding: 20
                        rightPadding: 20
                        //                        font.family: "Courier";
                        text: "Software failed to start. A recent hardware or software change might be the cause.<br>To fix the problem:"
                    }
                    Row{
                        spacing: 10
                        TextApp{
                            leftPadding: 20
                            //                            font.family: "Courier";
                            text: "1."
                        }
                        TextApp{
                            width: bodyItem.width * 0.95
                            rightPadding: 20
                            //                            font.family: "Courier";
                            wrapMode: Text.WordWrap
                            text: "Insert your software installation disc to the correct device (its original device) and restart your device"
                        }
                    }
                    Row{
                        spacing: 10
                        TextApp{
                            leftPadding: 20
                            //                            font.family: "Courier";
                            text: "2."
                        }
                        TextApp{
                            width: bodyItem.width * 0.95
                            rightPadding: 20
                            //                            font.family: "Courier";
                            text: "Re-flash your installation disc with new software"
                        }
                    }
                    Row{
                        spacing: 10
                        TextApp{
                            leftPadding: 20
                            //                            font.family: "Courier";
                            text: "3."
                        }
                        TextApp{
                            width: bodyItem.width * 0.95
                            rightPadding: 20
                            //                            font.family: "Courier";
                            text: "Login as Service or Factory user"
                                  + " "
                                  + (MachineData.escoLockServiceEnable ? "(Esco Lock Service PIN will be required)"
                                                                        : "")
                        }
                    }
                    //                    Row{
                    //                        spacing: 10
                    //                        TextApp{
                    //                            leftPadding: 20
                    //                            //                            font.family: "Courier";
                    //                            text: "4."
                    //                        }
                    //                        TextApp{
                    //                            width: bodyItem.width * 0.95
                    //                            rightPadding: 20
                    //                            //                            font.family: "Courier";
                    //                            text: "Service: %1, Factory: %2".arg(props.textPasswordService).arg(props.textPasswordFactory)
                    //                        }
                    //                    }
                    Column{
                        id: columnPassword
                        visible: false
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10
                        TextApp{
                            topPadding: 40
                            anchors.horizontalCenter: parent.horizontalCenter
                            //                            font.family: "Courier";
                            text: MachineData.escoLockServiceEnable ? ("Login with ELS PIN") : ("Login with Service or Factory PIN")
                        }

                        TextFieldApp {
                            id: passwordTextField
                            width: 150
                            height: 60
                            anchors.horizontalCenter: parent.horizontalCenter
                            echoMode: TextInput.Password
                            validator: RegExpValidator { regExp: /[0-9]+/ }
                            placeholderText: MachineData.escoLockServiceEnable ? ("ELS PIN") : ("PIN")
                            //                            font.family: "Courier";
                            colorBackground: "#333333"
                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, MachineData.escoLockServiceEnable ? ("ELS PIN") : ("PIN"))
                            }//
                            onAccepted: {
                                const strPassword = String(passwordTextField.text)
                                const strService = props.textPasswordService
                                const strFactory = props.textPasswordFactory

                                ////console.debug("onAccepted:", enteredText)
                                ////console.debug("service: ", service)
                                ////console.debug("factory:", factory)

                                if(!strPassword.localeCompare(strService)){
                                    ////console.debug("Password service")
                                    props.passwordElsEntered = props.service
                                    props.showLoginState = 2
                                }else if(!strPassword.localeCompare(strFactory)){
                                    ////console.debug("Password factory")
                                    props.passwordElsEntered = props.factory
                                    props.showLoginState = 2
                                }
                                else{
                                    ////console.debug("Password wrong")
                                    props.passwordElsEntered = 0
                                    props.passwordElsFalseCounter++
                                }
                            }//
                        }//

                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            //                            font.family: "Courier";
                            text: "Make sure Date and Time setting is correct!"
                        }
                    }
                }
                TextApp{
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    bottomPadding: 10
                    //                    font.family: "Courier";
                    text: /*qsTr*/("Auto Shut down in ") + utils.strfSecsToHumanReadable(props.shutDownCountDownTimer)
                }
            }//

            /// FOOTER
            Item {
                id: footerItem
                Layout.fillWidth: true
                Layout.minimumHeight: 70

                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    //                    border.color: "#e3dac9"
                    //                    border.width: 1
                    radius: 5

                    Item {
                        anchors.fill: parent
                        anchors.margins: 5

                        ButtonBlackApp{
                            id: buttonShutDown
                            iconSource: "qrc:/UI/Pictures/turnoff-red-icon.png"
                            buttonText: "Shut down"
                            onClicked: {
                                backgroundShutDownTimer.running = false
                                let exitCodePowerOff = 6
                                const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {
                                                                    exitCode: exitCodePowerOff,
                                                                    backgroundBlack: 1})
                                startRootView(intent)
                            }
                        }

                        ButtonBlackApp{
                            id: buttonDateTime
                            iconSource: "qrc:/UI/Pictures/datetime.png"
                            buttonText: "Set Date & Time"
                            anchors.left: buttonShutDown.right
                            onClicked: {
                                const intent = IntentApp.create("qrc:/UI/Pages/SoftwareFailedStartPage/DateTimeSettingPage.qml", {shutDownCountDownTimer: props.shutDownCountDownTimer})
                                startRootView(intent)
                            }
                        }

                        ButtonBlackApp{
                            id: buttonLogin
                            iconSource: "qrc:/UI/Pictures/user-login.png"
                            buttonText: "Show Login"
                            anchors.right: parent.right

                            states: [
                                State {
                                    when: props.showLoginState === 0
                                    PropertyChanges {
                                        target: buttonLogin
                                        buttonText: "Show Login"
                                    }
                                    PropertyChanges {
                                        target: buttonLogin
                                        iconSource: "qrc:/UI/Pictures/button-invisible.png"
                                    }
                                },
                                State {
                                    when: props.showLoginState === 1
                                    PropertyChanges {
                                        target: buttonLogin
                                        buttonText: "Hide Login"
                                    }
                                    PropertyChanges {
                                        target: buttonLogin
                                        iconSource: "qrc:/UI/Pictures/button-visible.png"
                                    }
                                },
                                State {
                                    when: props.showLoginState === 2
                                    PropertyChanges {
                                        target: buttonLogin
                                        buttonText: "Login"
                                    }
                                    PropertyChanges {
                                        target: buttonLogin
                                        iconSource: "qrc:/UI/Pictures/user-login.png"
                                    }
                                }
                            ]

                            onClicked: {
                                //console.debug("login pressed")
                                if(props.passwordElsEntered == 0)
                                {
                                    if(props.showLoginState == 0) {
                                        columnPassword.visible = true
                                        props.showLoginState = 1
                                    }
                                    else if(props.showLoginState == 1) {
                                        columnPassword.visible = false
                                        props.showLoginState = 0
                                    }
                                }else{
                                    if(props.passwordElsEntered == props.service){
                                        UserSessionService.loggedIn = true
                                        UserSessionService.roleLevel = UserSessionService.roleLevelService
                                        UserSessionService.username = "service"
                                        UserSessionService.fullname = "Unknown (service)"

                                        MachineAPI.setSignedUser(UserSessionService.username, UserSessionService.fullname, UserSessionService.roleLevel)
                                        const message = qsTr("Login unknown device successfully! username: ") + "service"
                                        MachineAPI.insertEventLog(message)

                                        props.loginSuccessDialog()
                                    }else if(props.passwordElsEntered == props.factory){
                                        UserSessionService.loggedIn = true
                                        UserSessionService.roleLevel = UserSessionService.roleLevelFactory
                                        UserSessionService.username = "factory"
                                        UserSessionService.fullname = "Unknown (factory)"

                                        MachineAPI.setSignedUser(UserSessionService.username, UserSessionService.fullname, UserSessionService.roleLevel)
                                        const message = qsTr("Login unknown device successfully! username: ") + "factory"
                                        MachineAPI.insertEventLog(message)

                                        props.loginSuccessDialog()
                                    }//
                                }//
                            }//
                        }//
                    }//
                }//
            }//
        }//

        UtilsApp{id: utils}

        ELSkeygen {
            id: elsKeygen

            /// Replacement for Service Pin
            generatedKey: ""
            /// Replacement for Factory Pin
            generatedKey2: ""

            onGeneratorKeyHasFinished: {
                let service = String(generatedKey)
                let factory = String(generatedKey2)

                //                console.log("generatedKeyService: " + service)
                //                console.log("generatedKeyFactory: " + factory)
                if(MachineData.escoLockServiceEnable){
                    props.textPasswordService = service/*.replace(" ","")*/
                    props.textPasswordFactory = factory/*.replace(" ","")*/
                }
            }//
        }//

        UtilsApp {
            id: utilsApp
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props
            property int shutDownCountDownTimer: 90
            property int showLoginState:        0
            property int passwordElsEntered:    0 //1 = service | 2 = factory
            property int passwordElsFalseCounter: 0
            property string textPasswordService: "0009"
            property string textPasswordFactory: "0019"
            readonly property int serialLength: 8
            readonly property int service :     1
            readonly property int factory :     2
            //            property bool connected:            NetworkService.connected

            property string dateString: ""
            property string serialNumber: "00000000"

            onDateStringChanged: {
                if(serialNumber === "00000000"){
                    return
                }
                elsKeygen.calculateKey(serialNumber)
            }//

            onPasswordElsFalseCounterChanged: {
                if(passwordElsFalseCounter >= 5){
                    backgroundShutDownTimer.running = false
                    let exitCodePowerOff = 6
                    const intent = IntentApp.create("qrc:/UI/Pages/ClosingPage/ClosingPage.qml", {exitCode: exitCodePowerOff, backgroundBlack: 1})
                    startRootView(intent)
                }
            }//

            function loginSuccessDialog(){
                viewApp.showDialogMessage(qsTr("Notification"),
                                          qsTr("You are successfully logged in!"),
                                          viewApp.dialogInfo,
                                          function onClosed(){
                                              const intent = IntentApp.create("qrc:/UI/Pages/_HomePage/HomePage.qml", {})
                                              startRootView(intent)
                                          })
            }
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            const message = qsTr("Software installed in an unknown device!")
            MachineAPI.insertEventLog(message)

            const extraData = IntentApp.getExtraData(intent)
            const message1 = extraData["fromDateTimePage"] || 0
            if(message1){
                const message2 = extraData["shutDownCountDownTimer"] || 0
                props.shutDownCountDownTimer = message2
                //console.debug("shutDownCountDownTimer:", props.shutDownCountDownTimer)
            }else{
                //console.debug("Not from Date time page")
            }

            //            var datetime = new Date();
            //            //            dateText.text = Qt.formatDateTime(datetime, "dddd\nMMM dd yyyy")
            //            let date = Qt.formatDateTime(datetime, "ddd MMM dd yyyy")

            //            let timeFormatStr = "hh:mm"

            //            let clock = Qt.formatDateTime(datetime, timeFormatStr)

            //            topBarClockText.text = date + "<br>" + clock


        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");
                const serialNumberExtract = MachineData.serialNumber.split("-")    /// example: 2021-00000000 -> [2021, 00000000]
                if (serialNumberExtract.length === 2){
                    let serialNum = serialNumberExtract[1]
                    if (serialNum.length !== props.serialLength) {
                        serialNum = utilsApp.fixStrLength(serialNum, props.serialLength, "0", 1)
                    }
                    //                        console.log("serial to be calculated: " + serialNum)

                    /// serial number not set yet, skip esco lock service
                    if(serialNum === "00000000"){
                        return
                    }

                    props.serialNumber = serialNum
                    elsKeygen.calculateKey(serialNum)
                }//
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/

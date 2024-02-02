import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Full-Field Sensor Calibration"

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
                    title: qsTr("Full-Field Sensor Calibration")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true
                StackView {
                    id: fragmentStackView
                    anchors.fill: parent
                    initialItem: fragmentStartedComp1
                }//

                Component {
                    id: fragmentStartedComp1
                    Item{
                        property string idname: "started1"
                        Rectangle{
                            color: "transparent"
                            radius: 5
                            width: 450
                            height: 330
                            anchors.centerIn: parent
                            ColumnLayout{
                                spacing: 5
                                anchors.fill: parent
                                Item{
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    RowLayout{
                                        anchors.fill: parent
                                        spacing: 5
                                        Item{
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            ColumnLayout{
                                                anchors.fill: parent
                                                spacing: 5
                                                Item{
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true
                                                    Rectangle{
                                                        anchors.fill: parent
                                                        radius: 5
                                                        color: "#80000000"
                                                    }
                                                    ColumnLayout{
                                                        anchors.fill: parent
                                                        anchors.margins: 5
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.minimumHeight: 30
                                                            TextApp{
                                                                height: parent.height
                                                                width: parent.width
                                                                text: qsTr("Sensor Constant")
                                                                wrapMode: Text.WordWrap
                                                                verticalAlignment: Text.AlignVCenter
                                                            }
                                                        }
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.fillHeight: true
                                                            RowLayout{
                                                                anchors.fill: parent
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    TextFieldApp{
                                                                        id: sensConstTextField
                                                                        height: parent.height
                                                                        width: parent.width
                                                                        verticalAlignment: Text.AlignVCenter
                                                                        horizontalAlignment: Text.AlignHCenter
                                                                        text: MachineData.inflowSensorConstant
                                                                        onAccepted: {
                                                                            MachineAPI.setInflowSensorConstant(Number(text))
                                                                            MachineAPI.setInflowSensorConstantTemporary(Number(text))
                                                                        }//
                                                                    }//
                                                                    MouseArea{
                                                                        anchors.fill: parent
                                                                        onClicked: {
                                                                            KeyboardOnScreenCaller.openNumpad(sensConstTextField, qsTr("Sensor Constant"))
                                                                        }//
                                                                    }//
                                                                }//
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    // TextApp{
                                                                    //     height: parent.height
                                                                    //     width: parent.width
                                                                    //     text: props.velocityUnit
                                                                    //     verticalAlignment: Text.AlignVCenter
                                                                    // }//
                                                                }//
                                                            }//
                                                        }//
                                                    }//
                                                }//
                                                Item{
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true
                                                    Rectangle{
                                                        anchors.fill: parent
                                                        radius: 5
                                                        color: "#80000000"
                                                    }
                                                    ColumnLayout{
                                                        anchors.fill: parent
                                                        anchors.margins: 5
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.minimumHeight: 30
                                                            TextApp{
                                                                height: parent.height
                                                                width: parent.width
                                                                text: qsTr("Nominal Inflow Velocity")
                                                                wrapMode: Text.WordWrap
                                                                verticalAlignment: Text.AlignVCenter
                                                            }
                                                        }
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.fillHeight: true
                                                            RowLayout{
                                                                anchors.fill: parent
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    TextFieldApp{
                                                                        id: ifaNomTextField
                                                                        height: parent.height
                                                                        width: parent.width
                                                                        verticalAlignment: Text.AlignVCenter
                                                                        horizontalAlignment: Text.AlignHCenter
                                                                        text: Number(props.ifaNominalVelocityField/100).toFixed(props.decimalPoint)
                                                                        onAccepted: {
                                                                            const val = Number(text)
                                                                            if(((val > 0 && val < 1) && !MachineData.measurementUnit)
                                                                                    || ((val > 0 && val < 197) && MachineData.measurementUnit))
                                                                                props.ifaNominalVelocityField = val * 100
                                                                            else{
                                                                                showDialogMessage(qsTr("Quick Field Sensor Calibration"),
                                                                                                  qsTr("Invalid input!"),
                                                                                                  dialogAlert,
                                                                                                  function onCLosed(){
                                                                                                      ifaNomTextField.text = Number(props.ifaNominalVelocityField/100).toFixed(props.decimalPoint)
                                                                                                  })
                                                                            }//

                                                                            props.checkAreParametersValid()
                                                                        }//
                                                                    }//
                                                                    MouseArea{
                                                                        anchors.fill: parent
                                                                        onClicked: {
                                                                            KeyboardOnScreenCaller.openNumpad(ifaNomTextField, qsTr("Nominal Inflow Velocity") + " " + "(%1)".arg(props.velocityUnit))
                                                                        }//
                                                                    }//
                                                                }//
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    TextApp{
                                                                        height: parent.height
                                                                        width: parent.width
                                                                        text: props.velocityUnit
                                                                        verticalAlignment: Text.AlignVCenter
                                                                    }//
                                                                }//
                                                            }//
                                                        }//
                                                    }//
                                                }//
                                                Item{
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true
                                                    Rectangle{
                                                        anchors.fill: parent
                                                        radius: 5
                                                        color: "#80000000"
                                                    }
                                                    ColumnLayout{
                                                        anchors.fill: parent
                                                        anchors.margins: 5
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.minimumHeight: 30
                                                            TextApp{
                                                                height: parent.height
                                                                width: parent.width
                                                                text: qsTr("Nominal Downflow Velocity")
                                                                wrapMode: Text.WordWrap
                                                                verticalAlignment: Text.AlignVCenter
                                                            }
                                                        }
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.fillHeight: true
                                                            RowLayout{
                                                                anchors.fill: parent
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    TextFieldApp{
                                                                        id: dfaNomTextField
                                                                        height: parent.height
                                                                        width: parent.width
                                                                        verticalAlignment: Text.AlignVCenter
                                                                        horizontalAlignment: Text.AlignHCenter
                                                                        text: Number(props.dfaNominalVelocityField/100).toFixed(props.decimalPoint)
                                                                        onAccepted: {
                                                                            const val = Number(text)
                                                                            if(((val > 0 && val < 1) && !MachineData.measurementUnit)
                                                                                    || ((val > 0 && val < 197) && MachineData.measurementUnit))
                                                                                props.dfaNominalVelocityField = val * 100
                                                                            else{
                                                                                showDialogMessage(qsTr("Quick Field Sensor Calibration"),
                                                                                                  qsTr("Invalid input!"),
                                                                                                  dialogAlert,
                                                                                                  function onCLosed(){
                                                                                                      dfaNomTextField.text = Number(props.dfaNominalVelocityField/100).toFixed(props.decimalPoint)
                                                                                                  })
                                                                            }//

                                                                            props.checkAreParametersValid()
                                                                        }//
                                                                    }//
                                                                    MouseArea{
                                                                        anchors.fill: parent
                                                                        onClicked: {
                                                                            KeyboardOnScreenCaller.openNumpad(dfaNomTextField, qsTr("Nominal Downflow Velocity") + " " + "(%1)".arg(props.velocityUnit))
                                                                        }//
                                                                    }//
                                                                }//
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    TextApp{
                                                                        height: parent.height
                                                                        width: parent.width
                                                                        text: props.velocityUnit
                                                                        verticalAlignment: Text.AlignVCenter
                                                                    }//
                                                                }//
                                                            }//
                                                        }//
                                                    }//
                                                }
                                            }
                                        }//
                                        Item{
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Rectangle{
                                                anchors.fill: parent
                                                radius: 5
                                                color: "#80000000"
                                            }
                                            ColumnLayout{
                                                anchors.fill: parent
                                                anchors.margins: 5
                                                spacing: 5
                                                Item{
                                                    Layout.minimumHeight: 50
                                                    Layout.fillWidth: true
                                                    TextApp{
                                                        height: parent.height
                                                        width: parent.width
                                                        text: qsTr("Fan Nominal")
                                                        verticalAlignment: Text.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                }
                                                Item {
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true
                                                    enabled: true
                                                    Rectangle{
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                        width: parent.width
                                                        height: 150
                                                        color: enabled ? "#0F2952" : "transparent"
                                                        border.color: "#e3dac9"
                                                        border.width: 2
                                                        radius: 5

                                                        ColumnLayout {
                                                            anchors.fill: parent
                                                            anchors.margins: 3
                                                            spacing: 1

                                                            Item {
                                                                Layout.fillWidth: true
                                                                Layout.fillHeight: true

                                                                Image {
                                                                    id: fanImage
                                                                    source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                                                    anchors.fill: parent
                                                                    fillMode: Image.PreserveAspectFit

                                                                    states: State {
                                                                        name: "stateOn"
                                                                        when: MachineData.fanPrimaryDutyCycle
                                                                        PropertyChanges {
                                                                            target: fanImage
                                                                            source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                                        }//
                                                                    }//
                                                                }//
                                                            }//

                                                            TextApp {
                                                                padding: 2
                                                                text: "Duty Cycle: " + MachineData.fanPrimaryDutyCycle + " %"
                                                            }//

                                                            TextApp {
                                                                padding: 2
                                                                text: "RPM: " + MachineData.fanPrimaryRpm
                                                            }//
                                                        }//

                                                        MouseArea {
                                                            id: fanSpeedMouseArea
                                                            anchors.fill: parent
                                                        }//

                                                        TextInput {
                                                            id: fanSpeedBufferTextInput
                                                            visible: false
                                                            validator: IntValidator{bottom: 0; top: MachineData.fanSpeedMaxLimit;}

                                                            Connections {
                                                                target: fanSpeedMouseArea

                                                                function onClicked() {
                                                                    fanSpeedBufferTextInput.text = MachineData.fanPrimaryDutyCycle
                                                                    KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                                                }//
                                                            }//

                                                            onAccepted: {
                                                                let val = Number(text)
                                                                if(isNaN(val)) return

                                                                if(val > 60){
                                                                    // Show Warning if more than 60% of ducy
                                                                    showDialogAsk(qsTr("Warning"),
                                                                                  qsTr("The nominal fan speed seems too high!"),
                                                                                  dialogAlert,
                                                                                  function onAccepted(){
                                                                                      props.fanNominalDucyField = val
                                                                                      props.adjustFanDutyCycle(val)
                                                                                  },
                                                                                  function onRejected(){
                                                                                      text = MachineData.fanPrimaryDutyCycle
                                                                                  },
                                                                                  function onCLosed(){
                                                                                      text = MachineData.fanPrimaryDutyCycle
                                                                                  },
                                                                                  true,
                                                                                  5,
                                                                                  qsTr("It's Okay"),//accept
                                                                                  qsTr("Cancel"))//Reject
                                                                }//
                                                                else{
                                                                    props.fanNominalDucyField = val
                                                                    props.adjustFanDutyCycle(val)
                                                                }//
                                                            }//
                                                        }//
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Item{
                                    Layout.fillWidth: true
                                    Layout.minimumHeight: 60
                                    Rectangle{
                                        anchors.fill: parent
                                        radius: 5
                                        color: "#80000000"
                                    }//
                                    TextApp{
                                        text: qsTr("Airflow sensor ADC") + ": %1".arg(props.ifaSensorAdc)
                                        height: parent.height
                                        width: parent.width
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    TextApp{
                                        text:  "* " + qsTr("Please wait until the value stabilizes")
                                        font.pixelSize: 14
                                        color: "#DEB887"
                                    }
                                }//
                            }//
                        }//
                        Component.onCompleted: {
                            props.checkAreParametersValid()
                        }
                    }
                }//

                Component {
                    id: fragmentStartedComp2
                    Item{
                        property string idname: "started2"
                        Rectangle{
                            color: "transparent"
                            radius: 5
                            width: 450
                            height: 280
                            anchors.centerIn: parent
                            ColumnLayout{
                                spacing: 5
                                anchors.fill: parent

                                Item{
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    RowLayout{
                                        anchors.fill: parent
                                        spacing: 5
                                        Item{
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            ColumnLayout{
                                                anchors.fill: parent
                                                spacing: 5
                                                Item{
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true
                                                    Rectangle{
                                                        anchors.fill: parent
                                                        radius: 5
                                                        color: "#80000000"
                                                    }
                                                    ColumnLayout{
                                                        anchors.fill: parent
                                                        anchors.margins: 5
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.minimumHeight: 50
                                                            TextApp{
                                                                height: parent.height
                                                                width: parent.width
                                                                text: qsTr("Minimum Inflow Velocity")
                                                                wrapMode: Text.WordWrap
                                                                verticalAlignment: Text.AlignVCenter
                                                            }
                                                        }
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.fillHeight: true
                                                            RowLayout{
                                                                anchors.fill: parent
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    TextFieldApp{
                                                                        id: ifaMinTextField
                                                                        height: parent.height
                                                                        width: parent.width
                                                                        verticalAlignment: Text.AlignVCenter
                                                                        horizontalAlignment: Text.AlignHCenter
                                                                        text: Number(props.ifaMinimumVelocityField/100).toFixed(props.decimalPoint)
                                                                        onAccepted: {
                                                                            const val = Number(text)
                                                                            if(((val > 0 && val < 1) && !MachineData.measurementUnit)
                                                                                    || ((val > 0 && val < 197) && MachineData.measurementUnit))
                                                                                props.ifaMinimumVelocityField = val * 100
                                                                            else{
                                                                                showDialogMessage(qsTr("Full Field Sensor Calibration"),
                                                                                                  qsTr("Invalid input!"),
                                                                                                  dialogAlert,
                                                                                                  function onCLosed(){
                                                                                                      ifaMinTextField.text = Number(props.ifaMinimumVelocityField/100).toFixed(props.decimalPoint)
                                                                                                  })
                                                                            }//

                                                                            props.checkAreParametersValid()
                                                                        }//
                                                                    }//
                                                                    MouseArea{
                                                                        anchors.fill: parent
                                                                        onClicked: {
                                                                            KeyboardOnScreenCaller.openNumpad(ifaMinTextField, qsTr("Minimum Inflow Velocity") + " " + "(%1)".arg(props.velocityUnit))
                                                                        }//
                                                                    }//
                                                                }//
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    TextApp{
                                                                        height: parent.height
                                                                        width: parent.width
                                                                        text: props.velocityUnit
                                                                        verticalAlignment: Text.AlignVCenter
                                                                    }//
                                                                }//
                                                            }//
                                                        }//
                                                    }//
                                                }//
                                                Item{
                                                    Layout.fillWidth: true
                                                    Layout.fillHeight: true
                                                    Rectangle{
                                                        anchors.fill: parent
                                                        radius: 5
                                                        color: "#80000000"
                                                    }
                                                    ColumnLayout{
                                                        anchors.fill: parent
                                                        anchors.margins: 5
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.minimumHeight: 50
                                                            TextApp{
                                                                height: parent.height
                                                                width: parent.width
                                                                text: qsTr("Inflow Velocity Alarm")
                                                                wrapMode: Text.WordWrap
                                                                verticalAlignment: Text.AlignVCenter
                                                            }
                                                        }
                                                        Item{
                                                            Layout.fillWidth: true
                                                            Layout.fillHeight: true
                                                            RowLayout{
                                                                anchors.fill: parent
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    TextFieldApp{
                                                                        id: ifaAlarmTextField
                                                                        height: parent.height
                                                                        width: parent.width
                                                                        verticalAlignment: Text.AlignVCenter
                                                                        horizontalAlignment: Text.AlignHCenter
                                                                        text: Number(props.ifaAlarmVelocityField/100).toFixed(props.decimalPoint)
                                                                        onAccepted: {
                                                                            const val = Number(text)
                                                                            if(((val > 0 && val < 1) && !MachineData.measurementUnit)
                                                                                    || ((val > 0 && val < 197) && MachineData.measurementUnit))
                                                                                props.ifaAlarmVelocityField = val * 100
                                                                            else{
                                                                                showDialogMessage(qsTr("Full Field Sensor Calibration"),
                                                                                                  qsTr("Invalid input!"),
                                                                                                  dialogAlert,
                                                                                                  function onCLosed(){
                                                                                                      ifaAlarmTextField.text = Number(props.ifaAlarmVelocityField/100).toFixed(props.decimalPoint)
                                                                                                  })
                                                                            }//

                                                                            props.checkAreParametersValid()
                                                                        }//
                                                                    }//
                                                                    MouseArea{
                                                                        anchors.fill: parent
                                                                        onClicked: {
                                                                            KeyboardOnScreenCaller.openNumpad(ifaAlarmTextField, qsTr("Inflow Velocity Alarm") + " " + "(%1)".arg(props.velocityUnit))
                                                                        }//
                                                                    }//
                                                                }//
                                                                Item{
                                                                    Layout.fillWidth: true
                                                                    Layout.fillHeight: true
                                                                    TextApp{
                                                                        height: parent.height
                                                                        width: parent.width
                                                                        text: props.velocityUnit
                                                                        verticalAlignment: Text.AlignVCenter
                                                                    }//
                                                                }//
                                                            }//
                                                        }//
                                                    }//
                                                }//
                                            }//
                                        }//
                                        Item{
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            Rectangle{
                                                anchors.fill: parent
                                                radius: 5
                                                color: "#80000000"
                                            }
                                            ColumnLayout{
                                                anchors.fill: parent
                                                anchors.margins: 5
                                                spacing: 5
                                                Item{
                                                    Layout.minimumHeight: 50
                                                    Layout.fillWidth: true
                                                    TextApp{
                                                        height: parent.height
                                                        width: parent.width
                                                        text: qsTr("Fan Minimum")
                                                        verticalAlignment: Text.AlignVCenter
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                }
                                                Item{
                                                    Layout.fillHeight: true
                                                    Layout.fillWidth: true
                                                    enabled: true
                                                    Rectangle {
                                                        anchors.horizontalCenter: parent.horizontalCenter
                                                        width: parent.width
                                                        height: 150
                                                        color: enabled ? "#0F2952" : "transparent"
                                                        border.color: "#e3dac9"
                                                        border.width: 2
                                                        radius: 5

                                                        ColumnLayout {
                                                            anchors.fill: parent
                                                            anchors.margins: 3
                                                            spacing: 1

                                                            Item {
                                                                Layout.fillWidth: true
                                                                Layout.fillHeight: true

                                                                Image {
                                                                    id: fanImage
                                                                    source: "qrc:/UI/Pictures/controll/Fan_W.png"
                                                                    anchors.fill: parent
                                                                    fillMode: Image.PreserveAspectFit

                                                                    states: State {
                                                                        name: "stateOn"
                                                                        when: MachineData.fanPrimaryDutyCycle
                                                                        PropertyChanges {
                                                                            target: fanImage
                                                                            source: "qrc:/UI/Pictures/controll/Fan_G.png"
                                                                        }//
                                                                    }//
                                                                }//
                                                            }//

                                                            TextApp {
                                                                padding: 2
                                                                text: "Duty Cycle: " + MachineData.fanPrimaryDutyCycle + " %"
                                                            }//

                                                            TextApp {
                                                                padding: 2
                                                                text: "RPM: " + MachineData.fanPrimaryRpm
                                                            }//
                                                        }//

                                                        MouseArea {
                                                            id: fanSpeedMouseArea
                                                            anchors.fill: parent
                                                        }//

                                                        TextInput {
                                                            id: fanSpeedBufferTextInput
                                                            visible: false
                                                            validator: IntValidator{bottom: 0; top: 99;}

                                                            Connections {
                                                                target: fanSpeedMouseArea

                                                                function onClicked() {
                                                                    fanSpeedBufferTextInput.text = MachineData.fanPrimaryDutyCycle
                                                                    KeyboardOnScreenCaller.openNumpad(fanSpeedBufferTextInput, qsTr("Fan Duty Cycle") + " " + "(0-99)")
                                                                }//
                                                            }//

                                                            onAccepted: {
                                                                let val = Number(text)
                                                                if(isNaN(val)) return
                                                                props.fanMinimumDucyField = val
                                                                props.adjustFanDutyCycle(val)
                                                            }//
                                                        }//
                                                    }//
                                                }//
                                            }//
                                        }//
                                    }//
                                }//

                                Item{
                                    Layout.fillWidth: true
                                    Layout.minimumHeight: 60
                                    Rectangle{
                                        anchors.fill: parent
                                        radius: 5
                                        color: "#80000000"
                                    }//
                                    TextApp{
                                        text: qsTr("Airflow sensor ADC") + ": %1".arg(props.ifaSensorAdc)
                                        height: parent.height
                                        width: parent.width
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    TextApp{
                                        text:  "* " + qsTr("Please wait until the value stabilizes")
                                        font.pixelSize: 14
                                        color: "#DEB887"
                                    }
                                }//
                            }//
                        }//

                        Component.onCompleted: {
                            props.checkAreParametersValid()
                        }
                    }
                }//

                Component {
                    id: fragmentStartedComp3
                    Item{
                        property string idname: "started3"

                        property int sashWindowState: MachineData.sashWindowState

                        onSashWindowStateChanged: {
                            //console.debug("onSashWindowStateChanged")
                            props.checkAreParametersValid()
                        }//


                        Column{
                            anchors.centerIn: parent
                            spacing: 5
                            Rectangle {
                                color: "#80000000"
                                radius: 2
                                TextApp {
                                    //id: msgInfoTextApp
                                    text: qsTr("Please position the sash at a standby height!")
                                    verticalAlignment: Text.AlignVCenter
                                    padding: 2
                                    font.pixelSize: 32
                                }
                                width: childrenRect.width
                                height: childrenRect.height
                            }
                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                visible: props.parametersValid
                                color: "#80000000"
                                radius: 2
                                TextApp {
                                    //id: msgInfoTextApp
                                    text: qsTr("Tap on '%1' button to continue.").arg(setButton.text)
                                    verticalAlignment: Text.AlignVCenter
                                    padding: 2
                                }
                                width: childrenRect.width
                                height: childrenRect.height
                            }
                        }//

                        Component.onCompleted: {
                            props.checkAreParametersValid()
                        }
                    }
                }//
                // Stabilizing
                Component {
                    id: fragmentStabilizationComp
                    Item {
                        property string idname: "stabilized"

                        Column {
                            id: parameterColumn
                            anchors.centerIn: parent
                            spacing: 10

                            TextApp {
                                visible: props.calibState != props.calibStateStandby
                                text: qsTr("Stabilizing the ADC value of Airflow Sensor%1").arg(MachineData.inflowSensorConstant === 0 ? (" " + qsTr("(ESCO High-End)")) : "")
                            }//

                            TextApp {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: qsTr("Please wait for %1").arg(utilsApp.strfSecsToHumanReadable((props.calibState != props.calibStateStandby) ? props.timerCountDown : 30)) + ":"
                            }//

                            TextApp {
                                id: waitTimeText
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: 52

                                Component.onCompleted: {
                                    text = utilsApp.strfSecsToMMSS(countTimer.count)
                                }//

                                Timer {
                                    id: countTimer
                                    interval: 1000
                                    running: true; repeat: true
                                    onTriggered: {
                                        if(count > 0) {
                                            count = count - 1
                                            waitTimeText.text = utilsApp.strfSecsToMMSS(countTimer.count)

                                            if(MachineData.sashWindowState !== MachineAPI.SASH_STATE_WORK_SSV && props.calibState != props.calibStateStandby){
                                                props.calibrateDone = false
                                                props.calibrationFailCode = 0x0020 //Sash position has been moved
                                                fragmentStackView.replace(fragmentResultComp)
                                            }
                                        }
                                        else {
                                            running = false

                                            let velocityValid, adcValid, fanValid, calibValid, resultMsg

                                            if(props.calibState == props.calibStateNominal){
                                                props.adcNominalResult = props.adcActual
                                                props.fanNominalDucyField = props.fanDutyCycleActual
                                                props.fanNominalRpmField = props.fanRpmActual
                                                props.temperatureCalib = props.temperatureActual
                                                props.temperatureCalibAdc = props.temperatureAdcActual
                                                props.temperatureCalibStrf = props.temperatureActualStr

                                                velocityValid = (props.ifaNominalVelocityField/100) > 0 ? true : false
                                                adcValid = props.adcNominalResult >= (2*80)
                                                fanValid = ((props.fanNominalDucyField > 0) && (props.fanNominalRpmField > 0))
                                                calibValid = velocityValid && adcValid && fanValid

                                                resultMsg = qsTr("ADC Nominal calibration is done.")
                                                if(!calibValid){
                                                    if(!velocityValid)
                                                        resultMsg = qsTr("Nominal velocity is invalid!")
                                                    if(!adcValid)
                                                        resultMsg = qsTr("ADC Nominal value is invalid!")
                                                    if(!fanValid)
                                                        resultMsg = qsTr("Fan Nominal Duty cycle or RPM is invalid!")
                                                }

                                                showDialogMessage(qsTr("ADC Nominal"),
                                                                  resultMsg,
                                                                  calibValid ? dialogInfo : dialogAlert,
                                                                  function onCLosed(){
                                                                      if(calibValid){
                                                                          props.calibState = props.calibStateMinimum
                                                                          props.adjustFanDutyCycle(props.fanMinimumDucyField)
                                                                          props.checkAreParametersValid()
                                                                          fragmentStackView.replace(fragmentStartedComp2)
                                                                      }else{
                                                                          props.checkAreParametersValid()
                                                                          fragmentStackView.replace(fragmentStartedComp1)
                                                                      }
                                                                  },
                                                                  false)
                                                return
                                            }
                                            else if(props.calibState == props.calibStateMinimum){
                                                props.adcMinimumResult = props.adcActual
                                                props.fanMinimumDucyField = props.fanDutyCycleActual
                                                props.fanMinimumRpmField = props.fanRpmActual

                                                velocityValid = (((props.ifaNominalVelocityField/100) > (props.ifaMinimumVelocityField/100))
                                                                 && (props.ifaMinimumVelocityField/100) > 0) ? true : false
                                                adcValid = (props.adcMinimumResult >= 80) && (props.adcNominalResult >= (props.adcMinimumResult + 80))
                                                fanValid = (props.fanMinimumDucyField > 0
                                                            && props.fanMinimumDucyField < props.fanNominalDucyField
                                                            && props.fanMinimumRpmField > 0
                                                            && props.fanMinimumRpmField < props.fanNominalRpmField)
                                                calibValid = velocityValid && adcValid && fanValid

                                                resultMsg = qsTr("ADC Minimum calibration is done.")
                                                if(!calibValid){
                                                    if(!velocityValid)
                                                        resultMsg = qsTr("Minimum velocity is invalid!")
                                                    if(!adcValid)
                                                        resultMsg = qsTr("ADC Minimum value is invalid!")
                                                    if(!fanValid)
                                                        resultMsg = qsTr("Fan Minimum Duty cycle or RPM is invalid!")
                                                }

                                                showDialogMessage(qsTr("ADC Minimum"),
                                                                  resultMsg,
                                                                  calibValid ? dialogInfo : dialogAlert,
                                                                  function onCLosed(){
                                                                      if(calibValid){
                                                                          props.calibState = props.calibStateStandby
                                                                          /// Fan Standby = 30% of Nominal Fan
                                                                          props.fanStandbyDucyField = Math.round((Number(props.fanStandbyDucyFactPercentNom/100)*props.fanNominalDucyField))
                                                                          props.adjustFanDutyCycle(props.fanStandbyDucyField)
                                                                          props.checkAreParametersValid()
                                                                          fragmentStackView.replace(fragmentStartedComp3)
                                                                      }else{
                                                                          props.checkAreParametersValid()
                                                                          fragmentStackView.replace(fragmentStartedComp2)
                                                                      }
                                                                  },
                                                                  false)
                                                return
                                            }//
                                            else if(props.calibState == props.calibStateStandby){
                                                props.fanStandbyDucyField = props.fanDutyCycleActual
                                                props.fanStandbyRpmField = props.fanRpmActual

                                                fanValid = (props.fanStandbyDucyField > 0
                                                            && props.fanStandbyDucyField < props.fanMinimumDucyField
                                                            && props.fanMinimumDucyField < props.fanNominalDucyField
                                                            && props.fanStandbyRpmField > 0
                                                            && props.fanStandbyRpmField < props.fanMinimumRpmField
                                                            && props.fanMinimumRpmField < props.fanNominalRpmField)
                                                calibValid = fanValid

                                                if (calibValid) {
                                                    props.calibrateDone = true
                                                }else{
                                                    if(!fanValid)
                                                        props.calibrationFailCode = 0x0001
                                                }//

                                                fragmentStackView.replace(fragmentResultComp)
                                            }//
                                        }//
                                    }//

                                    //property int count: 2
                                    property int count: (props.calibState != props.calibStateStandby) ? props.timerCountDown : 30
                                }//
                            }//

                            Row {
                                visible: props.calibState != props.calibStateStandby
                                anchors.horizontalCenter: parent.horizontalCenter
                                spacing: 10
                                TextApp{
                                    font.pixelSize: 18
                                    text: qsTr("Actual ADC") + ":"
                                    color: "#cccccc"
                                }//

                                TextApp{
                                    font.pixelSize: 18
                                    text: props.adcActual
                                    color: "#cccccc"
                                }//
                            }//
                        }//

                        UtilsApp {
                            id: utilsApp
                        }//

                        Component.onCompleted: {
                            props.parametersValid = false
                            props.calibWaitTime = true
                            console.debug("Component.onCompleted")
                        }
                        Component.onDestruction: {
                            props.calibWaitTime = false
                            console.debug("Component.onDestruction")
                        }
                    }//
                }//

                // Result
                Component {
                    id: fragmentResultComp

                    Item {
                        property string idname: "result"

                        RowLayout {
                            anchors.fill: parent

                            Item {
                                Layout.fillHeight: true
                                Layout.fillWidth: true

                                Flickable {
                                    id: resultDetailFlickable
                                    anchors.centerIn: parent
                                    height: Math.min(parent.height, resultDetailColumn.height)
                                    width: Math.min(parent.width, resultDetailColumn.width)
                                    clip: true

                                    contentWidth: resultDetailColumn.width
                                    contentHeight: resultDetailColumn.height

                                    ScrollBar.vertical: verticalScrollBar.scrollBar

                                    Column {
                                        id: resultDetailColumn
                                        spacing: 2

                                        Row{
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            Image {
                                                id: featureImage
                                                height: 100
                                                fillMode: Image.PreserveAspectFit
                                                source: "qrc:/UI/Pictures/done-green-white.png"
                                            }//

                                            TextApp{
                                                id: resultStattusText
                                                anchors.verticalCenter: parent.verticalCenter
                                                font.bold: true
                                                text: qsTr("Done")
                                            }//
                                        }

                                        TextApp{
                                            id: resultiInfoText
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: 400
                                            wrapMode: Text.WordWrap
                                            visible: false
                                            color: "#ff0000"
                                            padding: 5

                                            Rectangle {
                                                z: -1
                                                anchors.fill: parent
                                                radius: 5
                                                opacity: 0.5
                                            }
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: fanNomCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Fan Nominal") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.fanNominalDucyField + "% | " + props.fanNominalRpmField + " RPM"
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: fanMinCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Fan Minimum") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.fanMinimumDucyField + "% | " + props.fanMinimumRpmField + " RPM"
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: fanStbCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Fan Standby") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.fanStandbyDucyField + "% | " + props.fanStandbyRpmField + " RPM"
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Nominal Inflow Velocity") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + (props.ifaNominalVelocityField/100).toFixed(props.decimalPoint) + " " + props.velocityUnit
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Minimum Inflow Velocity") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + (props.ifaMinimumVelocityField/100).toFixed(props.decimalPoint) + " " + props.velocityUnit
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Inflow Velocity Alarm") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + (props.ifaAlarmVelocityField/100).toFixed(props.decimalPoint) + " " + props.velocityUnit
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row{
                                            TextApp{
                                                width: 300
                                                text: qsTr("Nominal Downflow Velocity") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + (props.dfaNominalVelocityField/100).toFixed(props.decimalPoint) + " " + props.velocityUnit
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC Nominal") + " (IFN)" //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.adcNominalResult
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            TextApp{
                                                width: 300
                                                text: qsTr("ADC Minimum") + " (IFF)" //+ ":"
                                            }//

                                            TextApp {
                                                text: ": " + props.adcMinimumResult
                                            }
                                        }

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}

                                        Row {
                                            id: temperatureCalibRow

                                            TextApp{
                                                width: 300
                                                text: qsTr("Temperature Calibration") //+ ":"
                                            }//

                                            TextApp {
                                                text: ": %1 | ADC: %2".arg(props.temperatureCalibStrf).arg(props.temperatureCalibAdc)
                                            }//
                                        }//

                                        Rectangle {height: 1; width: parent.width; color: "#cccccc"}
                                    }//
                                }//
                            }//

                            ScrollBarApp {
                                id: verticalScrollBar
                                Layout.fillHeight: true
                                Layout.fillWidth: false
                                Layout.minimumWidth: 20
                                visible: resultDetailFlickable.contentHeight > resultDetailFlickable.height
                            }//
                        }//

                        Component.onCompleted: {
                            props.calibResult = true
                            if (!props.calibrateDone){
                                featureImage.source = "qrc:/UI/Pictures/fail-red-white.png"
                                resultStattusText.text = qsTr("Failed")
                                resultiInfoText.visible = true
                                if(props.calibrationFailCode === 0x0001)
                                    resultiInfoText.text = qsTr("Fan Standby Duty cycle or RPM is invalid!")
                                //                                else if(props.calibrationFailCode === 0x0002)
                                //                                    resultiInfoText.text = qsTr("The ADC value is invalid!")
                                //                                else if(props.calibrationFailCode === 0x0004)
                                //                                    resultiInfoText.text = qsTr("The Velocity is invalid!")
                                //                                else if(props.calibrationFailCode === 0x0008)
                                //                                    resultiInfoText.text = qsTr("The Fan duty cycle is invalid!")
                                //                                else if(props.calibrationFailCode === 0x0010)
                                //                                    resultiInfoText.text = qsTr("The Fan RPM is invalid!")
                                //                                else if(props.calibrationFailCode === 0x0020)
                                //                                    resultiInfoText.text = qsTr("The Sash height is not at working height position!")
                            }//
                            else {
                                backButton.text = qsTr("Done")
                                props.saveCalibrationData()
                            }
                        }//
                        Component.onDestruction: {
                            props.calibResult = false
                            console.debug("Component.onDestruction")
                        }
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
                            id: backButton
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter

                            imageSource: "qrc:/UI/Pictures/back-step.png"
                            text: qsTr("Back")

                            onClicked: {
                                if (fragmentStackView.currentItem.idname === "stabilized"){

                                    viewApp.showDialogAsk(qsTr("Notification"),
                                                          qsTr("Cancel this process?"),
                                                          viewApp.dialogAlert,
                                                          function onAccepted(){
                                                              //                                                              ////console.debug("Y")
                                                              var intent = IntentApp.create(uri, {})
                                                              finishView(intent)
                                                          })

                                    return
                                }
                                if (fragmentStackView.currentItem.idname === "started1"
                                        || fragmentStackView.currentItem.idname === "started2"
                                        || fragmentStackView.currentItem.idname === "started3"){

                                    viewApp.showDialogAsk(qsTr("Notification"),
                                                          qsTr("Cancel this process?"),
                                                          viewApp.dialogAlert,
                                                          function onAccepted(){
                                                              //                                                              ////console.debug("Y")
                                                              var intent = IntentApp.create(uri, {})
                                                              finishView(intent)
                                                          })

                                    return
                                }

                                if (fragmentStackView.currentItem.idname === "result"){
                                    if(props.calibrateDone) {
                                        let intent = IntentApp.create(uri,
                                                                      {
                                                                          "pid": props.pid,
                                                                      })
                                        finishView(intent);
                                        //let intent = IntentApp.create(uri,
                                        //                              {
                                        //                                  "pid": props.pid,
                                        //                                  "sensorAdcNominal": props.adcNominalResult,
                                        //                                  "sensorVelNominal": props.velocity,
                                        //                                  "sensorVelNominalDfa": props.velocityDfaNom,
                                        //                                  "sensorAdcMinimum": props.adcMinimumResult,
                                        //                                  "fanDutyCycleResult": props.fanDutyCycleResult,
                                        //                                  "fanRpmResult": props.fanRpmResult,
                                        //                                  "temperatureCalib": props.temperatureCalib,
                                        //                                  "temperatureCalibAdc": props.temperatureCalibAdc
                                        //                              })
                                        //finishView(intent);
                                        return
                                    }
                                }

                                var intent = IntentApp.create(uri, {})
                                finishView(intent)
                            }
                        }//

                        ButtonBarApp {
                            id: setButton
                            visible: props.parametersValid
                            width: 194
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right

                            imageSource: "qrc:/UI/Pictures/start_small.png"
                            text: props.calibState != props.calibStateStandby ? qsTr("Start ADC Calibration") : qsTr("Start")

                            onClicked: {
                                fragmentStackView.replace(fragmentStabilizationComp)
                            }//
                        }//
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property string pid: ""

            property int fanNominalDucyField: 0
            property int fanMinimumDucyField: 0
            property int fanStandbyDucyField: 0
            property int fanNominalRpmField: 0
            property int fanMinimumRpmField: 0
            property int fanStandbyRpmField: 0

            property int fanStandbyDucyFactPercentNom: 0

            property int ifaNominalVelocityField: 0
            property int dfaNominalVelocityField: 0
            property int ifaMinimumVelocityField: 0
            property int ifaAlarmVelocityField: 0
            property int dfaMinimumVelocityField: 0

            property int ifaSensorAdcMin: 0
            property int ifaSensorAdcNom: 0

            /// 0: metric, m/s
            /// 1: imperial, fpm
            property int measureUnit: MachineData.measurementUnit
            property int decimalPoint: measureUnit ? 0 : 2
            property string velocityUnit: measureUnit ? "fpm" : "m/s"

            property bool parametersValid: false

            property int fanPrimaryRpm: 0
            property int ifaSensorAdc: 0

            property int fanDutyCycleActual: 0
            property int fanRpmActual: 0

            property int sensorAdcZero: 0

            property int temperatureActual: 0
            property int temperatureAdcActual: 0
            property string temperatureActualStr: "0°C"

            // Required for interpolation formula
            // a - ((x2 - x1) / (y2 - y1) * (b - y1))
            // IFF = newNomAdc - ((velocityNomAdcRef - velocityMinAdcRef) / (velocityNomRef - velocityMinRef) * (newNomVelocity - velocityMinRef))
            property real velocityNomAdcRef: 0
            property real velocityNomRef: 0
            //
            property real velocityMinAdcRef: 0
            property real velocityMinRef: 0

            property int fanDutyCycleInitial: 0
            property int fanDutyCycleResult: 0
            property int fanRpmResult: 0

            property int temperatureCalib: 0
            property int temperatureCalibAdc: 0
            property string temperatureCalibStrf: ""

            property bool calibrateDone: false
            property int calibrationFailCode: 0

            property int timerCountDownDivider: __osplatform__ ? 1 : 2
            property int timerCountDown: (MachineData.inflowSensorConstant === 0 ? 60 : 180)/timerCountDownDivider
            property int adcActual: 0
            property int adcNominalResult: 0
            property int adcMinimumResult: 0

            property int calibState: 0
            readonly property int calibStateNominal: 0
            readonly property int calibStateMinimum: 1
            readonly property int calibStateStandby: 2

            property bool calibWaitTime: false
            property bool calibResult: false


            onFanPrimaryRpmChanged: {
                checkAreParametersValid()
            }
            onIfaSensorAdcChanged: {
                checkAreParametersValid()
            }

            function checkAreParametersValid(){
                //                if(fragmentStackView.currentItem) return
                //                if(fragmentStackView.currentItem.idname === "stabilized")
                //                    parametersValid = false
                //                else{
                if(calibWaitTime || calibResult) {
                    parametersValid = false
                    return
                }
                if(props.calibState == calibStateNominal){
                    parametersValid = ((ifaNominalVelocityField > 0)
                                       && (dfaNominalVelocityField > 0)
                                       && (MachineData.fanPrimaryRpm > 0)
                                       && (fanNominalDucyField > 0)
                                       && (ifaSensorAdc >= (2*80)))
                }//
                else if (props.calibState == calibStateMinimum){
                    parametersValid = ((ifaMinimumVelocityField > 0) && (ifaMinimumVelocityField < ifaNominalVelocityField)
                                       && (ifaAlarmVelocityField > 0) && (ifaAlarmVelocityField < ifaNominalVelocityField)
                                       && (MachineData.fanPrimaryRpm > 0)
                                       && (MachineData.fanPrimaryRpm < fanNominalRpmField)
                                       && (fanMinimumDucyField > 0) && (fanMinimumDucyField < fanNominalDucyField)
                                       && (ifaSensorAdc <= (adcNominalResult-80)))
                }//
                else if(props.calibState == calibStateStandby){
                    parametersValid = ((MachineData.fanPrimaryRpm > 0
                                        && MachineData.fanPrimaryRpm < fanMinimumRpmField
                                        && (fanStandbyDucyField > 0) && (fanStandbyDucyField < fanMinimumDucyField)
                                        && ifaSensorAdc > 0)
                                       && (MachineData.sashWindowState === MachineAPI.SASH_STATE_STANDBY_SSV))
                }//
                //                }
            }//

            function adjustFanDutyCycle(fanSpeed){
                if (MachineData.fanPrimaryDutyCycle !== fanSpeed) {

                    MachineAPI.setFanPrimaryDutyCycle(fanSpeed);

                    viewApp.showBusyPage(qsTr("Adjusting fan duty cycle..."),
                                         function onTriggered(cycle){
                                             if(cycle >= MachineAPI.BUSY_CYCLE_1){
                                                 props.checkAreParametersValid()
                                                 // close this pop up dialog
                                                 viewApp.dialogObject.close()
                                             }
                                         })
                }//
            }//

            function saveCalibrationData(){
                MachineAPI.setInflowAdcPointField(0, props.adcMinimumResult, props.adcNominalResult)
                MachineAPI.setInflowVelocityPointField(0, props.ifaMinimumVelocityField, props.ifaNominalVelocityField)
                MachineAPI.setDownflowVelocityPointField(0, 0, props.dfaNominalVelocityField)

                MachineAPI.setInflowLowLimitVelocity(props.ifaAlarmVelocityField)

                MachineAPI.setInflowTemperatureCalib(props.temperatureCalib, props.temperatureCalibAdc)

                MachineAPI.setFanPrimaryNominalDutyCycleField(props.fanNominalDucyField)
                MachineAPI.setFanPrimaryMinimumDutyCycleField(props.fanMinimumDucyField)
                MachineAPI.setFanPrimaryStandbyDutyCycleField(props.fanStandbyDucyField)

                MachineAPI.setFanPrimaryNominalRpmField(props.fanNominalRpmField)
                MachineAPI.setFanPrimaryMinimumRpmField(props.fanMinimumRpmField)
                MachineAPI.setFanPrimaryStandbyRpmField(props.fanStandbyRpmField)

                MachineAPI.initAirflowCalibrationStatus(MachineAPI.AF_CALIB_FIELD);

                ///EVENT LOG
                const message = qsTr("User: Field sensor calibration")
                              + " ("
                              + "ADC-IFF: " + props.adcMinimumResult + ", "
                              + "ADC-IFN: " + props.adcNominalResult + ", "
                              + "VEL-IFF: " + (props.ifaMinimumVelocityField/100).toFixed(props.decimalPoint) + ", "
                              + "VEL-IFN: " + (props.ifaNominalVelocityField/100).toFixed(props.decimalPoint) + ", "
                              + "VEL-DFN: " + (props.dfaNominalVelocityField/100).toFixed(props.decimalPoint)
                              + ")"
                MachineAPI.insertEventLog(message);

                viewApp.showBusyPage(qsTr("Setting up..."), function(cycle){
                    if (cycle >= MachineAPI.BUSY_CYCLE_1) {
                        closeDialog()
                    }//
                })//
            }//
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            props.fanPrimaryRpm = Qt.binding(function(){return MachineData.fanPrimaryRpm})
            props.ifaSensorAdc = Qt.binding(function(){return MachineData.ifaAdcConpensation})
        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                let extradata = IntentApp.getExtraData(intent)
                props.pid = extradata['pid']

                //                    ////console.debug("StackView.Active");
                if(MachineData.airflowCalibrationStatus === MachineAPI.AF_CALIB_FIELD){
                    props.fanNominalDucyField = MachineData.getFanPrimaryNominalDutyCycleField()
                    props.fanMinimumDucyField = MachineData.getFanPrimaryMinimumDutyCycleField()
                    props.fanStandbyDucyField = MachineData.getFanPrimaryStandbyDutyCycleField()
                    props.fanNominalRpmField  = MachineData.getFanPrimaryNominalRpmField()
                    props.fanMinimumRpmField  = MachineData.getFanPrimaryMinimumRpmField()
                    props.fanStandbyRpmField  = MachineData.getFanPrimaryStandbyRpmField()

                    props.ifaNominalVelocityField = MachineData.getInflowVelocityPointField(MachineAPI.POINT_NOMINAL)
                    props.ifaMinimumVelocityField = MachineData.getInflowVelocityPointField(MachineAPI.POINT_MINIMUM)
                    props.dfaNominalVelocityField = MachineData.getDownflowVelocityPointField(MachineAPI.POINT_NOMINAL)

                    props.ifaSensorAdcMin = MachineData.getInflowAdcPointField(MachineAPI.POINT_MINIMUM)
                    props.ifaSensorAdcNom = MachineData.getInflowAdcPointField(MachineAPI.POINT_NOMINAL)
                }else{
                    props.fanNominalDucyField = MachineData.getFanPrimaryNominalDutyCycleFactory()
                    props.fanMinimumDucyField = MachineData.getFanPrimaryMinimumDutyCycleFactory()
                    props.fanStandbyDucyField = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                    props.fanNominalRpmField  = MachineData.getFanPrimaryNominalRpmFactory()
                    props.fanMinimumRpmField  = MachineData.getFanPrimaryMinimumRpmFactory()
                    props.fanStandbyRpmField  = MachineData.getFanPrimaryStandbyRpmFactory()

                    props.ifaNominalVelocityField = MachineData.getInflowVelocityPointFactory(MachineAPI.POINT_NOMINAL)
                    props.ifaMinimumVelocityField = MachineData.getInflowVelocityPointFactory(MachineAPI.POINT_MINIMUM)
                    props.dfaNominalVelocityField = MachineData.getDownflowVelocityPointFactory(MachineAPI.POINT_NOMINAL)

                    props.ifaSensorAdcMin = MachineData.getInflowAdcPointFactory(MachineAPI.POINT_MINIMUM)
                    props.ifaSensorAdcNom = MachineData.getInflowAdcPointFactory(MachineAPI.POINT_NOMINAL)
                }//

                const stbFactoryDucy = MachineData.getFanPrimaryStandbyDutyCycleFactory()
                const nomFactoryDucy = MachineData.getFanPrimaryNominalDutyCycleFactory()
                if(!stbFactoryDucy && !nomFactoryDucy){
                    props.fanStandbyDucyFactPercentNom = Math.round(Number(stbFactoryDucy/nomFactoryDucy)*100)
                }else{
                    props.fanStandbyDucyFactPercentNom = 30
                }

                props.ifaAlarmVelocityField   = props.ifaMinimumVelocityField
                {
                    //                    let velocity = props.ifaNominalVelocityField/100
                    //                    props.velocity = velocity
                    //                    props.velocityStrf = velocity.toFixed(props.decimalPoint)

                    //                    let velocityDfaNominal = props.dfaNominalVelocityField/100
                    //                    props.velocityDfaNom = velocityDfaNominal
                    //                    props.velocityDfaNomStrf = velocityDfaNominal.toFixed(props.decimalPoint)

                    /// Ref. for interpolation
                    let velocityNomAdcRef = props.ifaSensorAdcNom
                    //                        ////console.debug(velocityNomAdcRef)
                    props.velocityNomAdcRef = velocityNomAdcRef

                    let velocityNomRef = props.ifaNominalVelocityField/100
                    //                        ////console.debug(velocityNomRef)
                    props.velocityNomRef = velocityNomRef

                    let velocityMinAdcRef = props.ifaSensorAdcMin
                    //                        ////console.debug(velocityMinAdcRef)
                    props.velocityMinAdcRef = velocityMinAdcRef

                    let velocityMinRef = props.ifaMinimumVelocityField/100
                    //                        ////console.debug(velocityMinRef)
                    props.velocityMinRef = velocityMinRef
                }


                /// Real-Time update
                props.fanDutyCycleActual = Qt.binding(function(){ return MachineData.fanPrimaryDutyCycle })
                props.fanRpmActual = Qt.binding(function(){ return MachineData.fanPrimaryRpm })
                //
                props.adcActual = Qt.binding(function(){ return MachineData.ifaAdcConpensation })
                //
                props.temperatureActual = Qt.binding(function(){ return MachineData.temperature })
                props.temperatureAdcActual = Qt.binding(function(){ return MachineData.temperatureAdc })
                props.temperatureActualStr = Qt.binding(function(){ return MachineData.temperatureValueStr })


                //ifaNomTextField.text = Number(props.ifaNominalVelocityField/100).toFixed(props.decimalPoint)
                //dfaNomTextField.text = Number(props.dfaNominalVelocityField/100).toFixed(props.decimalPoint)

                props.adjustFanDutyCycle(props.fanNominalDucyField)

                if(MachineData.installationWizardActive){
                    viewApp.enabledSwipedFromLeftEdge   = false
                    //viewApp.enabledSwipedFromRightEdge  = false
                    viewApp.enabledSwipedFromBottomEdge = false
                }//

                props.checkAreParametersValid()
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

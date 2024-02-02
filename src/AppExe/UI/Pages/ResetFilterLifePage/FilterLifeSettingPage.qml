import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Filter Life Settings"

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
                    title: qsTr("Filter Life Settings")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Column{
                    anchors.centerIn: parent
                    spacing: 10
                    Row{
                        spacing: 5
                        TextApp{
                            width: 260
                            height: 50
                            text: qsTr("Filter Life calculated by")
                            verticalAlignment: Text.AlignVCenter
                        }
                        ComboBoxApp {
                            id: comboBox
                            width: 200
                            height: 50
                            backgroundColor: "#0F2952"
                            backgroundBorderColor: "#dddddd"
                            backgroundBorderWidth: 2
                            font.pixelSize: 20
                            anchors.verticalCenter: parent.verticalCenter
                            textRole: "text"

                            model: [
                                {text: qsTr("Fan usage"),   value: MachineAPI.FilterLifeCalc_BlowerUsage},
                                {text: qsTr("Fan RPM"),     value: MachineAPI.FilterLifeCalc_BlowerRpm}
                            ]

                            onActivated: {
                                //////console.debug(index)
                                //////console.debug(model[index].value)
                                let newValue = model[index].value
                                if(MachineData.filterLifeCalculationMode !== newValue){
                                    //props.elsIsEnabled = newValue

                                    MachineAPI.setFilterLifeCalculationMode(newValue)
                                    MachineAPI.insertEventLog(qsTr("User: Set filter life calculation mode (%1)").arg(model[index].text))

                                    //                                    var string = newValue ? qsTr("Enabling") : qsTr("Disabling")
                                    //                                    const busyText = string + " " + qsTr("Esco Lock Service")
                                    MachineAPI.insertEventLog(qsTr("Set filter life calculation mode to %1").arg(model[index].text))
                                    viewApp.showBusyPage("Please wait...",
                                                         function onTriggered(cycle){
                                                             if(cycle >= MachineAPI.BUSY_CYCLE_1
                                                                     || MachineData.filterLifeCalculationMode === newValue){
                                                                 comboBox.currentIndex = MachineData.filterLifeCalculationMode
                                                                 viewApp.dialogObject.close()}
                                                         })//
                                }//
                            }//

                            Component.onCompleted: {
                                currentIndex = MachineData.filterLifeCalculationMode
                            }
                        }//
                    }//
                    Row{
                        spacing: 5
                        TextApp{
                            id: minText
                            width: 260
                            height: 50
                            text: qsTr("Value when filter life 100%")
                            verticalAlignment: Text.AlignVCenter
                        }
                        TextFieldApp {
                            id: minTextField
                            width: 200
                            height: 50
                            validator: IntValidator{bottom: 0; top: props.rpmMode ? 1500: 10000}
                            text: props.rpmMode ? MachineData.filterLifeMinimumBlowerRpmMode
                                                : (MachineData.filterLifeMaximumBlowerUsageMode/60)

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, minText.text)
                            }//

                            onAccepted: {
                                const value = Number(text)
                                if(props.rpmMode){
                                    MachineAPI.setFilterLifeMinimumBlowerRpmMode(value)
                                    MachineAPI.insertEventLog(qsTr("User: Set 'RPM' when filter life 100% (%1)").arg(value))
                                }
                                else{
                                    MachineAPI.setFilterLifeMaximumBlowerUsageMode(value)
                                    MachineAPI.insertEventLog(qsTr("User: Set 'hours left' when filter life 100% (%1)").arg(value))
                                }
                            }//
                            //                            Component.onCompleted: {
                            //                                if(MachineData.filterLifeCalculationMode == MachineAPI.FilterLifeCalc_BlowerRpm)
                            //                                    text = MachineData.filterLifeMinimumBlowerRpmMode
                            //                                else
                            //                                    text = MachineData.filterLifeMaximumBlowerUsageMode/60
                            //                            }//
                        }//
                        TextApp{
                            height: 50
                            text: props.rpmMode ?  qsTr("RPM")
                                                : qsTr("hours left")
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                    Row{
                        spacing: 5
                        TextApp{
                            id: maxText
                            width: 260
                            height: 50
                            text: qsTr("Value when filter life 0%")
                            verticalAlignment: Text.AlignVCenter
                        }
                        TextFieldApp {
                            id: axTextField
                            width: 200
                            height: 50
                            validator: IntValidator{bottom: 0; top: props.rpmMode ? 1500: 10000}
                            text: props.rpmMode ? MachineData.filterLifeMaximumBlowerRpmMode : (MachineData.filterLifeMinimumBlowerUsageMode/60)

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, maxText.text)
                            }//

                            onAccepted: {
                                const value = Number(text)
                                if(props.rpmMode){
                                    MachineAPI.setFilterLifeMaximumBlowerRpmMode(value)
                                    MachineAPI.insertEventLog(qsTr("User: Set 'RPM' when filter life 0% (%1)").arg(value))
                                }
                                else{
                                    MachineAPI.setFilterLifeMinimumBlowerUsageMode(value)
                                    MachineAPI.insertEventLog(qsTr("User: Set 'hours left' when filter life 0% (%1)").arg(value))
                                }
                            }//
                            //                            Component.onCompleted: {
                            //                                if(MachineData.filterLifeCalculationMode == MachineAPI.FilterLifeCalc_BlowerRpm)
                            //                                    text = MachineData.filterLifeMaximumBlowerRpmMode
                            //                                else
                            //                                    text = MachineData.filterLifeMinimumBlowerUsageMode/60
                            //                            }//
                        }//
                        TextApp{
                            height: 50
                            text: props.rpmMode ?  qsTr("RPM") : qsTr("hours left")
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }//

                CheckBox {
                    id: policyCheckBox
                    text :qsTr("Display filter life on home screen")
                    height: 30//parent.height
                    font.pixelSize: 20
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.rightMargin: 40
                    anchors.bottomMargin: 10
                    checked: MachineData.filterLifeDisplayEnabled

                    visible: UserSessionService.roleLevel >= UserSessionService.roleLevelAdmin

                    contentItem: Text {
                        text: policyCheckBox.text
                        font: policyCheckBox.font
                        opacity: enabled ? 1.0 : 0.3
                        color: "#e3dac9"
                        verticalAlignment: Text.AlignVCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                    }//

                    onCheckedChanged: {
                        MachineAPI.setFilterLifeDisplayEnabled(checked)
                        MachineAPI.insertEventLog(qsTr("User: Display filter life on home screen") + " = " + (checked ? qsTr("Enable") : qsTr("Disable")))
                    }
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
                    }//
                }//
            }//
        }//

        ///// Put all private property inside here
        ///// if none, please comment this block to optimize the code
        QtObject {
            id: props

            property bool rpmMode: false
            //            property int count: 50
        }//

        /// One time executed after onResume
        Component.onCompleted: {

        }//

        /// Execute This Every This Screen Active/Visible
        executeOnPageVisible: QtObject {

            /// onResume
            Component.onCompleted: {
                //                    ////console.debug("StackView.Active");

                props.rpmMode = Qt.binding(function(){return MachineData.filterLifeCalculationMode == MachineAPI.FilterLifeCalc_BlowerRpm})
            }

            /// onPause
            Component.onDestruction: {
                //////console.debug("StackView.DeActivating");
            }
        }//
    }//
}//

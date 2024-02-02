import QtQuick 2.12
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.7

import UI.CusCom 1.1
import "../../../CusCom/JS/IntentApp.js" as IntentApp

import ModulesCpp.Machine 1.0

ViewApp {
    id: viewApp
    title: "Field Sensor Calibration"

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
                    title: qsTr("Field Sensor Calibration")
                }
            }

            /// BODY
            Item {
                id: bodyItem
                Layout.fillWidth: true
                Layout.fillHeight: true

                Row{
                    spacing: 100
                    anchors.centerIn: parent
                    Column{
                        spacing: 10
                        Image{
                            opacity: quickField.pressed ? 0.5 : 1
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/UI/Pictures/menu/Calibrate-Sensor.png"
                            MouseArea{
                                id: quickField
                                anchors.fill: parent
                                onClicked: {
                                    var intent = IntentApp.create("qrc:/UI/Pages/FieldCalibratePage/Basic/QuickFieldCalibration.qml",
                                                                  {
                                                                      "pid": "quick"
                                                                  })
                                    startView(intent)
                                }
                            }
                        }
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Quick-Field Sensor Calibration")
                        }
                    }
                    Column{
                        spacing: 10
                        Image{
                            opacity: fullField.pressed ? 0.5 : 1
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: "qrc:/UI/Pictures/menu/Calibrate-Sensor.png"
                            MouseArea{
                                id: fullField
                                anchors.fill: parent
                                onClicked: {
                                    var intent = IntentApp.create("qrc:/UI/Pages/FieldCalibratePage/Basic/FullFieldCalibration.qml",
                                                                  {
                                                                      "pid": "full"
                                                                  })
                                    startView(intent)
                                }
                            }
                        }
                        TextApp{
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Full-Field Sensor Calibration")
                        }
                    }
                }
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

            property int countDefault: 50
            property int count: 50
        }//

        /// One time executed after onResume
        Component.onCompleted: {
            MachineAPI.setOperationMaintenanceMode();
            if(!MachineData.lightState){
                MachineAPI.setLightState(MachineAPI.DIG_STATE_ONE)
            }
        }//

        /// Execute This Every This Screen Active/Visible
        Loader {
            active: viewApp.stackViewStatusForeground
            sourceComponent: Item {

                /// onResume
                Component.onCompleted: {
                    //////console.debug("StackView.Active-" + viewApp.uri);
                    if(MachineData.installationWizardActive){
                        viewApp.enabledSwipedFromLeftEdge   = false
                        //viewApp.enabledSwipedFromRightEdge  = false
                        viewApp.enabledSwipedFromBottomEdge = false
                    }//
                }//

                /// onPause
                Component.onDestruction: {
                    //////console.debug("StackView.DeActivating");
                }

                Connections{
                    target: viewApp

                    function onFinishViewReturned(intent){
                        //////console.debug("onFinishViewReturned-" + viewApp.uri)

                        let extradata = IntentApp.getExtraData(intent)

                        if (extradata['pid'] === 'quick'){
                            //console.debug("QUICKKKK")

                            let intent1 = IntentApp.create("qrc:/UI/Pages/FieldCalibratePage/Basic/_CalibrationFinishedPage.qml",
                                                           {})
                            finishView(intent1)

                        }//
                        if (extradata['pid'] === 'full'){
                            //console.debug("FULLLL")

                            let intent1 = IntentApp.create("qrc:/UI/Pages/FieldCalibratePage/Basic/_CalibrationFinishedPage.qml",
                                                           {})
                            finishView(intent1)
                        }//
                    }//
                }//
            }//
        }//
    }//
}//

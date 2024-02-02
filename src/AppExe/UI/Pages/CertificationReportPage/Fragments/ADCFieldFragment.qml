import QtQuick 2.0
import UI.CusCom 1.1

import Qt.labs.settings 1.1

import ModulesCpp.Machine 1.0

Item {


    Column {
        anchors.centerIn: parent
        spacing: 5

        //        Column {
        //            TextApp {
        //                text: qsTr("Sensor (VDC): Tap and type the value from Volt Meter!")
        //            }//
        //            //            TextApp {
        //            //                text: qsTr("ADC Actual (IFA): Ensure blower is ON, then press it to re-capturing!")
        //            //            }//
        //        }//

        //        Rectangle {
        //            width: parent.width
        //            height: 1
        //            color: "#e3dac9"
        //        }//

        Grid{
            spacing: 10

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Sensor") + "<br>" + "(VDC)"
                    }//

                    TextFieldApp {
                        id: sensorVoltageTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: Number(MachineData.haBoardInputCh2MVolt/1000).toFixed(2)

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Sensor voltage") + " (VDC)")
                        }//

                        onTextChanged: {
                            settings.sensorVdc = text
                        }
                        // onAccepted: {
                        //     settings.sensorVdc = text
                        // }//
                    }//
                }//
            }

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"
                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        id: adcActualText
                        text: qsTr("ADC Actual") + "<br>" + "(IFA)"
                    }//

                    TextFieldApp {
                        id: adcActualTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: props.adcActual

                        Component.onCompleted: {
                            text = Qt.binding(function(){return props.adcActual})
                        }
                    }//
                }//

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //console.log("onClicked")
                        adcActualTextField.text = MachineData.ifaAdcConpensation
                        //settings.adcActual = MachineData.ifaAdcConpensation
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        id: calibProText
                        text: qsTr("ADC Nominal") + "<br>" + qsTr("Field (IFN)")
                    }//

                    TextFieldApp {
                        id: adcNomTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        //                text: "LA2-4S8 NS"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this,  qsTr("ADC Nominal - Field (IFN)"))
                        }//

                        onAccepted: {
                            settings.adcNomField = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        id: modelText
                        text: qsTr("ADC Min") + "<br>" + qsTr("Field (IFF)")
                    }//

                    TextFieldApp {
                        id: adcMinTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        //                text: "LA2-4S8 NS"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Minimum - Field (IFF)"))
                        }//

                        onAccepted: {
                            settings.adcMinField = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: "<br>" + qsTr("IFN - IFF")
                    }//

                    TextFieldApp {
                        id: adcRangeTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Range"))
                        }//

                        onAccepted: {
                            //settings.adcRangeFac = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Sensor Constant")
                        width: 100
                        wrapMode: Text.WordWrap
                    }//

                    TextFieldApp {
                        id: sensorConstantTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Sensor Constant"))
                        }//

                        onAccepted: {
                            //settings.sensorConst = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Calibration Temp") + " (" + degreeMeaStr + ")"
                        width: 100
                        wrapMode: Text.WordWrap

                        property int degreeMea: 0
                        property string degreeMeaStr: degreeMea ? "°F" : "°C"

                        Component.onCompleted: {
                            degreeMea = MachineData.measurementUnit
                        }//
                    }//

                    TextFieldApp {
                        id: calibTempTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        //                text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Calibration Temp"))
                        }//

                        onAccepted: {
                            //settings.calibTemp = text
                        }//
                    }//
                }//
            }//

            Rectangle {
                //            height: children[0].height + 10
                //            width: children[0].width + 10
                height: 110
                width: 150
                color: "#aa0F2952"
                radius: 5
                border.width: 1
                border.color: "#e3dac9"

                Column {
                    anchors.centerIn: parent
                    spacing: 5

                    TextApp {
                        text: qsTr("Calibration") + "<br>" + qsTr("Temp ADC")
                    }//

                    TextFieldApp {
                        id: calibTempAdcTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        // text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Calibration Temp ADC"))
                        }//

                        onAccepted: {
                            //settings.calibTempAdc = text
                        }//
                    }//
                }//
            }//
        }//
    }

    QtObject{
        id: props
        property int adcActual: 0

        onAdcActualChanged: {
            settings.adcActual = adcActual
        }

        Component.onCompleted: {
            adcActual = Qt.binding(function(){return MachineData.ifaAdcConpensation})
        }
    }

    /*
      Author: Heri Cahyono
      Change to not editable except sensor VDC
    */

    Settings {
        id: settings
        category: "certificationField"

        property string sensorVdc: "0"
        property int adcActual: 0

        Component.onCompleted: {
            sensorVoltageTextField.text     = sensorVdc

            adcActual                       = MachineData.ifaAdcConpensation
            adcActualTextField.text         = adcActual
            adcMinTextField.text            = MachineData.getInflowAdcPointField(1)
            adcNomTextField.text            = MachineData.getInflowAdcPointField(2)
            //            adcNomFactoryTextField.text     = MachineData.getInflowAdcPointFactory(2)
            //            adcMinFactoryTextField.text     = MachineData.getInflowAdcPointFactory(1)
            //            adcZeroFactoryTextField.text    = MachineData.getInflowAdcPointFactory(0)
            sensorConstantTextField.text    = MachineData.getInflowSensorConstant()
            calibTempTextField.text         = MachineData.getInflowTempCalib()
            calibTempAdcTextField.text      = MachineData.getInflowTempCalibAdc()

            adcRangeTextField.text          = MachineData.getInflowAdcPointField(2) - MachineData.getInflowAdcPointField(1)
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:600;width:640}
}
##^##*/

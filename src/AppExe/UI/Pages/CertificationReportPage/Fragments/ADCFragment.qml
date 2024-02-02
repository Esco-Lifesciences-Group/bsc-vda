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
                        text: settings.adcActual

                        // Component.onCompleted: {
                        //     text = Qt.binding(function(){return props.adcActual})
                        // }
                    }//
                }//

                //  MouseArea {
                //      anchors.fill: parent
                //      onClicked: {
                //          //console.log("onClicked")
                //          adcActualTextField.text = MachineData.ifaAdcConpensation
                //          //settings.adcActual = MachineData.ifaAdcConpensation
                //      }//
                //  }//
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

            // Rectangle {
            //     // height: children[0].height + 10
            //     // width: children[0].width + 10
            //     height: 110
            //     width: 150
            //     color: "#aa0F2952"
            //     radius: 5
            //     border.width: 1
            //     border.color: "#e3dac9"

            //     Column {
            //         anchors.centerIn: parent
            //         spacing: 5

            //         TextApp {
            //             text: qsTr("ADC Zero\nFactory (IF0)")
            //         }//

            //         TextFieldApp {
            //             id: adcZeroFactoryTextField
            //             anchors.horizontalCenter: parent.horizontalCenter
            //             width: 100
            //             height: 40
            //             enabled: false
            //             colorBackground: "transparent"
            //             //                text: "120 VAC / 50Hz"

            //             onPressed: {
            //                 KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Zero - Factory (IF0)"))
            //             }//

            //             onAccepted: {
            //                 settings.adcZeroFac = text
            //             }//
            //         }//
            //     }//
            // }//

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
                        text: qsTr("ADC Min") + "<br>" + qsTr("Factory (IF1)")
                    }//

                    TextFieldApp {
                        id: adcMinFactoryTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        //                text: "0.0005"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Minimum - Factory (IF1)"))
                        }//

                        onAccepted: {
                            settings.adcMinFac = text
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
                        text: qsTr("ADC Nom") + "<br>" + qsTr("Factory (IF2)")
                    }//

                    TextFieldApp {
                        id: adcNomFactoryTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        //                text: "2"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Nominal - Factory (IF2)"))
                        }//

                        onAccepted: {
                            settings.adcNomFac = text
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
                        text: qsTr("IF2 - IF1")
                    }//

                    TextFieldApp {
                        id: adcRangeTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        // text: "10"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("ADC Range"))
                        }//

                        onAccepted: {
                            settings.adcRangeFac = text
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
                        width: 100
                        text: qsTr("Sensor Constant")
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
                            settings.calibTemp = text
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
                        text: qsTr("Calibration Temp ADC")
                        width: 100
                        wrapMode: Text.WordWrap
                    }//

                    TextFieldApp {
                        id: calibTempAdcTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        //                text: "10"

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

    /*
      Author: Heri Cahyono
      Change to not editable except sensor VDC
    */

    QtObject {
        id: settings
        //        category: "certification"

        property string sensorVdc   : Number(MachineData.haBoardInputCh2MVolt/1000).toFixed(2)
        property int adcActual      : MachineData.ifaAdcConpensation

        onSensorVdcChanged: MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_sensorVdc, sensorVdc)
        onAdcActualChanged: MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_adcActual, adcActual)

        Component.onCompleted: {
            sensorVdc = Qt.binding(function(){return Number(MachineData.haBoardInputCh2MVolt/1000).toFixed(2)})
            adcActual = Qt.binding(function(){return MachineData.ifaAdcConpensation})

            adcMinTextField.text            = MachineData.getInflowAdcPointFactory(1)
            adcNomTextField.text            = MachineData.getInflowAdcPointFactory(2)
            adcNomFactoryTextField.text     = MachineData.getInflowAdcPointFactory(2)
            adcMinFactoryTextField.text     = MachineData.getInflowAdcPointFactory(1)
            //            adcZeroFactoryTextField.text    = MachineData.getInflowAdcPointFactory(0)
            sensorConstantTextField.text    = MachineData.getInflowSensorConstant()
            calibTempTextField.text         = MachineData.getInflowTempCalib()
            calibTempAdcTextField.text      = MachineData.getInflowTempCalibAdc()

            adcRangeTextField.text          = MachineData.getInflowAdcPointFactory(2) - MachineData.getInflowAdcPointFactory(1)
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:600;width:640}
}
##^##*/

import QtQuick 2.0
import UI.CusCom 1.1

import Qt.labs.settings 1.1

import ModulesCpp.Machine 1.0

Item {


    Column {
        anchors.centerIn: parent
        spacing: 5

        Grid{
            columns: 4
            spacing: 10

            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Inflow Nominal (%1)").arg(props.velocityUnit)
                    }//

                    TextFieldApp {
                        id: ifaNomTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: (MachineData.getInflowVelocityPointField(MachineAPI.POINT_NOMINAL)/100).toFixed(props.decimalPoint)

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Nominal (%1)").arg(props.velocityUnit))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//

            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Inflow Minimum (%1)").arg(props.velocityUnit)
                    }//

                    TextFieldApp {
                        id: ifaMinTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: (MachineData.getInflowVelocityPointField(MachineAPI.POINT_MINIMUM)/100).toFixed(props.decimalPoint)

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Minimum (%1)").arg(props.velocityUnit))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//

            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Inflow Alarm (%1)").arg(props.velocityUnit)
                    }//

                    TextFieldApp {
                        id: ifaAlarmTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: (MachineData.getInflowLowLimitVelocity()/100).toFixed(props.decimalPoint)

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow Minimum (%1)").arg(props.velocityUnit))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//

            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Downflow Nominal (%1)").arg(props.velocityUnit)
                    }//

                    TextFieldApp {
                        id: dfaNomTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: (MachineData.getDownflowVelocityPointField(MachineAPI.POINT_NOMINAL)/100).toFixed(props.decimalPoint)

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow Nominal (%1)").arg(props.velocityUnit))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//


            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Fan Nominal Duty Cycle (%)")
                    }//

                    TextFieldApp {
                        id: fanNomTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: MachineData.getFanPrimaryNominalDutyCycleField()

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Nominal Duty Cycle (%)"))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//

            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Fan Minimum Duty Cycle (%)")
                    }//

                    TextFieldApp {
                        id: fanMinTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: MachineData.getFanPrimaryMinimumDutyCycleField()

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Minimum Duty Cycle (%)"))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//

            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Fan Standby Duty Cycle (%)")
                    }//

                    TextFieldApp {
                        id: fanStbTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: MachineData.getFanPrimaryStandbyDutyCycleField()

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Standby Duty Cycle (%)"))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }//
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//

            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Fan Nominal RPM")
                    }//

                    TextFieldApp {
                        id: fanNomRpmTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: MachineData.getFanPrimaryNominalRpmField()

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Nominal RPM"))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//

            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Fan Minimum RPM")
                    }//

                    TextFieldApp {
                        id: fanMinRpmTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: MachineData.getFanPrimaryMinimumRpmField()

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Minimum RPM"))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//

            Rectangle {
                height: 110
                width: 150
                color: "#aa0F2952" //"#aaf39c12"
                radius: 5
                border.width: 1
                border.color: "#e3dac9" //"#f39c12"

                Column {
                    anchors.centerIn: parent

                    TextApp {
                        height: 60
                        width: 150
                        wrapMode: Text.WordWrap
                        padding: 5
                        text: qsTr("Fan Standby RPM")
                    }//

                    TextFieldApp {
                        id: fanStbRpmTextField
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 100
                        height: 40
                        enabled: false
                        colorBackground: "transparent"
                        text: MachineData.getFanPrimaryStandbyRpmField()

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan Standby RPM"))
                        }//

                        onTextChanged: {
                            //settings.sensorVdc = text
                        }//
                        //                        onAccepted: {
                        //                            settings.sensorVdc = text
                        //                        }//
                    }//
                }//
            }//
        }//
    }//

    QtObject{
        id: props
        property int adcActual: 0

        property string velocityUnit: MachineData.measurementUnit ? "fpm" : "m/s"
        property int decimalPoint: MachineData.measurementUnit ? 0 : 2

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
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:600;width:640}
}
##^##*/

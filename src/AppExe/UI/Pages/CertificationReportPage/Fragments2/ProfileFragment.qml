import QtQuick 2.14
import UI.CusCom 1.1
import Qt.labs.settings 1.1

import ModulesCpp.Machine 1.0

Item {
    id: control

    Grid {
        anchors.centerIn: parent
        columnSpacing: 10
        spacing: 5
        columns: 2

        Column {
            spacing: 5

            TextApp {
                id: modelText
                text: qsTr("Cabinet Model")
            }//

            TextFieldApp {
                id: cabModelTextField
                width: 300
                height: 40
                //                text: "LA2-4S8 NS"

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, modelText.text)
                }//

                onAccepted: {
                    settings.cabinetModel = text
                }//
                Component.onCompleted: {
                    text = settings.cabinetModel
                }//
            }//
        }//

        Column {
            spacing: 5

            TextApp {
                id: serialNumberText
                text: qsTr("Serial Number")
            }//

            TextFieldApp {
                id: serialNumberTextField
                width: 300
                height: 40
                enabled: false
                //text: MachineData.serialNumber
                //colorBackground: "#949393"
                //text: "2021-123456"

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Serial Number"))
                }//

                onAccepted: {
                    settings.serialNumber = text
                }//

                Component.onCompleted: {
                    text = settings.serialNumber
                }//
            }//
        }//

        Column {
            spacing: 5

            TextApp {
                id: dateText
                text: qsTr("Date")
            }//

            TextFieldApp {
                id: dateTextField
                width: 300
                height: 40

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Date"))
                }//

                onAccepted: {
                    settings.date = text
                }//
            }//
        }//

        Column {
            spacing: 5

            TextApp {
                id: calibProText
                text: qsTr("Form Number")
            }//

            //            Row{
            //                spacing: 2
            TextFieldApp {
                id: formNoTextField
                width: 300
                height: 40
                //                text: "LA2-4S8 NS"

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Form number"))
                }//

                onAccepted: {
                    settings.formNo = text
                }//
                Component.onCompleted: {
                    text = settings.formNo
                }//
            }//
        }//

        Column {
            spacing: 5

            TextApp {
                text: qsTr("Customer")
            }//

            ComboBoxApp {
                id: comboBoxCustomer
                width: 170
                height: 40
                backgroundColor: enabled ? "#0F2952"
                                         : "#404244"
                backgroundBorderColor: "#dddddd"
                backgroundBorderWidth: 2
                font.pixelSize: 20
                textRole: "text"
                //// ETI, WORLD, ANCARE, NONE, STREAMLINE
                model: [
                    {text: "ETI"},
                    {text: "WORLD"},
                    {text: "ANCARE"},
                    {text: "NONE"},
                    {text: "STREAMLINE"}
                ]//

                onActivated: {
                    settings.customer = model[index].text
                }
                Component.onCompleted: {
                    const str = settings.customer
                    for(let i=0; i<model.length; i++){
                        if(str === model[i].text){
                            comboBoxCustomer.currentIndex = i
                            break
                        }
                    }
                }
            }//
        }//

        Column {
            spacing: 5

            TextApp {
                text: qsTr("Noise Standard")
            }//

            ComboBoxApp {
                id: comboBoxNoisStd
                width: 170
                height: 40
                backgroundColor: enabled ? "#0F2952"
                                         : "#404244"
                backgroundBorderColor: "#dddddd"
                backgroundBorderWidth: 2
                font.pixelSize: 20
                textRole: "text"

                model: [
                    {text: "EN"},
                    {text: "NSF ETI"},
                    {text: "NSF"},
                    {text: "AUS"}
                ]//

                onActivated: {
                    settings.noiseStd = model[index].text
                }
                Component.onCompleted: {
                    const str = settings.noiseStd
                    for(let i=0; i<model.length; i++){
                        if(str === model[i].text){
                            comboBoxNoisStd.currentIndex = i
                            break
                        }
                    }
                }
            }//
        }//


        Column {
            spacing: 5

            TextApp {
                text: qsTr("Tested by")
            }//

            TextFieldApp {
                id: testerNameTextField
                width: 300
                height: 40
                text: settings.testedBy

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Tested by"))
                }//

                onAccepted: {
                    settings.testedBy = text
                }//
            }//
        }//

        Column {
            spacing: 5

            TextApp {
                text: qsTr("Checked by")
            }//

            TextFieldApp {
                id: checkerNameTextField
                width: 300
                height: 40
                text: settings.checkedBy

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Checked by"))
                }//

                onAccepted: {
                    settings.checkedBy = text
                }//
            }//
        }//
    }//

    //    Settings{
    //        id: settings2
    //        category: "certification"
    //        property string serialNumber: ""
    //        Component.onCompleted: {
    //        }
    //    }
    Settings{
        id: settings
        category: "oneOfTen"

        //property bool oneOfTenEn: false
        property string cabinetModel: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_cabinetModel)
        property string serialNumber: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_serialNumber)
        property string formNo: "FM-TST-TR-1 of 10-01-B"
        property string testedBy: ""
        property string checkedBy: ""
        property string date: ""
        property string noiseStd: "NSF" //EN, NSF ETI, NSF, AUS
        property string customer: "WORLD" // ETI, WORLD, ANCARE, NONE, STREAMLINE

        Component.onCompleted: {
            date =  Qt.formatDate(new Date, "dd-MMM-yyyy")
            dateTextField.text = date
        }
    }

    QtObject{
        id: props
        property bool initialFisnished: false

    }

    UtilsApp{
        id: utils
    }//

    Component.onCompleted: {
        props.initialFisnished = true
    }
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

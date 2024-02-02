import QtQuick 2.0
import Qt.labs.platform 1.0
import Qt.labs.settings 1.1
import UI.CusCom 1.1

import ModulesCpp.Machine 1.0

Item {

    Column {
        anchors.centerIn: parent
        spacing: 5

        Grid {
            anchors.horizontalCenter: parent.horizontalCenter
            columnSpacing: 10
            spacing: 5
            columns: 2
            Row{
                spacing: 2
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

                        model: [
                            {text: "WORLD"},
                            {text: "ETI"}
                        ]//

                        onActivated: {
                            settings.customer = model[index].text
                        }
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Country")
                    }//

                    TextFieldApp {
                        id: countryText
                        width: 170
                        height: 40
                        text: "SINGAPORE"

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Country"))
                        }//

                        onAccepted: {
                            text = text.toUpperCase()
                            settings.country = text
                        }//
                    }//
                }//
            }//
            //            Row{
            //                spacing: 2
            Column {
                spacing: 5

                TextApp {
                    text: qsTr("Test Report Number")
                }//
                TextFieldApp {
                    id: testReportNoTextField
                    width: 340
                    height: 40
                    text: ""

                    onPressed: {
                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Test Report Number"))
                    }//

                    onAccepted: {
                        text = text.toUpperCase()
                        settings.testReportNo = text
                    }//
                }//
            }//
            Row{
                spacing: 2
                Column {
                    spacing: 5
                    TextApp {
                        text: qsTr("Date")
                    }//

                    TextFieldApp {
                        id: dateText
                        width: 170
                        height: 40
                        text: "28-Jan-2021"

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Date"))
                        }//

                        onAccepted: {
                            settings.dateTest = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5
                    TextApp {
                        text: qsTr("Software version")
                    }//

                    TextFieldApp {
                        id: swText
                        width: 170
                        height: 40
                        text: "SBC-V1.0.0-1"
                        enabled: false
                        //colorBackground: "#949393"

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Software version"))
                        }//

                        onAccepted: {
                            settings.swVersion = text
                        }//
                    }//
                }//
            }//


            Column {
                spacing: 5

                TextApp {
                    text: qsTr("Certificate Number")
                }//

                TextFieldApp {
                    id: certifNoTextField
                    width: 340
                    height: 40
                    text: ""

                    onPressed: {
                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Certificate Number"))
                    }//

                    onAccepted: {
                        text = text.toUpperCase()
                        settings.certifNo = text
                    }//
                }//
            }//

            Column {
                spacing: 10

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Tested by")
                    }//

                    TextFieldApp {
                        id: testerNameText
                        width: 340
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Tested by"))
                        }//

                        onAccepted: {
                            settings.testerName = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter

                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Draw Signature")
                    }

                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 5

                        Rectangle {

                            height: 160/*110*/
                            width: 280/*200*/
                            radius: 5
                            color: "#e3dac9"

                            Image {
                                id: savedTesterSignImage
                                cache: false
                                //                        source: "file"
                                Component.onCompleted: {
                                    const path = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation) + "/fullsigntester.png"
                                    source = path
                                }//

                                function reloadImage() {
                                    var oldSource = source
                                    source = ""
                                    source = oldSource
                                }//function to refresh the source

                                //                        onStatusChanged: {
                                //                            console.log(status)
                                //                        }//
                            }//

                            CanvasDrawByMouse {
                                id: signatureTesterCanvas
                                anchors.fill: parent
                                visible: false
                            }//
                        }//

                        Column {
                            spacing: 2

                            ButtonApp {
                                id: changeTesterSignButton
                                text: qsTr("Change")
                                width: 80
                                visible: true
                                onClicked: {
                                    changeTesterSignButton.visible = false
                                    saveTesterSignButton.visible = true
                                    clearTesterSignButton.visible = true
                                    savedTesterSignImage.visible = false
                                    signatureTesterCanvas.visible = true
                                }//

                                font.pixelSize: 14
                            }//

                            ButtonApp {
                                id: saveTesterSignButton
                                text: qsTr("Save")
                                width: 80
                                visible: false
                                onClicked: {
                                    saveTesterSignButton.visible = false
                                    clearTesterSignButton.visible = false

                                    const dataUrl = signatureTesterCanvas.toDataURL()
                                    const dataUrlPayload = dataUrl.replace("data:image/png;base64,", "")
                                    settings.testerSignature = Qt.btoa(dataUrlPayload)
                                    //                            console.log("dataUrl: " + dataUrl)

                                    const url = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation)
                                    const path = utilsApp.urlToPath(String(url))
                                    const pathImage = path + "/fullsigntester.png"
                                    //                            console.log("path: " + url)
                                    //                            console.log("path: " + path)

                                    signatureTesterCanvas.save(pathImage)
                                    signatureTesterCanvas.clear()

                                    savedTesterSignImage.reloadImage()

                                    signatureTesterCanvas.visible = false
                                    savedTesterSignImage.visible = true
                                    changeTesterSignButton.visible = true
                                }//

                                font.pixelSize: 14
                            }//

                            ButtonApp {
                                id: clearTesterSignButton
                                text: qsTr("Clear")
                                width: 80
                                visible: false
                                onClicked: {
                                    signatureTesterCanvas.clear()
                                }//

                                font.pixelSize: 14
                            }//
                        }//
                    }
                }//
            }//

            Column {
                spacing: 10

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Checked by")
                    }//

                    TextFieldApp {
                        id: checkerNameText
                        width: 340
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openKeyboard(this, qsTr("Checked by"))
                        }//

                        onAccepted: {
                            settings.checkerName = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5
                    anchors.horizontalCenter: parent.horizontalCenter

                    TextApp {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Draw Signature")
                    }

                    Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 5

                        Rectangle {

                            height: 160/*110*/
                            width: 280/*200*/
                            radius: 5
                            color: "#e3dac9"

                            Image {
                                id: savedChackerSignImage
                                cache: false
                                //                        source: "file"
                                Component.onCompleted: {
                                    const path = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation) + "/fullsignchecker.png"
                                    source = path
                                }//
                                function reloadImage() {
                                    var oldSource = source
                                    source = ""
                                    source = oldSource
                                }//function to refresh the source

                                //                        onStatusChanged: {
                                //                            console.log(status)
                                //                        }//
                            }//

                            CanvasDrawByMouse {
                                id: signatureChackerCanvas
                                anchors.fill: parent
                                visible: false
                            }//
                        }//

                        Column {
                            spacing: 2

                            ButtonApp {
                                id: changeCheckerSignButton
                                text: qsTr("Change")
                                width: 80
                                visible: true
                                onClicked: {
                                    changeCheckerSignButton.visible = false
                                    saveChackerSignButton.visible = true
                                    clearChackerSignButton.visible = true
                                    savedChackerSignImage.visible = false
                                    signatureChackerCanvas.visible = true
                                }//

                                font.pixelSize: 14
                            }//

                            ButtonApp {
                                id: saveChackerSignButton
                                text: qsTr("Save")
                                width: 80
                                visible: false
                                onClicked: {
                                    saveChackerSignButton.visible = false
                                    clearChackerSignButton.visible = false

                                    const dataUrl = signatureChackerCanvas.toDataURL()
                                    const dataUrlPayload = dataUrl.replace("data:image/png;base64,", "")
                                    settings.checkerSignature = Qt.btoa(dataUrlPayload)
                                    //                            console.log("dataUrl: " + dataUrl)
                                    //                            console.log("dataUrlPayload: " + dataUrlPayload)
                                    //                            console.log("dataUrlPayloadbtoa: " + Qt.btoa(dataUrlPayload))
                                    //                            console.log("dataUrlPayloadatob: " + Qt.atob(Qt.btoa(dataUrlPayload)))

                                    const url = StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation)
                                    const path = utilsApp.urlToPath(String(url))
                                    const pathImage = path + "/fullsignchecker.png"
                                    //                            console.log("path: " + url)
                                    //                            console.log("path: " + path)

                                    signatureChackerCanvas.save(pathImage)
                                    signatureChackerCanvas.clear()

                                    savedChackerSignImage.reloadImage()

                                    signatureChackerCanvas.visible = false
                                    savedChackerSignImage.visible = true
                                    changeCheckerSignButton.visible = true
                                }//

                                font.pixelSize: 14
                            }//

                            ButtonApp {
                                id: clearChackerSignButton
                                text: qsTr("Clear")
                                width: 80
                                visible: false
                                onClicked: {
                                    signatureChackerCanvas.clear()
                                }//

                                font.pixelSize: 14
                            }//
                        }//
                    }
                }//
            }//
        }//

        Rectangle {
            height: 1
            width: parent.width
            color: "#e3dac9"
        }//

        TextApp {
            text: qsTr("The signature will not be saved permanently!")
            font.pixelSize: 16
        }//
    }//

    UtilsApp {
        id: utilsApp
    }//

    QtObject {
        id: settings
        //        category: "certification"
        property var certificateModel: [
            {text: "FM-TST-CRT-02-B"}, //AC2 G4 World
            {text: "FM-TST-CRT-03-B"}, //AC2 G4 ETI
            {text: "FM-TST-CRT-04-B"}, //LA2 G4 World
            {text: "FM-TST-CRT-05-B"}, //LA2 G4 ETI
            {text: "FM-TST-CRT-06-B"}, //VA2 G4 World
            {text: "FM-TST-CRT-07-B"}  //VA2 G4 ETI
        ]
        property var testReportModel: [
            {text: "FM-TST-TR-A2-01-G"}, //AC2, LA2, VA2 G4 World
            {text: "FM-TST-TR-A2-02-G"}  //AC2, LA2, VA2 G4 ETI
        ]
        property string testReportNo    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_testReportNo)
        property string certifNo        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_certifNo)

        property string testerName      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_testerName)
        property string testerSignature : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_testerSignature)
        property string checkerName     : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_checkerName)
        property string checkerSignature: MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_checkerSignature)
        property string customer        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_customer)
        property string country         : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_country)
        property string dateTest        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_dateTest)
        property string swVersion       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_swVersion)

        onTestReportNoChanged   : {
            MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_testReportNo, testReportNo)
            testReportNoTextField.text = testReportNo
        }
        onCertifNoChanged       : {
            MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_certifNo, certifNo)
            certifNoTextField.text = certifNo
        }

        onTesterNameChanged             : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_testerName, testerName)
        onTesterSignatureChanged        : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_testerSignature, testerSignature)
        onCheckerNameChanged            : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_checkerName, checkerName)
        onCheckerSignatureChanged       : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_checkerSignature, checkerSignature)
        onCustomerChanged               : {
            MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_customer, customer)
            if(String(customer) == String("ETI")){
                country = "USA"
                countryText.text = country
            }
            updateDocsNumber()
        }
        onCountryChanged                : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_country, country)
        onDateTestChanged               : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_dateTest, dateTest)
        onSwVersionChanged              : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_swVersion, swVersion)

        function updateDocsNumber(){
            if(String(customer) == String(comboBoxCustomer.model[0].text)){ //WORLD
                testReportNo = testReportModel[0].text
                if(MachineData.machineModelName == "AC2"){
                    certifNo = certificateModel[0].text
                }
                else if(MachineData.machineModelName == "LA2"){
                    certifNo = certificateModel[2].text
                }
                else if(MachineData.machineModelName == "VA2"){
                    certifNo = certificateModel[4].text
                }
            }
            else if(String(customer) == String(comboBoxCustomer.model[1].text)){ //ETI
                testReportNo = testReportModel[1].text
                if(MachineData.machineModelName == "AC2"){
                    certifNo = certificateModel[1].text
                }
                else if(MachineData.machineModelName == "LA2"){
                    certifNo = certificateModel[3].text
                }
                else if(MachineData.machineModelName == "VA2"){
                    certifNo = certificateModel[5].text
                }
            }//
        }

        Component.onCompleted: {
            countryText.text = country

            dateTest = Qt.binding(function(){return Qt.formatDate(new Date, "dd-MMM-yyyy")})
            dateText.text = dateTest
            swVersion = Qt.application.name + " - " + Qt.application.version
            swText.text = swVersion

            testerNameText.text = testerName
            checkerNameText.text = checkerName

            if(String(customer) == String(comboBoxCustomer.model[0].text)){ //WORLD
                comboBoxCustomer.currentIndex = 0
            }
            else if(String(customer) == String(comboBoxCustomer.model[1].text)){ //ETI
                comboBoxCustomer.currentIndex = 1
            }//

            updateDocsNumber()

            testReportNoTextField.text = testReportNo
            certifNoTextField.text = certifNo
        }//
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#808080";height:480;width:800}
}
##^##*/

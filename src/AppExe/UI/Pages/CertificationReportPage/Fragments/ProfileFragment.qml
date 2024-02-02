import QtQuick 2.14
import UI.CusCom 1.1
import Qt.labs.settings 1.1

import ModulesCpp.Machine 1.0

Item {
    id: control

    property bool fieldOrFull
    property bool fieldAdvanced

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
            visible: fieldOrFull
            spacing: 5

            TextApp {
                id: calibProText
                text: qsTr("Factory Certification Procedure")
            }//

            //            Row{
            //                spacing: 2
            TextFieldApp {
                id: calibProTextField
                width: 300
                height: 40
                //                text: "LA2-4S8 NS"

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Factory Certification Procedure"))
                }//

                onAccepted: {
                    settings.calibProc = text
                }//
                Component.onCompleted: {
                    text = settings.calibProc
                }//
            }//
        }//

        Row{
            spacing: 2
            Column {
                visible: settings.needWoNumber && fieldOrFull
                spacing: 5

                TextApp {
                    id: woText
                    text: qsTr("Work Order")
                }//

                TextFieldApp {
                    id: woTextField
                    width: 149
                    height: 40
                    //                text: "LA2-4S8 NS"

                    onPressed: {
                        KeyboardOnScreenCaller.openKeyboard(this, woText.text)
                    }//

                    onAccepted: {
                        settings.woNumber = text
                    }//
                    Component.onCompleted: {
                        text = settings.woNumber
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
                    width: settings.needWoNumber ? 149 : 300
                    height: 40
                    enabled: false
                    //text: MachineData.serialNumber
                    //colorBackground: "#949393"
                    //                text: "2021-123456"

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
        }//
        Column {
            //visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("Field Certification Procedure")
            }//

            TextFieldApp {
                id: calibProTextField1
                width: 300
                height: 40
                //                text: "LA2-4S8 NS"

                onPressed: {
                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Field Certification Procedure"))
                }//

                onAccepted: {
                    settings.calibProcField = text
                }//
                Component.onCompleted: {
                    text = settings.calibProcField
                }//
            }//
            //            }//
        }//

        Column {
            spacing: 5

            TextApp {
                id: powerRatingText
                text: qsTr("Power Rating")
            }//
            Row{
                spacing: 2
                ComboBoxApp {
                    id: comboBoxPowerRating
                    width: 149
                    height: 40
                    backgroundColor: enabled ? "#0F2952"
                                             : "#404244"
                    backgroundBorderColor: "#dddddd"
                    backgroundBorderWidth: 2
                    font.pixelSize: 20
                    popupHeight: 200
                    //anchors.verticalCenter: parent.verticalCenter
                    textRole: "text"

                    //                model: [
                    //                    {text: "220-240 VAC, 50/60 Hz"}, //8
                    //                    {text: "110-130 VAC, 50/60 Hz"}, //9
                    //                    {text: "100VAC, 50/60 Hz"}       //7
                    //                ]

                    onActivated: {
                        settings.powerRating = settings.powerRatingModel[index].text + ", " + settings.powerRatingModel1[comboBoxPowerRating1.currentIndex].text
                        //model[index].text
                    }
                }//
                ComboBoxApp {
                    id: comboBoxPowerRating1
                    width: 149
                    height: 40
                    backgroundColor: enabled ? "#0F2952"
                                             : "#404244"
                    backgroundBorderColor: "#dddddd"
                    backgroundBorderWidth: 2
                    font.pixelSize: 20
                    popupHeight: 200
                    //anchors.verticalCenter: parent.verticalCenter
                    textRole: "text"

                    //                model: [
                    //                    {text: "220-240 VAC, 50/60 Hz"}, //8
                    //                    {text: "110-130 VAC, 50/60 Hz"}, //9
                    //                    {text: "100VAC, 50/60 Hz"}       //7
                    //                ]

                    onActivated: {
                        settings.powerRating = settings.powerRatingModel[comboBoxPowerRating.currentIndex].text + ", " + settings.powerRatingModel1[index].text
                        //model[index].text
                    }
                }//
            }//

            //            TextFieldApp {
            //                id: powerRatingTextField
            //                width: 300
            //                height: 40
            //                //                text: "120 VAC / 50Hz"

            //                onPressed: {
            //                    KeyboardOnScreenCaller.openKeyboard(this, qsTr("Power Rating"))
            //                }//

            //                onAccepted: {
            //                    settings.powerRating = text
            //                }//

            //                Component.onCompleted: {
            //                    text = settings.powerRating
            //                }//
            //            }//
        }//

        Row {
            spacing: 10

            Column {
                //visible: fieldOrFull

                spacing: 5

                TextApp {
                    text: qsTr("Room Temp | Pressure")
                }//

                Row {
                    spacing: 10

                    Row {
                        spacing: 2

                        TextFieldApp {
                            id: roomTempTextField
                            width: 100
                            height: 40
                            text: "20"

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this, qsTr("Temperature"))
                            }//

                            onAccepted: {
                                if(MachineData.measurementUnit){
                                    settings.tempRoomImp = Number(text)
                                    settings.tempRoom = utils.fahrenheitToCelcius(settings.tempRoomImp)
                                }
                                else{
                                    settings.tempRoom = Number(text)
                                    settings.tempRoomImp = utils.celciusToFahrenheit(settings.tempRoom)
                                }
                            }//
                            Component.onCompleted: {
                                if(MachineData.measurementUnit)
                                    text = settings.tempRoomImp
                                else
                                    text = settings.tempRoom
                            }//
                        }//

                        TextApp {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "°C"

                            Component.onCompleted: {
                                text = MachineData.measurementUnit ? "°F" : "°C"
                            }
                        }//
                    }//

                    Row {
                        spacing: 2

                        TextFieldApp {
                            id: roomPressTextField
                            width: 100
                            height: 40
                            text: "1.0005"

                            onPressed: {
                                KeyboardOnScreenCaller.openKeyboard(this, qsTr("Pressure"))
                            }//

                            onAccepted: {
                                settings.pressRoom = text
                            }//
                            Component.onCompleted: {
                                text = settings.pressRoom
                            }
                        }//

                        TextApp {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "bar"
                        }//
                    }//
                }//
            }//
        }//

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("PAO concentration")
            }//

            Row {
                spacing: 2

                TextFieldApp {
                    id: paoConTextField
                    width: 200
                    height: 40
                    text: "0.0005"

                    onPressed: {
                        KeyboardOnScreenCaller.openNumpad(this, qsTr("PAO concentration"))
                    }//

                    onAccepted: {
                        settings.paoCons = text
                    }//
                    Component.onCompleted: text = settings.paoCons
                }//

                TextApp {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "μg/liter"
                }//
            }//
        }//

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("No Laskin Nozzles")
            }//

            TextFieldApp {
                id: noLaskinTextField
                width: 100
                height: 40
                //                text: "2"

                onPressed: {
                    KeyboardOnScreenCaller.openNumpad(this, qsTr("No Laskin Nozzles"))
                }//

                onAccepted: {
                    settings.noLaskin = text
                }//
                Component.onCompleted: text = settings.noLaskin
            }//
        }//

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("Particle Penetration") + " (D/F | I/F)"
            }//

            Row {
                spacing: 2

                TextFieldApp {
                    id: dfParticlePenetration
                    width: 120
                    height: 40
                    text: "0.00"

                    onPressed: {
                        KeyboardOnScreenCaller.openNumpad(this, qsTr("D/F Particle Penetration"))
                    }//

                    onAccepted: {
                        settings.dfParPenet = text
                    }//
                    Component.onCompleted: text = settings.dfParPenet
                }//

                TextApp {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "%"
                }//

                TextFieldApp {
                    id: ifParticlePenetration
                    width: 120
                    height: 40
                    text: "0.00"

                    onPressed: {
                        KeyboardOnScreenCaller.openNumpad(this, qsTr("I/F Particle Penetration"))
                    }//

                    onAccepted: {
                        settings.ifParPenet = text
                    }//
                    Component.onCompleted: text = settings.ifParPenet
                }//

                TextApp {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "%"
                }//
            }//
        }//

        Column {
            visible: fieldOrFull
            spacing: 5

            TextApp {
                text: qsTr("Damper Opening")
            }//

            Row {
                spacing: 2

                TextFieldApp {
                    id: damOpTextField
                    width: 100
                    height: 40
                    text: "10"
                    //validator: RegularExpressionValidator { regularExpression: /\d{1,2}(?:\/\d{1,2})+$/}
                    onPressed: {
                        //                        if(MachineData.measurementUnit)
                        KeyboardOnScreenCaller.openKeyboard(this, qsTr("Damper Opening"))
                        //                        else
                        //                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Damper Opening"))
                    }//

                    onAccepted: {
                        const value = text
                        if(MachineData.measurementUnit)
                        {
                            const damperOpenText = text.split("/")
                            if(damperOpenText.length === 2){
                                settings.damperOpenImp = value
                                settings.damperOpen = Math.round((Number(value.split("/")[0]) / Number(value.split("/")[1])) * 25.4)
                            }
                        }
                        else{
                            settings.damperOpen = value
                            settings.damperOpenImp = (Number(value)/25.4).toFixed(1)
                        }
                    }//

                    Component.onCompleted: {
                        text = MachineData.measurementUnit ? settings.damperOpenImp : settings.damperOpen
                    }//
                }//

                TextApp {
                    anchors.verticalCenter: parent.verticalCenter
                    text: MachineData.measurementUnit ? "inch" : "mm"
                }//
            }//
        }
    }//

    CheckBoxApp{
        id: cbOneOfTen        
        visible: fieldOrFull
        width: 120
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        text: qsTr("1 of 10")
        onCheckedChanged: {
            if(!settings.initialFisnished) return;
            setting2.oneOfTenEn = checked
        }
    }

    Settings{
        id: setting2
        category: "oneOfTen"

        property bool oneOfTenEn: false

        Component.onCompleted: {
            cbOneOfTen.checked = oneOfTenEn
        }
    }

    QtObject {
        id: settings
        //        category: "certification"
        //220-240 VAC, 50/60 Hz
        property var powerRatingModel: [
            {text: "100 VAC"},      //7
            {text: "110 VAC"},      //9
            {text: "115 VAC"},      //9
            {text: "120 VAC"},      //9
            {text: "130 VAC"},      //9
            {text: "220 VAC"},      //8
            {text: "230 VAC"},      //8
            {text: "240 VAC"},      //8
            {text: "110/220 VAC"}   //8
        ]
        property var powerRatingModel1: [
            {text: "50 Hz"},
            {text: "60 Hz"},
            {text: "50/60 Hz"},
            {text: "50Hz, 60Hz"}
        ]

        property bool initialFisnished: false

        property bool needWoNumber: false

        property string cabinetModel    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_cabinetModel)
        property string woNumber        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_woNumber)
        property string calibProc       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_calibProc)
        property string calibProcField  : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_calibProcField)

        property string serialNumber    : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_serialNumber)
        property string powerRating     : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_powerRating)
        property int    tempRoom        : MachineData.temperatureCelcius
        property int    tempRoomImp     : utils.celciusToFahrenheit(MachineData.temperatureCelcius)
        property string pressRoom       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_pressRoom)
        property string paoCons         : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_paoCons)
        property string dfParPenet      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_dfParPenet)
        property string ifParPenet      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_ifParPenet)
        property int    noLaskin        : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_noLaskin)
        property string damperOpen      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_damperOpen)
        property string damperOpenImp   : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_damperOpenImp)

        onCabinetModelChanged   : {
            MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_cabinetModel, cabinetModel)

            if(!initialFisnished) return;

            let model = powerRatingModel
            let model1 = powerRatingModel1
            let cabModel = cabinetModel

            if(cabModel.indexOf('8') > -1){
                comboBoxPowerRating.currentIndex = 5
                comboBoxPowerRating1.currentIndex = 0
                powerRating = String(model[5].text) + ", " + String(model1[0].text)
            }
            else if(cabModel.indexOf('9') > -1){
                comboBoxPowerRating.currentIndex = 1
                comboBoxPowerRating1.currentIndex = 0
                powerRating = String(model[1].text) + ", " + String(model1[0].text)
            }
            else if(cabModel.indexOf('7') > -1){
                comboBoxPowerRating.currentIndex = 0
                comboBoxPowerRating1.currentIndex = 0
                powerRating = String(model[0].text) + ", " + String(model1[0].text)
            }
        }
        onWoNumberChanged       : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_woNumber, woNumber)
        onCalibProcChanged      : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_calibProc, calibProc)
        onCalibProcFieldChanged : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_calibProcField, calibProcField)

        onSerialNumberChanged   : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_serialNumber, serialNumber)
        onPowerRatingChanged    : {
            console.debug(powerRating)
            MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_powerRating, powerRating)
        }
        onTempRoomChanged       : MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_tempRoom, tempRoom)
        onTempRoomImpChanged    : MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_tempRoomImp, tempRoomImp)
        onPressRoomChanged      : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_pressRoom, pressRoom)
        onPaoConsChanged        : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_paoCons, paoCons)
        onDfParPenetChanged     : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_dfParPenet, dfParPenet)
        onIfParPenetChanged     : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_ifParPenet, ifParPenet)
        onNoLaskinChanged       : MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_noLaskin, noLaskin)
        onDamperOpenChanged     : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_damperOpen, damperOpen)
        onDamperOpenImpChanged  : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_damperOpenImp, damperOpenImp)

        Component.onCompleted: {
            serialNumber = MachineData.serialNumber
            cabModelTextField.text      = cabinetModel
            woTextField.text            = woNumber
            calibProTextField.text      = calibProc
            calibProTextField1.text     = calibProcField

            serialNumberTextField.text  = serialNumber
            //            powerRatingTextField.text   = powerRating
            if(MachineData.measurementUnit)
                roomTempTextField.text  = tempRoomImp
            else
                roomTempTextField.text  = tempRoom
            roomPressTextField.text     = pressRoom
            paoConTextField.text        = paoCons
            noLaskinTextField.text      = noLaskin
            damOpTextField.text         = MachineData.measurementUnit ? damperOpenImp : damperOpen
            dfParticlePenetration.text  = dfParPenet
            ifParticlePenetration.text  = ifParPenet

            MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_tempRoom, tempRoom)
            MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_tempRoomImp, tempRoomImp)

            needWoNumber = Qt.binding(function(){
                let modelStr = cabinetModel
                let custom = (modelStr.includes("-C") || modelStr.includes("- C"))
                //((String(String(modelStr.split("-")[modelStr.split("-").length - 1]).replace(/ /g,'')) == String("C")) ? true : false)
                return custom
            })

            let model = powerRatingModel
            let model1 = powerRatingModel1
            comboBoxPowerRating.model = model
            comboBoxPowerRating1.model = model1

            let currentIndex = -1;
            let currentIndex1 = -1;

            let powerRate = powerRating
            if(powerRate.split(", ").length > 1)
                powerRate = powerRate.split(", ")[0]
            let powerRate1 = powerRating
            if(powerRate1.split(", ").length > 1){
                if(powerRate1.split(", ").length == 3)
                    powerRate1 = powerRate1.split(", ")[1] + ", " + powerRate1.split(", ")[2]
                else
                    powerRate1 = powerRate1.split(", ")[1]
            }
            //            console.debug("&&", powerRating, "#", powerRate,"#", powerRate1)

            let i = 0;
            for(i=0; i<model.length; i++){
                if(String(powerRate) == String(model[i].text))
                    currentIndex = i;
            }
            for(i=0; i<model1.length; i++){
                if(String(powerRate1) == String(model1[i].text))
                    currentIndex1 = i;
            }
            //            console.debug("%%", currentIndex, "#", currentIndex1)

            if(currentIndex == -1 || currentIndex1 == -1){
                let cabModel = cabinetModel
                if(cabModel.indexOf('8') > -1){
                    comboBoxPowerRating.currentIndex = 5
                    comboBoxPowerRating1.currentIndex = 0
                    powerRating = String(model[5].text) + ", " + String(model1[0].text)
                }
                else if(cabModel.indexOf('9') > -1){
                    comboBoxPowerRating.currentIndex = 1
                    comboBoxPowerRating1.currentIndex = 0
                    powerRating = String(model[1].text) + ", " + String(model1[0].text)
                }
                else if(cabModel.indexOf('7') > -1){
                    comboBoxPowerRating.currentIndex = 0
                    comboBoxPowerRating1.currentIndex = 0
                    powerRating = String(model[0].text) + ", " + String(model1[0].text)
                }
            }else{
                comboBoxPowerRating.currentIndex = currentIndex
                comboBoxPowerRating1.currentIndex = currentIndex1
            }

            initialFisnished = true
        }//
    }//

    UtilsApp{
        id: utils
    }//
}//

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

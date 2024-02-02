import QtQuick 2.0
import QtQuick.Layouts 1.0
import Qt.labs.settings 1.1
import UI.CusCom 1.1
import ModulesCpp.Machine 1.0

Item {
    Column{
        anchors.centerIn: parent
        spacing: 5
        Row {
            spacing: 20

            Column {
                spacing: 5

                TextApp {
                    id: mvInit
                    text: qsTr("Initial")
                }//

                Rectangle {
                    height: 2
                    width: 120
                    color: "#e3dac9"
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Fan duty cycle") + " (%)" + " | " + "RPM"
                    }//

                    Row {
                        spacing: 5

                        TextFieldApp {
                            id: initialDutyCycleTextField
                            width: 50
                            height: 40
                            //                        text: "48"
                            //colorBorder: "#f39c12"
                            //enabled: false
                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan duty cycle") + " (%1)".arg(mvInit.text))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvInitialFanDucy = val
                            }//
                        }//

                        TextFieldApp {
                            id: initialRpmTextField
                            width: 145
                            height: 40
                            //                        text: "700"

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan RPM") + " (%1)".arg(mvInit.text))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvInitialFanRpm = val
                            }//
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Downflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: initialDfaTextField
                        width: 200
                        height: 40
                        //                    text: "0.33"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow velocity") + " (%1)".arg(mvInit.text))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvInitialDfa = value.toFixed(2)
                            settings.mvInitialDfaImp = valueImp.toFixed()

                            //                        settings.mvInitialDfa = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Inflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: initialIfaTextField
                        width: 200
                        height: 40
                        //                    text: "0.53"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow velocity") + " (%1)".arg(mvInit.text))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvInitialIfa = value.toFixed(2)
                            settings.mvInitialIfaImp = valueImp.toFixed()

                            //                        settings.mvInitialIfa = text
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Power consumption") + " " + unitStr

                        property string unitStr: "(Watt)"
                    }//

                    TextFieldApp {
                        id: initialPowerTextField
                        width: 200
                        height: 40
                        text: "0"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Power consumption") + " (%1)".arg(mvInit.text))
                        }//

                        onAccepted: {
                            const val = Number(text)

                            settings.mvInitialPower = val
                        }
                    }//
                }//

                ButtonBarApp {
                    text: qsTr("Capture")

                    onClicked: {
                        initialDutyCycleTextField.text = MachineData.fanPrimaryDutyCycle
                        initialRpmTextField.text = MachineData.fanPrimaryRpm

                        initialDfaTextField.text = MachineData.dfaVelocityStr.split(" ")[0] || "0"
                        initialIfaTextField.text = MachineData.ifaVelocityStr.split(" ")[0] || "0"

                        settings.mvInitialFanDucy = initialDutyCycleTextField.text
                        settings.mvInitialFanRpm = initialRpmTextField.text

                        if(MachineData.measurementUnit){
                            settings.mvInitialDfaImp = initialDfaTextField.text
                            settings.mvInitialIfaImp = initialIfaTextField.text
                        }else{
                            settings.mvInitialDfa = initialDfaTextField.text
                            settings.mvInitialIfa = initialIfaTextField.text
                        }
                    }//
                }//
            }//

            Column {
                spacing: 5

                TextApp {
                    id: mvBlock
                    text: qsTr("Grill blocked")
                }//

                Rectangle {
                    height: 2
                    width: 120
                    color: "#e3dac9"
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Fan duty cycle") + " (%)" + " | " + "RPM"
                    }//

                    Row {
                        spacing: 5

                        TextFieldApp {
                            id: blockedDutyCycleTextField
                            width: 50
                            height: 40
                            //                        text: "48"
                            //colorBorder: "#f39c12"
                            enabled: false
                            //colorBackground: "#949393"
                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan duty cycle") + " (%1)".arg(mvBlock.text))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvBlockFanDucy = val
                            }//
                        }//

                        TextFieldApp {
                            id: blockedRpmTextField
                            width: 145
                            height: 40
                            //                        text: "735"

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan RPM") + " (%1)".arg(mvBlock.text))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvBlockFanRpm = val
                            }//
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Downflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: blockedDfaTextField
                        width: 200
                        height: 40
                        //color: "#e74c3c"
                        //text: "0.32"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow velocity") + " (%1)".arg(mvBlock.text))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvBlockDfa = value.toFixed(2)
                            settings.mvBlockDfaImp = valueImp.toFixed()

                            //                        settings.mvBlockDfa = text
                        }//
                        Component.onCompleted: {
                            color = Qt.binding(function(){
                                let pass = true
                                let tolerance = 0.025
                                let initial = Number(settings.mvInitialDfa)

                                if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                    tolerance = 5
                                    initial = Number(settings.mvInitialDfaImp)
                                }

                                console.debug(initial, Number(text))

                                if(initial >= Number(text)){
                                    const diff = (Math.round((initial - Number(text)) * 1000)/1000)
                                    console.debug(diff, tolerance)
                                    if(diff > tolerance)
                                        pass = false
                                }
                                else{
                                    const diff = (Math.round((Number(text) - initial) * 1000)/1000)
                                    console.debug(diff, tolerance)
                                    if(diff > tolerance)
                                        pass = false
                                }

                                if(pass)
                                    return "#27AE60"
                                else
                                    return "#e74c3c"
                            })
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Inflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: blockedIfaTextField
                        width: 200
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow velocity") + " (%1)".arg(mvBlock.text))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvBlockIfa = value.toFixed(2)
                            settings.mvBlockIfaImp = valueImp.toFixed()

                            //                        settings.mvBlockIfa = text
                        }//
                        Component.onCompleted: {
                            color = Qt.binding(function(){
                                let pass = true
                                let tolerance = 0.025
                                let initial = Number(settings.mvInitialIfa)

                                if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                    tolerance = 5
                                    initial = Number(settings.mvInitialIfaImp)
                                }

                                console.debug(initial, Number(text))

                                if(initial >= Number(text)){
                                    const diff = (Math.round((initial - Number(text)) * 1000)/1000)
                                    console.debug(diff, tolerance)
                                    if(diff > tolerance)
                                        pass = false
                                }
                                else{
                                    const diff = (Math.round((Number(text) - initial) * 1000)/1000)
                                    console.debug(diff, tolerance)
                                    if(diff > tolerance)
                                        pass = false
                                }

                                if(pass)
                                    return "#27AE60"
                                else
                                    return "#e74c3c"
                            })
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Power consumption") + " " + unitStr

                        property string unitStr: "(Watt)"
                    }//

                    TextFieldApp {
                        id: blockedPowerTextField
                        width: 200
                        height: 40
                        text: "0"

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Power consumption") + " (%1)".arg(mvBlock.text))
                        }//

                        onAccepted: {
                            settings.mvBlockPower = text
                        }//
                    }//
                }//

                //                            Rectangle {
                //                                height: 2
                //                                width: 120
                //                                color: "#e3dac9"
                //                            }//

                ButtonBarApp {
                    text: qsTr("Capture")

                    onClicked: {
                        blockedDutyCycleTextField.text = settings.mvInitialFanDucy/*MachineData.fanPrimaryDutyCycle*/
                        blockedRpmTextField.text = MachineData.fanPrimaryRpm

                        blockedDfaTextField.text = MachineData.dfaVelocityStr.split(" ")[0] || "0"
                        blockedIfaTextField.text = MachineData.ifaVelocityStr.split(" ")[0] || "0"

                        settings.mvBlockFanDucy = blockedDutyCycleTextField.text
                        settings.mvBlockFanRpm = blockedRpmTextField.text

                        if(MachineData.measurementUnit){
                            settings.mvBlockDfaImp = blockedDfaTextField.text
                            settings.mvBlockIfaImp = blockedIfaTextField.text
                        }else{
                            settings.mvBlockDfa = blockedDfaTextField.text
                            settings.mvBlockIfa = blockedIfaTextField.text
                        }
                    }//
                }//
            }//

            Column {
                spacing: 5

                TextApp {
                    id: mvFinal
                    text: qsTr("Final")
                }//

                Rectangle {
                    height: 2
                    width: 120
                    color: "#e3dac9"
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Fan duty cycle") + " (%)" + " | " + "RPM"
                    }//

                    Row {
                        spacing: 5

                        TextFieldApp {
                            id: finalDutyCycleTextField
                            width: 50
                            height: 40
                            //                        text: "48"
                            //colorBorder: "#f39c12"
                            enabled: false
                            //colorBackground: "#949393"
                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan duty cycle") + " (%1)".arg(mvFinal.text))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvFinalFanDucy = val
                            }//
                        }//

                        TextFieldApp {
                            id: finalRpmTextField
                            width: 145
                            height: 40
                            //                        text: "735"

                            onPressed: {
                                KeyboardOnScreenCaller.openNumpad(this, qsTr("Fan RPM") + " (%1)".arg(mvFinal.text))
                            }//

                            onAccepted: {
                                const val = Number(text)
                                settings.mvFinalFanRpm = val
                            }//
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Downflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: finalDfaTextField
                        width: 200
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Downflow velocity") + " (%1)".arg(mvFinal.text))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvFinalDfa = value.toFixed(2)
                            settings.mvFinalDfaImp = valueImp.toFixed()

                            //                        settings.mvFinalDfa = text
                        }//
                        Component.onCompleted: {
                            color = Qt.binding(function(){
                                let pass = true
                                let tolerance = 0.025
                                let initial = Number(settings.mvInitialDfa)

                                if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                    tolerance = 5
                                    initial = Number(settings.mvInitialDfaImp)
                                }

                                console.debug(initial, Number(text))

                                if(initial >= Number(text)){
                                    const diff = (Math.round((initial - Number(text)) * 1000)/1000)
                                    console.debug(diff, tolerance)
                                    if(diff > tolerance)
                                        pass = false
                                }
                                else{
                                    const diff = (Math.round((Number(text) - initial) * 1000)/1000)
                                    console.debug(diff, tolerance)
                                    if(diff > tolerance)
                                        pass = false
                                }

                                if(pass)
                                    return "#27AE60"
                                else
                                    return "#e74c3c"
                            })
                        }//
                    }//
                }//

                Column {
                    spacing: 5

                    TextApp {
                        text: qsTr("Inflow velocity") + " " + unitStr

                        property string unitStr: "(m/s)"

                        Component.onCompleted: {
                            unitStr = MachineData.measurementUnit ? "(fpm)" : "(m/s)"
                        }//
                    }//

                    TextFieldApp {
                        id: finalIfaTextField
                        width: 200
                        height: 40

                        onPressed: {
                            KeyboardOnScreenCaller.openNumpad(this, qsTr("Inflow velocity") + " (%1)".arg(mvFinal.text))
                        }//

                        onAccepted: {
                            let value = 0.0
                            let valueImp = 0.0
                            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                valueImp = Number(text)
                                value = utils.getMpsFromFpm(valueImp)
                            }else{
                                value = Number(text)
                                valueImp = utils.getFpmFromMps(value)
                            }

                            settings.mvFinalIfa = value.toFixed(2)
                            settings.mvFinalIfaImp = valueImp.toFixed()
                            //                        settings.mvFinalIfa = text
                        }//

                        Component.onCompleted: {
                            color = Qt.binding(function(){
                                let pass = true
                                let tolerance = 0.025
                                let initial = Number(settings.mvInitialIfa)

                                if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                                    tolerance = 5
                                    initial = Number(settings.mvInitialIfaImp)
                                }

                                console.debug(initial, Number(text))

                                if(initial >= Number(text)){
                                    const diff = (Math.round((initial - Number(text)) * 1000)/1000)
                                    console.debug(diff, tolerance)
                                    if(diff > tolerance)
                                        pass = false
                                }
                                else{
                                    const diff = (Math.round((Number(text) - initial) * 1000)/1000)
                                    console.debug(diff, tolerance)
                                    if(diff > tolerance)
                                        pass = false
                                }

                                if(pass)
                                    return "#27AE60"
                                else
                                    return "#e74c3c"
                            })
                        }//
                    }//
                }//

                ButtonBarApp {
                    text: qsTr("Capture")

                    onClicked: {
                        finalDutyCycleTextField.text = settings.mvInitialFanDucy/*MachineData.fanPrimaryDutyCycle*/
                        finalRpmTextField.text = MachineData.fanPrimaryRpm

                        finalDfaTextField.text = MachineData.dfaVelocityStr.split(" ")[0] || "0"
                        finalIfaTextField.text = MachineData.ifaVelocityStr.split(" ")[0] || "0"

                        settings.mvFinalFanDucy = finalDutyCycleTextField.text
                        settings.mvFinalFanRpm = finalRpmTextField.text

                        if(MachineData.measurementUnit){
                            settings.mvFinalDfaImp = finalDfaTextField.text
                            settings.mvFinalIfaImp = finalIfaTextField.text
                        }else{
                            settings.mvFinalDfa = finalDfaTextField.text
                            settings.mvFinalIfa = finalIfaTextField.text
                        }

                    }//
                }//
            }//
        }//
        Column{
            Rectangle {
                height: 1
                width: textId.width
                color: "#e3dac9"
            }//

            TextApp {
                id: textId
                text: "<u>"+ qsTr("Grill blocked")+"</u> "
                      + qsTr("and")
                      + " <u>" + qsTr("Final") + "</u> "
                      + qsTr("duty cycle")+ ", "+ qsTr("will be based on")
                      + " <u>"+ qsTr("Initial")+"</u> "
                      + qsTr("value")+ ". " + qsTr("Cannot be edited...")
                font.pixelSize: 16
            }//
        }//
    }//

    QtObject {
        id: settings
        //        category: "certification"

        property int    mvInitialFanDucy    : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvInitialFanDucy)
        property int    mvInitialFanRpm     : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvInitialFanRpm)
        property string mvInitialDfa        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialDfa)
        property string mvInitialIfa        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialIfa)
        property string mvInitialDfaImp     : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialDfaImp)
        property string mvInitialIfaImp     : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialIfaImp)
        property string mvInitialPower      : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialPower)

        property int    mvBlockFanDucy      : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvBlockFanDucy)
        property int    mvBlockFanRpm       : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvBlockFanRpm)
        property string mvBlockDfa          : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockDfa)
        property string mvBlockIfa          : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockIfa)
        property string mvBlockDfaImp       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockDfaImp)
        property string mvBlockIfaImp       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockIfaImp)
        property string mvBlockPower        : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockPower)

        property int    mvFinalFanDucy      : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvFinalFanDucy)
        property int    mvFinalFanRpm       : MachineData.getCertificationParametersInt(MachineAPI.CertifParamInt_mvFinalFanRpm)
        property string mvFinalDfa          : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalDfa)
        property string mvFinalIfa          : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalIfa)
        property string mvFinalDfaImp       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalDfaImp)
        property string mvFinalIfaImp       : MachineData.getCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalIfaImp)

        onMvInitialFanDucyChanged    : MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_mvInitialFanDucy, mvInitialFanDucy)
        onMvInitialFanRpmChanged     : MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_mvInitialFanRpm, mvInitialFanRpm)
        onMvInitialDfaChanged        : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialDfa, mvInitialDfa)
        onMvInitialIfaChanged        : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialIfa, mvInitialIfa)
        onMvInitialDfaImpChanged     : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialDfaImp, mvInitialDfaImp)
        onMvInitialIfaImpChanged     : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialIfaImp, mvInitialIfaImp)
        onMvInitialPowerChanged      : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvInitialPower, mvInitialPower)

        onMvBlockFanDucyChanged      : MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_mvBlockFanDucy, mvBlockFanDucy)
        onMvBlockFanRpmChanged       : MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_mvBlockFanRpm, mvBlockFanRpm)
        onMvBlockDfaChanged          : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockDfa, mvBlockDfa)
        onMvBlockIfaChanged          : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockIfa, mvBlockIfa)
        onMvBlockDfaImpChanged       : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockDfaImp, mvBlockDfaImp)
        onMvBlockIfaImpChanged       : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockIfaImp, mvBlockIfaImp)
        onMvBlockPowerChanged        : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvBlockPower, mvBlockPower)

        onMvFinalFanDucyChanged      : MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_mvFinalFanDucy, mvFinalFanDucy)
        onMvFinalFanRpmChanged       : MachineAPI.setCertificationParametersInt(MachineAPI.CertifParamInt_mvFinalFanRpm, mvFinalFanRpm)
        onMvFinalDfaChanged          : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalDfa, mvFinalDfa)
        onMvFinalIfaChanged          : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalIfa, mvFinalIfa)
        onMvFinalDfaImpChanged       : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalDfaImp, mvFinalDfaImp)
        onMvFinalIfaImpChanged       : MachineAPI.setCertificationParametersStr(MachineAPI.CertifParamStr_mvFinalIfaImp, mvFinalIfaImp)

        Component.onCompleted: {
            initialDutyCycleTextField.text = mvInitialFanDucy
            initialRpmTextField.text = mvInitialFanRpm
            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                initialDfaTextField.text = mvInitialDfaImp
                initialIfaTextField.text = mvInitialIfaImp
            }else{
                initialDfaTextField.text = mvInitialDfa
                initialIfaTextField.text = mvInitialIfa
            }
            initialPowerTextField.text = mvInitialPower

            blockedDutyCycleTextField.text = mvBlockFanDucy
            blockedRpmTextField.text = mvBlockFanRpm
            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                blockedDfaTextField.text = mvBlockDfaImp
                blockedIfaTextField.text = mvBlockIfaImp
            }else{
                blockedDfaTextField.text = mvBlockDfa
                blockedIfaTextField.text = mvBlockIfa
            }
            blockedPowerTextField.text = mvBlockPower

            finalDutyCycleTextField.text = mvFinalFanDucy
            finalRpmTextField.text = mvFinalFanRpm
            if(MachineData.measurementUnit === MachineAPI.MEA_UNIT_IMPERIAL){
                finalDfaTextField.text = mvFinalDfaImp
                finalIfaTextField.text = mvFinalIfaImp
            }else{
                finalDfaTextField.text = mvFinalDfa
                finalIfaTextField.text = mvFinalIfa
            }
        }//
    }//

    UtilsApp{
        id: utils
    }

}//

/*##^##
Designer {
    D{i:0;autoSize:true;formeditorColor:"#4c4e50";height:480;width:800}
}
##^##*/

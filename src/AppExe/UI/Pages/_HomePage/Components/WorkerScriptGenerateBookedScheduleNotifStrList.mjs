WorkerScript.onMessage = function(msg){
    console.debug(JSON.stringify(msg))

    if (msg.action === 'init') {
        var bookedScheduleNotifStringList = []
        let notifStrList = []
        let notifStr = ""
        let notifToShow = msg.bookedScheduleForToday
        let notifToShowLength = notifToShow.length
        let i, startTime, endTime

        if(notifToShowLength === 0){
            bookedScheduleNotifStringList = notifStr
        }

        //console.debug("notifToShow", notifToShow)
        //console.debug("notifToShowLength", notifToShowLength)

        if(notifToShowLength === 2){
            if((notifToShow[0].bookTitle === notifToShow[1].bookTitle)
                    && (notifToShow[0].bookForName === notifToShow[1].bookForName)){
                startTime = notifToShow[0].time
                endTime = String(startTime).split(":")[0]
                endTime = Number(endTime) + 2
                if(endTime < 10)
                    endTime = "0" + String(endTime) + ":00"
                else
                    endTime = String(endTime) + ":00"

                notifStr = "<b>" + notifToShow[0].bookTitle + "</b><br>"
                        + qsTr("Booked by: %1").arg(notifToShow[0].bookForName) + "<br>"
                        + qsTr("Start time: %1").arg(startTime) + "<br>"
                        + qsTr("End time: %1").arg(endTime)

                notifStrList.push(notifStr)
            }else{
                for(i=0; i<2; i++){
                    startTime = notifToShow[i].time
                    endTime = String(startTime).split(":")[0]
                    endTime = Number(endTime) + 1
                    if(endTime < 10)
                        endTime = "0" + String(endTime) + ":00"
                    else
                        endTime = String(endTime) + ":00"

                    notifStr = "<b>" + notifToShow[i].bookTitle + "</b><br>"
                            + qsTr("Booked by: %1").arg(notifToShow[i].bookForName) + "<br>"
                            + qsTr("Start time: %1").arg(startTime) + "<br>"
                            + qsTr("End time: %1").arg(endTime)

                    notifStrList.push(notifStr)
                }
            }
        }
        else if(notifToShowLength === 3){
            if((notifToShow[0].bookTitle === notifToShow[1].bookTitle)
                    && (notifToShow[1].bookTitle === notifToShow[2].bookTitle)
                    && (notifToShow[0].bookForName === notifToShow[1].bookForName)
                    && (notifToShow[1].bookForName === notifToShow[2].bookForName)){
                startTime = notifToShow[0].time
                endTime = String(startTime).split(":")[0]
                endTime = Number(endTime) + 3
                if(endTime < 10)
                    endTime = "0" + String(endTime) + ":00"
                else
                    endTime = String(endTime) + ":00"

                notifStr = "<b>" + notifToShow[0].bookTitle + "</b><br>"
                        + qsTr("Booked by: %1").arg(notifToShow[0].bookForName) + "<br>"
                        + qsTr("Start time: %1").arg(startTime) + "<br>"
                        + qsTr("End time: %1").arg(endTime)

                notifStrList.push(notifStr)
            }
            else{
                for( i=0; i<3; i++){
                    startTime = notifToShow[i].time
                    endTime = String(startTime).split(":")[0]
                    endTime = Number(endTime) + 1
                    if(endTime < 10)
                        endTime = "0" + String(endTime) + ":00"
                    else
                        endTime = String(endTime) + ":00"

                    notifStr = "<b>" + notifToShow[i].bookTitle + "</b><br>"
                            + qsTr("Booked by: %1").arg(notifToShow[i].bookForName) + "<br>"
                            + qsTr("Start time: %1").arg(startTime) + "<br>"
                            + qsTr("End time: %1").arg(endTime)

                    notifStrList.push(notifStr)
                }
            }
        }
        else if(notifToShowLength === 4){
            if((notifToShow[0].bookTitle === notifToShow[1].bookTitle)
                    && (notifToShow[1].bookTitle === notifToShow[2].bookTitle)
                    && (notifToShow[2].bookTitle === notifToShow[3].bookTitle)
                    && (notifToShow[0].bookForName === notifToShow[1].bookForName)
                    && (notifToShow[1].bookForName === notifToShow[2].bookForName)
                    && (notifToShow[2].bookForName === notifToShow[3].bookForName)){
                startTime = notifToShow[0].time
                endTime = String(startTime).split(":")[0]
                endTime = Number(endTime) + 4
                if(endTime < 10)
                    endTime = "0" + String(endTime) + ":00"
                else
                    endTime = String(endTime) + ":00"

                notifStr = "<b>" + notifToShow[0].bookTitle + "</b><br>"
                        + qsTr("Booked by: %1").arg(notifToShow[0].bookForName) + "<br>"
                        + qsTr("Start time: %1").arg(startTime) + "<br>"
                        + qsTr("End time: %1").arg(endTime)
            }
            else{
                for( i=0; i<4; i++){
                    startTime = notifToShow[i].time
                    endTime = String(startTime).split(":")[0]
                    endTime = Number(endTime) + 1
                    if(endTime < 10)
                        endTime = "0" + String(endTime) + ":00"
                    else
                        endTime = String(endTime) + ":00"

                    notifStr = "<b>" + notifToShow[i].bookTitle + "</b><br>"
                            + qsTr("Booked by: %1").arg(notifToShow[i].bookForName) + "<br>"
                            + qsTr("Start time: %1").arg(startTime) + "<br>"
                            + qsTr("End time: %1").arg(endTime)

                    notifStrList.push(notifStr)
                }
            }
        }
        else{
            startTime = notifToShow[0].time
            endTime = String(startTime).split(":")[0]
            endTime = Number(endTime) + 1
            if(endTime < 10)
                endTime = "0" + String(endTime) + ":00"
            else
                endTime = String(endTime) + ":00"

            notifStr = "<b>" + notifToShow[0].bookTitle + "</b><br>"
                    + qsTr("Booked by: %1").arg(notifToShow[0].bookForName) + "<br>"
                    + qsTr("Start time: %1").arg(startTime) + "<br>"
                    + qsTr("End time: %1").arg(endTime)

            notifStrList.push(notifStr)
        }

        bookedScheduleNotifStringList = notifStrList
        JSON.stringify(notifStrList)

        WorkerScript.sendMessage({'bookedScheduleNotifStringList' : bookedScheduleNotifStringList})
    }//
}//

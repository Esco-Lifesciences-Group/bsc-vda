import QtQuick 2.0

Item {

    property alias workerScript: ws

    WorkerScript{
        id: ws
        source: "JsonStringifyApp/WorkerScript_JsonStringifyApp.js"

        onMessage: {
            console.log(messageObject['dataStr'])
        }//
    }//
}//

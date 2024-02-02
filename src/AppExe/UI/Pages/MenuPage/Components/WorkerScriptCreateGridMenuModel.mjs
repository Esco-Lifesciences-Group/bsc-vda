WorkerScript.onMessage = function(msg) {
    //    ////console.debug(msg)

    if (msg.action === 'init') {
        ///USER LEVEL
        let userRole_GUEST          = 0
        let userRole_OPERATOR       = 1
        let userRole_SUPERVISOR     = 2//unused
        let userRole_ADMIN          = 3
        let userRole_SUPERADMIN     = 4
        let userRole_SERVICE        = 5
        let userRole_SERVICE_ESCO   = 6
        let userRole_FACTORY        = 7

        //USER_ROLE
        let userRole = msg.userlevel
        let cfr21Enable = msg.cfr21Enable

        //MENU_MODEL
        let menuGroupModel = []
        //MENU_INDICATOR
        let menuIndicator = []

        let menu = [[]]
        let index = 0

        const itemPerPage = 7

        //OPERATOR_MENU
        if(userRole >= userRole_OPERATOR){

            menu = [[]]
            index = 0

            //            if(userRole !== userRole_ADMIN)
            //            {
            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Experiment Timer"),
                                 micon     : "qrc:/UI/Pictures/menu/Experiment-Timer.png",
                                 mlink     : "qrc:/UI/Pages/ExperimentTimerPage/ExperimentTimerShortcutPage.qml"
                                 //                                 mlink     : "qrc:/UI/Pages/FtpFileSharePage/FtpFileSharePage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Light Intensity"),
                                 micon     : "qrc:/UI/Pictures/menu/Light-Intensity.png",
                                 mlink     : "qrc:/UI/Pages/LightIntensityPage/LightIntensityPage.qml"
                             })

            //            }//

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("LCD Brightness"),
                                 micon     : "qrc:/UI/Pictures/menu/Adjust-Brightness.png",
                                 mlink     : "qrc:/UI/Pages/LcdBrightnessPage/LcdBrightnessPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("LCD Cleaning"),
                                 micon     : "qrc:/UI/Pictures/menu/Clear-LCD.png",
                                 mlink     : "qrc:/UI/Pages/CleanLcdPage/CleanLcdPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Booking Schedule"),
                                 micon      :   "qrc:/UI/Pictures/booking_schedule.png",
                                 mlink      :   "qrc:/UI/Pages/BookingSchedule/BookingSchedule.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Data Log"),
                                 micon     : "qrc:/UI/Pictures/menu/log-button_2.png",
                                 mlink     : "qrc:/UI/Pages/DataLogPage/DataLogPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Alarm Log"),
                                 micon     : "qrc:/UI/Pictures/menu/log-button_2.png",
                                 mlink     : "qrc:/UI/Pages/AlarmLogPage/AlarmLogPage.qml"
                             })

            if(cfr21Enable){
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype        : "menu",
                                     mtitle    : qsTr("Event Log"),
                                     micon     : "qrc:/UI/Pictures/menu/log-button_2.png",
                                     mlink     : "qrc:/UI/Pages/EventLogPage/EventLogPage.qml"
                                 })
            }//

            if(msg["uvInstalled"] !== undefined){
                if(msg["uvInstalled"] === true){
                    if(menu[index].length > itemPerPage) {index++; menu.push([])}
                    menu[index].push({mtype        : "menu",
                                         mtitle    : qsTr("UV Timer"),
                                         micon     : "qrc:/UI/Pictures/menu/UV_Timer.png",
                                         mlink     : "qrc:/UI/Pages/UVTimerSetPage/UVTimerSetPage.qml"
                                     })
                }
            }

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Fan Scheduler"),
                                 micon     : "qrc:/UI/Pictures/menu/Fan_Schedule.png",
                                 mlink     : "qrc:/UI/Pages/FanSchedulerPage/FanSchedulerPage.qml"
                             })

            if(msg["uvInstalled"] !== undefined){
                if(msg["uvInstalled"] === true){
                    if(menu[index].length > itemPerPage) {index++; menu.push([])}
                    menu[index].push({mtype        : "menu",
                                         mtitle    : qsTr("UV Scheduler"),
                                         micon     : "qrc:/UI/Pictures/menu/UV_Sched.png",
                                         mlink     : "qrc:/UI/Pages/UVSchedulerPage/UVSchedulerPage.qml"
                                     })
                }
            }

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Light Scheduler"),
                                 micon     : "qrc:/UI/Pictures/menu/Light_Sched.png",
                                 mlink     : "qrc:/UI/Pages/LightSchedulerPage/LightSchedulerPage.qml"
                             })

            if(msg["socketInstalled"] !== undefined){
                if(msg["socketInstalled"] === true){
                    if(menu[index].length > itemPerPage) {index++; menu.push([])}
                    menu[index].push({mtype        : "menu",
                                         mtitle    : qsTr("El-Outlet Scheduler"),
                                         micon     : "qrc:/UI/Pictures/menu/Socket_Sched.png",
                                         mlink     : "qrc:/UI/Pages/SocketSchedulerPage/SocketSchedulerPage.qml"
                                     })
                }
            }

            if(msg["particleCounterInstalled"] !== undefined){
                if(msg["particleCounterInstalled"] === true){
                    if(menu[index].length > itemPerPage) {index++; menu.push([])}
                    menu[index].push({mtype        : "menu",
                                         mtitle    : qsTr("Particulate Matter Information"),
                                         micon     : "qrc:/UI/Pictures/menu/particulate_matter_icon.png",
                                         mlink     : "qrc:/UI/Pages/ParticleCounterInfoPage/ParticleCounterInfoPage.qml"
                                     })
                }
            }//

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("About"),
                                 micon      :   "qrc:/UI/Pictures/menu/about-us.png",
                                 mlink      :   "qrc:/UI/Pages/ShortCutMenuPage/ShortCutMenuPage.qml"
                             })

            //MENU_INDICATOR
            menuIndicator.push(qsTr("Operator"))
            //PUSH_TO_MENU_MODEL
            menuGroupModel.push(menu)
            //            ////console.debug(menu)
            //            ////console.debug(menuGroupModel)
            //                ////console.debug(menuGroupModel.length)
        }//

        //ADMIN_MENU
        if(userRole >= userRole_OPERATOR){

            menu = [[]]
            index = 0

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Shut down"),
                                 micon     : "qrc:/UI/Pictures/menu/Shutdown.png",
                                 mlink     : "qrc:/UI/Pages/LeavePage/LeavePage.qml"
                                 //                                             mlink      : "FanInputPin"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Users"),
                                 micon      :   "qrc:/UI/Pictures/menu/User Mgnt.png",
                                 mlink      :   "qrc:/UI/Pages/UserManagePage/UserManagePage.qml"
                             })

            if(userRole >= userRole_ADMIN)
            {
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Logout Time"),
                                     micon      :   "qrc:/UI/Pictures/menu/logout-time.png",
                                     mlink      :   "qrc:/UI/Pages/LogoutTimePage/LogoutTimePage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype        : "menu",
                                     mtitle    : qsTr("Languages"),
                                     micon     : "qrc:/UI/Pictures/menu/Language.png",
                                     mlink     : "qrc:/UI/Pages/LanguagePage/LanguagePage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Cabinet Name"),
                                     micon      :   "qrc:/UI/Pictures/menu/Cabinet Name.png",
                                     mlink      :   "qrc:/UI/Pages/CabinetNameSetPage/CabinetNameSetPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Time Zone"),
                                     micon      :   "qrc:/UI/Pictures/menu/Time Zone.png",
                                     mlink      :   "qrc:/UI/Pages/TimeZonePage/TimeZonePage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype       :   "menu",
                                     mtitle   :   qsTr("Date"),
                                     micon    :   "qrc:/UI/Pictures/menu/Set-Date.png",
                                     mlink    :   "qrc:/UI/Pages/DateSetPage/DateSetPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype        :   "menu",
                                     mtitle    :   qsTr("Time"),
                                     micon     :   "qrc:/UI/Pictures/menu/Set-Time.png",
                                     mlink     :   "qrc:/UI/Pages/TimeSetPage/TimeSetPage.qml"
                                 })


                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Fan PIN"),
                                     micon      :   "qrc:/UI/Pictures/menu/Blower PIN.png",
                                     mlink      :   "qrc:/UI/Pages/FanPinSetPage/FanPinSetPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Operation Mode"),
                                     micon      :   "qrc:/UI/Pictures/menu/Set-User-Mode.png",
                                     mlink      :   "qrc:/UI/Pages/OperationModePage/OperationModePage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Airflow Monitor"),
                                     micon      :   "qrc:/UI/Pictures/menu/Airflow-Monitor.png",
                                     mlink      :   "qrc:/UI/Pages/AirflowMonitorPage/AirflowMonitorPage.qml"
                                 })
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Airflow Out Temperature"),
                                     micon      :   "qrc:/UI/Pictures/menu/Airflow-Out.png",
                                     mlink      :   "qrc:/UI/Pages/AirflowOutTempPage/AirflowOutTempPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype        : "menu",
                                     mtitle    : qsTr("Mute Timer"),
                                     micon     : "qrc:/UI/Pictures/menu/Mute Timer.png",
                                     mlink     : "qrc:/UI/Pages/MuteTimerSetPage/MuteTimerSetPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Warmup Timer"),
                                     micon      :   "qrc:/UI/Pictures/menu/Warm-Up.png",
                                     mlink      :   "qrc:/UI/Pages/WarmupSetPage/WarmupSetPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Post Purge Timer"),
                                     micon      :   "qrc:/UI/Pictures/menu/Post-Purge.png",
                                     mlink      :   "qrc:/UI/Pages/PostPurgeSetPage/PostPurgeSetPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype        : "menu",
                                     mtitle    : qsTr("Network"),
                                     micon     : "qrc:/UI/Pictures/menu/wifi.png",
                                     mlink     : "qrc:/UI/Pages/NetworkConfigPage/NetworkConfigPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Remote Modbus"),
                                     micon      :   "qrc:/UI/Pictures/menu/Remote Modbus.png",
                                     mlink      :   "qrc:/UI/Pages/RemoteModbusPage/RemoteModbusPage.qml"
                                 })
            }//

            //MENU_INDICATOR
            menuIndicator.push(qsTr("Admin"))
            //PUSH_TO_MENU_MODEL
            menuGroupModel.push(menu)
        }//

        //SERVICE_MENU
        if(userRole >= userRole_ADMIN){
            menu = [[]]
            index = 0
            if(userRole >= userRole_SERVICE){
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Fan Speed"),
                                     micon      :   "qrc:/UI/Pictures/menu/set-fan-speed.png",
                                     mlink      :   "qrc:/UI/Pages/FanSpeedPage/FanSpeedPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Measurement Unit"),
                                     micon      :   "qrc:/UI/Pictures/menu/Measurement-Unit.png",
                                     mlink      :   "qrc:/UI/Pages/MeasurementUnitPage/MeasurementUnitPage.qml"
                                 })//

                if(userRole >= userRole_SERVICE_ESCO){
                    if(menu[index].length > itemPerPage) {index++; menu.push([])}
                    menu[index].push({mtype         :   "menu",
                                         mtitle     :   qsTr("Field Sensor Calibration"),
                                         micon      :   "qrc:/UI/Pictures/menu/Field-Calibration.png",
                                         mlink      :   "qrc:/UI/Pages/FieldCalibratePage/FieldCalibPageOptions.qml"
                                     })//
                }//
                else{
                    if(menu[index].length > itemPerPage) {index++; menu.push([])}
                    menu[index].push({mtype         :   "menu",
                                         mtitle     :   qsTr("Field Sensor Calibration"),
                                         micon      :   "qrc:/UI/Pictures/menu/Field-Calibration.png",
                                         mlink      :   "qrc:/UI/Pages/FieldCalibratePage/FieldCalibBasicPage.qml"
                                     })//
                }//

                if(msg["seasInstalled"] !== undefined){
                    if(msg["seasInstalled"] === true){
                        if(menu[index].length > itemPerPage) {index++; menu.push([])}
                        menu[index].push({mtype        : "menu",
                                             mtitle    : qsTr("Pressure Alarm Setpoint"),
                                             micon     : "qrc:/UI/Pictures/seas_alarm.png",
                                             mlink     : "qrc:/UI/Pages/SeasAlarmSetPointPage/SeasAlarmSetPointPage.qml"
                                             //                                 mlink     : "qrc:/UI/Pages/FtpFileSharePage/FtpFileSharePage.qml"
                                         })//
                    }//
                }//


                //         if(menu[index].length > itemPerPage) {index++; menu.push([])}
                //            menu[index].push({mtype        : "menu",
                //                                 mtitle    : qsTr("Certification Reminder"),
                //                                 micon     : "qrc:/UI/Pictures/menu/reminder_date.png",
                //                                 mlink     : "qrc:/UI/Pages/CertificationReminderDatePage/CertificationReminderDatePage.qml"
                //                                 //                                             mlink      : "FanInputPin"
                //                             })
                if(userRole >= userRole_SERVICE_ESCO){
                    if(menu[index].length > itemPerPage) {index++; menu.push([])}
                    menu[index].push({mtype         :   "menu",
                                         mtitle     :   qsTr("Field Certification Summary"),
                                         micon      :   "qrc:/UI/Pictures/menu/cert_report_icon_field.png",
                                         mlink      :   "qrc:/UI/Pages/CertificationShortCut/CertificationShortCutField.qml"
                                     })
                }else{
                    if(menu[index].length > itemPerPage) {index++; menu.push([])}
                    menu[index].push({mtype         :   "menu",
                                         mtitle     :   qsTr("Field Certification Summary"),
                                         micon      :   "qrc:/UI/Pictures/menu/cert_report_icon_field.png",
                                         mlink      :   "qrc:/UI/Pages/CertificationReportPage/CertificationReportFieldBasicPage.qml"
                                     })
                }//

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Manual Input Calibration"),
                                     micon      :   "qrc:/UI/Pictures/menu/Manual-Input-Data.png",
                                     mlink      :   "qrc:/UI/Pages/ManualInputDataPage/GettingManualInputDataPage.qml"
                                 })
                if(msg["sensorConstant"] !== undefined )
                {
                    if (msg["sensorConstant"] > 0){
                        if(menu[index].length > itemPerPage) {index++; menu.push([])}
                        menu[index].push({mtype         :   "menu",
                                             mtitle     :   qsTr("Sensor Constant Correction"),
                                             micon      :   "qrc:/UI/Pictures/menu/sensor-constant-corr.png",
                                             mlink      :   "qrc:/UI/Pages/SensorConstantCorrectionPage/SensorConstantCorrectionPage.qml"
                                         })
                    }//
                }//

                //            if(menu[index].length > itemPerPage) {index++; menu.push([])}
                //            menu[index].push({mtype         :   "menu",
                //                                 mtitle     :   qsTr("Installation Wizard"),
                //                                 micon      :   "qrc:/UI/Pictures/menu/Installation Wizard.png",
                //                                 mlink      :   "qrc:/UI/Pages/InstallationWizardPage/InstallationWizardPage.qml"
                //                             })

                ////////////////////////////////
                /// SUB_RESET_MENU
                let resetMenu = []
                resetMenu.push({mtype         :   "menu",
                                   mtitle     :   qsTr("Reset Filter Life Meter"),
                                   micon      :   "qrc:/UI/Pictures/menu/Reset-Filter-Odometer.png",
                                   mlink      :   "qrc:/UI/Pages/ResetFilterLifePage/ResetFilterLifePage.qml"
                               })

                resetMenu.push({mtype         :   "menu",
                                   mtitle     :   qsTr("Reset Fan Usage Meter"),
                                   micon      :   "qrc:/UI/Pictures/menu/Reset-Blower-Odometer.png",
                                   mlink      :   "qrc:/UI/Pages/ResetBlowerMeterPage/ResetBlowerMeterPage.qml"
                               })

                if(msg["uvInstalled"] !== undefined){
                    if(msg["uvInstalled"] === true){
                        //IF_UV_AVAILBALE_IN_THIS_UNIT
                        resetMenu.push({mtype         :   "menu",
                                           mtitle     :   qsTr("Reset UV Life Meter"),
                                           micon      :   "qrc:/UI/Pictures/menu/Reset-UV-Lamp-Odometer.png",
                                           mlink      :   "qrc:/UI/Pages/ResetUvLifePage/ResetUvLifePage.qml"
                                       })
                    }
                }

                if (msg["sashWindowMotorizeInstalled"] !== undefined){
                    //                console.log(msg["sashWindowMotorizeInstalled"])
                    if (msg["sashWindowMotorizeInstalled"] === true){
                        resetMenu.push({mtype         :   "menu",
                                           mtitle     :   qsTr("Reset Sash Cycle Meter"),
                                           micon      :   "qrc:/UI/Pictures/menu/Reset-Sash-Cycle-Odometer.png",
                                           mlink      :   "qrc:/UI/Pages/ResetSashCycleMeterPage/ResetSashCycleMeterPage.qml"
                                       })
                    }
                }

                if (msg["fieldCalibrated"] !== undefined){
                    //                console.log(msg["sashWindowMotorizeInstalled"])
                    if (msg["fieldCalibrated"] === true){
                        resetMenu.push({mtype         :   "menu",
                                           mtitle     :   qsTr("Reset Field Calibration"),
                                           micon      :   "qrc:/UI/Pictures/menu/Reset-Calibration.png",
                                           mlink      :   "qrc:/UI/Pages/ResetFieldCalibrationPage/ResetFieldCalibrationPage.qml"
                                       })
                    }//
                }//

                resetMenu.push({mtype         :   "menu",
                                   mtitle     :   qsTr("Reset Configuration"),
                                   micon      :   "qrc:/UI/Pictures/menu/Reset-Default.png",
                                   mlink      :   "qrc:/UI/Pages/ResetConfigurationPage/ResetConfigurationPage.qml"
                               })

                ///////////////////////////////

                /// PUT TO ACTUAL MENU
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "submenu",
                                     mtitle     :   qsTr("Reset Parameters"),
                                     micon      :   "qrc:/UI/Pictures/menu/Reset-Default.png",
                                     mlink      :   "",
                                     sub        :   resetMenu
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Advanced Airflow Alarm"),
                                     micon      :   "qrc:/UI/Pictures/menu/adv-af-alarm.png",
                                     mlink      :   "qrc:/UI/Pages/AdvancedAirflowAlarmPage/AdvancedAirflowAlarmPage.qml"
                                     //                                 mlink      :   "qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Environmental Temperature Limit"),
                                     micon      :   "qrc:/UI/Pictures/menu/Env-Temp-Limit.png",
                                     mlink      :   "qrc:/UI/Pages/TemperatureAmbOperationSetPage/TemperatureAmbOperationSetPage.qml"
                                     //                                 mlink      :   "qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype        : "menu",
                                     mtitle    : qsTr("Security Level"),
                                     micon     : "qrc:/UI/Pictures/security_level.png",
                                     mlink     : "qrc:/UI/Pages/SecurityLevelSetPage/SecurityLevelSetPage.qml"
                                     //                                 mlink     : "qrc:/UI/Pages/FtpFileSharePage/FtpFileSharePage.qml"
                                 })
            }//

            //            if(userRole >= userRole_ADMIN){
            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Replaceable Components Record"),
                                 micon     : "qrc:/UI/Pictures/menu/Commissioning_icon.png",
                                 mlink     : "qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsPage.qml"
                                 //                                 mlink     : "qrc:/UI/Pages/FtpFileSharePage/FtpFileSharePage.qml"
                             })//
            //            }//

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        : "menu",
                                 mtitle    : qsTr("Preventive Maintenance"),
                                 micon     : "qrc:/UI/Pictures/menu/preventive-maintenance.png",
                                 mlink     : "qrc:/UI/Pages/PreventiveMaintenancePage/PreventiveMaintenancePage.qml"
                                 //                                 mlink     : "qrc:/UI/Pages/FtpFileSharePage/FtpFileSharePage.qml"
                             })
            if(userRole >= userRole_SERVICE){
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("System Monitor"),
                                     micon      :   "qrc:/UI/Pictures/menu/resource-mon.png",
                                     mlink      :   "qrc:/UI/Pages/ResourceMonitorPage/ResourceMonitorPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Shipping Setup"),
                                     micon      :   "qrc:/UI/Pictures/menu/shipping-menu.png",
                                     mlink      :   "qrc:/UI/Pages/ShippingSetupPage/ShippingSetupPage.qml"
                                 })

                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype        :   "menu",
                                     mtitle    :   qsTr("Software Update"),
                                     micon     :   "qrc:/UI/Pictures/menu/Software-Update.png",
                                     mlink     :   "qrc:/UI/Pages/SoftwareUpdatePage/SoftwareUpdatePage.qml"
                                 })//
            }//

            //MENU_INDICATOR
            menuIndicator.push(qsTr("Service"))
            //PUSH_TO_MENU_MODEL
            menuGroupModel.push(menu)
        }//

        //FACTORY_MENU
        if(userRole >= userRole_FACTORY){

            menu = [[]]
            index = 0

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Full Sensor Calibration"),
                                 micon      :   "qrc:/UI/Pictures/menu/Calibrate-Sensor.png",
                                 mlink      :   "qrc:/UI/Pages/FullCalibrateSensorPage/FullCalibrateSensorPage.qml"
                             })
            if(msg["oneOfTenEnable"]){
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Full Certification Summary"),
                                     micon      :   "qrc:/UI/Pictures/menu/cert_report_icon_full.png",
                                     mlink      :   "qrc:/UI/Pages/CertificationShortCut/CertificationShortCut.qml"
                                 })
            }else{
                if(menu[index].length > itemPerPage) {index++; menu.push([])}
                menu[index].push({mtype         :   "menu",
                                     mtitle     :   qsTr("Full Certification Summary"),
                                     micon      :   "qrc:/UI/Pictures/menu/cert_report_icon_full.png",
                                     mlink      :   "qrc:/UI/Pages/CertificationReportPage/CertificationReportPage.qml"
                                 })
            }

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("Serial Number"),
                                 micon     :   "qrc:/UI/Pictures/menu/BSC_Serial.png",
                                 //                                            mlink     :   "CabinetSelectOptionPage"
                                 mlink       : "qrc:/UI/Pages/SerialNumberSetPage/SerialNumberSetPage.qml"
                             })
            //

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("ESCO Lock Service"),
                                 micon      :   "qrc:/UI/Pictures/menu/Esco_Lock.png",
                                 mlink      :   "qrc:/UI/Pages/EscoLockServicePage/EscoLockServicePage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("21 CFR Part 11"),
                                 micon      :   "qrc:/UI/Pictures/menu/21-cfr-p11.png",
                                 mlink      :   "qrc:/UI/Pages/CFR21Part11Page/CFR21Part11Page.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype         :   "menu",
                                 mtitle     :   qsTr("Auxiliary Functions"),
                                 micon      :   "qrc:/UI/Pictures/menu/Auxiliary F.png",
                                 mlink      :   "qrc:/UI/Pages/AuxiliaryFunctionsPage/AuxiliaryFunctionsPage.qml"
                                 //                                 mlink      :   "qrc:/UI/Pages/ReplaceablePartsPage/ReplaceablePartsPage.qml"
                             })
            //
            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("Cabinet Model"),
                                 micon     :   "qrc:/UI/Pictures/menu/Select-Cabinet-Model.png",
                                 mlink     :   "qrc:/UI/Pages/CabinetProfilePage/CabinetProfilePage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("RTC Watchdog Test"),
                                 micon     :   "qrc:/UI/Pictures/menu/rtc-watchdog-test-menu.png",
                                 mlink     :   "qrc:/UI/Pages/RtcWatchdogTestPage/RtcWatchdogTestPage.qml"
                             })

            if(menu[index].length > itemPerPage) {index++; menu.push([])}
            menu[index].push({mtype        :   "menu",
                                 mtitle    :   qsTr("System Information"),
                                 micon     :   "qrc:/UI/Pictures/menu/microprocessor-device.png",
                                 mlink     :   "qrc:/UI/Pages/SystemInformationPage/SystemInformationPage.qml"
                             })

            //MENU_INDICATOR
            menuIndicator.push(qsTr("Factory"))
            //PUSH_TO_MENU_MODEL
            menuGroupModel.push(menu)
        }

        //        //SET_MENU_MODEL
        //        menuApp.menuGroup = menuGroupModel
        //        //SET_MENU_INDICATOR_MODEL
        //        menuApp.menuGroupIndicator = menuIndicator
        //        //
        //        menuApp.initMenu()

        //        msg.modelmenu = menuGroupModel;
        //        msg.modelmenu.sync(); /// update front end

        //        ////console.debug(menuGroupModel)
        WorkerScript.sendMessage({'menu' : menuGroupModel, 'indicator' : menuIndicator})
    }
}

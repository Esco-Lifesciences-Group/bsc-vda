/**
 *  Copyright (C) 2021 by ESCO Bintan Indonesia
 *  https://escoglobal.com
 *
 *  Author: Heri Cahyono
**/

import QtQuick 2.0

QtObject {
    //// Version 1 UUID Generator
    //// https://www.uuidgenerator.net/

    readonly property var profiles: [
        {
            "name": "-",
        },
        ////////////////////// LA2
        ////// Sash 8 Inches
        ////// 3 Feet
        {"name": "VDA-3", "profilelId": "d4c04484-15ec-44e9-b90d-cb22fbb33a6c",
            "modelBase": 1,
            "classStr": "",
            "modelStr": "VDA",
            "width": {
                "meter": 0.914 /*meter = 3 Feet*/,
                "feet": 3
            },
            "sashWindow": 14,//inch
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2000,
                "constant": {
                    "a1": 1,
                    "a2": 0.1333,
                    "a3": 0.00002431,
                    "a4": 1.0118
                }
            },
            "envTempLimit": {
                "highest": 35,
                "lowest": 5,
            },
            "airflow": {
                "ifa": {
                    "dim": {
                        "gridCount": 5,
                        "nominal": {
                            "fanDutyCycle": 39,
                            "metric": {
                                "volume": 144,
                                "velocity": 0.16,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.135,
                                "velocityTolHigh": 0.185,
                                "openingArea": 0.899,
                            },
                            "imp": {
                                "volume": 300,
                                "velocity": 31,
                                "velocityTol": 5,
                                "velocityTolLow": 26,
                                "velocityTolHigh": 36,
                                "openingArea": 9.67,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 81,
                                "velocity": 0.09,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.065,
                                "velocityTolHigh": 0.115,
                                "openingArea": 0.899,
                            },
                            "imp": {
                                "volume": 174,
                                "velocity": 18,
                                "velocityTol": 5,
                                "velocityTolLow": 13,
                                "velocityTolHigh": 23,
                                "openingArea": 9.67,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "metric": {
                                "volume": 46,
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                                "openingArea": 0.046,
                            },
                            "imp": {
                                "volume": 97,
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                                "openingArea": 0.492,

                            },
                        }
                    },
                    "sec": {
                        "nominal": {
                            "fanDutyCycle": 39,
                            "correctionFactor": 0.066,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.16,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.135,
                                "velocityTolHigh": 0.185,
                            },
                            "imp": {
                                "velocity": 31,
                                "velocityTol": 5,
                                "velocityTolLow": 26,
                                "velocityTolHigh": 36,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.066,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.09,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.065,
                                "velocityTolHigh": 0.115,
                            },
                            "imp": {
                                "velocity": 18,
                                "velocityTol": 5,
                                "velocityTolLow": 13,
                                "velocityTolHigh": 23,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.066,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                            },
                            "imp": {
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.24,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.215,
                            "velocityTolHigh": 0.265,
                        },
                        "imp": {
                            "velocity": 48,
                            "velocityTol": 5,
                            "velocityTolLow": 43,
                            "velocityTolHigh": 53
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    }
                }
            }
        },
        ///// 4 Feet
        {"name": "VDA-4", "profilelId": "88bfd485-17ce-418b-93c2-38634690791a",
            "modelBase": 1,
            "classStr": "",
            "modelStr": "VDA",
            "width": {
                "meter": 1.220 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 14,//inch
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2000,
                "constant": {
                    "a1": 1,
                    "a2": 0.1333,
                    "a3": 0.00002431,
                    "a4": 1.0118
                }
            },
            "envTempLimit": {
                "highest": 35,
                "lowest": 5,
            },
            "airflow": {
                "ifa": {
                    "dim": {
                        "gridCount": 5,
                        "nominal": {
                            "fanDutyCycle": 39,
                            "metric": {
                                "volume": 144,
                                "velocity": 0.16,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.135,
                                "velocityTolHigh": 0.185,
                                "openingArea": 0.899,
                            },
                            "imp": {
                                "volume": 300,
                                "velocity": 31,
                                "velocityTol": 5,
                                "velocityTolLow": 26,
                                "velocityTolHigh": 36,
                                "openingArea": 9.67,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 81,
                                "velocity": 0.09,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.065,
                                "velocityTolHigh": 0.115,
                                "openingArea": 0.899,
                            },
                            "imp": {
                                "volume": 174,
                                "velocity": 18,
                                "velocityTol": 5,
                                "velocityTolLow": 13,
                                "velocityTolHigh": 23,
                                "openingArea": 9.67,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "metric": {
                                "volume": 61,
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                                "openingArea": 0.061,
                            },
                            "imp": {
                                "volume": 129,
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                                "openingArea": 0.656,

                            },
                        }
                    },
                    "sec": {
                        "nominal": {
                            "fanDutyCycle": 39,
                            "correctionFactor": 0.066,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.16,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.135,
                                "velocityTolHigh": 0.185,
                            },
                            "imp": {
                                "velocity": 31,
                                "velocityTol": 5,
                                "velocityTolLow": 26,
                                "velocityTolHigh": 36,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.066,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.09,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.065,
                                "velocityTolHigh": 0.115,
                            },
                            "imp": {
                                "velocity": 18,
                                "velocityTol": 5,
                                "velocityTolLow": 13,
                                "velocityTolHigh": 23,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.066,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                            },
                            "imp": {
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.24,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.215,
                            "velocityTolHigh": 0.265,
                        },
                        "imp": {
                            "velocity": 48,
                            "velocityTol": 5,
                            "velocityTolLow": 43,
                            "velocityTolHigh": 53
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    }
                }
            }
        },
        ///// 5 Feet
        {"name": "VDA-5", "profilelId": "58109ea0-db6b-4b34-b9a3-73cb9f322b9a",
            "modelBase": 1,
            "classStr": "",
            "modelStr": "VDA",
            "width": {
                "meter": 1.524 /*meter = 5 Feet*/,
                "feet": 5
            },
            "sashWindow": 14,//inch
            "fan": {
                "horsePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2000,
                "constant": {
                    "a1": 1.0667,
                    "a2": 0.3412,
                    "a3": 0.00000002249,
                    "a4": 1.6392
                }
            },
            "envTempLimit": {
                "highest": 35,
                "lowest": 5,
            },
            "airflow": {
                "ifa": {
                    "dim": {
                        "gridCount": 5,
                        "nominal": {
                            "fanDutyCycle": 38,
                            "metric": {
                                "volume": 179,
                                "velocity": 0.16,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.135,
                                "velocityTolHigh": 0.185,
                                "openingArea": 1.118,
                            },
                            "imp": {
                                "volume": 374,
                                "velocity": 31,
                                "velocityTol": 5,
                                "velocityTolLow": 26,
                                "velocityTolHigh": 36,
                                "openingArea": 12.05,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 28,
                            "metric": {
                                "volume": 101,
                                "velocity": 0.09,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.065,
                                "velocityTolHigh": 0.115,
                                "openingArea": 1.118,
                            },
                            "imp": {
                                "volume": 217,
                                "velocity": 18,
                                "velocityTol": 5,
                                "velocityTolLow": 13,
                                "velocityTolHigh": 23,
                                "openingArea": 12.05,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "metric": {
                                "volume": 77,
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                                "openingArea": 0.077,
                            },
                            "imp": {
                                "volume": 162,
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                                "openingArea": 0.820,

                            },
                        }
                    },
                    "sec": {
                        "nominal": {
                            "fanDutyCycle": 39,
                            "correctionFactor": 0.065,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.16,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.135,
                                "velocityTolHigh": 0.185,
                            },
                            "imp": {
                                "velocity": 31,
                                "velocityTol": 5,
                                "velocityTolLow": 26,
                                "velocityTolHigh": 36,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.065,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.09,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.065,
                                "velocityTolHigh": 0.115,
                            },
                            "imp": {
                                "velocity": 18,
                                "velocityTol": 5,
                                "velocityTolLow": 13,
                                "velocityTolHigh": 23,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.065,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                            },
                            "imp": {
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.24,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.215,
                            "velocityTolHigh": 0.265,
                        },
                        "imp": {
                            "velocity": 48,
                            "velocityTol": 5,
                            "velocityTolLow": 43,
                            "velocityTolHigh": 53,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    }
                }
            }
        },
        ///// 6 Feet
        {"name": "VDA-6", "profilelId": "b009adb6-be88-4cd7-8102-dbcb38a2b563",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.829 /*meter = 6 Feet*/,
                "feet": 6
            },
            "sashWindow": 14,//inch
            "fan": {
                "horsePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2000,
                "constant": {
                    "a1": 1.0667,
                    "a2": 0.3412,
                    "a3": 0.00000002249,
                    "a4": 1.6392
                }
            },
            "envTempLimit": {
                "highest": 35,
                "lowest": 5,
            },
            "airflow": {
                "ifa": {
                    "dim": {
                        "gridCount": 5,
                        "nominal": {
                            "fanDutyCycle": 38,
                            "metric": {
                                "volume": 179,
                                "velocity": 0.16,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.135,
                                "velocityTolHigh": 0.185,
                                "openingArea": 1.118,
                            },
                            "imp": {
                                "volume": 374,
                                "velocity": 31,
                                "velocityTol": 5,
                                "velocityTolLow": 26,
                                "velocityTolHigh": 36,
                                "openingArea": 12.05,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 28,
                            "metric": {
                                "volume": 101,
                                "velocity": 0.09,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.065,
                                "velocityTolHigh": 0.115,
                                "openingArea": 1.118,
                            },
                            "imp": {
                                "volume": 217,
                                "velocity": 18,
                                "velocityTol": 5,
                                "velocityTolLow": 13,
                                "velocityTolHigh": 23,
                                "openingArea": 12.05,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "metric": {
                                "volume": 92,
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                                "openingArea": 0.092,
                            },
                            "imp": {
                                "volume": 194,
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                                "openingArea": 0.984,

                            },
                        }
                    },
                    "sec": {
                        "nominal": {
                            "fanDutyCycle": 39,
                            "correctionFactor": 0.065,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.16,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.135,
                                "velocityTolHigh": 0.185,
                            },
                            "imp": {
                                "velocity": 31,
                                "velocityTol": 5,
                                "velocityTolLow": 26,
                                "velocityTolHigh": 36,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.065,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.09,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.065,
                                "velocityTolHigh": 0.115,
                            },
                            "imp": {
                                "velocity": 18,
                                "velocityTol": 5,
                                "velocityTolLow": 13,
                                "velocityTolHigh": 23,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.065,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 1,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.975,
                                "velocityTolHigh": 1.025,
                            },
                            "imp": {
                                "velocity": 197,
                                "velocityTol": 5,
                                "velocityTolLow": 192,
                                "velocityTolHigh": 202,
                            },
                        }
                    }
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.24,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.215,
                            "velocityTolHigh": 0.265,
                        },
                        "imp": {
                            "velocity": 48,
                            "velocityTol": 5,
                            "velocityTolLow": 43,
                            "velocityTolHigh": 53,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 8,
                            "columns": 4,
                        }
                    }
                }
            }
        },
    ]
}//

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
        {"name": "LA2-3 Sash 8\"", "profilelId": "c46dbb82-8878-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 0.914 /*meter = 3 Feet*/,
                "feet": 3
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 1800,
                "constant": {
                    "a1": 1.5176,
                    "a2": 0.4353,
                    "a3": 0.00000002617,
                    "a4": 1.098
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
                                "volume": 99,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.187,
                            },
                            "imp": {
                                "volume": 210,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 2.0,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 75,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.187,
                            },
                            "imp": {
                                "volume": 158,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 2.0,
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
                            "correctionFactor": 0.380,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.421,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.380,
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
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 21,
                            "columns": 7,
                        }
                    }
                }
            }
        },
        ///// 4 Feet
        {"name": "LA2-4 Sash 8\"", "profilelId": "c9ca8100-8878-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.220 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2000,
                "constant": {
                    "a1": 1.5059,
                    "a2": 0.3294,
                    "a3": 0.000004763,
                    "a4": 0.6431
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
                                "volume": 131,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.248,
                            },
                            "imp": {
                                "volume": 280,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 2.669,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 99,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.248,
                            },
                            "imp": {
                                "volume": 211,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 2.669,
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
                            "correctionFactor": 0.371,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.389,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.371,
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
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 21,
                            "columns": 7,
                        }
                    }
                }
            }
        },
        ///// 5 Feet
        {"name": "LA2-5 Sash 8\"", "profilelId": "d6ce280c-8878-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.524 /*meter = 5 Feet*/,
                "feet": 5
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2500,
                "constant": {
                    "a1": 1.0314,
                    "a2": 0.1843,
                    "a3": 0.00004836,
                    "a4": 0.949
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
                                "volume": 165,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.311,
                            },
                            "imp": {
                                "volume": 350,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 3.333,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 28,
                            "metric": {
                                "volume": 124,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.311,
                            },
                            "imp": {
                                "volume": 263,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 3.333,
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
                            "correctionFactor": 0.364,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.387,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.364,
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
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 27,
                            "columns": 9,
                        }
                    }
                }
            }
        },
        ///// 6 Feet
        {"name": "LA2-6 Sash 8\"", "profilelId": "ee3ef502-8878-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.829 /*meter = 6 Feet*/,
                "feet": 6
            },
            "sashWindow": 8,
            "fan": {
                "horsePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 3000,
                "constant": {
                    "a1": 1.1137,
                    "a2": 0.5451,
                    "a3": 0.000005337,
                    "a4": 1.0902
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
                            "fanDutyCycle": 37,
                            "metric": {
                                "volume": 197,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.371,
                            },
                            "imp": {
                                "volume": 420,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 4.000,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 149,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.371,
                            },
                            "imp": {
                                "volume": 316,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 4.000,
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
                            "correctionFactor": 0.327,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.378,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.327,
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
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 33,
                            "columns": 11,
                        }
                    }
                }
            }
        },

        ////// Sash 10 Inches
        ////// 3 Feet
        {"name": "LA2-3 Sash 10\"", "profilelId": "fe8dbf9c-8878-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 0.914 /*meter = 4 Feet*/,
                "feet": 3
            },
            "sashWindow": 10,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 1800,
                "constant": {
                    "a1": 1.5176,
                    "a2": 0.4353,
                    "a3": 0.00000002617,
                    "a4": 1.098
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
                            "fanDutyCycle": 43,
                            "metric": {
                                "volume": 124,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.234,
                            },
                            "imp": {
                                "volume": 263,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 2.500,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 93,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.234,
                            },
                            "imp": {
                                "volume": 198,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 2.500,
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
                            "correctionFactor": 0.301,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.342,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.301,
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
                            "velocity": 0.33,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.305,
                            "velocityTolHigh": 0.355,
                        },
                        "imp": {
                            "velocity": 65,
                            "velocityTol": 5,
                            "velocityTolLow": 60,
                            "velocityTolHigh": 70,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 21,
                            "columns": 7,
                        }
                    }
                }
            }
        },
        ////// 4 Feet
        {"name": "LA2-4 Sash 10\"", "profilelId": "04edc30a-8879-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.220 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 10,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2000,
                "constant": {
                    "a1": 1.5059,
                    "a2": 0.3294,
                    "a3": 0.000004763,
                    "a4": 0.6431
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
                            "fanDutyCycle": 45,
                            "metric": {
                                "volume": 164,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.310,
                            },
                            "imp": {
                                "volume": 350,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 3.333,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 35,
                            "metric": {
                                "volume": 124,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.310,
                            },
                            "imp": {
                                "volume": 263,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 3.333,
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
                            "correctionFactor": 0.319,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.317,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.319,
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
                        "fanDutyCycle": 45,
                        "metric": {
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 21,
                            "columns": 7,
                        }
                    }
                }
            }
        },
        ////// 5 Feet
        {"name": "LA2-5 Sash 10\"", "profilelId": "0abf71de-8879-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.524 /*meter = 4 Feet*/,
                "feet": 5
            },
            "sashWindow": 10,
            "fan": {
                "horsePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2500,
                "constant": {
                    "a1": 1.0314,
                    "a2": 0.1843,
                    "a3": 0.00004836,
                    "a4": 0.949
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
                            "fanDutyCycle": 44,
                            "metric": {
                                "volume": 206,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.389,
                            },
                            "imp": {
                                "volume": 438,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 4.167,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 33,
                            "metric": {
                                "volume": 155,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.389,
                            },
                            "imp": {
                                "volume": 329,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 4.167,
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
                            "correctionFactor": 0.313,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.312,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.313,
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
                        "fanDutyCycle": 43,
                        "metric": {
                            "velocity": 0.33,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.305,
                            "velocityTolHigh": 0.355,
                        },
                        "imp": {
                            "velocity": 65,
                            "velocityTol": 5,
                            "velocityTolLow": 60,
                            "velocityTolHigh": 70,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 27,
                            "columns": 9,
                        }
                    }
                }
            }
        },
        ////// 6 Feet
        {"name": "LA2-6 Sash 10\"", "profilelId": "109bbb94-8879-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.829 /*meter = 6 Feet*/,
                "feet": 6
            },
            "sashWindow": 10,
            "fan": {
                "horsePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 3000,
                "constant": {
                    "a1": 1.1137,
                    "a2": 0.5451,
                    "a3": 0.000005337,
                    "a4": 1.0902
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
                            "fanDutyCycle": 43,
                            "metric": {
                                "volume": 246,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.465,
                            },
                            "imp": {
                                "volume": 525,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 5.000,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 33,
                            "metric": {
                                "volume": 186,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.465,
                            },
                            "imp": {
                                "volume": 395,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 5.000,
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
                            "correctionFactor": 0.281,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.322,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.281,
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
                        "fanDutyCycle": 43,
                        "metric": {
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 33,
                            "columns": 11,
                        }
                    }
                }
            }
        },

        ////// Sash 12 Inches -> Check value on Certification Procedure
        ////// 3 Feet
        {"name": "LA2-3 Sash 12\"", "profilelId": "fe8dbf9c-5578-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 0.914 /*meter = 4 Feet*/,
                "feet": 3
            },
            "sashWindow": 12,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 1800,
                "constant": {
                    "a1": 1.5176,
                    "a2": 0.4353,
                    "a3": 0.00000002617,
                    "a4": 1.098
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
                            "fanDutyCycle": 43,
                            "metric": {
                                "volume": 149,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.281,
                            },
                            "imp": {
                                "volume": 315,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 3,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "metric": {
                                "volume": 112,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.281,
                            },
                            "imp": {
                                "volume": 237,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 3,
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
                            "correctionFactor": 0.260,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.295,
                            "gridCount": 6, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.260,
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
                    }//
                },
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 39,
                        "metric": {
                            "velocity": 0.35,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.325,
                            "velocityTolHigh": 0.375,
                        },
                        "imp": {
                            "velocity": 70,
                            "velocityTol": 5,
                            "velocityTolLow": 65,
                            "velocityTolHigh": 75,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 21,
                            "columns": 7,
                        }
                    }
                }
            }
        },
        ////// 4 Feet
        {"name": "LA2-4 Sash 12\"", "profilelId": "04edc30a-7659-11eb-a843-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.220 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 12,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2000,
                "constant": {
                    "a1": 1.5059,
                    "a2": 0.3294,
                    "a3": 0.000004763,
                    "a4": 0.6431
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
                            "fanDutyCycle": 45,
                            "metric": {
                                "volume": 197,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.372,
                            },
                            "imp": {
                                "volume": 420,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 4,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 35,
                            "metric": {
                                "volume": 149,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.372,
                            },
                            "imp": {
                                "volume": 316,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 4,
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
                        }//
                    },
                    "sec": {
                        "nominal": {
                            "correctionFactor": 0.250,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.262,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.250,
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
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 21,
                            "columns": 7,
                        }
                    }
                }
            }
        },
        ////// 5 Feet
        {"name": "LA2-5 Sash 12\"", "profilelId": "0abf71de-9839-11ec-a8a3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.524 /*meter = 5 Feet*/,
                "feet": 5
            },
            "sashWindow": 12,
            "fan": {
                "horsePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2500,
                "constant": {
                    "a1": 1.0314,
                    "a2": 0.1843,
                    "a3": 0.00004836,
                    "a4": 0.949
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
                            "fanDutyCycle": 44,
                            "metric": {
                                "volume": 247,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.467,
                            },
                            "imp": {
                                "volume": 525,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 5,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 33,
                            "metric": {
                                "volume": 187,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.467,
                            },
                            "imp": {
                                "volume": 395,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 5,
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
                            "correctionFactor": 0.273,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.264,
                            "gridCount": 10, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.273,
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
                        "fanDutyCycle": 43,
                        "metric": {
                            "velocity": 0.35,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.325,
                            "velocityTolHigh": 0.375,
                        },
                        "imp": {
                            "velocity": 70,
                            "velocityTol": 5,
                            "velocityTolLow": 65,
                            "velocityTolHigh": 75,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 27,
                            "columns": 9,
                        }
                    }
                }
            }
        },
        ////// 6 Feet
        {"name": "LA2-6 Sash 12\"", "profilelId": "04edc30a-0129-11eb-a143-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "LA2",
            "width": {
                "meter": 1.829 /*meter = 6 Feet*/,
                "feet": 6
            },
            "sashWindow": 12,
            "fan": {
                "horsePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 3000,
                "constant": {
                    "a1": 1.1137,
                    "a2": 0.5451,
                    "a3": 0.000005337,
                    "a4": 1.0902
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
                            "fanDutyCycle": 43,
                            "metric": {
                                "volume": 296,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.558,
                            },
                            "imp": {
                                "volume": 630,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 6,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 33,
                            "metric": {
                                "volume": 223,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.558,
                            },
                            "imp": {
                                "volume": 474,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 6,
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
                            "correctionFactor": 0.222,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.265,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.222,
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
                        "fanDutyCycle": 43,
                        "metric": {
                            "velocity": 0.35,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.325,
                            "velocityTolHigh": 0.375,
                        },
                        "imp": {
                            "velocity": 70,
                            "velocityTol": 5,
                            "velocityTolLow": 65,
                            "velocityTolHigh": 75,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 33,
                            "columns": 11,
                        }
                    }
                }
            }
        },

        ////// VA2
        ////// Sash 12 Inches
        ////// 4 Feet
        {"name": "VA2-4", "profilelId": "04edc30a-8879-11eb-a833-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "VA2",
            "width": {
                "meter": 1.220 /*meter = 4 Feet*/,
                "feet": 4
            },
            "sashWindow": 12,
            "fan": {
                "horsePower": 0.75,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 2000,
                "constant": {
                    "a1": 1.5059,
                    "a2": 0.3294,
                    "a3": 0.000004763,
                    "a4": 0.6431
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
                            "fanDutyCycle": 45,
                            "metric": {
                                "volume": 197,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.372,
                            },
                            "imp": {
                                "volume": 420,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 4,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 35,
                            "metric": {
                                "volume": 149,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.372,
                            },
                            "imp": {
                                "volume": 316,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 4,
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
                        }//
                    },
                    "sec": {
                        "nominal": {
                            "correctionFactor": 0.260,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.262,
                            "gridCount": 8, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.260,
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
                            "velocity": 0.30,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.275,
                            "velocityTolHigh": 0.325,
                        },
                        "imp": {
                            "velocity": 60,
                            "velocityTol": 5,
                            "velocityTolLow": 55,
                            "velocityTolHigh": 65,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 21,
                            "columns": 7,
                        }
                    }
                }
            }
        },
        ////// 6 Feet
        {"name": "VA2-6", "profilelId": "109bbb94-8879-11ef-a8t3-0242ac120002",
            "modelBase": 1,
            "classStr": "CLASS II A2",
            "modelStr": "VA2",
            "width": {
                "meter": 1.829 /*meter = 6 Feet*/,
                "feet": 6
            },
            "sashWindow": 12,
            "fan": {
                "horsePower": 1,
                "direction": 1,
                "highSpeedLimit": 1292,
                "maxAirVolume": 3000,
                "constant": {
                    "a1": 1.1137,
                    "a2": 0.5451,
                    "a3": 0.000005337,
                    "a4": 1.0902
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
                            "fanDutyCycle": 43,
                            "metric": {
                                "volume": 296,
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                                "openingArea": 0.558,
                            },
                            "imp": {
                                "volume": 630,
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                                "openingArea": 6,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 33,
                            "metric": {
                                "volume": 223,
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                                "openingArea": 0.558,
                            },
                            "imp": {
                                "volume": 474,
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                                "openingArea": 6,
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
                            "correctionFactor": 0.238,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.53,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.505,
                                "velocityTolHigh": 0.555,
                            },
                            "imp": {
                                "velocity": 105,
                                "velocityTol": 5,
                                "velocityTolLow": 100,
                                "velocityTolHigh": 110,
                            },
                        },
                        "minimum": {
                            "fanDutyCycle": 29,
                            "correctionFactor": 0.265,
                            "gridCount": 12, // 2 times from cabinet width
                            "metric": {
                                "velocity": 0.40,
                                "velocityTol": 0.025,
                                "velocityTolLow": 0.375,
                                "velocityTolHigh": 0.425,
                            },
                            "imp": {
                                "velocity": 80,
                                "velocityTol": 5,
                                "velocityTolLow": 75,
                                "velocityTolHigh": 85,
                            },
                        },
                        "stb": {
                            "fanDutyCycle": 10,
                            "correctionFactor": 0.238,
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
                    }//
                },//
                "dfa": {
                    "nominal": {
                        "fanDutyCycle": 43,
                        "metric": {
                            "velocity": 0.35,
                            "velocityTol": 0.025,
                            "velocityTolLow": 0.325,
                            "velocityTolHigh": 0.375,
                        },
                        "imp": {
                            "velocity": 70,
                            "velocityTol": 5,
                            "velocityTolLow": 65,
                            "velocityTolHigh": 75,
                        },
                        "velDevp": 20, /*%*/
                        "velDevpField": 25, /*%*/
                        "grid": {
                            "count": 33,
                            "columns": 11,
                        }
                    }
                }
            }
        },
    ]
}//

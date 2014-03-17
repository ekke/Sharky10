APP_NAME = Sharky10

MQTT_PROJECT=Mqtt

CONFIG += qt warn_on cascades10

INCLUDEPATH += /daten/bb_workspaces/cascades-api-10-1/$${MQTT_PROJECT}/public

LIBS += -lsocket

include(config.pri)

device {
    CONFIG(debug, debug|release) {
		LIBS += -L/daten/bb_workspaces/cascades-api-10-1/$${MQTT_PROJECT}/Device-Debug -l$${MQTT_PROJECT}
    }
    CONFIG(release, debug|release) {
		 LIBS += -L/daten/bb_workspaces/cascades-api-10-1/$${MQTT_PROJECT}/Device-Release -l$${MQTT_PROJECT}
    }
    CONFIG(profile, debug|profile) {
        LIBS += -L/daten/bb_workspaces/cascades-api-10-1/$${MQTT_PROJECT}/Device-Debug -l$${MQTT_PROJECT}
    }
}

simulator {
    CONFIG(debug, debug|release) {
		LIBS += -L/daten/bb_workspaces/cascades-api-10-1/$${MQTT_PROJECT}/Simulator-Debug -l$${MQTT_PROJECT}
    }
}
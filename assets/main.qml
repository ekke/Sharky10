/* Copyright (c) 2013 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import bb.cascades 1.0

NavigationPane {
    id: navigationPane
    Page {
        Container {
            id: mainPage
            objectName: "mainPage"
            // ======== Properties ========
            property bool clientConnected: false
            property bool clientSubscribed: false
            
            property string hostname: "10.0.0.40"
            property string sharkyTopic: "sharky_commands"

            // ======== SIGNAL()s ========
            signal mqttConnect(string hostname)
            signal mqttDisconnect()
            signal mqttPublish(string topic, string message)
            signal mqttSubscribe(string topic)
            signal mqttUnSubscribe(string topic)

            // ======== SLOT()s ========
            function mqttConnected() {
                clientConnected = true;
            }
            function mqttDisconnected() {
                clientConnected = false;
            }
            // ======== Local functions ========

            function clientConnectionStatus() {
                if (clientConnected) {
                    return "started";
                } else {
                    return "not started";
                }
            }

            // ======== Components ========

            layout: StackLayout {
            }

            topPadding: 10
            leftPadding: 30
            rightPadding: 30

            Container {
                layout: DockLayout {
                }

                leftPadding: 20
                bottomPadding: 20
                horizontalAlignment: HorizontalAlignment.Center

                Container {
                    layout: StackLayout {
                    }
                    
                    Container {
                        id: sharkyImageContainer
                        horizontalAlignment: HorizontalAlignment.Center
                        verticalAlignment: VerticalAlignment.Top
                        ImageView {
                            minHeight: 720
                            maxHeight: 720
                            minWidth: 720
                            maxWidth: 720
                            imageSource: "asset:///images/sharky_720.png"
                        }
                        ImageLabel {
                            label: qsTr("MQTT client " + mainPage.clientConnectionStatus())
                            image: mainPage.clientConnected ? "asset:///images/led_green_black.png" : "asset:///images/led_red_black.png"
                            horizontalAlignment: HorizontalAlignment.Left
                        }
                        
                    } // end sharkyImageContainer
                    Container {
                        id: subscribeToContainer
                        visible: false
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }

                        Button {
                            id: startSubscribeButton
                            text: (mainPage.clientConnected & mainPage.clientSubscribed) ? qsTr("Unsubscribe") : qsTr("Subscribe to")
                            enabled: mainPage.clientConnected
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 40
                            }
                            horizontalAlignment: HorizontalAlignment.Center
                            onClicked: {
                                if (mainPage.clientSubscribed) {
                                    mainPage.clientSubscribed = false;
                                    mainPage.mqttUnSubscribe(topicText.text);
                                } else {
                                    mainPage.clientSubscribed = true;
                                    mainPage.mqttSubscribe(topicText.text);
                                }
                            }
                        }
                        TextField {
                            id: topicText
                            text: "bbc/#"
                            //text: "foo/bar"
                            inputMode: TextFieldInputMode.Text
                            input.flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.AutoCorrectionOff | TextInputFlag.AutoPeriodOff | TextInputFlag.PredictionOff | TextInputFlag.SpellCheckOff
                            enabled: mainPage.clientConnected & ! mainPage.clientSubscribed
                            verticalAlignment: VerticalAlignment.Center
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 60
                            }
                        }
                    } // end subscribeToContainer
                    Container {
                        id: publishToContainer
                        visible: false
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Container {
                            leftPadding: 15
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 40
                            }
                            Label {
                                text: "    Publish to"
                            }
                        }
                        TextField {
                            id: publishTopicText
                            text: "sharky_commands"
                            inputMode: TextFieldInputMode.Text
                            input.flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.AutoCorrectionOff | TextInputFlag.AutoPeriodOff | TextInputFlag.PredictionOff | TextInputFlag.SpellCheckOff
                            enabled: mainPage.clientConnected
                            verticalAlignment: VerticalAlignment.Center
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 60
                            }
                        }
                    } // end publishToContainer
                    Container {
                        id: publishSendContainer
                        visible: false
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }

                        Button {
                            id: sendButton
                            text: qsTr("Publish")
                            enabled: mainPage.clientConnected
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 40
                            }
                            horizontalAlignment: HorizontalAlignment.Center
                            onClicked: {
                                mainPage.mqttPublish(mainPage.sharkyTopic, sendText.text);
                            }
                        }
                        TextField {
                            id: sendText
                            text: "Hello, MQTT!"
                            inputMode: TextFieldInputMode.Text
                            enabled: mainPage.clientConnected
                            verticalAlignment: VerticalAlignment.Center
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 60
                            }
                        }
                    } // end publishSendContainer
                    Container {
                        id: sharkyControlRotation
                        topPadding: 40
                        leftPadding: 40
                        rightPadding: 40
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Button {
                            text: "LEFT"
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1.0
                            }
                            onClicked: {
                                controlSharky("rotation:1")
                            }
                        }
                        Button {
                            text: "RIGHT"
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1.0
                            }
                            onClicked: {
                                controlSharky("rotation:-1")
                            }
                        }
                    } // end sharkyControlRotation
                    Container {
                        id: sharkyPitchController
                        topPadding: 40
                        leftPadding: 40
                        rightPadding: 40
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: "Down"
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 0.3
                            }
                        }
                        Slider {
                            id: pitchSlider
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1.5
                            }
                            fromValue: -5
                            toValue: 5
                            value: 0
                            onValueChanged: {
                                var newValue = Math.floor(pitchSlider.value);
                                controlSharky("pitch:"+newValue)
                            }
                        }
                        Label {
                            text: "Up"
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 0.3
                            }
                        }
                    } // end sharkyPitchController
                    Container {
                        id: sharkySpeedController
                        topPadding: 60
                        leftPadding: 40
                        rightPadding: 40
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        Label {
                            text: "Slow"
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 0.3
                            }
                        }
                        Slider {
                            id: speedSlider
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1.5
                            }
                            fromValue: 0
                            toValue: 5
                            value: 0
                            onValueChanged: {
                                var newValue = Math.floor(speedSlider.value);
                                controlSharky("speed:"+newValue)
                            }
                        }
                        Label {
                            text: "Fast"
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 0.3
                            }
                        }
                    } // end sharkySpeedController
                }
            }
            onCreationCompleted: {
            }
        }

        actions: [
            ActionItem {
                title: mainPage.clientConnected ? qsTr("Stop") : qsTr("Start")
                imageSource: mainPage.clientConnected ? "asset:///images/ic_stop.png" : "asset:///images/ic_play.png"
                ActionBar.placement: ActionBarPlacement.OnBar
                onTriggered: {
                    if (mainPage.clientConnected) {
                        mainPage.mqttDisconnect();
                        mainPage.clientSubscribed = false;
                    } else {
                        mainPage.mqttConnect(mainPage.hostname);
                    }
                }
            },
            ActionItem {
                title: "Use Mosquitto"
                imageSource: "asset:///images/mosquitto.png"
                ActionBar.placement: ActionBarPlacement.InOverflow
                onTriggered: {
                    mainPage.hostname = "test.mosquitto.org"
                }
            }
        ]

    }
    
    function controlSharky(publishText){
        console.debug("Publish to "+mainPage.sharkyTopic+" value: "+publishText)
        mainPage.mqttPublish(mainPage.sharkyTopic, publishText);
    }
    
    onCreationCompleted: {
        console.log("XXXX NavigationPane - onCreationCompleted()");
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
    }

    onPopTransitionEnded: {
        console.log("XXXX NavigationPane - onPopTransitionEnded()");
        page.destroy();
    }
}

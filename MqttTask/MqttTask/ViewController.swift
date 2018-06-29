//
//  ViewController.swift
//  MqttTask
//
//  Created by Mina Adel on 6/27/18.
//  Copyright © 2018 Mina Adel. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController, CocoaMQTTDelegate{

    @IBAction func ByeSW(_ sender: UISwitch) {
        let messagePayload = sender.isOn ? type(of: self).turnOnSw1Command : type(of: self).turnOffSw1Command
        mqttClient.publish(type(of: self).Switch1CommandTopic, withString: messagePayload, qos: CocoaMQTTQOS.qos0, retained: false, dup: false)
    }
    
    

    
    @IBAction func HelloSW(_ sender: UISwitch)
    {
        let messagePayload = sender.isOn ? type(of: self).turnOnSw2Command : type(of: self).turnOffSw2Command
        mqttClient.publish(type(of: self).Switch2CommandTopic, withString: messagePayload, qos: CocoaMQTTQOS.qos0, retained: false, dup: false)
    }

    @IBOutlet weak var InCommingMassages: UILabel!
    
    
    static let Switch1CommandTopic = "commands/boards/SWITCH01"
    static let Switch2CommandTopic = "commands/boards/SWITCH02"
    static let IncommingMsgStatusTopic = "status/boards/LABLE01"
    static let turnOnSw1Command = "Hello"
    static let turnOffSw1Command = ""
    static let turnOnSw2Command = "Bye"
    static let turnOffSw2Command = ""
    var mqttClient: CocoaMQTT!
    func configureMQTTAndConnect() {
        let clientID = "iOS_mina_MQTT_Task" + String(ProcessInfo().processIdentifier)
        // Replace with the host name for the MQTT Server(Broker)
        let host = "m11.cloudmqtt.com"
        // Replace with the port number for MQTT Server
        let port = UInt16(16101)
        mqttClient = CocoaMQTT(clientID: clientID, host: host, port: port)
        mqttClient.username = "hmhbvtug"
        mqttClient.password = "NAdWB1vMhylY"
        mqttClient.keepAlive = 60
        mqttClient.delegate = self
        mqttClient.connect()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureMQTTAndConnect()
    }

    func mqtt(_ mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        // Connection established with the MQTT Server
        print("Connected with MQTT Server \(host):\(port)")
    }
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        // Connection acknowledged
        print("Connection acknowledged \(ack)rawValue: \(ack.rawValue)")
        if ack == .accept {
            // Subscribe to the motor01StatusTopic topic with QoS 0
            mqtt.subscribe(type(of: self).IncommingMsgStatusTopic, qos:
                CocoaMQTTQOS.qos0)
        }
    }
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id:
        UInt16) {
        print("Message published to topic \(message.topic) with payload \(message.string!)")
    }
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("Publish acknowledged with id: \(id)")
    }
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id:
        UInt16 ) {
        print("Message received in topic \(message.topic) with payload \(message.string!)")
            if (message.topic == type(of: self).IncommingMsgStatusTopic) {
            InCommingMassages.text = "\(message.string!)"
        }
    }
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("Subscribed to \(topic)")
    }
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("Unsubscribed from \(topic)")
    }
    func mqttDidPing(_ mqtt: CocoaMQTT) {
    }
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
    }
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("Disconnected from the MQTT Server")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


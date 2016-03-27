//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by Devesh Laungani on 3/24/16.
//  Copyright (c) 2016 Devesh Laungani. All rights reserved.
//

import SpriteKit
import SocketIOClientSwift

// Set socket connection location an initialize it for the the GameView



class GameScene: SKScene {
    
    let socket = SocketIOClient(socketURL: NSURL(string: "http://192.168.1.143:1234")!, options: [.Log(false), .ForcePolling(true)])
    

    let player = SKSpriteNode(imageNamed: "player")
    
    var background = SKSpriteNode(imageNamed: "maze2")
    
    override func didMoveToView(view: SKView) {
        // 2
        backgroundColor = SKColor.whiteColor()
        // 3
        //player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        player.position = CGPoint(x: size.width, y: 0)
        
       
        // 4
        
        background.position = CGPoint(x: size.width/2 - 80, y: frame.size.height / 2)
        background.yScale = 0.75
        addChild(player)
        addChild(background)
        
        
        self.addHandlers()
        socket.connect()
        
        
    }
    
    
    // Add handlers for socket connections
    func addHandlers() {
        
        //self.socket.onAny {print("Got event: \($0.event), with items: \($0.items)")}
        socket.emit("freeze", "Hello!")
        
        socket.on("new_coord") {data, ack in
            print("new_coord event detected")
            //print("Got event: \(data as! NSString ), with items: \(data.items)")
            
            
            if  let info = data[0] as? NSDictionary {
            
                var xPosition = info["x"] as! Double
                var yPosition = info["y"] as! Double
                
                print (xPosition)
                print (yPosition)
                
                let xBounds = Float(self.size.width)
                let yBounds = Float(self.size.height)
                
                let xBounds1 = Double (xBounds)
                let yBounds1 = Double (yBounds)
                
               
               
                
                var adjustedXValue = (xBounds1 / 60) * xPosition
                var adjustedYValue = (yBounds1 / 60 ) * yPosition
                
                self.setPlayerPosition(adjustedXValue , yVal: adjustedYValue)
                
            }
            
        }
    }
    
    
    func setPlayerPosition (xVal: Double , yVal: Double) {
        
        // Determine where to spawn the monster along the Y axis
        //let actualY = random(min: player.size.height/2, max: size.height - player.size.height/2)
        print ("Processed is \(xVal) ")
        print ("Processed is \(yVal) ")
        // Determine where to spawn the monster along the Y axis
        print (player.position)
        player.position = CGPoint(x: xVal, y: yVal)
        print (player.position)
        // Determine speed of the monster
        //let actualDuration = 1
        
        /*
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -playersize.width/2, y: 20, duration: NSTimeInterval(actualDuration))
        let actionMoveDone = nil //SKAction.removeFromParent()
        player.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        */
    }
    
    
}

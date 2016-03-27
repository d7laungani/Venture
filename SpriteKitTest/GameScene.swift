//
//  GameScene.swift
//  SpriteKitTest
//
//  Created by Devesh Laungani on 3/26/16.
//  Copyright (c) 2016 Devesh Laungani. All rights reserved.
//

import SpriteKit
import SocketIOClientSwift


class GameScene: SKScene {
    
    // Set socket connection location an initialize it for the the GameView
    
    //let socket = SocketIOClient(socketURL: NSURL(string: "http://default-environment.qbap3sembc.us-east-1.elasticbeanstalk.com/:80")!, options: [.Log(false), .ForcePolling(true)])
    
    let socket = SocketIOClient(socketURL: NSURL(string: "http://192.168.35.101:1234")!, options: [.Log(false), .ForcePolling(true)])

/****************************************************************************/
    
     /*********************************************************/
     /*                                                       */
     /*    Start of global button implementations             */
     /*                                                       */
     /*********************************************************/
    
    // Create a background from an image
    var background = SKSpriteNode(imageNamed: "background")
    
    // Create a collection of TWbutton doors
    var doorSpawnPoints:[TWButton] = []
    
    // Create a collection of TWbutton monster spawn points
    var monsterSpawnPoints:[TWButton] = []
    
    // Create a collection of SKSpriteNode monsters
    var monsters:[SKSpriteNode] = []

    
    // Button implementaiton using TWButton class
    //let spawnMonsterButton = TWButton(size: CGSize(width: 100, height: 35), normalColor: SKColor.blueColor(), highlightedColor: SKColor.redColor() )
    let spawnMonsterButton = TWButton (normalTexture: SKTexture(imageNamed: "monster_btn_up"), highlightedTexture: SKTexture(imageNamed: "monster_btn_up"))
    //let mainDoorButton = TWButton(size: CGSize(width: 100, height: 35), normalColor: SKColor.yellowColor(), highlightedColor: SKColor.redColor() )
    let mainDoorButton = TWButton (normalTexture: SKTexture(imageNamed: "door_btn_up"), highlightedTexture: SKTexture(imageNamed: "door_btn_up"))
    //let createGhostButton = TWButton(size: CGSize(width: 100, height: 35), normalColor: SKColor.greenColor(), highlightedColor: SKColor.redColor() )
    let createGhostButton = TWButton (normalTexture: SKTexture(imageNamed: "ghost_btn"), highlightedTexture: SKTexture(imageNamed: "ghost_btn"))
    
    //let freezeButton = TWButton(size: CGSize(width: 100, height: 35), normalColor: SKColor.blueColor(), highlightedColor: SKColor.redColor() )
    let freezeButton = TWButton (normalTexture: SKTexture(imageNamed: "ice_btn_up"), highlightedTexture: SKTexture(imageNamed: "ice_btn_up"))
    
    // Player initialization
    let player = SKSpriteNode(imageNamed: "player_mark")
    
    // Maze Image implementation
    var mazeImage = SKSpriteNode(imageNamed: "map")
    
    // Main label Implementation
    var gameLabel = SKSpriteNode (imageNamed: "Venture")
    
     /*********************************************************/
     /*                                                       */
     /*    End of global button implementations               */
     /*                                                       */
     /*********************************************************/

/****************************************************************************/
    
    
    // Real number is number + 1
    let numberOfMonsters = 10
    let numberOfDoors = 3
    let numberOfMonsterSpawnPoints = 7
    
    
    
    
    override func didMoveToView(view: SKView) {
        
        // Background Image Configuration
        
        background.position = CGPoint(x: (frame.size.width / 2) + 182, y: frame.size.height / 2)
        background.zPosition = 0
        background.setScale(0.28)
        background.xScale = 0.32
        background.yScale = 0.275
        let darkBrown = UIColor(hexString: "413402")
        
        backgroundColor = darkBrown
        
        addChild(background)
        
        /*
        // Game label configuration
        let myColor = UIColor(hexString: "669999")
        let gameLabel = SKLabelNode(imageNamed:"Venture")
        gameLabel.fontColor = myColor
        gameLabel.text = "Venture"
        gameLabel.fontSize = 25
        */
        gameLabel.position = CGPoint(x: size.width/2 + 175, y: size.height - 80)
        
        gameLabel.setScale(0.6)
        gameLabel.zPosition = 2

        
        //backgroundColor = myColor
        self.addChild(gameLabel)

        
        // Maze Image setup Configuration
        
        mazeImage.position = CGPoint(x: size.width/2  - 150, y: frame.size.height / 2 )
        mazeImage.setScale(0.7)
        mazeImage.zPosition = 1
        
        
        // Define Constraints for anything inside of map image
        let xConstraintRange = SKRange(lowerLimit: (-512/2), upperLimit: (512/2))
        let yConstraintRange = SKRange(lowerLimit: (-512/2), upperLimit: (512/2))
        
        let distanceConstraint = SKConstraint.positionX(xConstraintRange)
        
        // Player setup configuration
        
        player.setScale(0.035)
        player.zPosition = 10
        player.position = CGPoint(x: 0, y: 0)
        player.constraints = [SKConstraint.positionX(xConstraintRange,y:yConstraintRange)]
        player.hidden = true
        
        mazeImage.addChild(player)
        
        
        // Monster setup configuration
        // Runs through all monsters in monsters array limited by numberOfMonsters variable limiter
        for i in 0...numberOfMonsters {
            
            var monster = SKSpriteNode(imageNamed: "monster_mark")
            monster.name = "\(i)"
            monsters.append(monster)
            monster.setScale(0.115)
            monster.zPosition = 9
            monster.position = CGPoint(x: 0, y: 0)
            monster.constraints = [SKConstraint.positionX(xConstraintRange,y:yConstraintRange)]
            monster.hidden = true
           
            mazeImage.addChild(monster)
            
            
        }
        
        
       
        // Freeze Button Setup Configuration
        
        
        freezeButton.position = CGPoint(x: size.width - 80 , y: (size.height/2) - 60 )
        freezeButton.userData = ["clickedCount" : 0 ]
        //freezeButton.setNormalStateLabelText("Freeze")
        freezeButton.zPosition = 5
        self.addChild(freezeButton)
        freezeButton.addClosure(.TouchUpInside, target: self) { (target, sender) -> () in
            
            
            //self.freezeButton.enabled =  false
            print ("Freeze button pressed")
            self.socket.emit("freeze", "Hello!")
            print ("freeze successful")
            
        }

        
        // Create Ghost Button Setup Configuration
        
        
        createGhostButton.position = CGPoint(x: size.width - 140 , y: (size.height/2) + 40 )
        createGhostButton.userData = ["clickedCount" : 0 ]
        //createGhostButton.setNormalStateLabelText("Ghost")
        createGhostButton.zPosition = 5
        self.addChild(createGhostButton)
        
        createGhostButton.addClosure(.TouchUpInside, target: self) { (target, sender) -> () in
            
            self.createGhostButton.enabled =  false
            print ("Create Ghost button pressed")
            
        }

        
        
        
/****************************************************************************/
        
        /*********************************************************/
        /*                                                       */
        /*    Start of door spawn  point implementation          */
        /*                                                       */
        /*********************************************************/
        
       // Setup main door button
        
        mainDoorButton.position = CGPoint(x: size.width - 80 , y: (size.height/2) - 60 )
        mainDoorButton.userData = ["clickedCount" : 0 ]
        mainDoorButton.zPosition = 5
        mainDoorButton.enabled = false
        mainDoorButton.hidden = true
        
       
        mainDoorButton.addClosure(.TouchUpInside, target: self) { (target, sender) -> () in
            
           
                //self.mainDoorButton.enabled = false
                self.displayDoors()
            
        }
        
        self.addChild(mainDoorButton)
        
        
        // Setup multiple spawn door button classes
        // Doors setup configuration
        // Runs through all doors in doors array limited by numberOfDoors variable limiter
        
        for i in 0...numberOfDoors {
            
            var door = TWButton(normalTexture: SKTexture(imageNamed:"door_mark"), highlightedTexture: nil)
            //door.size = CGSize(width: 50, height: 50)
            door.setScale(0.1)
            door.name = "\(i)"
            doorSpawnPoints.append(door)
            door.setScale(1)
            door.zPosition = 9
          
            
            door.constraints = [SKConstraint.positionX(xConstraintRange,y:yConstraintRange)]
            door.hidden = true
            door.enabled = false
            
            mazeImage.addChild(door)
            
            doorSpawnPoints[i].addClosure(.TouchUpInside, target: self) { (target, sender) -> () in
                
                print(i)
                let json = [ "id" : i]
                self.socket.emit("door", json)
                self.doorSpawnPoints[i].enabled = true
                //self.killAllDoors()
                
                
            }
            
        }
        

        
        
        /*********************************************************/
        /*                                                       */
        /*    End of door spawn  point implementation            */
        /*                                                       */
        /*********************************************************/
        
        
/****************************************************************************/
        
        
        
        /*********************************************************/
        /*                                                       */
        /*    Start of monster spawn  point implementation       */
        /*                                                       */
        /*********************************************************/
        
        // spawn button class using TWButton class implementation Setup Configuration
        
        
        spawnMonsterButton.position = CGPoint(x: size.width - 220 , y: (size.height/2) - 60)
        spawnMonsterButton.userData = ["clickedCount" : 0 ]
        //spawnMonsterButton.setNormalStateLabelText("Monster")
        spawnMonsterButton.zPosition = 5
        spawnMonsterButton.addClosure(.TouchUpInside, target: self) { (target, sender) -> () in
            
            //print(self.spawnMonsterButton.enabled)
            self.displayMonsterSpawnPoints()
            
        }
 
        self.addChild(spawnMonsterButton)
        
        for i in 0...numberOfMonsterSpawnPoints {
            
            
            var monsterSpawnPoint = TWButton(normalTexture: SKTexture(imageNamed:"spawn_point"), highlightedTexture: nil)
            //door.size = CGSize(width: 50, height: 50)
            monsterSpawnPoint.setScale(0.1)
            monsterSpawnPoint.name = "\(i)"
            monsterSpawnPoints.append(monsterSpawnPoint)
            monsterSpawnPoint.setScale(1)
            monsterSpawnPoint.zPosition = 9

            monsterSpawnPoint.constraints = [SKConstraint.positionX(xConstraintRange,y:yConstraintRange)]
            monsterSpawnPoint.hidden = true
            monsterSpawnPoint.enabled = false
            
            mazeImage.addChild(monsterSpawnPoint)
            
            monsterSpawnPoints[i].addClosure(.TouchUpInside, target: self) { (target, sender) -> () in
                
                print(i)
                let json = [ "id" : i]
                self.socket.emit("new_monster", json)
                self.monsterSpawnPoints[i].enabled = true
                self.killAllMonsterSpawnPoints()
                
                
            }
            
        }

        
        /**********************************************/
        /* End of monster spawn point implementation  */
        /*                                            */
        /*                                            */
        /**********************************************/
        
        
/****************************************************************************/

        // Add mazeImage to game scene
        
        addChild(mazeImage)
        
        // Initialize socket events and connect socket
        self.addHandlers()
        socket.connect()
        

    
    }
    
/****************************************************************************/
    
     /**********************************************/
     /*    Start of implementation for socket      */
     /*    to check for certain events defined     */
     /*    below                                   */
     /**********************************************/

    
    
    // Add handlers for socket connections
    func addHandlers() {
        
        socket.on("init") {data, ack in
            if let info = data[0] as? NSDictionary {
                
                print (info)
                print ("Connected to Jay's server")
                
            }
            
        }
        
        socket.on("json_error") {data, ack in
            if let info = data[0] as? NSDictionary {
                
                if let message = info["message"] as? NSString {
                    
                    print (message)
                }
                
            }
            
        }
        
        // Keeps track of the player coordinate and updates it on screen
        
        socket.on("new_coord") {data, ack in
            

            if  let info = data[0] as? NSDictionary {
                
                var xPosition = info["x"] as! CGFloat
                var yPosition = info["y"] as!CGFloat
                
               // print (xPosition)
               // print (yPosition)
                self.player.hidden = false
                // Set bounds of Oculus rift frame to convert to current frame positionß
                let xBounds = CGFloat(68)
                let yBounds = CGFloat(68)
                
                
                // Adjustes position values for original map frame layoutß
                
                var adjustedXValue = ( (512) / xBounds) * xPosition
                var adjustedYValue = ( (512) / yBounds) * yPosition
                
                // Calls set player position to change position value on game view frame
                self.setPlayerPosition(adjustedXValue  , y: adjustedYValue)
                
            }
            
        }
        
        // Keeps track of all monsters in the game and makes sure there positions are updated
        
        socket.on("new_coord_monster") {data, ack in
            //print("new_coord_monster  event detected")
            //print("Got event: \(data as! NSString ), with items: \(data.items)")
            
            //print("Reached here")
            if  let info = data[0] as? NSDictionary {
                
                var xPosition = info["x"] as! CGFloat
                var yPosition = info["y"] as! CGFloat
                var id = info["id"] as! NSInteger
                
                self.monsters[id].hidden = false
                //print (xPosition)
                //print (yPosition)
                
                // Set bounds of Oculus rift frame to convert to current frame positionß
                let xBounds = CGFloat(68)
                let yBounds = CGFloat(68)
                
                
                // Adjustes position values for original map frame layoutß
                
                
                var adjustedXValue = ( (512) / xBounds) * xPosition
                var adjustedYValue = ( (512) / yBounds) * yPosition
                
                // Calls set player position to change position value on game view frame
                self.setMonsterPosition(adjustedXValue  , y: adjustedYValue, id: id)
                
            }
            
        }
        
        
        socket.on("monster_death") {data, ack in
            print("monster_death event detected")
            
            
            
            if  let info = data[0] as? NSDictionary {
                
                
                if let id = info["id"] as? NSInteger {
                    
                    print(id)
                    // Calls set player position to change position value on game view frame
                    self.killMonster(id)
                
                }
                
            }
            
        }
        
        socket.on("monster_spawnpoints") {data, ack in
            print("monster_spawnpoints")
            
            
            
            if  let info = data[0] as? NSDictionary {
                
                var xPosition = info["x"] as! CGFloat
                var yPosition = info["y"] as! CGFloat
                var id = info["id"] as! NSInteger
                
                        
                self.monsterSpawnPoints[id].position = CGPoint (x: xPosition * (256/68) * 2, y: yPosition * (256/68) * 2 )
                        
                

    
            }
            
        }
        
        socket.on("door_spawnpoints") {data, ack in
            print("door_spawnpoints")
            
            
            if  let info = data[0] as? NSDictionary {
                
                var xPosition = info["x"] as! CGFloat
                var yPosition = info["y"] as! CGFloat
                var id = info["id"] as! NSInteger
                
                self.doorSpawnPoints[id].hidden = false
                self.doorSpawnPoints[id].enabled = true

                self.doorSpawnPoints[id].position = CGPoint (x: xPosition * (256/68) * 2, y: yPosition * (256/68) * 2 )
                
               
                
                
            }
            
        }


        


    }
    
    
     
     /**********************************************/
     /*    End of implementation for socket        */
     /*    to check for certain events defined     */
     /*    below                                   */
     /**********************************************/
     
     
/****************************************************************************/
    
    
    // sets the player position based on position values passed in by new_coord event
    func setPlayerPosition (x: CGFloat , y: CGFloat) {
        

        // Set the position of the monster to the passed in values
        player.position = CGPoint(x: x, y: y)
        
    
    }
    
    // kills a certain monster when a monster_death event is seen
    func killMonster (id: NSInteger) {
        
        
        // Set the position of the monster to the passed in values
        monsters[id].hidden = true
        
        
    }

    // sets the monster position based on position values passed in by new_coord_player event
    
    func setMonsterPosition (x: CGFloat , y: CGFloat, id: NSInteger) {
        
        // Bring monster to view if hiddent
        
        
        // Set the position of the monster to the passed in values
        monsters[id].position = CGPoint(x: x, y: y)
    
        
        
        /*
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: -playersize.width/2, y: 20, duration: NSTimeInterval(actualDuration))
        let actionMoveDone = nil //SKAction.removeFromParent()
        player.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        */
    }
    
    func fixLocationPoint (x: CGFloat, y : CGFloat) -> CGPoint{
        
        var xFixed =  ( ( (x - 6.5) / 0.7 ) - 256 )
        var yFixed = ( ( (y - 6) / 0.7 ) - 256 )
        
        //print ("X Fixed is \(xFixed)")
        return CGPoint(x: xFixed,y: yFixed)
    }
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            print (location)
            var fixedlocation = self.fixLocationPoint(location.x, y: location.y)
            
            
            if (createGhostButton.enabled == false) {
                
                print (fixedlocation)
                var oculusFrameLocation = CGPoint(x: fixedlocation.x * (68/256)  , y: fixedlocation.y * (68/256) )
                let json = [ "x" : oculusFrameLocation.x , "y" : oculusFrameLocation.y ]
                
                socket.emit("new_ghost", json)
                
                createGhostButton.enabled = true
                
            }
            
            if (location.x > 370) {
                
                clearScreen()
                
            }
            
            
            
        }
    }
    
    
    
    // Clear Screen completely
    
    func clearScreen () {
        
        
        //killAllDoors()
        killAllMonsterSpawnPoints()
        spawnMonsterButton.enabled = true
        mainDoorButton.enabled = true
        createGhostButton.enabled = true
        freezeButton.enabled = true
        
    }
    
    // Bring all doors up to view and enable the door buttons
    
    func displayMonsterSpawnPoints () {
        
        for i in 0...numberOfMonsterSpawnPoints {
            
            monsterSpawnPoints[i].hidden = false
            monsterSpawnPoints[i].enabled = true
            
            
        }
        
        
    }
    

    
    
    // Bring all monster spawn points up to view and enable the door buttons
    
    func displayDoors () {
        
        for i in 0...numberOfDoors {
            
           doorSpawnPoints[i].hidden = false
           doorSpawnPoints[i].enabled = true
            
            
        }

        
    }
    
    // Remove all monster spawn points from the screen and disable their buttons
    
    func killAllMonsterSpawnPoints() {
        
        for i in 0...numberOfMonsterSpawnPoints {
            
            monsterSpawnPoints[i].hidden = true
            monsterSpawnPoints[i].enabled = false
            
        }
        
    }

    
    // Remove all doors from the screen and disable their buttons
    
    /*
    func killAllDoors() {
        
        for i in 0...numberOfDoors {
            
            
            doorSpawnPoints[i].enabled = false
            
        }

    }

    */
        
}

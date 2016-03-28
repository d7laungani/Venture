# Venture


![alt tag](http://challengepost-s3-challengepost.netdna-ssl.com/photos/production/software_photos/000/365/944/datas/gallery.jpg)

We all love multiplayer games, and in the emerging field of Virtual Reality, multiplayer looks exceptionally promising. Unfortunately, Virtual Reality headsets and the powerful gaming rigs required to run them are becoming increasingly expensive. So we devised an alternative solution that is far cheaper, more accessible, and just as fun as enjoying a multiplayer VR experience.

Venture is terror in a maze. As the VR user, your sole purpose is to make it to the other side in one piece. You will traverse the corridors while dodging monsters and racing time. Meanwhile, as the iOS user, you'll enjoy a laid back perspective in God mode. Here you can see the whole maze from a bird's eye view. Your goal is to help your VR friend finish the maze. To do this you'll need to unleash unspeakable monsters and ghosts into his world to scare him in the right direction! Together you make the perfect team of the age old fieldwork-and-intelligence duo.

Venture is glued together with a Node.js server that uses socket.io streaming technology to provide the low latency experience modern games demand. Through the Oculus Rift, the Unity game engine relays information of the 3D world through the server and into a projection on the iOS screen. Similarly, the phone user can transmit commands to modify the 3D world the VR user resides in.

We ran into several difficulties in the process of creating this project. Node.js and socket.io are very new technologies with little documentation. Interfacing Unity with a completely new technology like socket.io created a variety of glitches, inconsistencies, and latency issues throughout our time of developing. We literally used the entire twenty-four hours of HackUTD to overcome these bugs by modifying the source code of different default libraries and implementing creative hacks that ensured consistency throughout our source code.

This is one of the first times something like this has ever been done, and it was by no means easy. The libraries given to us are extremely basic and required a lot of modification to get them to work with our project. Finishing this project and sticking through with it through all the difficulties is definitely something we're proud of.

Throughout the process of this project, we learned how to interface the three different devices with low latency all while maintaining AAA graphics

In the near future, look for us in a more public light. We'd like to deploy our server to cloud services and make our game much more accessible to the world! Along our development cycle we had so many great ideas for additional features such as new ways to change the 3d world, scarier monsters, and maybe even some cleaner code!

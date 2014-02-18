**Angry Balls**

Made by Antoine Dailly and Clément Moutet  
This is a project done in ENS de Lyon during the class “Projet de programmation”.  
It is a basic  implementation of the Angry Birds game, with balls. The aim of this project was to program physical laws with the programming language Ocaml.  
Since this project was done in a French university, the comment are in French. We apologize for the English speakers, but if you have any question about this project, don't hesitate to contact me and I will be pleased to answer them.  

*How to play*
To compile the game, you need to have ocaml installed on your computer.  
Just type ocamlbuild -libs graphics angry_balls.native and the game will create an angry_balls.native file.  
To play, just execute it using ./angry_balls  
You will have to choose how many missiles you want to throw, and the difficulty of the game. Once the window is opened, you can grab the missile, located on the left bottom side of the screen, move the mouse in the opposite direction than the desired one, and release it.  

The aim of the game is to destroy the balls. To do this, you need to project in a smart way the missile to take advantage of the physical laws of this game : gravity, friction, collision, elasticity...  
If you already threw all your missiles and there is some balls that still are one the ground, you loose the game.  

*An important issue *
If your computer is too slow for the actual configuration, you can change the value of the refresh parameter, witch will reduce the fluidity of the game. Here is how to do :  
- Open the file header.ml, and increase the value of the “refresh” parameter
- recompile the program

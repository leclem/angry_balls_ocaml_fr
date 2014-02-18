Angry Balls 
----------- 
Made by Antoine Dailly and Clément Moutet

This is a project done at the ENS de Lyon in the context of the class “Projet de programmation”. It is a basic implementation of the Angry Birds game, but it uses balls. The aim of this project was to program physical laws with the programming language Ocaml. Unfortunately, since this project was done at a French university, the code comments and user indications are in French. We apologize to the English speakers, but if you have any questions about this project, don't hesitate to contact us and I we will be pleased to answer them. Nevertheless, this should not prevent you to use this software. 

**How to play**  
To compile the game, you need to have ocaml installed on your computer. Just type ocamlbuild -libs graphics angry_balls.native and the game will create an angry_balls.native file. To play, just execute it using ./angry_balls You will have to choose how many missiles you want to throw, and the difficulty of the game. Once the window is opened, you can grab the missile located on the left bottom side of the screen, move the mouse in the opposite direction of the desired one, and release it. The aim of the game is to destroy the balls. To do this, you need to project the missile in such a way that it takes advantage of the physical laws of this game : gravity, friction, collision, elasticity... When you have thrown all your missiles and there are some balls that are still one the ground, the game is over.  

**An important issue**  
If your computer is too slow for the actual configuration, you can change the value of the refresh parameter, which will reduce the fluidity of the game. Here is how to do :  
- Open the file header.ml, and increase the value of the “refresh” parameter
- recompile the program 

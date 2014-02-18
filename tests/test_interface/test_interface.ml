open Graphics;;
open Header;;
open Gravite_frottements;;
open Collisions;;
open Deplacement;;
open Quadtree;;
open Core;;
open Difficulte;;
open Interface_utilisateur;;

(* Dans ce fichier, nous allons mettre les tests de l'interface utilisateur. Decommentez la fonctions que vous voulez tester, compilez et executez ! (puis recommentez-les pour tester d'autres fonctions) *)

(* Pour compiler, copiez/coller dans le terminal la commande suivante :
ocamlbuild -libs graphics test_interface.native
Puis executez le fichier ainsi cree. *)


(*

open_graph " 800x500";
let listeBoules = [
	{x=size_x()/2;
	y=size_y()/2;
	vitesseX=0;
	vitesseY=0;
	tempsDernierDeplacementX=0.;
	tempsDernierDeplacementY=0.;
	destructibleoupas=false;
	coefficient_destruction=1;}
	] in
afficher_boules listeBoules rayonBoules;
force_et_direction_de_frappe listeBoules (int_of_float (1000. /. refresh));
bougerBoules listeBoules rayonBoules refresh;
let _ = wait_next_event [Button_down] in
close_graph();;

*)
(* Cette fonction sert a tester force_et_direction_de_frappe. Elle va tout simplement faire apparaitre une boule au milieu de l'ecran et attendre que vous la lanciez.
Une fois la boule arretee, cliquez sur la fenetre graphique pour la quitter. *)



(*

open_graph " 800x500";
let listeBoules = [
	{x=size_x()/2;
	y=size_y()/2;
	vitesseX=0;
	vitesseY=0;
	tempsDernierDeplacementX=0.;
	tempsDernierDeplacementY=0.;
	destructibleoupas=false;
	coefficient_destruction=1;}
	] in
interface_utilisateur 1 listeBoules rayonBoules refresh;
let _ = wait_next_event [Button_down] in
close_graph();;

*)
(* Cette fonction vous permet de tester interface_utilisateur. Vous allez avoir un missile, en bas à gauche de la fenêtre graphique. Une boule se situera en l'air au milieu de l'ecran, attendant que vous projetiez le missile pour se mouvoir.
Les deux boules en jeu sont indestructibles, vous ne pouvez donc pas gagner. Cliquez sur la fenetre graphique une fois les deux boules a l'arret et le texte triste affiche pour quitter. *)

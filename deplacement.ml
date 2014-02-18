open Graphics;;
open Header;;
open Gravite_frottements;;
open Collisions;;

(* Ce fichier contient les fonctions ayant trait au deplacement des boules. *)

let avancerUnPixelX boule rayon= 
(*On ne fait pas sortir des boules du cadre*)
	if (boule.vitesseX < 0 && (boule.x -rayon - 1) >= 0)
		then boule.x <- boule.x - 1
		else
			if ((boule.x + rayon + 1) <= size_x())
				then boule.x <- boule.x + 1	
				else ();;


let avancerUnPixelY boule rayon= 
	if (boule.vitesseY < 0  && (boule.y -rayon - 1) >= 0)
		then boule.y <- boule.y - 1
		else
			if ((boule.y + rayon + 1) <= size_y())
				then boule.y <- boule.y + 1
				else ();;



let rec gereurDeDeplacements listeBoules listeBoulesInit rayon= 
	match listeBoules with 
| [] -> ()
| boule::tail -> 
	(*L'inverse de la vitesse est la fraction de seconde necessaire pour qu'un deplacement d'1 pixel ait lieu*)
	let tempsActuel = Sys.time() in (*On stoque le temps actuel pour avoir le même dans toutes les conditions*)
	while ((tempsActuel -. boule.tempsDernierDeplacementX) > absFloat(1. /. float_of_int(boule.vitesseX))) do 
	
		gereurDeCollisionsDuneBoule boule listeBoulesInit rayon;
		avancerUnPixelX boule rayon;
		boule.tempsDernierDeplacementX <- tempsActuel;
	done;
	while ((tempsActuel -. boule.tempsDernierDeplacementY) > absFloat(1. /. float_of_int(boule.vitesseY)))  do
	
		gereurDeCollisionsDuneBoule boule listeBoulesInit rayon;
		avancerUnPixelY boule rayon;
		boule.tempsDernierDeplacementY <- tempsActuel;
		
	done;

	gereurDeDeplacements tail listeBoulesInit rayon ;
;;

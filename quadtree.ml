open Graphics;;
open Header;;
open Gravite_frottements;;
open Collisions;;
open Deplacement;;

(* Ce fichier contient les fonctions ayant trait aux quadtrees. *)

let rec construireArbre listeBoules rayon= 
	let rec boulesDansNoeud listeBoules xNoeud yNoeud tailleXNoeud tailleYNoeud = match listeBoules with
		| [] -> []
		| boule::tail -> 
		(* On teste si la boule est dans le carré décrit par ce rectangle*)
		if 
		(
			( (*On vérifie que l'un des deux sommets X est dans le rectangle*)
				((float_of_int(boule.x+rayon) >= xNoeud) && (float_of_int(boule.x+rayon) <= (xNoeud +. tailleXNoeud)))
				|| 	
				((float_of_int(boule.x-rayon) >= xNoeud) && (float_of_int(boule.x-rayon) <= (xNoeud +. tailleXNoeud)))
			)
			&&
			( (*La même chose pour les sommets Y*)
				((float_of_int(boule.y+rayon) >= yNoeud) && (float_of_int(boule.y+rayon) <= (yNoeud +. tailleYNoeud)))
				||
				((float_of_int(boule.y-rayon) >= yNoeud) && (float_of_int(boule.y-rayon) <= (yNoeud +. tailleYNoeud)))
			)
		)
		 then
			boule::(boulesDansNoeud tail xNoeud yNoeud tailleXNoeud tailleYNoeud)
		else
			boulesDansNoeud tail xNoeud yNoeud tailleXNoeud tailleYNoeud in
		let rec construireArbreSub listeBoules xNoeud yNoeud tailleXNoeud tailleYNoeud = 
		let listeBoulesDansNoeud = (boulesDansNoeud listeBoules xNoeud yNoeud tailleXNoeud tailleXNoeud) in
		let tailleXNoeudDiviseeParDeux = tailleXNoeud/. 2.0 in
		let tailleYNoeudDiviseeParDeux = tailleYNoeud/. 2.0 in
		 if (xNoeud < float_of_int(rayon+1) || yNoeud < float_of_int(rayon+1)) then begin (* On crée une feuille si l'un des cotes du rectangle est inferieur au rayon d'une boule +1, afin de toujours pouvoir encadrer deux boules*)
			
			Noeud(Quadtree_Vide,Quadtree_Vide,Quadtree_Vide,Quadtree_Vide,listeBoulesDansNoeud);
		end
		else
(*On construit la feuile en séparant les boules dans les 4 sous noeuds*)
			Noeud
			(
				(construireArbreSub listeBoulesDansNoeud xNoeud yNoeud tailleXNoeudDiviseeParDeux tailleYNoeudDiviseeParDeux),

				(construireArbreSub listeBoulesDansNoeud xNoeud (yNoeud+.tailleYNoeudDiviseeParDeux) tailleXNoeudDiviseeParDeux 	 					tailleYNoeudDiviseeParDeux),

				(construireArbreSub listeBoulesDansNoeud (xNoeud+.tailleXNoeudDiviseeParDeux) (yNoeud+.tailleYNoeudDiviseeParDeux) 					tailleXNoeudDiviseeParDeux tailleYNoeudDiviseeParDeux),

				(construireArbreSub listeBoulesDansNoeud (xNoeud+.tailleXNoeudDiviseeParDeux) yNoeud tailleXNoeudDiviseeParDeux 				tailleYNoeudDiviseeParDeux),

				listeBoulesDansNoeud

			);  
in
	(construireArbreSub listeBoules 0.0 0.0 (float_of_int(size_x())) (float_of_int(size_y())) ) ;;



let rec deplacementAPartirDarbre arbre rayon = match arbre with
|Noeud(Quadtree_Vide,Quadtree_Vide,Quadtree_Vide,Quadtree_Vide,listeBoulesDansNoeud) -> gereurDeDeplacements listeBoulesDansNoeud listeBoulesDansNoeud rayon;

|Quadtree_Vide -> ();
|Noeud(branche1,branche2,branche3,branche4,liste) -> 
	deplacementAPartirDarbre branche1 rayon;
	deplacementAPartirDarbre branche2 rayon;
	deplacementAPartirDarbre branche3 rayon;
	deplacementAPartirDarbre branche4 rayon;;

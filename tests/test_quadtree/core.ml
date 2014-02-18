open Graphics;;
open Header;;
open Gravite_frottements;;
open Collisions;;
open Deplacement;;
open Quadtree;;

(* Ce fichier contient les fonctions au coeur de la gestion interne. Elles vont appeler les fonctions de collision, de gravite, de quadtrees... *)

(* On commence par tester si une boule sort du cadre ou si des boules s'intersectent. Si ce n'est pas le cas, on trace les cercles qui representent les boules. *)
let rec afficher_boules listeBoules rayon =
	match listeBoules with
	|[] -> synchronize ();
	|boule::tail ->
		draw_circle boule.x boule.y rayon;
		fill_circle boule.x boule.y rayon;
		afficher_boules tail rayon;;


(*Renvoie true tant qu'une boule est en mouvement*)
let rec uneBouleBouge listeBoules listeBoulesInit rayon = match listeBoules with
	| [] -> false
	| boule::tail -> 
		((abs boule.vitesseX) > 1) 
	|| 
		((abs boule.vitesseY) > 1) 
	|| 
		(not (bouleEstSurUneAutreBoule boule rayon listeBoulesInit)) (*Les bandes sont comprises dans cette fonction*)
	||
		(uneBouleBouge tail listeBoulesInit rayon );;

let wait milli =
  let sec = milli /. 1000. in
  let tm1 = Sys.time() in
  while Sys.time() -. tm1 < sec do () done ;;



let rec supprime_boules_detruites listeBoules = match listeBoules with
| [] -> []
| boule::tail -> if boule.coefficient_destruction <= 0
			then supprime_boules_detruites tail
			else boule::(supprime_boules_detruites tail);;



let bougerBoules listeBoulesAux rayon refresh =
	let listeBoules = ref [] in
	listeBoules := listeBoulesAux;
	let vitesseMax = int_of_float(300.0 /. refresh) in (*On prend a peu près la moitié de refresh par seconde maximal afin qu'ils aient le temps de s'executer*)
	while (uneBouleBouge !listeBoules !listeBoules rayon) do
(* On commence par supprimer les boules detruites *)
		listeBoules := supprime_boules_detruites !listeBoules;
(* On teste les collisions avec les bandes. *)
		collisionsAvecBandes !listeBoules rayon (size_x()) (size_y()) coefficientFrottement;
(* On applique la gravite, et les frottements au sol. *)
		deplacementAPartirDarbre (construireArbre !listeBoules rayon) rayon;
		gravite !listeBoules !listeBoules rayon vitesseMax;
		raclementDeSol !listeBoules rayon coefficientFrottement;
(* On fait se deplacer les boules. *)

(* On redessine les boules et on attend le prochain calcul. *)
		clear_graph();
		afficher_boules !listeBoules rayon;
		wait refresh;
	done;;

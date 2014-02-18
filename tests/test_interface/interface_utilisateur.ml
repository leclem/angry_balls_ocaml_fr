open Graphics;;
open Header;;
open Gravite_frottements;;
open Collisions;;
open Deplacement;;
open Quadtree;;
open Core;;

(* Ce fichier contient les fonctions assurant l'interface entre l'utilisateur et le code interne. *)

(* Cette fonction modifie le vecteur vitesse de la boule selectionnee en fonction de ce qu'a fait l'utilisateur avec sa souris *)
let rec force_et_direction_de_frappe listeBoules vitesseMax =

	let posinitiale = wait_next_event [Button_down] in
	(* posinitiale est la position du curseur lorsqu'on selectionne une boule *)
	let absinitiale = posinitiale.mouse_x and ordinitiale = posinitiale.mouse_y in

	(* Les quatre lignes suivantes permettent de n'avoir qu'un seul message d'erreur (en ecrivant en blanc par-dessus le message precedent, on l'efface). *)
	set_color white;
	draw_string "Please select a missile !";
	moveto 0 0;
	set_color black;

	let diffx = (absinitiale - (List.hd listeBoules).x) and diffy = (ordinitiale - (List.hd listeBoules).y) in

(* Cette condition sert a tester si l'utilisateur a bien selectionne un missile : ceux-ci seront toujours places en tete de listeBoules pour simplifier l'implementation *)
	if ((float_of_int (diffx * diffx)) +. (float_of_int (diffy * diffy))) > (float_of_int (rayonBoules*rayonBoules))

		then 
		begin
		draw_string "Please select a missile !";
		force_et_direction_de_frappe listeBoules vitesseMax;
		end
(* Si l'utilisateur n'a pas selectionne le missile, l'inscription "Please select a missile !" s'inscrira sur la fenetre graphique, et celle-ci restera ouverte jusqu'a ce qu'il suive les consignes et lance un missile *)

		else
		begin
		let boulet = (List.hd listeBoules) in
		let posfinale = wait_next_event [Button_up] in
		(* posfinale est la position du curseur lorsqu'on relache la boule *)
		let absfinale = posfinale.mouse_x and ordfinale = posfinale.mouse_y in
		let vitesseabs = 2*(absinitiale - absfinale) in
		if (abs vitesseabs) <= vitesseMax then boulet.vitesseX <- vitesseabs
			else
			if vitesseabs >= 0 then boulet.vitesseX <- vitesseMax
				else boulet.vitesseX <- (- vitesseMax);
		(* La vitesse est limitee par le temps de calcul ! *)
		let vitesseord = 2*(ordinitiale - ordfinale) in
		if (abs vitesseord) <= vitesseMax then boulet.vitesseY <- vitesseord
			else
			if vitesseord >= 0 then boulet.vitesseY <- vitesseMax
				else boulet.vitesseY <- (- vitesseMax);
		()
		end;;

let rec nonvide liste = match liste with
| [] -> false
| _ -> true;;


(* Tres simple : L'utilisateur a i essais pour jouer. Tant qu'il lui en reste, on le laisse selectionner une boule et la propulser en utilisant les fonctions modifiant la vitesse de la boule et les bougeant ! *)
let interface_utilisateur i listeBoulesAux rayon refresh=
let vitesseMax = int_of_float(300.0 /. refresh) and taille_abs = size_x() and taille_ord = size_y() in
	let listeBoules = ref [] in
	listeBoules := listeBoulesAux;
	let j = ref i in
	while (!j > 0) && (nonvide !listeBoules) do
	listeBoules := {x=size_x()/4;
			y=size_y()/4;
			vitesseX=0;
			vitesseY=0;
			tempsDernierDeplacementX=0.;
			tempsDernierDeplacementY=0.;
			destructibleoupas=false;
			coefficient_destruction=1;}
			:: !listeBoules;
	afficher_boules !listeBoules rayon;
	force_et_direction_de_frappe !listeBoules vitesseMax;
	bougerBoules !listeBoules rayon refresh;
(* On a donc fait bouger les boules une fois la force et la direction de frappe imprimees au missile. *)
	listeBoules := List.tl !listeBoules;
	bougerBoules !listeBoules rayon refresh;
(* On refait bouger les boules une fois le missile disparu au cas ou des boules auraient ete en equilibre sur lui : le cas echeant, elles auraient flotte en l'air jusqu'a ce que le joueur lance son prochain missile... *)
	listeBoules := supprime_boules_detruites !listeBoules;
	clear_graph();
	afficher_boules !listeBoules rayon;
	j := !j - 1;
	done;
	if nonvide !listeBoules
		then
			begin
			moveto (taille_abs/3) (taille_ord/2);
			draw_string "Dommage, vous avez perdu ! :(";
			end
		else
			begin
			moveto (taille_abs/3) (taille_ord/2);
			draw_string "Bravo, vous avez gagne ! :)";
			end;;

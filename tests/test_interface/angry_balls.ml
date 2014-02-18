open Graphics;;
open Header;;
open Gravite_frottements;;
open Collisions;;
open Deplacement;;
open Quadtree;;
open Core;;
open Difficulte;;
open Interface_utilisateur;;

(* Ce fichier contient le code qui, execute, permet de jouer a Angry Balls. *)

let j = ref 0 and s = ref "" in
	let rayon = rayonBoules in

	j:=choix_nombre_boules();
	print_newline();
(* On laisse l'utilisateur choisir son nombre de missiles... *)

	s:=choix_difficulte();
	print_newline();
(* On laisse l'utilisateur choisir la difficulte... *)

	open_graph " 800x500";

	let listeBoules = ref [] in
		listeBoules := generateur_listeboules_selon_difficulte (!j) (!s);
	if (((!j) <= 3) && ((!j) > 0))
		then
			begin
			interface_utilisateur !j !listeBoules rayon refresh;
			let _ = wait_next_event [Button_down] in
			close_graph()
			end
		else
			begin
			interface_utilisateur 3 !listeBoules rayon refresh;
			let _ = wait_next_event [Button_down] in
			close_graph()
			end;;

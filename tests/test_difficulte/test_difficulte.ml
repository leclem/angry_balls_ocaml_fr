open Graphics;;
open Header;;
open Difficulte;;

(* Dans ce fichier, nous allons mettre les tests de difficulte. Decommentez la fonctions que vous voulez tester, compilez et executez ! (puis recommentez-les pour tester d'autres fonctions) *)

(* Pour compiler, copiez/coller dans le terminal la commande suivante :
ocamlbuild -libs graphics test_difficulte.native
Puis executez le fichier ainsi cree. *)

(*

let j = choix_nombre_boules () in
print_int j; print_newline();;

*)
(* Ici, le nombre qui s'affichera sera celui que vous aurez tape. Si vous avez tape un autre nombre que 1, 2 ou 3, un message reprobateur s'inscrira sur l'ecran, vous invitant a reviser vos facultes de lecture. *)

(* 

let s = choix_difficulte () in
print_string s; print_newline();;

*)
(* Ici, la chaîne de caracteres qui s'affichera sera celle que vous aurez tapee. Si vous n'avez pas tape un des caracteres proposes, un message excede s'inscrira sur l'ecran, vous invitant a appliquer les consignes. *)

(*

let rec afficher_boules listeBoules rayon =
	match listeBoules with
	|[] -> ()
	|boule::tail ->
		draw_circle boule.x boule.y rayon;
		fill_circle boule.x boule.y rayon;
		afficher_boules tail rayon;;

let listeBoules = ref [] in
open_graph " 800x500";
listeBoules := boules_selon_difficulte 15 [] 0 1 (size_x()/2) (size_x()/10) 5;
afficher_boules !listeBoules rayonBoules;
let _ = wait_next_event [Button_down] in
close_graph();;

*)

(* Ce test va afficher les tours de boules lorsque la difficulte Insane est choisir avec 3 missiles. La capture d'ecran illustrant l'affichage se trouve dans le dossier. Cliquez sur la fenetre graphique pour la fermer. *)

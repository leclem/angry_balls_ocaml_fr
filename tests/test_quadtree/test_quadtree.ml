open Graphics;;
open Header;;
open Gravite_frottements;;
open Collisions;;
open Deplacement;;
open Quadtree;;
open Core;;
open Difficulte;;
open Interface_utilisateur;;

(* Dans ce fichier, nous allons mettre les tests de quadtree. Compilez et executez ! *)

(* Pour compiler, copiez/coller dans le terminal la commande suivante :
ocamlbuild -libs graphics test_quadtree.native
Puis executez le fichier ainsi cree. *)

let boulet = {x=150;y=250;vitesseX=(-150);vitesseY=(130);tempsDernierDeplacementX=0.0;tempsDernierDeplacementY=0.0;destructibleoupas=true;coefficient_destruction=300} in
let boulet2 = {x=50;y=250;vitesseX=170;vitesseY=(-180);tempsDernierDeplacementX=0.0;tempsDernierDeplacementY=0.0;destructibleoupas=true;coefficient_destruction=300} in
let boulet3 = {x=250;y=250;vitesseX=(110);vitesseY=130;tempsDernierDeplacementX=0.0;tempsDernierDeplacementY=0.0;destructibleoupas=true;coefficient_destruction=300} in
let boulet4 = {x=150;y=350;vitesseX=(0);vitesseY=(-500);tempsDernierDeplacementX=0.0;tempsDernierDeplacementY=0.0;destructibleoupas=true;coefficient_destruction=300} in
let boulet5 = {x=150;y=150;vitesseX=0;vitesseY=0;tempsDernierDeplacementX=0.0;tempsDernierDeplacementY=0.0;destructibleoupas=true;coefficient_destruction=300} in
let rayon = ref 0 in
let mode = ref "" in
print_string("Tapez le rayon voulu des boules : ");
rayon := read_int();
print_string("\n");
while (not ((!mode) = "y" || (!mode) = "n")) do
print_string("Voulez vous bouger les boules avec un quadtree (y ou n) : ");
mode := read_line()
done;
open_graph "";
let listeBoules = ref [] in
listeBoules := boulet::boulet2::boulet3::boulet4::boulet5::[] ;
	let vitesseMax = int_of_float(1000.0 /. refresh) in (*On prend a peu près la moitié de refresh par seconde maximal afin qu'ils aient le temps de s'executer*)
	while (uneBouleBouge !listeBoules !listeBoules !rayon) do
		(*On commence par dessiner la configuration courrante*)
		 (*On efface la fenetre graphique afin de ne pas dessinner le billard sur l'ancienne configuration*)
		listeBoules := supprime_boules_detruites !listeBoules;
		collisionsAvecBandes !listeBoules !rayon (size_x()) (size_y()) coefficientFrottement;
		
		gravite !listeBoules !listeBoules !rayon vitesseMax;
		raclementDeSol !listeBoules !rayon coefficientFrottement;
		if ((!mode) != "y") then
			deplacementAPartirDarbre (construireArbre !listeBoules !rayon) !rayon
		else
			gereurDeDeplacements !listeBoules !listeBoules !rayon;

		clear_graph();
		afficher_boules !listeBoules !rayon; (*fonction servant à afficher mais tous les tests pour savoir si les boules n'ont pas une position illégale*)
		wait 1.0
done;;

(* Cette fonction sert a comparer la fluidite et la vitesse de calcul avec et sans quadtrees (et bien sur de constater que les quadtrees fonctionnent !). *)

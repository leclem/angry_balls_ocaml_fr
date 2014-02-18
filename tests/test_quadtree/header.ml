open Graphics;;
auto_synchronize false;;
(* Ce fichier contient les declarations de types et de variables globales. *)

(* Declaration des constantes qui serviront dans le code tout entier. *)
let rayonBoules = 30;;
let pi = 3.14159265;;
let coefficientFrottement = 45 ;;
let refresh = 1.0;;
let absFloat x = if x >= 0.0 then x else -. x;;

(* Definition du type boule. Celui-ci contient huit variables : sa position, sa vitesse, son temps de deplacement relatif, sa nature (missile ou boule destructible) et sa fragilite. *)
type boule =
	{mutable x : int ;mutable  y : int ;
	mutable vitesseX : int ; mutable vitesseY : int;
	mutable tempsDernierDeplacementX : float;
	mutable tempsDernierDeplacementY : float;
	mutable destructibleoupas : bool;
	mutable coefficient_destruction : int
	};;

(* Definition du type quadtree : il s'agit d'une union de quatre quadtrees contenant des boules. *)
type quadtree = Noeud of (quadtree*quadtree*quadtree*quadtree*(boule list)) | Quadtree_Vide;;
auto_synchronize false;

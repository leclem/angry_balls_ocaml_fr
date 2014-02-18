open Graphics;;
open Header;;

(* Ce fichier contient les fonctions permettant de gerer la difficulte et de generer les boules a detruire. *)

let rec boules_selon_difficulte n listeBoules nb_boules_en_cours nb_lignes abs_initiale decalage difficulte  = match n with
(* nb_boules_en_cours est le nombre de boules presentes sur la ligne en cours ; nb_lignes est le nombre de lignes ; difficulte est le coefficient multiplicateur defini par la difficulte choisie par l'utilisateur *)
(* Cette fonction construit une listeBoules en tours. Comme on a au plus trois vies et que le facteur multiplicatif varie de 1 à 5, on peut avoir maximum 15 boules a detruire. Donc, on place d'abord une tour d'au plus cinq boules, puis une d'au plus quatre, et ainsi de suite. *)
	| 0 -> listeBoules
	| n ->
		if nb_lignes = 1 then
			begin
			if nb_boules_en_cours = 5 then
				boules_selon_difficulte n listeBoules 0 2 abs_initiale decalage difficulte
				else
				boules_selon_difficulte (n - 1) ({x=abs_initiale + (2 * decalage);
								y=(2*nb_boules_en_cours+1)*rayonBoules;
								vitesseX=0;
								vitesseY=0;
								tempsDernierDeplacementX=0.;
								tempsDernierDeplacementY=0.;
								destructibleoupas=true;
								coefficient_destruction=600+(600*difficulte)}
								:: listeBoules) (nb_boules_en_cours + 1) nb_lignes abs_initiale decalage difficulte
			end
			else
			if nb_lignes = 2 then
				begin
				if nb_boules_en_cours = 4 then
					boules_selon_difficulte n listeBoules 0 3 abs_initiale decalage difficulte
					else
					boules_selon_difficulte (n - 1) ({x=abs_initiale + (3 * decalage);
									y=(2*nb_boules_en_cours+1)*rayonBoules;
									vitesseX=0;
									vitesseY=0;
									tempsDernierDeplacementX=0.;
									tempsDernierDeplacementY=0.;
									destructibleoupas=true;
									coefficient_destruction=600+(600*difficulte)}
									:: listeBoules) (nb_boules_en_cours + 1)
									nb_lignes abs_initiale decalage difficulte
				end
				else
				if nb_lignes = 3 then
					begin
					if nb_boules_en_cours = 3 then
						boules_selon_difficulte n listeBoules 0 4 abs_initiale decalage difficulte
						else
						boules_selon_difficulte (n - 1) ({x=abs_initiale + decalage;
										y=(2*nb_boules_en_cours+1)*rayonBoules;
										vitesseX=0;
										vitesseY=0;
										tempsDernierDeplacementX=0.;
										tempsDernierDeplacementY=0.;
										destructibleoupas=true;
										coefficient_destruction=600+(600*difficulte)}
										:: listeBoules) (nb_boules_en_cours + 1)
										nb_lignes abs_initiale decalage difficulte
					end
					else
					if nb_lignes = 4 then
						begin
						if nb_boules_en_cours = 2 then
							boules_selon_difficulte n listeBoules 0 5 abs_initiale decalage difficulte
							else
							boules_selon_difficulte (n - 1) ({x=abs_initiale + (4 * decalage);
											y=(2*nb_boules_en_cours+1)*rayonBoules;
											vitesseX=0;
											vitesseY=0;
											tempsDernierDeplacementX=0.;
											tempsDernierDeplacementY=0.;
											destructibleoupas=true;
											coefficient_destruction=600+(600*difficulte)}
											:: listeBoules) (nb_boules_en_cours + 1)
											nb_lignes abs_initiale decalage difficulte
						end
						else				
						({x=abs_initiale;
						y=(2*nb_boules_en_cours+1)*rayonBoules;
						vitesseX=0;
						vitesseY=0;
						tempsDernierDeplacementX=0.;
						tempsDernierDeplacementY=0.;
						destructibleoupas=true;
						coefficient_destruction=600+(600*difficulte)} :: listeBoules);;

(* Cette fonction sert a creer la pyramide de boules, en prenant en parametre le nombre de missiles dont disposera l'utilisateur et la difficulte qu'il a choisi. *)
let generateur_listeboules_selon_difficulte j s =
	let taille_abs = size_x() in
	let abs_initiale = (taille_abs / 2) in
	let decalage_entre_tours = (taille_abs / 10) in
(* On commence par choisir l'abscisse a la moitie de la fenetre graphique, qui servira de repere pour les tours, ainsi que le decalage entre les tours. *)
	let coefficient_multiplicateur s =
		if (s = "B" || s = "b") then
			1
			else
				if (s = "E" || s = "e") then
					2
					else
						if (s = "N" || s = "n") then
							3
							else
								if (s = "H" || s = "h") then
									4
									else 5 in
(* Cette fonction genere donc le facteur de difficulte : plus celle-ci est elevee, plus le joueur aura de boules a detruire ! *)
	let difficulte = coefficient_multiplicateur s in
	let nb_boules = (difficulte * j) in

boules_selon_difficulte nb_boules [] 0 1 abs_initiale decalage_entre_tours difficulte;;


let rec choix_nombre_boules () =
	let j = ref 0 in
	print_string "De combien de missiles voulez-vous disposer ? \n Vous pouvez en choisir un, deux ou trois. \n";
	j := read_int();
	if (!j != 1) && (!j != 2) && (!j != 3)
		then 
			begin
			print_string "Apprenez a lire, vil manant ! \n";
			choix_nombre_boules();
			end
		else !j;;
(* Cette fonction permet a l'utilisateur de choisir le nombre de missiles dont il disposera. Je limite a trois missiles : si on en met plus, la fonction qui gere la difficulte va devenir encore plus horrible... *)

let rec choix_difficulte () =
	let s = ref "" in
	print_string "Quelle difficulte voulez-vous ? \n B=Beginner ; E=Easy ; N=Normal ; H=Hard ; I=Insane \n";
	s := read_line();
	if ((!s = "b") || (!s = "B") ||
	   (!s = "e") || (!s = "E") ||
	   (!s = "n") || (!s = "N") ||
	   (!s = "h") || (!s = "H") ||
	   (!s = "i") || (!s = "I"))
		then
			!s
		else
			begin
			print_string "Apprenez a lire, cornegidouille ! \n";
			choix_difficulte();
			end;;
(* Ici, s est la difficulte choisie par l'utilisateur : de Beginner a Insane. *)

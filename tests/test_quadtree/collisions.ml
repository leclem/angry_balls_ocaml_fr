open Graphics;;
open Header;;
open Gravite_frottements;;

(*Fonction qui regarde si deux boules sont en situation de collision. Le modulo est pour voir si elles sont en situation de collision a modulo pixels pres*)
let deux_boules_collision boule1 boule2 rayon= 
	let deux_Boules_A_Cote boule1 boule2 rayon= 
		let diffx = boule1.x - boule2.x and diffy = boule1.y - boule2.y in
			(( sqrt (
				float_of_int(diffx * diffx) +. float_of_int(diffy * diffy)
			      )) <= (float_of_int((2 * rayon+1)))
(*+1 : on travaille sur des floats, on veut eviter que des boules se croisent donc on laisse une marge de comparaison*)
			) && (diffx != 0 || diffy != 0) in


	let deux_boules_seloignent boule1 boule2 = 
		let bouleDroiteVX = ref 0 in
		let bouleGaucheVX = ref 0 in
		let bouleHautVY = ref 0 in
		let bouleBasVY = ref 0 in
	(*On regarde quelle boule est a droite et quelle boule est a gauche*)
		if (boule2.x - boule1.x > 0)
			then begin bouleDroiteVX := boule2.vitesseX; bouleGaucheVX := boule1.vitesseX end
			else begin bouleDroiteVX := boule1.vitesseX; bouleGaucheVX := boule2.vitesseX end ;
 
	(*On regarde quelle boule est en haut et quelle boule est en bas*)
		if (boule2.y - boule1.y > 0)
			then begin bouleHautVY := boule2.vitesseY; bouleBasVY := boule1.vitesseY end
			else begin bouleHautVY := boule1.vitesseY; bouleBasVY := boule2.vitesseY end ;

(
	( (*On regarde si les boules vont l'une vers l'autre en X*)
		(!bouleDroiteVX >= 0 && !bouleGaucheVX <= 0) (*Si la boule de droite va vers la gauche et la boule de gauche vers la droite*)
		|| 
		( (*Si les deux boules vont dans la meme direction X mais la boule de deriere va plus vite que la boule de devant*)
 			(
				(!bouleGaucheVX >= 0 && !bouleDroiteVX >= 0) 
				|| 
				(!bouleGaucheVX <= 0 && !bouleDroiteVX <= 0)
			) 
			&& 
			(!bouleGaucheVX <= !bouleDroiteVX) 
		) 
		|| 
		((abs !bouleDroiteVX) == (abs !bouleGaucheVX)) (*Si les deux boules ont exactement la meme vitesse X, utile pour les collisions a basse vitesse ou a vitesse 0*)
	) 
	&& 
	( (*Idem pour Y, on regarde si les boules vont l'une vers l'autre sur cet axe*)
		(!bouleHautVY >= 0 && !bouleBasVY <= 0) (*Si la boule du haut va vers le bas et la boule du bas vers le haut*)
		|| 
		( (*Si les deux boules vont dans la meme direction Y mais la boule de deriere va plus vite que la boule de devant*)
			(
				(!bouleHautVY >=0 && !bouleBasVY > 0) 
				|| 
				(!bouleHautVY <= 0 && !bouleBasVY <= 0)
			) 
			&& 
			(!bouleBasVY <= !bouleHautVY)
		) 
		|| 
		((abs !bouleBasVY) == (abs !bouleHautVY)) (*Si les deux boules ont exactement la meme vitesse Y, utile pour les collisions a basse vitesse ou a vitesse 0 (cas classique pour Y : les empilements)*)
	) 
)
in
	
	(deux_Boules_A_Cote boule1 boule2 rayon) && (not (deux_boules_seloignent boule1 boule2));;



(*Calcule les collision d'une boule avec le reste*)
let rec gereurDeCollisionsDuneBoule boule listeBoulesSuivantes rayon = match listeBoulesSuivantes with
	| [] -> ()
	| boule2::suiteListeBoulesSuivantes ->
	(*On evite de collisionner des boules a côté et ayant la meme vitesse*)

	if (deux_boules_collision boule boule2 rayon) then begin
		if boule.destructibleoupas then
			boule.coefficient_destruction <- boule.coefficient_destruction - (abs boule.vitesseX) - (abs boule.vitesseY) - 
							(abs boule2.vitesseX) - (abs boule2.vitesseY);
		frottements (boule::boule2::[]) coefficientFrottement;
		(*	On se sert de la formule de collision entre deux boules de même taille de Wikipédia*)
	(*http://fr.wikipedia.org/wiki/Choc_%C3%A9lastique*)
	(*On calcule la base orthogonale par rapport au point d'intersection des deux boules, en prenant la normale et la tangente*)
		let ordX = float_of_int(boule2.x-boule.x)/.(float_of_int(2*rayon)) in
		let ordY = float_of_int(boule2.y-boule.y)/.float_of_int(2*rayon) in
		let absX = 0.0-.ordY in
 		let absY = ordX in

		(*On calcule les vitesses dans cette base*)
		let vitesseBoule1ord = float_of_int(boule.vitesseX)*.ordX +. float_of_int(boule.vitesseY)*.ordY in
		let vitesseBoule1abs = float_of_int(boule.vitesseX)*.absX +. float_of_int(boule.vitesseY)*.absY in
		let vitesseBoule2ord = float_of_int(boule2.vitesseX)*.ordX +. float_of_int(boule2.vitesseY)*.ordY in
		let vitesseBoule2abs = float_of_int(boule2.vitesseX)*.absX +. float_of_int(boule2.vitesseY)*.absY in
		
		(*Puis on projete sur l'axe x y en gardant la même vitesse tangentielle*)
		boule.vitesseX <- int_of_float(ordX *. vitesseBoule2ord +. absX *. vitesseBoule1abs);
		boule.vitesseY <- int_of_float(ordY *. vitesseBoule2ord +. absY *. vitesseBoule1abs);
		boule2.vitesseX <- int_of_float(ordX *. vitesseBoule1ord +. absX*.vitesseBoule2abs);
		boule2.vitesseY <- int_of_float(ordY *. vitesseBoule1ord +. absY*.vitesseBoule2abs);

		while (deux_boules_collision boule boule2 rayon) do (*On rajoute une fonction qui écarte un peu les boules si jamais elles restent en situation de collision*)
			if ((boule2.x - boule.x) > 0) then 
			begin 
				boule.x <- boule.x - 1 ;
				boule2.x <- boule2.x + 1 
			end 
			else 
			begin
				boule.x <- boule.x + 1;
				boule2.x <- boule2.x - 1
			end;
			if ((boule2.y - boule.y) > 0) then 
			begin
				boule.y <- boule.y - 1 ;
				boule2.y <- boule2.y + 1
			end
			else 
			begin
				boule.y <- boule.y + 1;
				boule2.y <- boule2.y - 1
			end
		done;
	
	end;
	
	gereurDeCollisionsDuneBoule boule suiteListeBoulesSuivantes rayon;;



(* Modifie les vitesses de toutes les boules en situation de collision*)
let rec gereurDeCollisions listeBoules rayon= match listeBoules with
		| [] -> ()
		| boule:: tail ->

(*On gère la collision avec les autres boules*)
		gereurDeCollisionsDuneBoule boule tail rayon;
		gereurDeCollisions tail rayon;;


let rec collisionsAvecBandes listeBoules rayon sizeX sizeY coefFrottement = match listeBoules with
| [] -> ();
| boule::tail ->
(*Pour gérer les frottements et ne pas inverser les vitesses quand ils sont trop forts, on rend en compte les 4 côtés séparement*)
if ((boule.y-rayon) <= 0 && boule.vitesseY < 0)
	then 
		begin
		if ((coefFrottement+boule.vitesseY) < 0)
			then begin boule.vitesseY <- -(coefFrottement+boule.vitesseY); end
			else boule.vitesseY <- 0;
		end
	else ();

if (((boule.y+rayon) >= sizeY) && boule.vitesseY > 0) 
	then 
		begin
		if ((boule.vitesseY-coefFrottement) > 0)
			then begin boule.vitesseY <- -(boule.vitesseY-coefFrottement); end
			else boule.vitesseY <- 0;
		end
	else ();

if ((boule.x-rayon) <= 0 && boule.vitesseX < 0)
	then
		begin
		if ((coefFrottement+boule.vitesseX) < 0)
			then begin boule.vitesseX <- -(boule.vitesseX+coefFrottement); end
		else boule.vitesseX <- 0;
		end
	else ();

if (((boule.x+rayon) >= sizeX) && boule.vitesseX > 0)
	then
		begin
		if ((boule.vitesseX-coefFrottement) > 0)
			then begin boule.vitesseX <- -(boule.vitesseX-coefFrottement); end
			else boule.vitesseX <- 0;
		end
	else ();

collisionsAvecBandes tail rayon sizeX sizeY coefFrottement ;;


let rec boulesSortentDuCadre listeBoules rayon = match listeBoules with 

| [] -> false
| boule::tail -> ((boule.x+rayon) > size_x()) || ((boule.y + rayon) > size_y()) || ((boule.x-rayon) < 0) || ((boule.y-rayon) < 0) || (boulesSortentDuCadre tail rayon) ;;

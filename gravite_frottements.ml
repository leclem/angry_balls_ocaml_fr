open Header;;

(* Ce fichier contient les fonctions gerant la gravite et les frottements (de l'air comme du sol). *)

(*La fonction qui gère la force de frottement*)
let rec frottements listeBoules coefFrottement = match listeBoules with
 | [] -> ();
 | boule::tail ->
	frottements tail coefFrottement; 
	let absVitesseX = abs boule.vitesseX in
	let absVitesseY = abs boule.vitesseY in 	
	if (boule.vitesseX != 0 || boule.vitesseY != 0) then begin
		let coefFrottementX = coefFrottement * ( (absVitesseX/(absVitesseX+absVitesseY))) in
		let coefFrottementY = coefFrottement * ( (absVitesseY/(absVitesseX+absVitesseY))) in
	
	(*On gère deux cas : si la vitesse est positive et si elle est négative*)
		if (boule.vitesseX > 0)
			then
			begin
		
			 if (boule.vitesseX - coefFrottement > 0)
					then  boule.vitesseX <- boule.vitesseX-coefFrottementX
					else boule.vitesseX <- 0 end
			else
				begin if (boule.vitesseX + coefFrottement < 0)
					then boule.vitesseX <- boule.vitesseX+coefFrottementX
					else boule.vitesseX <- 0 end;
		if (boule.vitesseY > 0)
			then
			begin 
			if (boule.vitesseY - coefFrottement > 0)
					then  boule.vitesseY <- boule.vitesseY-coefFrottementY
					else boule.vitesseY <- 0 end
			else
				begin if (boule.vitesseY + coefFrottement < 0)
					then boule.vitesseY <- boule.vitesseY+coefFrottementY
					else boule.vitesseY <- 0 end
	end;

;;


let rec raclementDeSol listeBoules rayon coefFrottement = 
let coefficientStatique = 1 in 
	match listeBoules with 
		| [] -> ()
		| boule :: tail -> 
			if (boule.y <= rayon) && (boule.vitesseY == 0)
				then 
					if (boule.vitesseX > 0)
						then
							if ((boule.vitesseX - coefficientStatique) > 0)
								then
								boule.vitesseX <- boule.vitesseX - coefficientStatique
								else
								boule.vitesseX <- 0
						else
							if (boule.vitesseX < 0)
								then
								if ((boule.vitesseX + coefficientStatique) > 0)
									then
									boule.vitesseX <- boule.vitesseX + coefficientStatique
									else
									boule.vitesseX <- 0
				else ();
			raclementDeSol tail rayon coefFrottement;;


let boule1_sur_boule2 boule1 boule2 rayon= 
let diffx = boule1.x - boule2.x and diffy = boule1.y - boule2.y in

((*On regarde d'abord si une boule est en contact avec l'autre (contact physique, donc pas collision, donc on redefinit une fonction)*)
	( 
		sqrt 
			(
				float_of_int(diffx * diffx) +. float_of_int(diffy * diffy)		
			)
	) 
	<= 
	(
		float_of_int((2 * rayon+2))(*Experimentalement, le +3 marchait mieux*)
	)(*+1 : on travaille sur des floats, on veut eviter que des boules se croisent donc on laisse une marge de comparaison*)
) 
&& 
(diffy > 0) (*On a la boule1 qui est plus haute que la boule 2*)
&& 

(boule2.coefficient_destruction > 0)(*On regarde si la boule ne vient pas juste d'être détruite*) ;;

let rec bouleEstSurUneAutreBoule boule rayon listeBoules = match listeBoules with 
| [] -> false
| boule2 :: tail -> 
	(boule1_sur_boule2  boule boule2 rayon) 
|| 
	(boule.y <= rayon) 
|| 
	(bouleEstSurUneAutreBoule boule rayon tail);; (*On considere les boules sur la bande du bas aussi en equilibre sur une plate forme*)

let rec gravite listeBoules listeBoulesInit rayon vitesseMax= match listeBoules with
(*Ca ne sert a rien de faire accelerer une boule au delà de la vitesse maximale autorisee par le refresh, ca ne fera que la rendre 'resistante' a la gravite si elle change de direction*)
 | [] -> ();
 | boule::tail -> 
	if (*On teste si cette boule a droit à la gravité*)
	(
			boule.y > rayon 
		&& 
			(abs boule.vitesseY) <= vitesseMax 
		&& 
			(not (bouleEstSurUneAutreBoule boule rayon listeBoulesInit))
	)
	then boule.vitesseY <- boule.vitesseY-1
	else
	
		if ((abs boule.vitesseY) > vitesseMax) then (*On verifie que la vitesse maximale n'est pas depassée*)
			boule.vitesseY <- ((boule.vitesseY / (abs boule.vitesseY)) * vitesseMax)
		else ();
		if ((abs boule.vitesseX) > vitesseMax) then (*On verifie que la vitesse maximale n'est pas depassée*)
			boule.vitesseX <- ((boule.vitesseX / (abs boule.vitesseX)) * vitesseMax)
		else ();
	gravite tail listeBoulesInit rayon vitesseMax;
;;

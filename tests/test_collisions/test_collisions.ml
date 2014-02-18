open Graphics;;
open Header;;
open Gravite_frottements;;
open Collisions;;

(* Dans ce fichier, nous allons mettre les tests de difficulte. Compilez et executez ! *)

(* Pour compiler, copiez/coller dans le terminal la commande suivante :
ocamlbuild -libs graphics test_collisions.native
Puis executez le fichier ainsi cree. *)



print_string("Tapez une position puis une vitesse x et y pour la boule 1 puis faites d même pour une boule, et je vous dirais si elles sont en situation de collision \n");;

(*On prend les informations de la boule 1*)
let xBoule1 = ref 0 in
let yBoule1 = ref 0 in 
let vitessexBoule1 = ref 0 in
let vitesseyBoule1 = ref 0 in 
print_string("Position X boule 1 : ");
xBoule1 := read_int();
print_string("\n");
print_string("Position Y boule 1 : ");
yBoule1 := read_int();
print_string("\n");
print_string("Vitesse X boule 1 : ");
vitessexBoule1 := read_int();
print_string("\n");
print_string("Vitesse Y boule 1 : ");
vitesseyBoule1 := read_int();
print_string("\n");

(*On prend les informations de la boule 2*)
let xBoule2 = ref 0 in
let yBoule2 = ref 0 in 
let vitessexBoule2 = ref 0 in
let vitesseyBoule2 = ref 0 in 
print_string("Position X boule 2 : ");
xBoule2 := read_int();
print_string("\n");
print_string("Position Y boule 2 : ");
yBoule2 := read_int();
print_string("\n");
print_string("Vitesse X boule 2 : ");
vitessexBoule2 := read_int();
print_string("\n");
print_string("Vitesse Y boule 2 : ");
vitesseyBoule2 := read_int();
print_string("\n");

(*Et puis le rayon*)
let rayon = ref 0 in
print_string("Maintenant, indiquez le rayon des boules : ");
rayon := read_int();
print_string("\n");

let boule1 = {
x=(!xBoule1);
y=(!yBoule1);
vitesseX=(!vitessexBoule1);
vitesseY=(!vitesseyBoule1); 
tempsDernierDeplacementX = 0.0; 
tempsDernierDeplacementY = 0.0; 
destructibleoupas = true; 
coefficient_destruction = 1} in
let boule2 = {
x=(!xBoule2);
y=(!yBoule2);
vitesseX=(!vitessexBoule2);
vitesseY=(!vitesseyBoule2); 
tempsDernierDeplacementX = 0.0; 
tempsDernierDeplacementY = 0.0; 
destructibleoupas = true; 
coefficient_destruction = 1} in

if (deux_boules_collision boule1 boule2 !rayon) then
print_string("Les deux boules sont en situation de collision ! ")
else
print_string("Les deux boules ne sont pas en situation de collision \n");;

(* Cette fonction va vous demander de rentrer les coordonnees, la vitesse et le rayon de deux boules, puis va tester si elles se trouvent en situation de collision ou non. *)

% Hechos:
% Genero
hombre("Abraham").
hombre("Alejandro").
hombre("Esteban").
hombre("Gerardo").
hombre("Jose").

mujer("Lurdes").
mujer("Lucia").
mujer("Monica").
mujer("Arizdelcy").
mujer("Tania").
mujer("Maciel").
mujer("Guillermina").
mujer("Jazmin").
mujer("Michel").
mujer("Daniela").

% Progenitor
progenitor("Abraham", "Gerardo").
progenitor("Abraham", "Esteban").
progenitor("Abraham", "Monica").

progenitor("Lucia", "Gerardo").
progenitor("Lurdes", "Monica").
progenitor("Desconocida", "Esteban").

progenitor("Alejandro", "Jazmin").
progenitor("Alejandro", "Michel").
progenitor("Alejandro", "Maciel").

progenitor("Guillermina", "Jazmin").
progenitor("Guillermina", "Michel").
progenitor("Guillermina", "Maciel").

progenitor("Michel", "Daniela").

progenitor("Gerardo", "Jose").
progenitor("Gerardo", "Arizdelcy").
progenitor("Gerardo", "Tania").

progenitor("Maciel", "Jose").
progenitor("Maciel", "Arizdelcy").
progenitor("Maciel", "Tania").

% Pareja
pareja("Abraham", "Lucia").
pareja("Lucia", "Abraham").
pareja("Alejandro", "Guillermina").
pareja("Guillermina", "Alejandro").
pareja("Gerardo", "Maciel").
pareja("Maciel", "Gerardo").


%Reglas
padre(Hijo,Padre) :-
    progenitor(Padre,Hijo),hombre(Padre).

madre(Hijo,Madre) :-
    progenitor(Madre,Hijo),mujer(Madre).

hermanos(Hermano1,Hermano2) :-
    padre(Hermano1,Y),padre(Hermano2,X),X==Y,Hermano1\=Hermano2.

hermano(Hermano1,Hermano2) :-
    padre(Hermano1,Y),padre(Hermano2,X),hombre(Hermano2),X==Y,Hermano1\=Hermano2.

hermana(Hermano1,Hermano2) :-
    padre(Hermano1,Y),padre(Hermano2,X),mujer(Hermano2),X==Y,Hermano1\=Hermano2.

esposo(Esposa,Esposo) :-
    pareja(Esposo,Esposa),hombre(Esposo).

esposa(Esposo,Esposa) :-
    pareja(Esposo,Esposa),mujer(Esposa).

abuelo(Nieto,Abuelo) :-
    padre(X,Abuelo), (madre(Nieto,X) ; padre(Nieto,X)).

abuela(Nieto,Abuela) :-
    madre(X,Abuela), (madre(Nieto,X) ; padre(Nieto,X)).

suegro(Persona,Suegro) :-
    pareja(Persona,X),padre(X,Suegro).

suegra(Persona,Suegra) :-
    pareja(Persona,X),madre(X,Suegra).

cuñados(Persona1,Cuñados) :-
    ((pareja(Persona1,X),hermanos(X,Cuñados));(pareja(Cuñados,X),hermanos(X,Persona1))).

cuñado(Persona1,Cuñado) :-
    cuñados(Persona1,Cuñado),mujer(Persona1).

cuñada(Persona1,Cuñada) :-
    cuñados(Persona1,Cuñada),hombre(Persona1).
 
nieto(Abuelo,Nieto) :-
    (madre(Nieto,X) ; padre(Nieto,X)), padre(X,Abuelo), hombre(Nieto).

nieta(Abuelo,Nieta) :-
    (madre(Nieta,X) ; padre(Nieta,X)), padre(X,Abuelo), mujer(Nieta).

tia(Persona,Tia) :-
    (madre(Persona,X) ; padre(Persona,X)), hermana(X,Tia).

tio(Persona,Tio) :-
    (madre(Persona,X) ; padre(Persona,X)), hermano(X,Tio).

primo(Primo1,Primo2) :-
    (progenitor(X,Primo1),progenitor(Y,Primo2),hermanos(X,Y),hombre(Primo2)).

prima(Primo1,Primo2) :-
    (progenitor(X,Primo1),progenitor(Y,Primo2),hermanos(X,Y),mujer(Primo2)).
% Relaciones
padre_de(a, b).
padre_de(b, c).
padre_de(b, d).
padre_de(c, e).
padre_de(d, f).
padre_de(e, g).

madre_de(h, i).
madre_de(i, j).
madre_de(i, k).
madre_de(j, l).
madre_de(k, m).
madre_de(l, n).

pareja_de(a, h).
pareja_de(h, a).

% Reglas
suegro_de(X, Y) :- padre_de(X, Z), pareja_de(Z, Y).
suegro_de(X, Y) :- madre_de(X, Z), pareja_de(Z, Y).

suegra_de(X, Y) :- madre_de(X, Z), pareja_de(Z, Y).
suegra_de(X, Y) :- padre_de(X, Z), pareja_de(Z, Y).

abuelo_de(X, Y) :- padre_de(X, Z), padre_de(Z, Y).
abuelo_de(X, Y) :- padre_de(X, Z), madre_de(Z, Y).
abuelo_de(X, Y) :- madre_de(X, Z), padre_de(Z, Y).
abuelo_de(X, Y) :- madre_de(X, Z), madre_de(Z, Y).

abuela_de(X, Y) :- madre_de(X, Z), madre_de(Z, Y).
abuela_de(X, Y) :- madre_de(X, Z), padre_de(Z, Y).
abuela_de(X, Y) :- padre_de(X, Z), madre_de(Z, Y).
abuela_de(X, Y) :- padre_de(X, Z), padre_de(Z, Y).

hermano_de(X, Y) :- padre_de(Z, X), padre_de(Z, Y), X \= Y.
hermana_de(X, Y) :- madre_de(Z, X), madre_de(Z, Y), X \= Y.

tio_de(X, Y) :- hermano_de(X, Z), padre_de(Z, Y).
tio_de(X, Y) :- hermano_de(X, Z), madre_de(Z, Y).

cuñado_de(X, Y) :- hermano_de(X, Z), pareja_de(Z, Y).
cuñado_de(X, Y) :- hermana_de(X, Z), pareja_de(Z, Y).

bisabuelo_de(X, Y) :- abuelo_de(X, Z), padre_de(Z, Y).
bisabuelo_de(X, Y) :- abuelo_de(X, Z), madre_de(Z, Y).
bisabuelo_de(X, Y) :- abuela_de(X, Z), padre_de(Z, Y).
bisabuelo_de(X, Y) :- abuela_de(X, Z), madre_de(Z, Y).

nieto_de(X, Y) :- abuelo_de(Y, X).
nieto_de(X, Y) :- abuela_de(Y, X).

descendiente_de(X, Y) :- hijo_de(X, Y).
descendiente_de(X, Y) :- hijo_de(X, Z), descendiente_de(Z, Y).

hijo_de(X, Y) :- padre_de(Y, X).
hijo_de(X, Y) :- madre_de(Y, X).

progenitor_de(X, Y) :- padre_de(X, Y).
progenitor_de(X, Y) :- madre_de(X, Y).

suegro(X) :- suegro_de(X, _).
suegra(X) :- suegra_de(X, _).
abuelo(X) :- abuelo_de(X, _).
abuela(X) :- abuela_de(X, _).
hermano(X) :- hermano_de(X, _).
hermana(X) :- hermana_de(X, _).
tio(X) :- tio_de(X, _).
cuñado(X) :- cuñado_de(X, _).
bisabuelo(X) :- bisabuelo_de(X, _).
nieto(X) :- nieto_de(X, _).
descendiente(X) :- descendiente_de(X, _).
hijo(X) :- hijo_de(X, _).
progenitor(X) :- progenitor_de(X, _).
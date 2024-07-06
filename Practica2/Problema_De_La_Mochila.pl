% Definición de los elementos
item(pendrive, 5, 500).
item(laptop, 3000, 2000).
item(libro, 1000, 400).
item(botella_agua, 600, 150).

% Función objetivo
aptitud(Items, Peso, Valor) :-
    calcular_aptitud(Items, 0, 0, Peso, Valor).

calcular_aptitud([], Peso, Valor, Peso, Valor).
calcular_aptitud([Elemento|Resto], PesoActual, ValorActual, PesoTotal, ValorTotal) :-
    item(Elemento, PesoElemento, ValorElemento),
    NuevoPeso is PesoActual + PesoElemento,
    NuevoValor is ValorActual + ValorElemento,
    calcular_aptitud(Resto, NuevoPeso, NuevoValor, PesoTotal, ValorTotal).

% Genera una población inicial aleatoria
generar_poblacion(_, 0, []).
generar_poblacion(Items, N, [Individuo|Poblacion]) :-
    N > 0,
    random_permutation(Items, Individuo),
    N1 is N - 1,
    generar_poblacion(Items, N1, Poblacion).

% Selecciona los mejores individuos de la población
seleccionar_mejores_poblacion(_, 0, _, []).
seleccionar_mejores_poblacion(Poblacion, N, FuncionAptitud, [Mejor|Seleccionados]) :-
    N > 0,
    seleccionar_mejor_individuo(Poblacion, FuncionAptitud, Mejor),
    N1 is N - 1,
    seleccionar_mejores_poblacion(Poblacion, N1, FuncionAptitud, Seleccionados).

seleccionar_mejor_individuo([Individuo|Poblacion], FuncionAptitud, Mejor) :-
    aptitud(Individuo, _, Valor),
    seleccionar_mejor_individuo(Poblacion, Individuo, Valor, FuncionAptitud, Mejor).

seleccionar_mejor_individuo([], MejorIndividuo, _, _, MejorIndividuo).
seleccionar_mejor_individuo([Individuo|Poblacion], MejorActual, MejorValorActual, FuncionAptitud, Mejor) :-
    aptitud(Individuo, _, Valor),
    call(FuncionAptitud, Individuo, _, NuevoValor),
    (NuevoValor > MejorValorActual ->
        seleccionar_mejor_individuo(Poblacion, Individuo, NuevoValor, FuncionAptitud, Mejor)
    ;
        seleccionar_mejor_individuo(Poblacion, MejorActual, MejorValorActual, FuncionAptitud, Mejor)
    ).

% Cruza dos individuos
cruce(Individuo1, Individuo2, Cruzado1, Cruzado2) :-
    length(Individuo1, Longitud),
    random_between(1, Longitud, Division),
    append(Prefijo1, Sufijo1, Individuo1),
    append(Prefijo2, Sufijo2, Individuo2),
    append(Prefijo1, Sufijo2, Cruzado1),
    append(Prefijo2, Sufijo1, Cruzado2).

% Mutación de un individuo
mutacion(Individuo, Mutado) :-
    length(Individuo, Longitud),
    random_between(1, Longitud, PuntoMutacion),
    reemplazar_elemento_en(Individuo, PuntoMutacion, Mutado).

reemplazar_elemento_en([_|Resto], 1, [NuevoElem|Resto]) :-
    random_permutation([pendrive, laptop, libro, botella_agua], [NuevoElem|_]).
reemplazar_elemento_en([Cabeza|Resto], Posicion, [Cabeza|NuevoResto]) :-
    Posicion > 1,
    NuevaPosicion is Posicion - 1,
    reemplazar_elemento_en(Resto, NuevaPosicion, NuevoResto).

% Algoritmo genético principal
% Definición del predicado algoritmo_genetico/4
algoritmo_genetico(Items, TamanoPoblacion, Generaciones, MejorSolucion) :-
    generar_poblacion(Items, TamanoPoblacion, Poblacion),
    iterar_algoritmo_genetico(Poblacion, Items, Generaciones, MejorSolucion),
    writeln('La mejor solución encontrada es:'),
    writeln(MejorSolucion).

iterar_algoritmo_genetico(_, _, 0, _) :-
    !.

iterar_algoritmo_genetico(Poblacion, Items, GeneracionesRestantes, MejorSolucion) :-
    seleccionar_mejores_poblacion(Poblacion, TamanoMejorPoblacion, aptitud, MejorPoblacion),
    cruce_poblacion(MejorPoblacion, PoblacionCruzada),
    mutar_poblacion(PoblacionCruzada, PoblacionMutada),
    NuevasGeneracionesRestantes is GeneracionesRestantes - 1,
    iterar_algoritmo_genetico(PoblacionMutada, Items, NuevasGeneracionesRestantes, MejorSolucion).



cruce_poblacion([], []).
cruce_poblacion([Individuo1, Individuo2|Resto], [Cruzado1, Cruzado2|RestoCruzado]) :-
    cruce(Individuo1, Individuo2, Cruzado1, Cruzado2),
    cruce_poblacion(Resto, RestoCruzado).

mutar_poblacion([], []).
mutar_poblacion([Individuo|Resto], [Mutado|RestoMutado]) :-
    mutacion(Individuo, Mutado),
    mutar_poblacion(Resto, RestoMutado).
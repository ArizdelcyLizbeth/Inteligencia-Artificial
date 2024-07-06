:- use_module(library(random)).
:- use_module(library(lists)).

% Predicado que inicializa una población de individuos
init_population(0, _, []).
init_population(N, Size, [Ind|Population]) :-
    N > 0,
    N1 is N - 1,
    init_individual(Size, Ind),
    init_population(N1, Size, Population).

% Predicado que inicializa un individuo con valores aleatorios
init_individual(0, []).
init_individual(Size, [Gen|Individuo]) :-
    Size > 0,
    random(0, 2, Gen),
    Size1 is Size - 1,
    init_individual(Size1, Individuo).

% Predicado que evalúa un individuo
fitness(Individuo, Aptitud) :-
    sum_list(Individuo, Aptitud).

% Predicado que selecciona un individuo de una población basándose en su aptitud
select_individual([Ind|Poblacion], Seleccionado) :-
    select_individual(Poblacion, Ind, Seleccionado).

select_individual([], Seleccionado, Seleccionado).
select_individual([Ind|Poblacion], SeleccionadoHastaAhora, Seleccionado) :-
    fitness(Ind, AptitudInd),
    fitness(SeleccionadoHastaAhora, AptitudSeleccionado),
    (AptitudInd < AptitudSeleccionado ->
        select_individual(Poblacion, Ind, Seleccionado)
    ;
        select_individual(Poblacion, SeleccionadoHastaAhora, Seleccionado)
    ).

% Predicado que realiza el cruce entre dos individuos
crossover([Gen1|Ind1], [Gen2|Ind2], Punto, Punto, [Gen2|Cruzado]) :-
    crossover(Ind1, Ind2, Punto, Punto, Cruzado).
crossover([Gen1|Ind1], [Gen2|Ind2], Punto, Acumulador, [Gen1|Cruzado]) :-
    Acumulador < Punto,
    Acumulador1 is Acumulador + 1,
    crossover(Ind1, Ind2, Punto, Acumulador1, Cruzado).
crossover([], [], _, _, []).

% Predicado que muta un individuo
mutacion([], []).
mutacion([Gen|Ind], [GenMutado|IndMutado]) :-
    random(0.0, 1.0, R),
    (R < 0.1 ->
        GenMutado is 1 - Gen % Mutación bit a bit (flip)
    ;
        GenMutado = Gen
    ),
    mutacion(Ind, IndMutado).

% Predicado que evoluciona una población una generación
evolucionar_poblacion([], _, []).
evolucionar_poblacion([Ind1, Ind2|Resto], TamanoPoblacion, [Mutado1, Mutado2|Evolucionado]) :-
    crossover(Ind1, Ind2, Punto, 0, Cruzado1),
    crossover(Ind2, Ind1, Punto, 0, Cruzado2),
    mutacion(Cruzado1, Mutado1),
    mutacion(Cruzado2, Mutado2),
    evolucionar_poblacion(Resto, TamanoPoblacion, Evolucionado).

% Ejemplo de uso
algoritmo_genetico(TamanoPoblacion, Generaciones, Poblacion) :-
    init_population(TamanoPoblacion, 10, Poblacion0),
    evolucionar(Generaciones, Poblacion0, Poblacion).

evolucionar(0, Poblacion, Poblacion).
evolucionar(N, Poblacion, PoblacionFinal) :-
    N > 0,
    evolucionar_poblacion(Poblacion, Poblacion, PoblacionEvolucionada),
    N1 is N - 1,
    evolucionar(N1, PoblacionEvolucionada, PoblacionFinal).
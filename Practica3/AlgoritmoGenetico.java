import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;
import java.util.Scanner;

public class AlgoritmoGenetico {
    static String TARGET;
    static final String CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ";
    static final int POPULATION_SIZE = 500; 
    static final int MAX_GENERATIONS = 10000;
    static final double MUTATION_RATE = 0.05; 
    static final int ELITE_COUNT = 5; 

    static Random random = new Random();

    /**
     * Método principal que ejecuta el algoritmo genético.
     * @param args 
     */
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Ingrese la cadena objetivo (solo mayúsculas y espacios): ");
        TARGET = scanner.nextLine().toUpperCase().replaceAll("[^A-Z ]", "");

        ArrayList<String> population = initializePopulation();
        int generation = 0;

        while (generation < MAX_GENERATIONS) {
            ArrayList<String> newPopulation = new ArrayList<>();

            // Evalúa la aptitud de cada individuo
            ArrayList<Individual> individuals = new ArrayList<>();
            for (String individual : population) {
                individuals.add(new Individual(individual, fitness(individual)));
            }

     
            Collections.sort(individuals);

           
            if (individuals.get(0).fitness == 0) {
                System.out.println("Cadena encontrada en la generación " + generation);
                System.out.println("Cadena: " + individuals.get(0).string);
                return;
            }

           
            for (int i = 0; i < ELITE_COUNT; i++) {
                newPopulation.add(individuals.get(i).string);
            }

            // Genera nueva población mediante cruce y mutación
            while (newPopulation.size() < POPULATION_SIZE) {
                String parent1 = selectParent(individuals);
                String parent2 = selectParent(individuals);
                String child1 = crossover(parent1, parent2);
                String child2 = crossover(parent2, parent1);
                newPopulation.add(mutate(child1));
                newPopulation.add(mutate(child2));
            }

            population = newPopulation;
            generation++;
        }

        System.out.println("No se encontró la cadena en " + MAX_GENERATIONS + " generaciones.");
    }
    /**
     * Inicializa la población con cadenas aleatorias.
     * @return La población inicial.
     */
    static ArrayList<String> initializePopulation() {
        ArrayList<String> population = new ArrayList<>();
        for (int i = 0; i < POPULATION_SIZE; i++) {
            population.add(generateRandomString(TARGET.length()));
        }
        return population;
    }
    /**
     * Genera una cadena aleatoria de una longitud dada.
     * @param length La longitud de la cadena a generar.
     * @return Una cadena aleatoria.
     */
    static String generateRandomString(int length) {
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(CHARACTERS.charAt(random.nextInt(CHARACTERS.length())));
        }
        return sb.toString();
    }
    /**
     * Calcula la aptitud de un individuo comparándolo con la cadena objetivo.
     * @param individual El individuo cuya aptitud se calcula.
     * @return La aptitud del individuo.
     */
    static int fitness(String individual) {
        int fitness = 0;
        for (int i = 0; i < individual.length(); i++) {
            if (individual.charAt(i) != TARGET.charAt(i)) {
                fitness++;
            }
        }
        return fitness;
    }
    /**
     * Selecciona un padre para el cruce basado en la aptitud.
     * @param individuals La lista de individuos de la población actual.
     * @return Un padre seleccionado para el cruce.
     */
    static String selectParent(ArrayList<Individual> individuals) {
        int totalFitness = individuals.stream().mapToInt(ind -> ind.fitness).sum();
        int randomFitness = random.nextInt(totalFitness);
        int runningSum = 0;

        for (Individual individual : individuals) {
            runningSum += individual.fitness;
            if (runningSum > randomFitness) {
                return individual.string;
            }
        }

        return individuals.get(0).string; 
    }
    /**
     * Realiza el cruce entre dos padres para producir un hijo.
     * @param parent1 El primer padre.
     * @param parent2 El segundo padre.
     * @return El hijo resultante del cruce.
     */
    static String crossover(String parent1, String parent2) {
        int crossoverPoint = random.nextInt(TARGET.length());
        return parent1.substring(0, crossoverPoint) + parent2.substring(crossoverPoint);
    }
    /**
     * Aplica mutación a un individuo.
     * @param individual El individuo a mutar.
     * @return El individuo mutado.
     */
    static String mutate(String individual) {
        StringBuilder mutated = new StringBuilder(individual);
        for (int i = 0; i < individual.length(); i++) {
            if (random.nextDouble() < MUTATION_RATE) {
                mutated.setCharAt(i, CHARACTERS.charAt(random.nextInt(CHARACTERS.length())));
            }
        }
        return mutated.toString();
    }

    static class Individual implements Comparable<Individual> {
        String string;
        int fitness;
        /**
         * Constructor de la clase Individual.
         * @param string La cadena que representa al individuo.
         * @param fitness La aptitud del individuo.
         */
        Individual(String string, int fitness) {
            this.string = string;
            this.fitness = fitness;
        }

        /**
         * Compara este individuo con otro basado en la aptitud.
         * @param o El otro individuo a comparar.
         * @return Un valor negativo si este individuo es menor que el otro, cero si son iguales, 
         * y un valor positivo si este individuo es mayor que el otro.
         */
        @Override
        public int compareTo(Individual o) {
            return Integer.compare(this.fitness, o.fitness);
        }
    }
}
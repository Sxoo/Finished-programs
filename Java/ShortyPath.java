import java.util.*;

public class ShortyPath {

    static final int V = 8;
    private static final int NO_PARENT = -1;

    void printSolution(int dist[], int n, int from, int to, List<String> citiesList, int parents[]) {
        if (dist[to] == Integer.MAX_VALUE) {
            System.out.println("Such route does not exist...");
        }
        else {
            System.out.println("Distance from city - " + citiesList.get(from) + " to city - " + citiesList.get(to) + " is " + dist[to]);
            System.out.println("The route you need to take is: ");
            printRoute(to, parents, citiesList);
        }
    }
    private static void printRoute(int current, int[] parents, List<String> citiesList) {
        if (current == NO_PARENT) {
            return;
        }
        printRoute(parents[current], parents, citiesList);
        System.out.print(citiesList.get(current) + " ");
    }

    void build(int graph[][], int from, int to, List<String> citiesList) {
        int dist[] = new int[V];
        Boolean add[] = new Boolean[V];
        int[] parents = new int[V];
        for (int i = 0; i < V; i++) {
            dist[i] = Integer.MAX_VALUE;
            add[i] = false;
        }
        dist[from] = 0;
        parents[from] = NO_PARENT;
        for (int i = 0; i < V-1; i++) {
            int u = minDist(dist, add);
            add[u] = true;
            for (int v = 0; v < V; v++) {

                if (!add[v] && graph[u][v] != 0 && dist[u] != Integer.MAX_VALUE && dist[u] + graph[u][v] < dist[v]) {
                    dist[v] = dist[u] + graph[u][v];
                    parents[v] = u;
                }
            }
        }
        printSolution(dist, V, from, to, citiesList, parents);
    }
    int minDist(int dist[], Boolean add[]) {
        int min = Integer.MAX_VALUE;
        int index = -1;

        for (int v = 0; v < V; v++) {
            if (add[v] == false && dist[v] <= min) {
                min = dist[v];
                index = v;
            }
        }
        return index;
    }

    public static void main (String[] args) {
        int graph[][] = new int[][]{
                {0, 5, 0, 0, 0, 0, 0, 9},
                {5, 0, 9, 0, 0, 0, 0, 12},
                {0, 9, 0, 0, 0, 5, 0, 0},
                {0, 0, 0, 0, 10, 0, 0, 0},
                {0, 0, 0, 10, 0, 0, 0, 0},
                {0, 0, 5, 0, 0, 0, 3, 0},
                {0, 0, 0, 0, 0, 3, 0, 2},
                {9, 12, 0, 0, 0, 0, 2, 0}
        };
        Scanner userInput = new Scanner(System.in);
        String[] Cities = new String[]{"Riga","Vilnius", "Kaunas", "Klaipeda", "Mare", "Moletai", "Warsaw", "Berlin"};
        System.out.println("Choose two cities from the list: ");
        for (int i = 0; i < V; i++) {
            System.out.println(Cities[i]);
            Cities[i] = Cities[i].toUpperCase();
        }
        List<String> citiesList = new ArrayList<>(Arrays.asList(Cities));
        String firstCity = userInput.nextLine().toUpperCase();
        int from = checkInput(userInput, citiesList, firstCity);
        String secondCity = userInput.nextLine().toUpperCase();
        int to = checkInput(userInput, citiesList, secondCity);
        ShortyPath yes = new ShortyPath();
        yes.build(graph, from, to, citiesList);
    }

    private static int checkInput(Scanner userInput, List<String> CITIES, String city) {
        while (CITIES.contains(city) == false) {
            System.out.println("There is no such city");
            city = userInput.nextLine().toUpperCase();
        }
        return CITIES.indexOf(city);
    }
}

package Games;

import java.util.ArrayList;
import java.util.Random;

public class AI {
    public static void mainAI(ArrayList <String> location) {
        int r;
        Random rand = new Random();
        boolean sameNumber = true;
        while (sameNumber) {
            r = rand.nextInt(8);
            if (location.get(r).equalsIgnoreCase("O") || location.get(r).equalsIgnoreCase("X")) {
                sameNumber = true;
            } else {
                sameNumber = false;
                location.set(r, "O");
            }
        }
    }
    public static void runScenario1(ArrayList <String> location) {
        Random rand = new Random();
        int r = rand.nextInt(4);
        if (location.get(0).equalsIgnoreCase("X") || location.get(2).equalsIgnoreCase("X")
                || location.get(6).equalsIgnoreCase("X") || location.get(8).equalsIgnoreCase("X")) {
            location.set(4, "O");
        } else if (location.get(4).equalsIgnoreCase("X")) {
            if (r == 0) {
                location.set(0, "O");
            } else if (r == 1) {
                location.set(2, "O");
            } else if (r == 2) {
                location.set(6, "O");
            } else if (r >= 3) {
                location.set(8, "O");
            }
        }
        else
            mainAI(location);
    }
    public static void runScenario2(ArrayList <String> location) {
        Random rand = new Random();

        int r = rand.nextInt(2);
        if (location.get(0).equalsIgnoreCase("X") || location.get(2).equalsIgnoreCase("X")
                || location.get(6).equalsIgnoreCase("X") || location.get(8).equalsIgnoreCase("X")) {
            if(r == 0){location.set(3, "O");
            }
            else if(r >= 1){location.set(5, "O");
            }
            else
                mainAI(location);
        }
        else
            mainAI(location);
    }
}
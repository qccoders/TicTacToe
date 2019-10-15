package Games;

import java.util.ArrayList;

public class Board {
    public static void displayPlayingBoard(ArrayList<String> location) {

        for (int i = 1; i < location.size(); i++) {
            if (i == 3 || i == 6 || i == 10) {
                System.out.print(location.get(i) + " \n");
                System.out.print("---------\n");
            } else if (i <= 8){
                System.out.print(location.get(i) + " | ");
            } else if(i == 9){
                System.out.print(location.get(i));
            }
        }
    }
    public static void populateArraySizeToString(ArrayList<String> location){
        //It creates the the size of the array and string from 0 - 8
        for (int j = 0; j <= 9; j++) {
            location.add(j, Integer.toString(j));
        }
    }
}

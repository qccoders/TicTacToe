package Games;

import java.util.ArrayList;
import java.util.Random;
import java.util.Scanner;

public class TicTacToe {
    private static boolean quit;

    public static void playTicTacToe() throws InterruptedException {
        Scanner input = new Scanner(System.in);
        int set;
        quit = true;
        int count = 0;
        Random rand = new Random();
        ArrayList <String> location = new ArrayList <>();//This populates to the board and displays
        //where you have placed your markers
        Board.populateArraySizeToString(location);//Calls and populates the array size
        while (quit) {
            System.out.println("\nWelcome to Tic Tac Toe \nenter a number from the grid.");
            //X goes first
            Board.displayPlayingBoard(location);//displays playing board
            System.out.println();
            if(count % 2 == 0){//remainder it is O's turn no remainder X's turn
                boolean again = true;

                while (again){
                    set = input.nextInt();
                    if (location.get(set).equalsIgnoreCase("O")|| location.get(set).equalsIgnoreCase("X")) {
                        System.out.println("Enter a new number that one was taken.");
                        again = true;
                        System.out.println();
                    }
                    else{
                        again = false;
                        location.set(set, "X");
                    }

                }
            }
            //O goes next if 'count' has a remainder
            else{
                int r;
                boolean sameNumber = true;
                while(sameNumber){
                    r = rand.nextInt(8);
                    if (location.get(r).equalsIgnoreCase("O")||location.get(r).equalsIgnoreCase("X")) {
                        sameNumber = true;
                    }
                    else{
                        sameNumber = false;
                        location.set(r, "O");
                    }
                }
                Graphics.displayGraphics();
            }
            //counts the number of total attempts
            count++;
            if(count == 9){
                System.out.println("\nTie\n");
                System.out.println("\nTie\n");
                System.out.println("\nTie\n");
                WinnerLoser.playAgain();
            }
            else{
            //Call the board showing the new locations
            WinnerLoser.winner(location, "X");
            WinnerLoser.winner(location, "O");}

        }
        Board.displayPlayingBoard(location);
    }
}


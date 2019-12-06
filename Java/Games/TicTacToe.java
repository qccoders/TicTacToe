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
        //Random rand = new Random();
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
            //This is a makeshift attempt at an AI
            else if(count == 1){
                AI.runScenario1(location);
                Graphics.displayGraphics();
            }
            else if(count == 3){
                AI.runScenario2(location);
                Graphics.displayGraphics();
            }
            //O goes next if 'count' has a remainder
            else{
                AI.mainAI(location);
                Graphics.displayGraphics();
            }
            //counts the number of total attempts
            count++;
            WinnerLoser.winner(location, "X", count);
            WinnerLoser.winner(location, "O", count);
        }
        Board.displayPlayingBoard(location);
    }
}


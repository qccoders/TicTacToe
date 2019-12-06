package Games;

import java.util.ArrayList;
import java.util.Scanner;

import static Games.Graphics.*;

public class WinnerLoser {

    public static void playAgain() throws InterruptedException {

        String again;
        Scanner input = new Scanner(System.in);
        Graphics.mainScreen();
        System.out.println("Would you like to play yes or no?");
        again = input.next();
        if(again.equalsIgnoreCase("yes")){
                TicTacToe.playTicTacToe();
                Graphics.mainScreen();
        }
        else {
            System.out.println("Thanks for playing");
            System.exit(0);
        }
    }

    public static void winner(ArrayList <String> location, String check, int count) throws InterruptedException {
        int oWins = 0;
        int xWins = 1;
        if (location.get(1).equals(check) && location.get(2).equals(check) && location.get(3).equals(check)) {
                if(check.equalsIgnoreCase("O")){
                    oWins++; }
            else if(check.equalsIgnoreCase("X")){
                xWins++; }
        } else if (location.get(7).equals(check) && location.get(5).equals(check) && location.get(3).equals(check)) {
            if(check.equalsIgnoreCase("O")){
                oWins++; }
            else if(check.equalsIgnoreCase("X")){
                xWins++; }
        } else if (location.get(7).equals(check) && location.get(8).equals(check) && location.get(9).equals(check)) {
            if(check.equalsIgnoreCase("O")){
                oWins++; }
            else if(check.equalsIgnoreCase("X")){
                xWins++; }
        } else if (location.get(1).equals(check) && location.get(4).equals(check) && location.get(7).equals(check)) {
            if(check.equalsIgnoreCase("O")){
                oWins++; }
            else if(check.equalsIgnoreCase("X")){
                xWins++; }
        } else if (location.get(2).equals(check) && location.get(5).equals(check) && location.get(8).equals(check)) {
            if(check.equalsIgnoreCase("O")){
                oWins++; }
            else if(check.equalsIgnoreCase("X")){
                xWins++; }
        } else if (location.get(3).equals(check) && location.get(6).equals(check) && location.get(9).equals(check)) {
            if(check.equalsIgnoreCase("O")){
                oWins++; }
            else if(check.equalsIgnoreCase("X")){
                xWins++; }
        } else if (location.get(4).equals(check) && location.get(5).equals(check) && location.get(6).equals(check)) {
            if(check.equalsIgnoreCase("O")){
                oWins++; }
            else if(check.equalsIgnoreCase("X")){
                xWins++; }
        } else if (location.get(1).equals(check) && location.get(5).equals(check) && location.get(9).equals(check)) {
            if(check.equalsIgnoreCase("O")){
                oWins++; }
            else if(check.equalsIgnoreCase("X")){
                xWins++; }
        }
        if(oWins == 1){
            OWINS();
            playAgain();
        }
        else if(xWins == 2){
            XWINS();
            playAgain();
        }
        else if(count == 9){
            System.out.println("\nTie\n");
            System.out.println("\nTie\n");
            Board.displayPlayingBoard(location);
            System.out.println("\nTie\n");
            WinnerLoser.playAgain();
        }
    }
}

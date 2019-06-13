// Tic Tac Toe, by Sun A

// Include the libraries
#include <iostream>
#include <string>
#include <ctime>

//Use the standard namespace
using namespace std;

// Declare global variables
char Board[9];

// Declare functions
void showBoard();
bool moveIsValid(int m);
int whoWon(); //Returns 0 if no one has won, 1 if player 1 has won,
	      //and 2 if player 2 has won 

// dmh - This global variable is never used.
// int Move = rand() % 7 + 1;

int main()
{
    // Seed the random number.
    srand(time(NULL));

    // Declare local variables
    string Player_1_Name;
    string Player_2_Name;
    int Whose_Turn = 1;		// 1 means it's player 1's turn, 2 means it's player 2's turn
    int Move;			// Stores where the player wants to move
    int Total_Moves = 0;

    //Assign values to the playing board
    Board[0] = '0';
    Board[1] = '1';
    Board[2] = '2';
    Board[3] = '3';
    Board[4] = '4';
    Board[5] = '5';
    Board[6] = '6';
    Board[7] = '7';
    Board[8] = '8';

    // Get player names
    cout << "Player 1: Please enter your name." << endl;
    cin >> Player_1_Name;

    // dmh - do you mean for the computer to have a name?
    cout << "Player 2: Computer." << endl;
    cin >> Player_2_Name;

    while (whoWon() == 0 && Total_Moves < 9) {
	// Do this until the player chooses a valid move
	do {
	    if (Whose_Turn == 1) {
		// Show the board
		showBoard();

		cout << Player_1_Name << ": It's your turn." << endl;
		// Get the move
		cout << "Enter the number of the spot where you'd like to move." << endl;
		cin >> Move;

	    } else {
		// Computer selects random square
		Move = rand() % 9;
	    }

	} while (moveIsValid(Move) != true);

	// Add 1 to Total_Moves
	Total_Moves++;

	// Change whose turn it is
	switch (Whose_Turn) {
	case (1):
	  // dmh - No need for braces in the cases, unless you define
	  // a local variable with a constructor.
	  Board[Move] = 'x';
	  Whose_Turn = 2;
	  break;
	case (2):
	  Board[Move] = 'o';
	  Whose_Turn = 1;
	}
    }

    // Show the board
    showBoard();

    // dmh - I changed this to a switch statement so (1) whoWon()
    // would be called only once and (2) because switch is more
    // appropriate since you're checking the value of a single
    // expression
    switch (whoWon()) {
    case 1:
	cout << Player_1_Name << " has won the game!" << endl;
	break;
    case 2:
	cout << Player_2_Name << " has won the game!" << endl;
	break;
    default:
	cout << "It's a tie game!" << endl;
	break;
    }

//    system("PAUSE");
    system("sleep 3");

    return 0;
}

void
showBoard()
{
    cout << endl;
    cout << Board[0] << " | " << Board[1] << " | " << Board[2] << endl;
    cout << "--+---+--" << endl;
    cout << Board[3] << " | " << Board[4] << " | " << Board[5] << endl;
    cout << "--+---+--" << endl;
    cout << Board[6] << " | " << Board[7] << " | " << Board[8] << endl;
    cout << endl;
}

bool
moveIsValid(int m)
{
    // dmh - There's no need for an "if" statement here. Just return
    // the value of the boolean expression
    return (Board[m] != 'x' && Board[m] != 'o');
}

// dmh - here's a helper function that shows one way to reduce the
// duplicate code in whoWon().
int charToWinner(char ch)
{
    if (ch == 'x') {
	return 1;
    } else {
	return 2;
    }
}
    
int
whoWon()
{
    if (Board[0] == Board[1] && Board[1] == Board[2]) {
	// dmh - use helper function to reduce duplicate code
	return charToWinner(Board[0]);
    }

    if (Board[3] == Board[4] && Board[4] == Board[5]) {
	return charToWinner(Board[3]);
    }

    if (Board[6] == Board[7] && Board[7] == Board[8]) {
	return charToWinner(Board[6]);
    }

    if (Board[0] == Board[3] && Board[3] == Board[6]) {
	return charToWinner(Board[0]);
    }

    if (Board[1] == Board[4] && Board[4] == Board[7]) {
	return charToWinner(Board[1]);
    }
    if (Board[2] == Board[5] && Board[5] == Board[8]) {
	return charToWinner(Board[2]);
    }

    if (Board[0] == Board[4] && Board[4] == Board[8]) {
	return charToWinner(Board[0]);
    }

    if (Board[2] == Board[4] && Board[4] == Board[6]) {
	return charToWinner(Board[2]);
    }
    return 0;
}

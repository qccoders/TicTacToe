const readline = require('readline');

const turnReader = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});
  
var board = [[]];

main();

function main() {
    console.log("Welcome to QC Coders' Tic TacToe! You're 'X' and you'll go first.");
    initBoard();

    let takeTurn = () => { 
        console.log("\nHere's the current board:\n");
        printBoard();
        console.log("\n");

        turnReader.question("Enter your choice in the format 'x,y' (zero based, left to right, top to bottom): ", answer => {
            let x, y;

            try {
                let nums = answer.split(",");

                x = parseInt(nums[0]);
                y = parseInt(nums[1]);

                if (x < 0 || x > 2 || y < 0 || y > 2)
                {
                    throw "Invalid input! Try again.";
                }
            } catch(err) {
                console.log(err);
                takeTurn();
            }
            
            if (board[y][x] !== ' ') {
                console.log("That cell is already selected.");
                takeTurn();
            }

            board[y][x] = 'X';

            let gameOver = () => {
                if (getWinner() === 'Z') {
                    console.log("The game was a draw!");
                } else {
                    console.log((getWinner() === 'X' ? "You're" : "The computer is") + " the winner!");
                }

                console.log("Here's the final board: \n");
                printBoard();
                turnReader.close();
            }

            if (getWinner() !== 'X') {
                console.log("Computer is taking its turn...");
                doComputersTurn();
    
                if (getWinner() === null) {
                    takeTurn();
                } else {
                    gameOver();
                }
            } else {
                gameOver();
            }
        });
    }

    takeTurn();
};

function doComputersTurn() {
    let availableCells = getAvailableCells();
    let randomCell = availableCells[Math.floor(Math.random() * Math.floor(availableCells.length))];
    board[randomCell[1]][randomCell[0]] = 'O';
}

function getAvailableCells() {
    let availableCells = [];

    for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
            if (board[j][i] == ' ') {
                availableCells.push([ i, j ]);
            }
        }
    }

    return availableCells;
}

function getWinner() {
    let combos = [
        [[0, 0], [0, 1], [0, 2]],
        [[1, 0], [1, 1], [1, 2]],
        [[2, 0], [2, 1], [2, 2]],
        [[0, 0], [1, 0], [2, 0]],
        [[0, 1], [1, 1], [2, 1]],
        [[0, 2], [1, 2], [2, 2]],
        [[0, 0], [1, 1], [2, 2]],
        [[2, 0], [1, 1], [0, 2]],
    ];

    for (i = 0; i < 8; i++) {
        let combo = [];

        for (j = 0; j < 3; j++) {
            combo[j] = board[combos[i][j][1]][combos[i][j][0]];
        }

        if (combo[0] != ' ' && combo[0] == combo[1] && combo[1] == combo[2])
        {
            return combo[0];
        }
    }

    return getAvailableCells().length == 0 ? 'Z' : null;
}

function printBoard() {
    for (i = 0; i < 3; i++) {
        for (j = 0; j < 3; j++) {
            process.stdout.write(board[i][j] + (j < 2 ? "|" : "\n"));
        }

        if (i < 2) {
            console.log("-+-+-");
        }
    }
}

function initBoard() {
    board = [
        [ ' ', ' ', ' '],
        [ ' ', ' ', ' '],
        [ ' ', ' ', ' '],
    ];
}

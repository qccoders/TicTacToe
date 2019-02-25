const readline = require('readline-sync');

var board = [[]];

main();

function main() {
    do {
        console.log("Welcome to QC Coders' Tic TacToe! You're 'X' and you'll go first.");
        initBoard();
    
        do {
            console.log("\nHere's the current board:\n");
            printBoard();

            var input = readline.question("\nEnter your choice in the format 'x,y' (zero based, left to right, top to bottom): ");        
            let x, y;
        
            try {
                let nums = input.split(",");
        
                x = parseInt(nums[0]);
                y = parseInt(nums[1]);
       
                if (isNaN(x) || isNaN(y) || x < 0 || x > 2 || y < 0 || y > 2)
                {
                    throw "\nInvalid input! Try again.";
                }
            } catch(err) {
                console.log(err);
                continue;
            }
            
            if (board[y][x] !== ' ') {
                console.log("\nThat cell is already selected.");
                continue;
            }
        
            board[y][x] = 'X';
            if (getWinner() !== null) break;

            console.log("\nComputer is taking its turn...");
            doComputersTurn();
        } while (getWinner() === null);

        if (getWinner() === 'Z') {
            console.log("\nThe game was a draw!");
        } else {
            console.log("\n" + (getWinner() === 'X' ? "You're" : "The computer is") + " the winner!");
        }

        console.log("Here's the final board:\n");
        printBoard();
    } while (readline.question("\nPress Enter to play again or x + Enter to exit.") === "");
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

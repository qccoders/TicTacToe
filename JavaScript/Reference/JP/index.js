const readline = require('readline');

const stdin = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});
  
var board = [[]];

function read(prompt) {
    let input;
    stdin.question(prompt, answer => input = answer);
    return input;
}

main();

function main() {
    do {
        console.log("Welcome to QC Coders' Tic TacToe! You're 'X' and you'll go first.");
        initBoard();

        do {
            console.log("\nHere's the current board:\n");
            printBoard();
            console.log("\n");

            let input = "1,1";
            //stdin.question("Enter your choice in the format 'x,y' (zero based, left to right, top to bottom):", answer => input = answer);

            let x, y;

            try {
                let nums = input.split(",");

                x = parseInt(nums[0]);
                y = parseInt(nums[1]);

                console.log(x, y);

                if (x < 0 || x > 2 || y < 0 || y > 2)
                {
                    throw "Invalid input! Try again.";
                }

                if (board[y][x] !== ' ') {
                    throw "That cell is already selected";
                }

                board[y][x] = 'X';

                doComputersTurn();

                printBoard();
            } catch(err) {
                console.log(err);
            }
        } while (getWinner() !== null);
    } while (read("Press Enter to play again or x + Enter to exit.") === "yes");

    stdin.close();
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

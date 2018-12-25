package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

var board [][]byte
var reader = bufio.NewReader(os.Stdin)

func main() {
	for {
		fmt.Println("Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.")
		initBoard()

		for {
			fmt.Println("\nHere's the current board:\n")
			printBoard()
			fmt.Println("\nEnter your choice in the format 'x,y' (zero based, left to right, top to bottom):")

			input, err := reader.ReadString('\n')
			input = strings.TrimSuffix(input, "\n")

			parts := strings.Split(input, ",")

			if err != nil || len(parts) != 2 {
				fmt.Println("\nInvalid input! try again.")
				continue
			}

			x, err := strconv.ParseInt(parts[0], 10, 32)

			if err != nil {
				fmt.Println("\nInvalid input! try again.")
				continue
			}

			y, err := strconv.ParseInt(parts[1], 10, 32)

			if err != nil || x < 0 || x > 2 || y < 0 || y > 2 {
				fmt.Println("\nInvalid input! try again.")
				continue
			}

			if board[y][x] != ' ' {
				fmt.Println("\nThat cell is already selected.")
				continue
			}

			board[y][x] = 'X'
		}
	}
}

func printBoard() {
	for i := 0; i < 3; i++ {
		for j := 0; j < 3; j++ {
			fmt.Print(string(board[i][j]))

			if j < 2 {
				fmt.Print("|")
			}
		}

		if i < 2 {
			fmt.Println("\n-+-+-")
		}
	}

	fmt.Println()
}

func initBoard() {
	board = make([][]byte, 3)

	for i := 0; i < 3; i++ {
		board[i] = make([]byte, 3)

		for j := 0; j < 3; j++ {
			board[i][j] = ' '
		}
	}
}

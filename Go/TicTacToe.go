package main

import "fmt"

var board [][]byte

func main() {
	initBoard()
	printBoard()
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

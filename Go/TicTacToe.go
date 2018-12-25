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
		initBoard()
		printBoard()

		input, err := reader.ReadString('\n')
		input = strings.TrimSuffix(input, "\n")

		parts := strings.Split(input, ",")

		if err != nil || len(parts) != 2 {
			fmt.Println("\nInvalid input! try again.")
			continue
		}

		fmt.Println(parts)

		x, err := strconv.ParseInt(parts[0], 10, 32)
		y, err := strconv.ParseInt(parts[1], 10, 32)

		if err != nil || x < 0 || x > 2 || y < 0 || y > 2 {
			fmt.Println(err)
			fmt.Println("\nInvalid input! try again.")
			continue
		}

		fmt.Println(input)
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

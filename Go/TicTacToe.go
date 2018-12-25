package main

import (
	"bufio"
	"fmt"
	"math/rand"
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
			if getWinner() != 0x0 {
				break
			}

			fmt.Println("\nComputer is taking its turn...")
			doComputersTurn()

			if getWinner() != 0x0 {
				break
			}
		}

		if getWinner() == 'Z' {
			fmt.Println("The game was a draw!")
		} else if getWinner() == 'X' {
			fmt.Println("You're the winner!")
		} else {
			fmt.Println("The computer is the winner!")
		}

		fmt.Println("Here's the final board:\n")
		printBoard()

		fmt.Println("\nPress Enter to play again or x + Enter to exit.")
	}
}

func doComputersTurn() {
	availableCells := getAvailableCells()
	randomCell := availableCells[rand.Intn(len(availableCells))]
	board[randomCell[1]][randomCell[0]] = 'O'
}

func getAvailableCells() [][]int {
	availableCells := make([][]int, 0)

	for i := 0; i < 3; i++ {
		for j := 0; j < 3; j++ {
			if board[j][i] == ' ' {
				availableCells = append(availableCells, []int{i, j})
			}
		}
	}

	return availableCells
}

func getWinner() byte {
	combos := [][][]int{
		[][]int{[]int{0, 0}, []int{0, 1}, []int{0, 2}},
		[][]int{[]int{1, 0}, []int{1, 1}, []int{1, 2}},
		[][]int{[]int{2, 0}, []int{2, 1}, []int{2, 2}},
		[][]int{[]int{0, 0}, []int{1, 0}, []int{2, 0}},
		[][]int{[]int{0, 1}, []int{1, 1}, []int{2, 1}},
		[][]int{[]int{0, 2}, []int{1, 2}, []int{2, 2}},
		[][]int{[]int{0, 0}, []int{1, 1}, []int{2, 2}},
		[][]int{[]int{2, 0}, []int{1, 1}, []int{0, 2}},
	}

	for i := 0; i < 8; i++ {
		combo := []byte{' ', ' ', ' '}

		for j := 0; j < 3; j++ {
			combo[j] = board[combos[i][j][1]][combos[i][j][0]]
		}

		if combo[0] != ' ' && combo[0] == combo[1] && combo[1] == combo[2] {
			return combo[0]
		}
	}

	if len(getAvailableCells()) == 0 {
		return 'Z'
	}

	return 0x0
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

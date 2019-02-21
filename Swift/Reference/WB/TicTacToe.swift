enum TicTacToeError: Error {
    case cellSelected
    case invalidCoordinate
    case invalidInputFormat
    case outOfBoundsCoordinate
}

class Program {
    static var board: [[Character]] = []

    static func Main() {
        repeat {
            print("Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.")
            InitBoard()

            repeat {
                print("\nHere's the current board:\n")
                PrintBoard()
                print("\nEnter your choice in the format 'x,y' (zero based, left to right, top to bottom):")

                let input = readLine() ?? ""

                do {
                    var nums = input.split(separator: ",")

                    guard nums.count == 2 else {
                        throw TicTacToeError.invalidInputFormat
                    }

                    guard let x = Int(nums[0]) else {
                        throw TicTacToeError.invalidCoordinate
                    }

                    guard let y = Int(nums[1]) else {
                        throw TicTacToeError.invalidCoordinate
                    }

                    guard x >= 0 && x <= 2 && y >= 0 && y <= 2 else {
                        throw TicTacToeError.outOfBoundsCoordinate
                    }

                    guard board[y][x] == " " else {
                        throw TicTacToeError.cellSelected
                    }

                    board[y][x] = "X"

                    if (GetWinner() != nil) {
                        break
                    }

                    print("\nComputer is taking its turn...")
                    DoComputersTurn()
                } catch TicTacToeError.cellSelected {
                    print("\nThat cell is already selected.")
                } catch {
                    print("\nInvalid input! Try again.")
                }

            } while (GetWinner() == nil)

            switch GetWinner() {
            case "X":
                print("\nYou're the winner!")
            case "O":
                print("\nThe computer is the winner!")
            case "Z":
                print("\nThe game was a draw!")
            default:
                break
            }

            print("Here's the final board:\n")
            PrintBoard()

            print("\nPress Enter to play again or x + Enter to exit.")
        } while (readLine() == "")
    }

    static func DoComputersTurn() {
        var availableCells = GetAvailableCells()
        var randomCell = availableCells[Int.random(in: 0..<availableCells.count)]
        board[randomCell[1]][randomCell[0]] = "O"
    }

    static func GetAvailableCells() -> [[Int]] {
        var availableCells = [(Int, Int)]()

        for i in 0...2 {
            for j in 0...2 {
                if (board[j][i] == " ") {
                    availableCells.append((i, j))
                }
            }
        }

        return availableCells.map{[$0, $1]}
    }

    static func GetWinner() -> Character? {
        var combos: [[[Int]]] = [
            [[0, 0], [0, 1], [0, 2]],
            [[1, 0], [1, 1], [1, 2]],
            [[2, 0], [2, 1], [2, 2]],
            [[0, 0], [1, 0], [2, 0]],
            [[0, 1], [1, 1], [2, 1]],
            [[0, 2], [1, 2], [2, 2]],
            [[0, 0], [1, 1], [2, 2]],
            [[2, 0], [1, 1], [0, 2]],
        ]

        for i in 0...7 {
            var combo: [Character] = [" ", " ", " "]

            for j in 0...2 {
                combo[j] = board[combos[i][j][1]][combos[i][j][0]]
            }

            if (combo[0] != " " && combo[0] == combo[1] && combo[1] == combo[2]) {
                return combo[0]
            }
        }

        return GetAvailableCells().count == 0 ? "Z" : nil
    }

    static func PrintBoard() {
        for i in 0...2 {
            for j in 0...2 {
                print(board[i][j], terminator: (j < 2 ? "|" : "\n"))
            }

            if (i < 2) {
                print("-+-+-")
            }
        }
    }

    static func InitBoard() {
        board = Array(repeating: Array(repeating: " ", count: 3), count: 3)
    }
}

Program.Main()

using System;

namespace TicTacToe.NET
{
    class Program
    {
        struct Cell
        {
            public Cell(int x, int y)
            {
                X = x;
                Y = y;
            }

            public readonly int X;
            public readonly int Y;
        }

        static char[,] board;

        static void Main(string[] args)
        {
            Console.WriteLine($"Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.");

            InitBoard();

            do
            {
                Console.WriteLine(Environment.NewLine + "Here's the current board:" + Environment.NewLine);
                PrintBoard();
                Console.WriteLine(Environment.NewLine + "Enter your choice in the format 'x,y' (zero based, left to right, top to bottom):");

                var input = Console.ReadLine();
                Cell inputCell;

                try
                {
                    var nums = input.Split(',');

                    var x = int.Parse(nums[0]);
                    var y = int.Parse(nums[1]);

                    if (x < 0 || x > 2 || y < 0 || y > 2)
                    {
                        throw new ArgumentException();
                    }

                    inputCell = new Cell(x, y);
                }
                catch (Exception)
                {
                    Console.WriteLine("Invalid input!  Try again.");
                    continue;
                }

                if (!IsCellAvailable(inputCell))
                {
                    Console.WriteLine("That cell is already selected.");
                    continue;
                }

                board[inputCell.Y, inputCell.X] = 'X';

            } while (!GameOver());
        }

        static bool IsCellAvailable(Cell cell)
        {
            return board[cell.Y, cell.X] == ' ';
        }

        static bool GameOver()
        {
            return false;
        }

        static void PrintBoard()
        {
            for (int i = 0; i < 3; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    Console.Write(board[i, j] + (j < 2 ? "|" : Environment.NewLine));
                }

                if (i < 2)
                {
                    Console.WriteLine("-+-+-");
                }
            }
        }

        static void InitBoard()
        {
            board = new char[3, 3] {
                { ' ', ' ', ' ' },
                { ' ', ' ', ' ' },
                { ' ', ' ', ' ' },
            };
        }
    }
}

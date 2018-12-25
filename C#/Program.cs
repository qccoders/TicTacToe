using System;
using System.Collections.Generic;

namespace TicTacToe.NET
{
    class Program
    {
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
                int x, y;

                try
                {
                    var nums = input.Split(',');

                    x = int.Parse(nums[0]);
                    y = int.Parse(nums[1]);

                    if (x < 0 || x > 2 || y < 0 || y > 2)
                    {
                        throw new ArgumentException();
                    }
                }
                catch (Exception)
                {
                    Console.WriteLine(Environment.NewLine + "Invalid input!  Try again.");
                    continue;
                }

                if (board[y, x] != ' ')
                {
                    Console.WriteLine(Environment.NewLine + "That cell is already selected.");
                    continue;
                }

                board[y, x] = 'X';
                if (GetWinner() != null) break;

                Console.WriteLine(Environment.NewLine + "Computer is taking its turn...");
                DoComputersTurn();
            } while (GetWinner() == null);

            if (GetWinner() == 'Z')
            {
                Console.WriteLine("The game was a draw!");
            }
            else
            {
                Console.WriteLine($"{Environment.NewLine}{(GetWinner() == 'X' ? "you\'re" : "the computer is")} the winner!");
            }

            Console.WriteLine("Here's the final board:" + Environment.NewLine);
            PrintBoard();
        }

        static void DoComputersTurn()
        {
            var availableCells = GetAvailableCells();
            var randomCell = availableCells[new Random().Next(0, availableCells.Count)];
            board[randomCell.Item2, randomCell.Item1] = 'O';
        }

        static List<Tuple<int, int>> GetAvailableCells()
        {
            var availableCells = new List<Tuple<int, int>>();

            for (int i = 0; i < 3; i++)
            {
                for (int j = 0; j < 3; j++)
                {
                    if (board[j, i] == ' ')
                    {
                        availableCells.Add(new Tuple<int, int>(i, j));
                    }
                }
            }

            return availableCells;
        }

        static char? GetWinner()
        {
            int[,,] combos = new int[8, 3, 2] {
                { { 0, 0 }, { 0, 1 }, { 0, 2 } },
                { { 1, 0 }, { 1, 1 }, { 1, 2 } },
                { { 2, 0 }, { 2, 1 }, { 2, 2 } },
                { { 0, 0 }, { 1, 0 }, { 2, 0 } },
                { { 0, 1 }, { 1, 1 }, { 2, 1 } },
                { { 0, 2 }, { 1, 2 }, { 2, 2 } },
                { { 0, 0 }, { 1, 1 }, { 2, 2 } },
                { { 2, 0 }, { 1, 1 }, { 0, 2 } },
            };

            for (int i = 0; i < 8; i++)
            {
                var combo = new char[] { ' ', ' ', ' ' };

                for (int j = 0; j < 3; j++)
                {
                    combo[j] = board[combos[i, j, 1], combos[i, j, 0]];
                }

                if (combo[0] != ' ' && combo[0] == combo[1] && combo[1] == combo[2])
                {
                    return combo[0];
                }
            }

            return GetAvailableCells().Count == 0 ? 'Z' : (char?)null;
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

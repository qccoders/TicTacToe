using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace TicTacToe
{
    class AI
    {
        delegate void SetTextCallback(string text, int x, int y);
        delegate void SetVisCallback();
        public Label[][] Board;
        public Label ThinkLabel;
        //private int[][] corners = { new int[] { 0, 0 }, new int[] { 2, 2 }, new int[] { 2, 0 }, new int[] { 0, 2 } };
        //private int[][] orderOfImportance = { new int[] { 1, 1 }, new int[] { 0, 0 }, };
        int difficulty;

        public bool done = true;

        public AI (int difficulty)
        {
            this.difficulty = difficulty;
        }

        //Easy: random, Med: Random num that decides if it should pick the best, hard always picks best
        public void Choose()
        {
            switch (difficulty)
            {
                case 0:
                    {
                        done = false;
                        while (!done)
                        {
                            int[] rand = PickRandom();
                            if (CheckBoardPos(rand))
                            {
                                done = true;
                                PlaceOnBoard(rand);
                            }
                        }

                        break;
                    }

                case 1:
                    {
                        Random rand1 = new Random();
                        int chooseWisely = rand1.Next(10);
                        if (chooseWisely > 4)
                        {
                            int[] rand = PickRandom();
                            if (CheckBoardPos(rand))
                            {
                                done = true;
                                PlaceOnBoard(rand);
                            }
                        }
                        else
                        {
                            int[] bestpos = FindBestPos();
                            if (CheckBoardPos(bestpos))
                            {
                                done = true;
                                PlaceOnBoard(bestpos);
                            }
                        }

                        break;
                    }

                case 2:
                    {
                        int[] bestpos = FindBestPos();
                        if (CheckBoardPos(bestpos))
                        {
                            done = true;
                            PlaceOnBoard(bestpos);
                        }
                        break;
                    }
            }
        }

        private int[] PickRandom()
        {
            bool valid = false;
            int x = -1, y = -1;
            while (!valid)
            {
                Random rand = new Random();
                x = rand.Next(3);
                y = rand.Next(3);
                valid = CheckBoardPos(x, y);
            }
            return new int[] { x, y };
        }

        private bool AnyOs()
        {
            foreach (Label[] labels in Board)
            {
                foreach(Label label in labels)
                {
                    if (label.Text == "O")
                        return true;
                }
            }
            return false;
        }

        private int[] PickCorner()
        {
            Random rand = new Random();
            int x = rand.Next(2);
            int y = rand.Next(2);
            Console.WriteLine(x + ", " + y);
            return new int[] { x == 1 ? 2 : 0, y == 1 ? 2 : 0 };
        }

        private int[] FindBestPos()
        {
            if (!AnyOs() && CheckBoardPos(1, 1))
                return new int[] { 1, 1 };
            else if (!AnyOs())
            {
                return PickCorner();
            }

            int[] blockX = GoThruBoard(2, false);
            if (blockX[0] != -1 && blockX[1] != -1)
            {
                return blockX;
            }
            
            int OsToLookFor = 2;
            while (OsToLookFor > 0)
            {
                int[] pos = GoThruBoard(OsToLookFor--, true);
                if ((pos[0] > -1 || pos[1] > -1) && (pos[0] < 3 || pos[1] < 3))
                    return pos;
            }
            return PickRandom();
        }

        private int[] GoThruBoard(int NumToLookFor, bool LookForO)
        {
            Label[][] diagonals = new Label[][] { new Label[3] { Board[0][0], Board[1][1], Board[2][2] },
                                                  new Label[3] { Board[2][0], Board[1][1], Board[0][2] } };
            bool possible = true;
            int[] InRow = { 0, 0, 0 };
            int[] InCol = { 0, 0, 0 };

            bool[] ColumnPossible = new bool[3] { true, true, true };
            int[] ColumnXPos = new int[3] { -1, -1, -1 };

            //Strings (Switch them if LookForO is false)
            string X = LookForO ? "X" : "O";
            string O = LookForO ? "O" : "X";

            //Iterators
            int xI = 0;
            int yI = 0;

            //Pos of valid place.
            int posX = -1;
            int posY = -1;

            foreach (Label[] labels in Board)
            {
                possible = true;
                //Every row
                foreach (Label label in labels)
                {
                    //If X is found, win/placement is not possible
                    if (label.Text == X)
                    {
                        ColumnPossible[xI] = false;
                        possible = false;
                    }
                    //If there is an O, add.
                    else if (label.Text == O)
                    {
                        InRow[yI]++;
                        InCol[xI]++;
                    }
                    else if (label.Text == "")
                    {
                        posY = yI;
                        posX = xI;
                        ColumnXPos[xI] = yI;
                    }
                    xI++;
                }

                xI = 0;
                Console.WriteLine(InRow[yI] + ", " + NumToLookFor);
                if (InRow[yI] == NumToLookFor && possible)
                {
                    return new int[] { posY, posX };
                }
                yI++;
            }

            //Check Columns
            for (int i = 0; i < Board.Length; i++)
            {
                if (InCol[i] == NumToLookFor && ColumnPossible[i])
                {
                    return new int[] { ColumnXPos[i], i };
                }
            }
            
            //Diagonals
            for (int i = 0; i < 2; i++)
            {
                bool possible2 = true;
                int OsInDia = 0;
                int newX = i == 0 ? 0 : 2;
                int newY = 0;
                foreach (Label label in diagonals[i])
                {
                    if (label.Text == X)
                        possible2 = false;
                    else if (label.Text == O)
                        OsInDia++;
                    else if (label.Text == "")
                    {
                        posX = newX;
                        posY = newY;
                    }
                    if (i == 0)
                        newX++;
                    else
                        newX--;
                    newY++;
                }
                if (OsInDia == NumToLookFor && possible2)
                {
                    return new int[] { posX, posY };
                }
            }
            return new int[] { -1, -1 };
        }

        private bool CheckBoardPos(int[] x)
        {
            return CheckBoardPos(x[0], x[1]);
        }
        private bool CheckBoardPos(int x, int y)
        {
            return Board[x][y].Text == "";
        }

        private void PlaceOnBoard(int[] x)
        {
            PlaceOnBoard(x[0], x[1]);
        }
        private void PlaceOnBoard(int x, int y)
        {
            Random rand = new Random();
            Wait(rand.Next(1000, 2000));
            Console.WriteLine($"Doing a selection {x}, {y}");
            SetBoard("O", x, y);
            SetLabel();
        }
        
        private void SetBoard(string text, int x, int y)
        {
            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (Board[x][y].InvokeRequired)
            {
                SetTextCallback d = new SetTextCallback(SetBoard);
                Board[x][y].Invoke(d, new object[] { text, x, y });
            }
            else
            {
                Board[x][y].Text = text;
            }
        }
        private void SetLabel()
        {
            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (ThinkLabel.InvokeRequired)
            {
                SetVisCallback d = new SetVisCallback(SetLabel);
                ThinkLabel.Invoke(d, new object[] {});
            }
            else
            {
                ThinkLabel.Visible = false;
            }
        }

        public static void Wait(object ms)
        {
            var timeout = DateTime.Now.AddMilliseconds(Convert.ToDouble(ms));
            while (true)
            {
                if (DateTime.Now > timeout)
                {
                    break;
                }
            }
        }

    }
}

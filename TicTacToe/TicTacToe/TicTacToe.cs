using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace TicTacToe
{
    public partial class TicTacToe : Form
    {
        delegate void SetTextCallback(string text, Label l);
        delegate void SetVisCallback(bool vis, Control c);

        Label[][] board;
        Label[][] diagonals;

        bool win = false;

        AI Albert;
        bool singlePlayer = false;
        bool playerTurn = true;
        bool playerGoesFirst = true;

        int playerScore = 0;
        int compScore = 0;

        string[] players = { "X", "O" };


        public TicTacToe()
        {
            InitializeComponent();
            
            diagonals = new Label[][] { new Label[] { label1, label5, label9 },
                                        new Label[] { label3, label5, label7 } };
            board = new Label[][] { new Label[] { label1, label2, label3 },
                                    new Label[] { label4, label5, label6 },
                                    new Label[] { label7, label8, label9 } };
            ThinkLabel();
        }

        private void label1_Click(object sender, EventArgs e)
        {
            PlayerPlay(0, 0);
        }

        private void label2_Click(object sender, EventArgs e)
        {
            PlayerPlay(0, 1);
        }

        private void label3_Click(object sender, EventArgs e)
        {
            PlayerPlay(0, 2);
        }

        private void label4_Click(object sender, EventArgs e)
        {
            PlayerPlay(1, 0);
        }

        private void label5_Click(object sender, EventArgs e)
        {
            PlayerPlay(1, 1);
        }

        private void label6_Click(object sender, EventArgs e)
        {
            PlayerPlay(1, 2);
        }

        private void label7_Click(object sender, EventArgs e)
        {
            PlayerPlay(2, 0);
        }

        private void label8_Click(object sender, EventArgs e)
        {
            PlayerPlay(2, 1);
        }

        private void label9_Click(object sender, EventArgs e)
        {
            PlayerPlay(2, 2);
        }

        private void PlayerPlay(int x, int y)
        {
            if (!win && board[x][y].Text == "")
            {
                if (singlePlayer && playerTurn && Albert.done)
                {
                    board[x][y].Text = players[0];
                    playerTurn = false;
                    CheckWin();
                    if (!win)
                    {
                        AISetup();
                    }
                }
                else if (!singlePlayer)
                {
                    board[x][y].Text = players[playerTurn ? 0 : 1];
                    playerTurn = !playerTurn;
                }
                CheckWin();
            }
        }
        System.Threading.Timer timer;
        private void ThinkLabel()
        {
            TimeSpan startTimeSpan = TimeSpan.Zero;
            TimeSpan periodTimeSpan = TimeSpan.FromMilliseconds(500);

            timer = new System.Threading.Timer((e) =>
            {
                SetText(AIThinkLabel.Text.Contains("...") ? "." : AIThinkLabel.Text + ".", AIThinkLabel);
            }, null, startTimeSpan, periodTimeSpan);
            
        }
        private void SetText(string text, Label l)
        {
            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (l.InvokeRequired)
            {
                //NEW METHOD FOR AITHINKLABEL
                SetTextCallback d = new SetTextCallback(SetText);
                if ((!win && l == AIThinkLabel) || l != AIThinkLabel)
                    l.Invoke(d, new object[] {text, l});
            }
            else
            {
                l.Text = text;
            }
        }

        private void SetControlVisible(bool win, Control c)
        {
            // InvokeRequired required compares the thread ID of the
            // calling thread to the thread ID of the creating thread.
            // If these threads are different, it returns true.
            if (winnerLabel.InvokeRequired)
            {
                SetVisCallback d = new SetVisCallback(SetControlVisible);
                winnerLabel.Invoke(d, new object[] { win, c });
            }
            else
            {
                c.Visible = win;
            }
        }

        private void AISetup()
        {
            AIThinkLabel.Visible = true;
            Thread t = new Thread(new ThreadStart(AIPlay));
            t.Start();

        }
        private void AIPlay()
        {
            Albert.ThinkLabel = AIThinkLabel;
            Albert.Board = board;
            Albert.Choose();
            CheckWin();
            playerTurn = true;
        }

        private void CheckWin()
        {
            string prev = "null";
            bool same = true;

            string[] prev1 = new string[3] { "null", "null", "null" };
            bool[] same1 = new bool[3] { true, true, true };

            foreach (Label[] labels in board)
            {
                //Every row
                foreach (Label label in labels)
                {
                    if (prev == "null")
                        prev = label.Text;
                    else if (prev != label.Text || label.Text == "")
                        same = false;
                }

                if (same && prev != "null")
                {
                    Win(prev);
                    return;
                }
                same = true;
                prev = "null";

                //Columns
                for (int i = 0; i < 3; i++)
                {
                    if (prev1[i] == "null")
                        prev1[i] = labels[i].Text;
                    else if (prev1[i] != labels[i].Text || labels[i].Text == "")
                        same1[i] = false;
                }
            }

            for (int i = 0; i < 3; i++)
            {
                if (same1[i] && prev1[i] != "null")
                {
                    Win(prev1[i]);
                    return;
                }
            }

            for (int i = 0; i < 2; i++)
            {
                string prev2 = "null";
                bool same2 = true;
                foreach (Label label in diagonals[i])
                {
                    if (prev2 == "null")
                        prev2 = label.Text;
                    else if (prev2 != label.Text || label.Text == "")
                        same2 = false;
                }

                if (same2 && prev2 != "null")
                {
                    Win(prev2);
                    return;
                }
            }
            if (BoardFilled())
                Win("Tie");
        }

        private bool BoardFilled()
        {
            bool allFilled = true;
            foreach (Label[] labels in board)
            {
                foreach (Label l in labels)
                {
                    if (l.Text == "")
                    {
                        allFilled = false;
                    }
                }
            }
            return allFilled;
        }

        private void Win(string winner)
        {
            if (winner == "X" && !win)
            {
                playerScore++;
            }
            else if (winner == "O" && !win)
            {
                compScore++;
            }
            SetText("Winner: " + winner, winnerLabel);
            SetControlVisible(true, winnerLabel);
            SetControlVisible(true, acceptDifficulty);
            win = true;
            SetControlVisible(true, winsLabel);
            if (singlePlayer)
                SetText($"Player: {playerScore}\nAl: {compScore}", winsLabel);
            else
                SetText($"Player 1: {playerScore}\nPlayer 2: {compScore}", winsLabel);
        }

        private void singlePlayerButton_Click(object sender, EventArgs e)
        {
            difficultyBox.Visible = true;
            firstBox.Visible = true;
            singlePlayerButton.Visible = false;
            multiplayerButton.Visible = false;
            acceptDifficulty.Visible = true;
        }

        private void multiplayerButton_Click(object sender, EventArgs e)
        {
            foreach (Label[] labels in board)
            {
                foreach (Label label in labels)
                {
                    label.Visible = true;
                }
            }
            singlePlayerButton.Visible = false;
            multiplayerButton.Visible = false;
            winsLabel.Visible = true;
            winsLabel.Text = $"Player 1: {playerScore}\nPlayer 2: {compScore}";
            acceptDifficulty.Location = new Point(5, 71);
            acceptDifficulty.Text = "Play Again";
        }

        private void acceptDifficulty_Click(object sender, EventArgs e)
        {
            if (!win)
            {
                difficultyBox.Visible = false;
                firstBox.Visible = false;

                int difficulty = -1;
                if (easyRadio.Checked)
                {
                    difficulty = 0;
                }
                else if (mediumRadio.Checked)
                {
                    difficulty = 1;
                }
                else if (hardRadio.Checked)
                {
                    difficulty = 2;
                }

                if (playerFirstRadio.Checked)
                {
                    playerGoesFirst = true;
                }
                else
                {
                    playerGoesFirst = false;
                    AISetup();
                }
                Albert = new AI(difficulty);
                singlePlayer = true;
                winsLabel.Visible = true;
                acceptDifficulty.Location = new Point(5, 71);
                acceptDifficulty.Text = "Play Again";
                
                winsLabel.Text = $"Player: {playerScore}\nAl: {compScore}";
            }
            else
            {
                win = false;
                winnerLabel.Visible = false;
                if(playerGoesFirst)
                    playerTurn = true;
                else
                {
                    playerTurn = false;
                    AISetup();
                }
            }
            acceptDifficulty.Visible = false;
            
            foreach (Label[] labels in board)
            {
                foreach (Label label in labels)
                {
                    label.Visible = true;
                    label.Text = "";
                }
            }
            
        }

        private void ExitButton_Click(object sender, EventArgs e)
        {
            timer.Dispose();
            Close();
        }
    }
}

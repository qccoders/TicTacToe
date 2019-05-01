extern crate rand;
use rand::seq::SliceRandom;

use std::io::stdin;

const EMPTY_BOARD: [[char; 3]; 3] = [[' ', ' ', ' '], [' ', ' ', ' '], [' ', ' ', ' ']];

struct Program {
    pub board: [[char; 3]; 3],
}

impl Program {
    pub fn main(&mut self) {
        loop {
            println!("Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.");
            self.board = EMPTY_BOARD;

            loop {
                println!("\nHere's the current board:\n");
                self.print_board();
                println!("\nEnter your choice in the format 'x,y' (zero based, left to right, top to bottom):");

                let mut input = String::new();
                match stdin().read_line(&mut input) {
                    Ok(_) => {},
                    Err(_) => continue
                }

                let nums: Vec<&str> = input.split(',').collect();
                if nums.len() != 2 {
                    println!("\nInvalid input!  Try again.");
                    continue;
                }

                let x: usize = match nums[0].trim().parse() {
                    Ok(n @ 0 ..= 2) => n,
                    _ => { println!("\nInvalid input!  Try again."); continue }
                };

                let y: usize = match nums[1].trim().parse() {
                    Ok(n @ 0 ..= 2) => n,
                    _ => { println!("\nInvalid input!  Try again."); continue }
                };

                if self.board[y][x] != ' ' {
                    println!("\nThat cell is already selected.");
                    continue;
                }

                self.board[y][x] = 'X';
                if self.get_winner().is_some() {
                    break;
                }

                println!("\nComputer is taking its turn...");

                self.do_computers_turn();
                if self.get_winner().is_some() {
                    break;
                }
            }

            let message = match self.get_winner().unwrap() {
                'X' => "You're the winner!",
                'O' => "The computer is the winner!",
                _ => "The game was a draw!"
            };

            println!("\n{}", message);

            println!("Here's the final board:\n");
            self.print_board();

            println!("\nPress Enter to play again or x + Enter to exit.");

            let mut input = String::new();
            match stdin().read_line(&mut input) {
                Ok(_) => {},
                Err(_) => break
            }

            if !input.trim().is_empty() {
                break;
            }
        }
    }

    fn do_computers_turn(&mut self) {
        let available_cells = self.get_available_cells();
        let random_cell = available_cells.choose(&mut rand::thread_rng()).unwrap();
        self.board[random_cell.1][random_cell.0] = 'O';
    }

    fn get_available_cells(&self) -> Vec<(usize, usize)> {
        let mut available_cells = vec![];

        for i in 0 ..= 2 {
            for j in 0 ..= 2 {
                if self.board[j][i] == ' ' {
                    available_cells.push((i, j));
                }
            }
        }

        available_cells
    }

    fn get_winner(&self) -> Option<char> {
        let combos: [[[usize; 2]; 3]; 8] = [
            [[0, 0], [0, 1], [0, 2]],
            [[1, 0], [1, 1], [1, 2]],
            [[2, 0], [2, 1], [2, 2]],
            [[0, 0], [1, 0], [2, 0]],
            [[0, 1], [1, 1], [2, 1]],
            [[0, 2], [1, 2], [2, 2]],
            [[0, 0], [1, 1], [2, 2]],
            [[2, 0], [1, 1], [0, 2]]
        ];

        for c in combos.iter() {
            let mut combo: [char; 3] = [' ', ' ', ' '];

            for i in 0 ..= 2 {
                combo[i] = self.board[c[i][1]][c[i][0]];
            }

            if combo[0] != ' ' && combo[0] == combo[1] && combo[1] == combo[2] {
                return Some(combo[0]);
            }
        }

        if self.get_available_cells().is_empty() { Some('Z') } else { None }
    }

    fn print_board(&self) {
        for i in 0 ..= 2 {
            for j in 0 ..= 2 {
                print!("{}{}", self.board[i][j], if j < 2 { '|' } else { '\n' } );
            }

            if i < 2 {
                println!("-+-+-");
            }
        }
    }
}

fn main() {
    let mut p = Program { board: EMPTY_BOARD };
    p.main()
}

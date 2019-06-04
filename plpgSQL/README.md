# TicTacToe in plpgsql

## Steps to run it
1. install and configure Postgresql
2. create database objects in tictactoe.sql
3. start a new game:

    `call new_game()`

4. take turns until the game is over:

    `call take_turn(0,2)`
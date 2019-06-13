       IDENTIFICATION DIVISION.
       PROGRAM-ID. TICTACTOE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * Tic-Tac-Toe game board; COLUMN and CELL are keywords, so shorten
           01 BOARD.
               05 COLUM OCCURS 3 TIMES.
                   10 CEL PIC X OCCURS 3 TIMES.

      * User coordinate input
           01 COORD-INPUT PIC XXX.

      * Parsed coordinates
           01 COORDINATES.
               05 X-COORD PIC 9.
               05 Y-COORD PIC 9.

      * Error flag for input validation
           01 INPUT-ERROR PIC 9.

      * Check whether the user input anything at the new game prompt
           01 CONTINUE-INPUT PIC X.

      * The winner, if any
      * Call 'GET-WINNER' whenever the board changes to update.
           01 WINNER PIC X.

      * Current date; used for RNG seeding
           01 CURRENT-DATE-DATA.
               05 FILLER PIC 9(14).
               05 CURRENT-MILLISECONDS PIC 99.

           01 A-DARK-DAY-FOR-HUMANITY PIC 9(16).
       PROCEDURE DIVISION.
           MOVE FUNCTION WHEN-COMPILED TO A-DARK-DAY-FOR-HUMANITY.

      * Seed RNG. MOVE " " TO WINNER is effectively a no-op.
           MOVE FUNCTION CURRENT-DATE TO CURRENT-DATE-DATA.
           IF FUNCTION RANDOM(CURRENT-MILLISECONDS) = 0
               MOVE " " TO WINNER
           END-IF.
           PERFORM MAIN.
           GOBACK.

           PRINT-BOARD.
           PERFORM VARYING Y-COORD FROM 1 BY 1 UNTIL Y-COORD > 3
               PERFORM VARYING X-COORD FROM 1 BY 1 UNTIL X-COORD > 3
                   DISPLAY CEL(Y-COORD, X-COORD) WITH NO ADVANCING
                   IF X-COORD < 3
                       DISPLAY "|" WITH NO ADVANCING
                   ELSE
                       DISPLAY " "
                   END-IF
               END-PERFORM

               IF Y-COORD < 3
                   DISPLAY "-+-+-"
               END-IF
           END-PERFORM.

           INIT-BOARD.
           MOVE " " TO WINNER
           MOVE SPACES TO BOARD.
        
           MAIN.
           PERFORM WITH TEST AFTER UNTIL CONTINUE-INPUT IS NOT = " "
               DISPLAY "Welcome to QC Coders' Tic Tac Toe! You're 'X' an
      -        "d you'll go first."
               PERFORM INIT-BOARD
               PERFORM WITH TEST AFTER UNTIL WINNER IS NOT = " "
                   DISPLAY " "
                   DISPLAY "Here's the current board:"
                   DISPLAY " "
                   PERFORM PRINT-BOARD
                   DISPLAY " "
                   DISPLAY "Enter your choice in the format 'x,y' (zero 
      -            "based, left to right, top to bottom): "
                   DISPLAY " "

                   ACCEPT COORD-INPUT FROM CONSOLE

                   MOVE 0 TO INPUT-ERROR
                   
                   IF COORD-INPUT(2:1) IS NOT = ","
                       MOVE 1 TO INPUT-ERROR
                   END-IF

                   IF COORD-INPUT(1:1) IS ALPHABETIC
                       MOVE 1 TO INPUT-ERROR
                   ELSE
                       MOVE COORD-INPUT(1:1) TO X-COORD
                   END-IF

                   IF COORD-INPUT(3:1) IS ALPHABETIC
                       MOVE 1 TO INPUT-ERROR
                   ELSE
                       MOVE COORD-INPUT(3:1) TO Y-COORD
                   END-IF

                   IF X-COORD > 2 OR Y-COORD > 2
                       MOVE 1 TO INPUT-ERROR
                   ELSE
                       COMPUTE X-COORD = X-COORD + 1
                       COMPUTE Y-COORD = Y-COORD + 1
                   END-IF

                   IF INPUT-ERROR = 1
                       DISPLAY "Invalid input! Try again."
                   ELSE IF CEL(Y-COORD, X-COORD) IS NOT = " "
                       DISPLAY "That cell is already selected."
                   ELSE
                       MOVE "X" TO CEL(Y-COORD, X-COORD)
                       CALL 'GET-WINNER' USING BOARD, WINNER
                       IF WINNER = " "
                           DISPLAY " "
                           DISPLAY "Computer is taking its turn..."
                           CALL 'DO-COMPUTERS-TURN' USING BOARD
                           CALL 'GET-WINNER' USING BOARD, WINNER
                       END-IF
                   END-IF

                   END-PERFORM
               DISPLAY " "
               IF WINNER = "Z"
                   DISPLAY "The game was a draw!"
               ELSE IF WINNER = "X"
                   DISPLAY "You're the winner!"
               ELSE
                   DISPLAY "The computer is the winner!"
               END-IF   
               DISPLAY "Here's the final board:"
               DISPLAY " " 
               PERFORM PRINT-BOARD
               DISPLAY " "
               DISPLAY " "
               DISPLAY "Press Enter to play again or x + Enter to exit."
               ACCEPT CONTINUE-INPUT FROM CONSOLE
           END-PERFORM.

       END PROGRAM TICTACTOE.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. GET-WINNER.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * Combos are encoded as X1, Y1, X2, Y2, X3, Y3 (6 digits each)
      * COBOL indices are one-based; compensate for that here 
       01 COMBOS VALUE "111213212223313233112131122232132333112233312213
      -    "".
           05 COMBO OCCURS 8 TIMES INDEXED BY CBIDX.
               10 CELL-COORDS OCCURS 3 TIMES INDEXED BY CLIDX.
                   15 X-COORD PIC 9.
                   15 Y-COORD PIC 9.
      * We don't need to access individual available cells, just confirm
      * that one exists after calling 'GET-AVAILABLE-CELLS'
       01 AVAILABLE-CELLS PIC 9(18) VALUE 0.

      * Look at the cells corresponding to a given combo
       01 THIS-COMBO.
           05 COMBO-ENTRY PIC X OCCURS 3 TIMES.
       LINKAGE SECTION.
       01 BOARD.
            05 COLUM OCCURS 3 TIMES.
                10 CEL PIC X OCCURS 3 TIMES.
       01 WINNER PIC X.
       PROCEDURE DIVISION USING BOARD, WINNER.
           PERFORM CHECK-COMBO VARYING CBIDX FROM 1 BY 1 UNTIL CBIDX = 9
           CALL 'GET-AVAILABLE-CELLS' USING BOARD, AVAILABLE-CELLS.
           IF AVAILABLE-CELLS = 0
               MOVE "Z" TO WINNER
           ELSE
               MOVE " " TO WINNER
           END-IF
           GOBACK.

           CHECK-COMBO.
               PERFORM VARYING CLIDX FROM 1 BY 1 UNTIL CLIDX = 4
                   MOVE CEL(Y-COORD(CBIDX, CLIDX), X-COORD(CBIDX, CLIDX)
      -            ) TO COMBO-ENTRY(CLIDX)
               END-PERFORM
               IF COMBO-ENTRY(1) IS NOT = " " AND COMBO-ENTRY(1) = COMBO
      -        -ENTRY(2) AND COMBO-ENTRY(2) = COMBO-ENTRY(3)
                   MOVE COMBO-ENTRY(1) TO WINNER
                   GOBACK
               END-IF.
       END PROGRAM GET-WINNER.
       
       IDENTIFICATION DIVISION.
       PROGRAM-ID. GET-AVAILABLE-CELLS.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * Cell indices
           01 X-COORD PIC 9.
           01 Y-COORD PIC 9.
       LOCAL-STORAGE SECTION.
           01 AVIDX PIC 9 VALUE 1.
       LINKAGE SECTION.
           01 BOARD.
               05 COLUM OCCURS 3 TIMES.
                   10 CEL PIC X OCCURS 3 TIMES.
           01 AVAILABLE-CELLS.
               05 AVAILABLE-CELL OCCURS 9 TIMES.
                   10 AVAILABLE-X PIC 9.
                   10 AVAILABLE-Y PIC 9.
       PROCEDURE DIVISION USING BOARD, AVAILABLE-CELLS.
           PERFORM VARYING Y-COORD FROM 1 BY 1 UNTIL Y-COORD = 4
               PERFORM VARYING X-COORD FROM 1 BY 1 UNTIL X-COORD = 4
                   IF CEL(Y-COORD, X-COORD) = " "
                       MOVE X-COORD TO AVAILABLE-X(AVIDX)
                       MOVE Y-COORD TO AVAILABLE-Y(AVIDX)
                       COMPUTE AVIDX = AVIDX + 1
                   END-IF
               END-PERFORM
           END-PERFORM
           GOBACK.
       END PROGRAM GET-AVAILABLE-CELLS.

       IDENTIFICATION DIVISION.
       PROGRAM-ID. DO-COMPUTERS-TURN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * The cell selected by the computer to play in
           01 SELECTED-CELL.
               05 SELECTED-X PIC 9.
               05 SELECTED-Y PIC 9.
      * Index used to count available cells
           01 AVIDX PIC 9.
      * Index of the selected cell
           01 SELIDX PIC 9.
      
       LOCAL-STORAGE SECTION.
      * List of available cells. Allocate enough memory to hold the maxi
      * mum number of available cells.
           01 AVAILABLE-CELLS VALUE ZEROES.
               05 AVAILABLE-CELL OCCURS 9 TIMES.
                   10 AVAILABLE-X PIC 9.
                   10 AVAILABLE-Y PIC 9.
      * The actual number of available cells.
           01 AVCOUNT PIC 9 VALUE 0.
       LINKAGE SECTION.
           01 BOARD.
               02 COLUM OCCURS 3 TIMES.
                   03 CEL PIC X OCCURS 3 TIMES.
       PROCEDURE DIVISION USING BOARD.
           CALL 'GET-AVAILABLE-CELLS' USING BOARD, AVAILABLE-CELLS.
           PERFORM COUNT-AVAILABLE-CELLS.
           COMPUTE SELIDX = FUNCTION RANDOM * AVCOUNT + 1.
           MOVE AVAILABLE-X(SELIDX) TO SELECTED-X.
           MOVE AVAILABLE-Y(SELIDX) TO SELECTED-Y.
           MOVE "O" TO CEL(SELECTED-Y, SELECTED-X).
           GOBACK.

           COUNT-AVAILABLE-CELLS.
               PERFORM WITH TEST AFTER VARYING AVIDX 
               FROM 1 BY 1 UNTIL AVIDX = 9
                   IF AVAILABLE-X(AVIDX) > 0
                       COMPUTE AVCOUNT = AVCOUNT + 1
                   END-IF
               END-PERFORM.
       END PROGRAM DO-COMPUTERS-TURN.
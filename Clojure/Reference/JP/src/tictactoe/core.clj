(ns tictactoe.core
  (:gen-class))

(def board nil)

(defn initboard []
  (def board 
    (vector 
      (vector \  \  \ )
      (vector \  \X \ )
      (vector \  \  \ ))))

(defn getWinner []
  (def combos 
    (vector
      (vector (vector 0 0) (vector 0 1) (vector 0 2))
      (vector (vector 1 0) (vector 1 1) (vector 1 2))
      (vector (vector 2 0) (vector 2 1) (vector 2 2))
      (vector (vector 0 0) (vector 1 0) (vector 2 0))
      (vector (vector 0 1) (vector 1 1) (vector 2 1))
      (vector (vector 0 2) (vector 1 2) (vector 2 2))
      (vector (vector 0 0) (vector 1 1) (vector 2 2))
      (vector (vector 2 0) (vector 1 1) (vector 0 2))))

(defn doComputersTurn [] nil)

(defn printboard []
  (doseq [[i row] (map-indexed vector board)] 
    (doseq [[i cell] (map-indexed vector row)]
      (print cell)
      (print (if (< i 2) "|" "")))

    (if (< i 2) (println "\n-+-+-"))))

(defn -main [& args]
  (loop []
    (println "Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.")
    (initboard)

    (loop []
      (loop []
        (loop []
          (println "\nHere's the current board:\n")
          (printboard)

          (println "\n\nEnter your choice in the format 'x,y' (zero based, left to right, top to bottom):")
          (def input (read-line))
          (def coords (clojure.string/split input #","))

          (def x (clojure.edn/read-string (get coords 0)))
          (def y (clojure.edn/read-string (get coords 1)))

          (when 
            (or 
              (< x 0) (> x 2) (< y 0) (> y 2)) 
                (println "Invalid input!  Try again.")
                (recur)))

        (when (not= (get-in board [y x]) \ )
          (println "That cell is already selected.")
          (recur)))

      (def board (assoc-in board [y x] \X))

      (when (= (getWinner) nil)
        (doComputersTurn)
        (when (= (getWinner) nil)
          (recur))))

    (when (= (getWinner) \X)
      (println "You're the winner!"))
    (when (= (getWinner) \O)
      (println "The computer is the winner!"))
    (when (= (getWinner) \Z)
      (println "The game was a draw!"))

    (println "Here's the final board:") 
    (printboard)

    (println "\nPress Enter to play again or x + Enter to exit.")
    (def input (read-line))
    (if (= "" input)
      (recur)
      (System/exit 0)))
)


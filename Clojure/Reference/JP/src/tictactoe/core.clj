(ns tictactoe.core
  (:gen-class))

(def board nil)

(defn initboard []
  (def board 
    (vector 
      (vector \  \  \ )
      (vector \  \  \ )
      (vector \  \  \ ))))

(defn getAvailableCells []
  (def availableCells nil)
  (loop [i 0]
    (loop [j 0]
      (when (= \  (get-in board [j i]))
        (def availableCells (conj availableCells [i j])))
      (when (< j 2) 
        (recur (inc j))))
    (when (< i 2) 
      (recur (inc i))))

    availableCells)

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
    
  (def winner nil)

  (loop [i 0]
    (def combo (vector \ \ \ ))
    (loop [j 0]
      (def combo 
        (assoc-in combo [j] 
          (get-in board [(get-in combos [i j 1]) (get-in combos [i j 0])])))
      (when (< j 2)
        (recur (inc j))))

      (when (not= \ (get-in combo [0]))
        (when (and (= (get-in combo [0]) (get-in combo [1])) (= (get-in combo [1]) (get-in combo [2])))
          (def winner (get-in combo [0]))))

    (when (< i 7)
      (recur (inc i))))

  (if (not= nil winner) winner     
    (if (= nil (getAvailableCells)) \Z nil)))

(defn doComputersTurn [] 
  (def randomCell (rand-nth (getAvailableCells)))
  (def board 
    (assoc-in board [(get-in randomCell [1]) (get-in randomCell [0])] \O)))

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
        (println "\nComputer is taking its turn...")
        (doComputersTurn)
        (when (= (getWinner) nil)
          (recur))))

    (when (= (getWinner) \X)
      (println "\nYou're the winner!"))
    (when (= (getWinner) \O)
      (println "\nThe computer is the winner!"))
    (when (= (getWinner) \Z)
      (println "\nThe game was a draw!"))

    (println "Here's the final board:\n") 
    (printboard)

    (println "\n\nPress Enter to play again or x + Enter to exit.")
    (def input (read-line))
    (if (= "" input)
      (recur)
      (System/exit 0))))
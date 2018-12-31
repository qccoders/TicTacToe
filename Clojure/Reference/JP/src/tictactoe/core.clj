(ns tictactoe.core
  (:gen-class))

(def board nil)

(defn initboard []
  (def board 
    (vector 
      (vector \  \  \ )
      (vector \  \  \ )
      (vector \  \  \ ))))

(defn printboard []
  (doseq [[i row] (map-indexed vector board)] 
    (doseq [[i cell] (map-indexed vector row)]
      (print cell)
      (print (if (< i 2) "|" "")))

    (if (< i 2) (println "\n-+-+-"))))

(defn -main [& args]
  (println "Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.")
  (initboard)
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
        (System/exit 0))

  (println "Your input looks valid so far..."))


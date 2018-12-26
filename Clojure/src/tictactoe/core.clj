(ns tictactoe.core
  (:gen-class))

(def board nil)

(defn initboard []
  (def board 
    (vector 
      (vector \  \  \ )
      (vector \  \  \ )
      (vector \  \  \ ))))


(defn cell-printer [i cell]
  (print cell)
  (print (if (< i 2) "|" "")))


(defn row-printer [i row]
  (doall (map-indexed cell-printer row))
  (if (< i 2) (println "\n-+-+-")))


(defn printboard []
  (doall (map-indexed row-printer board)))


(defn go [& args]
  (println "Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.")
  (initboard)
  (println "\nHere's the current board:\n")
  (printboard)
  (println "\n\nEnter your choice in the format 'x,y' (zero based, left to right, top to bottom):"))

(defn -main [& args] (apply go args))

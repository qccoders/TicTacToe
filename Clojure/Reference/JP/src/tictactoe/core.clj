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
  (println "\n\nEnter your choice in the format 'x,y' (zero based, left to right, top to bottom):"))

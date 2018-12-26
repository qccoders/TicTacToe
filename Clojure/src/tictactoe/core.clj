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
  (println "-+-+-"))

(defn -main [& args]
  (println "Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.")
  (println "\nHere's the current board:\n")
  (printboard))

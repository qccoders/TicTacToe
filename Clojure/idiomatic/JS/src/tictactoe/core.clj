(ns tictactoe.core
  (:require [clojure.set :refer [subset?]])
  (:gen-class))

(def WINNERS #{[0 1 2]
              [3 4 5]
              [6 7 8]
              [0 3 6]
              [1 4 7]
              [2 5 8]
              [0 4 8]
              [2 4 6]})


(defn prompt [s]
  (println s)
  (read-line))


(defn new-board [] 
  (vec (take 9 (repeat \ ))))


(defn print-cell [i cell]
  (print cell)
  (when (< (mod i 3) 2)
    (print "|"))
  (when (or (= 2 i) (= 5 i))
     (println "\n-+-+-")))


(defn print-board 
  ([board] (print-board board nil))
  ([board state] 
    (println (str "\nHere's the " (if state "final" "current") " board:\n"))
    (doall (map-indexed print-cell @board))
    (println)))


(defn slots-with-value [board player]
  (->> (map-indexed vector @board)
    (filter #(= player (second %)))
    (map first)))


(defn to-index [[a b]]
  (if (and (< -1 a 3) (< -1 b 3))
    (+ (* a 3) b)
    -1))


(defn machine-turn [board]
  (swap! board assoc 
    (-> (slots-with-value board \ )
        (shuffle)
        (first)) \O))


(defn parse-coords [s]
  (->> (clojure.string/split s #",")
       (mapv #(Integer/parseInt %))
       (to-index)))


(defn handle-human-input [board s]
   (let [input (prompt s)
         as-index (parse-coords input)]
      (if (= -1 as-index)
        (recur board "Please enter valid coordinates")
        (if (= \ (get @board as-index))
          (swap! board assoc as-index \X)
          (recur board "This spot is already taken.  Please select another.")))))


(defn human-turn [board]
  (print-board board)
  (handle-human-input board "\n\nEnter your choice in the format 'x,y' (zero based, left to right, top to bottom):"))


(defn is-winner? [board player r]
  (when 
    (some #(subset? % (set (slots-with-value board player)))
            WINNERS)
    r))


(defn done-playing? [board]
  (or (is-winner? board \X "You're the winner!")
      (is-winner? board \O "The computer is the winner!")
      (when (empty? (slots-with-value board \ )) "The game was a draw!")))


(defn handle-game-over [board f]
  (if-let [done-playing (done-playing? board)]
    (do
      (println done-playing)
      (print-board board 1)
      (when (= "y" (prompt "Would you like to play again? (y/n)"))
        (reset! board (new-board))
        human-turn))
     f))


(defn play-game [board f]
  (when-let [next-player (handle-game-over board f)]
    (next-player board)
    (recur board 
           (if (= next-player human-turn) 
             machine-turn
             human-turn))))


(defn go []
  (println "Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.")
  (play-game (atom (new-board)) human-turn))


(defn -main [& args]
  (go))
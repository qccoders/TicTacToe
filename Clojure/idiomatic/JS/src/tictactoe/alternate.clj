(ns tictactoe.alternate	
   (:gen-class))	
 
  
  (defn init-board []	
   (vector 	
     (vector \  \  \ )	
     (vector \  \  \ )	
     (vector \  \ \ )))	
 
  
  (defn print-cell [i cell]	
   (print cell)	
   (print (if (< i 2) "|" "")))	
 
  (defn print-row [i row]	
 
    ;because print-cell has side effects, call doall 	
   ;to force evaluation of the structure returned by map-indexed  	
   (doall (map-indexed print-cell row)) 	
 
    ;changed this from if to *when* as there doesn't appear to be an else.  	
   ;the *if* form is only allowed two children (a then and an else) while 	
   ;when is allowed as many as you want	
   (when (< i 2) 	
     (println "\n-+-+-")))	
 
  (defn print-board [board]	
   (println "\nHere's the current board:\n")	
   (doall (map-indexed print-row board)))	
 
  
  (defn go []	
   (println "Welcome to QC Coders' Tic Tac Toe! You're 'X' and you'll go first.")	
 
    ; the -> is the "threading macro", which lets you rewrite:	
   ; (a (b (c (d (e f)))))	
   ; as:	
   ; (-> f	
     ; (e)	
     ; (d)	
     ; (c)	
     ; (b)	
     ; (a))	
 
    (-> (init-board)	
       (print-board))	
   (println "\n\nEnter your choice in the format 'x,y' (zero based, left to right, top to bottom):"))	
 
  (defn -main [& args]	
   (go))
(defconst width 40)
(defconst height 40)
(defvar grid (make-vector (* width height) 0))
(defvar grid_next (make-vector (* width height) 0))

(defmacro set_grid_at (y x value)
  `(aset grid (+ ,x (* ,y width)) ,value))

(defmacro get_grid_at (y x)
  `(aref grid (+ ,x (* ,y width))))

(defmacro set_grid_next_at (y x value)
  `(aset grid_next (+ ,x (* ,y width)) ,value))

(defmacro get_grid_next_at (y x)
  `(aref grid_next (+ ,x (* ,y width))))

(defun init_grid ()
  (set_grid_at 1 25 1)
  (set_grid_at 2 23 1)
  (set_grid_at 2 25 1)
  (set_grid_at 3 13 1)
  (set_grid_at 3 14 1)
  (set_grid_at 3 21 1)
  (set_grid_at 3 22 1)
  (set_grid_at 3 35 1)
  (set_grid_at 3 36 1)
  (set_grid_at 4 12 1)
  (set_grid_at 4 16 1)
  (set_grid_at 4 21 1)
  (set_grid_at 4 22 1)
  (set_grid_at 4 35 1)
  (set_grid_at 4 36 1)
  (set_grid_at 5 1 1)
  (set_grid_at 5 2 1)
  (set_grid_at 5 11 1)
  (set_grid_at 5 17 1)
  (set_grid_at 5 21 1)
  (set_grid_at 5 22 1)
  (set_grid_at 6 1 1)
  (set_grid_at 6 2 1)
  (set_grid_at 6 11 1)
  (set_grid_at 6 15 1)
  (set_grid_at 6 17 1)
  (set_grid_at 6 18 1)
  (set_grid_at 6 23 1)
  (set_grid_at 6 25 1)
  (set_grid_at 7 11 1)
  (set_grid_at 7 17 1)
  (set_grid_at 7 25 1)
  (set_grid_at 8 12 1)
  (set_grid_at 8 16 1)
  (set_grid_at 9 13 1)
  (set_grid_at 9 14 1)
  )

(defun print_grid(grid)
  "Display the grid"
  (let ((y 0))
    (while (< y height)
      (let ((x 0))
	(while (< x width)
	  (if (= (get_grid_at y x) 1)
	      (princ "o " standard-output)
	    (princ ". " standard-output))
	  (setq x (+ x 1))
	  ))
      (princ "\n" standard-output)
      (setq y (+ y 1))
      ))
  )

(defun my-mod (a b)
  (if (zerop b)
      (error "Division by zero is not allowed.")
    (let ((result (% a b)))
      (if (< result 0)
          (+ result b)
        result))))

(defun count_neighbors(y x)
  "Count neighbors of the grid cell at grid(y, x)."
  (let ((count 0))
    (let ((dy -1))
      (while (<= dy 1)
	(let ((dx -1))
	  (while (<= dx 1)
	    (setq iy (my-mod (+ y dy) height))
	    (setq ix (my-mod (+ x dx) width))
	    (if (= (get_grid_at iy ix) 1)
		(setq count (+ count 1)))
	    (setq dx (+ dx 1))))
	(setq dy (+ dy 1))))
    (if (= (get_grid_at y x) 1)
	(setq count (- count 1)))
    count))


(defun next_gen()
  "Compute the next generation."
  (let ((y 0))
    (while (< y height)
      (let ((x 0))
	(while (< x width)
	  (setq count (count_neighbors y x))
	  (if (not (= (get_grid_at y x) 1))
	      (if (= count 3)
		  (set_grid_next_at y x 1)))
	  (if (= (get_grid_at y x) 1)
	      (if (or (= count 2) (= count 3))
		  (set_grid_next_at y x 1)))
	  (setq x (+ x 1))
	  ))
      (setq y (+ y 1))
      ))
  (setq grid (copy-sequence grid_next))
  (setq grid_next (make-vector (* height width) 0))
  )

(defun main ()
  (init_grid)
  (while (= 1 1)
    (print_grid grid)
    (let ((counter 0))
      (while (< counter 3500000)
	(setq counter (+ counter 1))
	))
    (princ "\033[2J\033[0;0f" standard-output)
    (next_gen)
    ))

(main)

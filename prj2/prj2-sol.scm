;function to multiply two lists
(define unary-mul
(lambda (list1 list2)
(accumulate->multiply 'z list1 list2)
)
)

;recursive accumulator function to get multiplication of two lists 
(define accumulate->multiply
(lambda (acc list1 list2)
(if (equal? list2 'z)
acc
(accumulate->multiply (unary-add acc list1) list1 (cdr list2))
)
)
)

;recursive function to convert integer to its unary represengtation
(define int->unary
(lambda (n)
(if (<= n 0)
'z
(cons 's (int->unary(- n 1)))
)))

;recursive function to add two lists
(define unary-add
(lambda (list1 list2)
(if (equal? list1 'z)
list2
(cons (car list1) (unary-add(cdr list1) list2))
)))

;rescursive function to convert unary to its corresponding integer
(define unary->int
(lambda (list)
(if (equal? list 'z)
0
(+ 1 (unary->int(cdr list)))
)))

;Start of the function
;ls: list to be processed
(define list-tuples
(lambda (ls)
(if (not(list? ls))
(error ls)
(iterator ls null)
)))

;function to throw errors
(define error
(lambda (ls)
(display "not a list")
))

;Function gets ls, firstacc, restacc, count from the iterator function. These values gets updates as function proceeds
(define main
(lambda (ls firstacc restacc count)
(if (equal? ls null)
(values (reverse firstacc) (reverse restacc) count)
(let ((car-element (car ls)))
(if (not(equal? car-element null))
(main (cdr ls) (cons (car car-element) firstacc) (cons (cdr car-element) restacc) (+ 1 count))
(main (cdr ls) (cons car-element firstacc) (cons car-element restacc) count)
)))))

;Function calls main iteratively and gets values of firstacc restacc and count
(define iterator
(lambda (ls result)
(let-values (((firstacc restacc count) (main ls null null 0)))
(if (not(equal? count 0))
(iterator restacc (cons firstacc result))
(reverse result)
))))



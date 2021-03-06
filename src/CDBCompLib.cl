;***********************************************************************
; Copyright (C) 1989, G. E. Weddell.
;
; This file is part of RDM.
;
; RDM is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; RDM is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with RDM.  If not, see <http://www.gnu.org/licenses/>.
;
;***********************************************************************

(defun caadddr (L) (car (cadddr L)))
(defun cadadar (L) (car (cdadar L)))
(defun cadaddr (L) (car (cdaddr L)))
(defun caddadr (L) (car (cddadr L)))
(defun cadddar (L) (car (cdddar L)))
(defun caddddr (L) (car (cddddr L)))
(defun cddadar (L) (cdr (cdadar L)))
(defun cdddddr (L) (cdr (cddddr L)))
(defun caaddadr (L) (caar (cddadr L)))
(defun caaddddr (L) (caar (cddddr L)))
(defun cadadadr (L) (cadr (cadadr L)))
(defun cadaddar (L) (cadr (caddar L)))
(defun cadadddr (L) (cadr (cadddr L)))
(defun cadddadr (L) (cadr (cddadr L)))
(defun caddddar (L) (cadr (cdddar L)))
(defun cadddddr (L) (cadr (cddddr L)))
(defun cddddddr (L) (cddr (cddddr L)))
(defun caaddddar (L) (caadr (cdddar L)))
(defun cadadaddr (L) (cadar (cdaddr L)))
(defun cadaddadr (L) (cadar (cddadr L)))
(defun cadadddar (L) (cadar (cdddar L)))
(defun caddadadr (L) (caddr (cadadr L)))
(defun caddaddar (L) (caddr (caddar L)))
(defun cadddddar (L) (caddr (cdddar L)))
(defun caddddddr (L) (caddr (cddddr L)))
(defun cdadddadr (L) (cdadr (cddadr L)))
(defun cdddddddr (L) (cdddr (cddddr L)))
(defun cadaddadar (L) (cadadr (cdadar L)))
(defun cadadddadr (L) (cadadr (cddadr L)))
(defun cadaddddar (L) (cadadr (cdddar L)))
(defun caddadaddr (L) (caddar (cdaddr L)))
(defun caddaddadr (L) (caddar (cddadr L)))
(defun caddadddar (L) (caddar (cdddar L)))
(defun caddddddar (L) (cadddr (cdddar L)))
(defun cadadaddadr (L) (car (cdadar (cddadr L))))
(defun cadadaddddr (L) (car (cdadar (cddddr L))))
(defun cadadddddar (L) (car (cdaddr (cdddar L))))
(defun caddadddadr (L) (car (cddadr (cddadr L))))
(defun caddaddddar (L) (car (cddadr (cdddar L))))
(defun cadddaddddr (L) (car (cdddar (cddddr L))))
(defun caadaddddadr (L) (caar (cdaddr (cddadr L))))
(defun cadaddaddddr (L) (cadr (caddar (cddddr L))))
(defun cadadddddadr (L) (cadr (cadddr (cddadr L))))
(defun cadaddddddar (L) (cadr (cadddr (cdddar L))))
(defun cadaddaddddar (L) (cadar (cddadr (cdddar L))))
(defun cadaddddddadr (L) (cadar (cddddr (cddadr L))))

(defun append1 (L e) (append L (list e)))
(defun add1 (&rest args) (apply #'1+ args))
(defun concat (&rest args)
   (read-from-string (concatenate 'string "|" (apply #'concatenate (cons 'string (mapcar #'symbol-name args))) "|")))

(defun RestoreList (L)
  (prog ()
        (if (null L) (return nil))
        (if (atom L) (return (list L)))
        (if (equal (car L) 'Id) (return (cdr L)))
        (return (append (RestoreList (cadr L)) (RestoreList (caddr L))))))


(defun RestoreArgExpList (L)
  (prog ()
        (if (null L) (return nil))
        (if (equal (car L) 'ArgExpList) (return (append1 (RestoreArgExpList (cadr L)) (caddr L))))
        (return (list L))))


(defun RestoreIdList (L)
  (prog ()
        (if (null L) (return nil))
        (if (equal (car L) 'IdList) (return (append1 (RestoreIdList (cadr L)) (caddr L))))
        (return (list L))))


(defun FixInput (PDMcode) 
  (prog (F S) 
        (setq F PDMcode S nil) 
        loop 
        (if (null F) (return (car S))) 
        (case (car F) 
               (0 (rplaca S (list (car S)))) 
               (1 (rplaca S (list (car S) (cadr S))) (rplacd S (cddr S))) 
               (2 (rplaca S (list (car S) (caddr S) (cadr S))) (rplacd S (cdddr S))) 
               (3 (rplaca S (list (car S) (cadddr S) (caddr S) (cadr S))) (rplacd S (cddddr S))) 
               (4 (rplaca S (list (car S) (caddddr S) (cadddr S) (caddr S) (cadr S))) (rplacd S (cdddddr S))) 
               (5 (rplaca S (list (car S) (cadddddr S) (caddddr S) (cadddr S) (caddr S) (cadr S))) (rplacd S (cddddddr S))) 
               (6 (rplaca S (list (car S) (caddddddr S) (cadddddr S) (caddddr S) (cadddr S) (caddr S) (cadr S))) 
                  (rplacd S (cdddddddr S))) 
               (**error** (quit))
               (t (setq S (cons (car F) S)))) 
        (setq F (cdr F)) 
        (go loop))) 


(defun PrintMsg (Message)
  (princ Message *error-output*)
  (terpri *error-output*))


(defun ErrorMsg (L)
  (prog ()
        (do ((Temp L (cdr Temp))) ((null Temp))
            (princ (car Temp) *error-output*)
            (princ " " *error-output*))
        (terpri *error-output*)
        (quit)))


(defun CMatch (Pat L)
  (cond ((null (Match Pat L)) 
         (PrintMsg "*****warning: from Pattern matcher")
         (princ Pat *error-output*))))


(defun GenerateName (Name)
  (prog ()
        (cond ((equal Name 'SchemaVar)
               (setq @SchemaVar (add1 @SchemaVar))
               (return (concat '|CDBCSchemaVar| (make-symbol (write-to-string @SchemaVar))))))))


(defun GenStructDeclCode (Name1 Name2 Name3)
  (prog (Temp)
        (if (atom Name1) 
            (setq Name1 (list 'Id Name1)))
        (if (not (Match `(* (Type ,Name2 >* P) *) InfoList))
            (ErrorMsg  `("***CDB Error: prop" ,Name2 "has not been defined.")))
        (cond ((equal (car (Build '(<< P))) 'Integer)
               (setq Temp (list Name3 '(IntType) Name1)))
              ((equal (car (Build '(<< P))) 'Real)
               (setq Temp (list Name3 '(LongType) Name1)))
              ((equal (car (Build '(<< P))) 'DoubleReal)
               (setq Temp (list Name3 '(DoubleType) Name1)))
              ((equal (car (Build '(<< P))) 'String)
               (setq Temp `(,Name3 (CharType) (ArrayVarWSize ,Name1 (Const ,(caddadadr (Build '(<< P))))))))
              (t
               (CMatch `(* (Reference ,(car (Build '(<< P))) > Q) *) InfoList)
               (cond ((equal '(Direct) (Build '(< Q)))
                      (setq Temp `(,Name3 (StructWId (Id ,(car (Build '(<< P))))) (PtrVar (Ptr) ,Name1))))
                     (t
                      (setq Temp `(,Name3 (StructWId (Id ,(car (Build '(<< P))))) (PtrVar (PtrPtr (Ptr)) ,Name1)))))))
        (return Temp)))

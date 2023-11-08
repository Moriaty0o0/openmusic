;=========================================================================
;  OpenMusic: Visual Programming Language for Music Composition
;
;  Copyright (c) 1997-... IRCAM-Centre Georges Pompidou, Paris, France.
; 
;    This file is part of the OpenMusic environment sources
;
;    OpenMusic is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 3 of the License, or
;    (at your option) any later version.
;
;    OpenMusic is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with OpenMusic.  If not, see <http://www.gnu.org/licenses/>.
;
;=========================================================================
;;; Music package 
;;; authors G. Assayag, C. Agon, J. Bresson, K. Haddad
;=========================================================================

(in-package :om)


;; various general methods applicable to all or most analysis classes:

(defun format-alternative-list (prep alternatives)
  (let ((format-string (concatenate 'string "~#[ nil~; ~S~; ~S ~A"
				    (format nil "~A" prep)
				    "~:;~@{~#[~; "
				    (format nil "~A" prep)
				    "~] ~S~^,~}~]")))
    (apply #'format nil format-string alternatives)))

;; (format-alternative-list "and" (loop for i from 0 below 4 collect i))
;; (format-alternative-list "or" (loop for i from 0 below 4 collect i))

(defmethod! get-segment-begins ((self chord-seq) &optional (n 0) (add-initial-zero? nil))
  :indoc '("chord-seq" "nth analysis")
  :doc "returns a list of offsets (ms.) for segments in analysis 'n'"
  :icon 143
  (let* ((all-analyses (analysis self))
	 (n-analyses (length all-analyses))
	 (nth-an (or n 0)))
    (if (>= nth-an n-analyses)
	(om-beep-msg (concatenate 'string (format nil "Error: ~A analyses found in ~A, n must be" n-analyses self)
				  (format-alternative-list "or" (loop for i from 0 below n-analyses collect i))))
	(let ((offsets (mapcar #'tb (analysis-segments (nth nth-an all-analyses)))))
	  (if (and (> (car offsets) 0) add-initial-zero?)
	      (cons 0 offsets)
	      offsets)))))


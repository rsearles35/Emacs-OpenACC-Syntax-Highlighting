;;; OpenACC syntax highlighting

;;;; 
;;;; Enable Highlighing of OpenACC and OpenMP directives in Fortan 
;;;; 
(when (require 'font-lock nil 'noerror ) 

  (defface openacc-command-face 
    '((t
       :foreground "#00ff00" 
       ;; :background "yellow" 
       ;; :bold       t 
       )) 
    "Face for #pragma acc comments" 
    ) 

    (defface openacc-modifier-face 
    '((t
       :foreground "#e91a23" 
       ;; :background "yellow" 
       ;; :bold       t 
       )) 
    "Face for OpenACC data clauses/constructs and update directives" 
    ) 

  (defvar openacc-command-face 'openacc-command-face)
  (defvar openacc-modifier-face 'openacc-modifier-face) 

  ;; Regex describing all known OpenACC directive names 
  (defvar acc-commands-regex  
    ;; Use regexp-opt to build the regex and replace-regexp-in-string 
    ;; to allow any sequence of blank characters as separator 
    (replace-regexp-in-string " " "[ \t]+"    
                              (regexp-opt '( "cache" 
                                             "data"      
                                             "declare"        
                                             "host_data" 
                                             "init" 
                                             "kernels"     ;; will also catch "kernels loop"  
                                             "loop" 
                                             "parallel"    ;; will also catch "parallel loop" 
                                             "routine" 
                                             "set" 
                                             "shutdown" 
                                             "update" 
                                             "wait" 
                                             "end parallel" 
                                             "end kernels" 
                                             "end data" 
                                             "end host_data" 
                                             "end atomic" 
                                             "atomic read" 
                                             "atomic write" 
                                             "atomic update" 
                                             "atomic capture" 
                                             "enter data" 
                                             "exit data" 
                                             )) 
                              )) 

  ;; Regex describing all known OpenACC directive modifier names
  (defvar acc-modifiers-regex
    ;; Use regexp-opt to build the regex and replace-regexp-in-string 
    ;; to allow any sequence of blank characters as separator 
    (replace-regexp-in-string " " "[ \t]+"    
                              (regexp-opt '( "copyin"
					     "copyout"
					     "copy"
					     "create"
					     "pcopy"
					     "present_or_copyin"
					     "present_or_copyout"
					     "present_or_copy"
					     "present_or_create"
					     "gang"
					     "worker"
					     "vector"
					     "collapse"
					     "seq"
					     "reduction"
					     "num_gangs"
					     "num_workers"
					     "vector_length"
					     "async"
					     "wait"
					     "present"
					     "independent"
					     ))
			      ))


  ;; For OpenACC, uncomment one of the two lines below to choose between a simple regexp 
  ;; that only matches the "#pragma acc" prefix or a more advanced version that also matches the directive name. 
  ;; (defvar acc-regex "pragma[ \t]+acc[\t ].*") 
  (defvar acc-commands-highlight-regex (concat "pragma[ \t]+acc\\([ \t]+" acc-commands-regex "\\)+" ))

  ;; Regex describing C comments containing an OpenACC directive and modifiers
  ;; 
  ;; Reminder: For C comments, the \\( ... \\)) indicates which part should be 
  ;; highlighted. Then the argument 1 should be passed instead of 0 to font-lock-add-keywords 
  ;; 
  (defvar acc-regex-c (concat "^[ \t]*\\(#" acc-commands-highlight-regex "\\)" ) )
  (defvar acc-modifiers-c (concat  "\\(" acc-regex-c "\\([ \t]*" acc-modifiers-regex ".*[\n]\\)+\\)" ))

  (font-lock-add-keywords 'c-mode
                          ( list 
                            ( list acc-modifiers-c 1 'openacc-modifier-face t)
                            ( list acc-regex-c 1 'openacc-command-face t)
                            )) 

  (font-lock-add-keywords 'c++-mode
                          ( list 
                            ( list acc-modifiers-c 1 'openacc-modifier-face t)
                            ( list acc-regex-c 1 'openacc-face t)
                            )) 
  
)  ;;;;;; of Fortran OpenACC and OpenMP highlighting 

(provide 'openacc-syntax-highlighting-c)

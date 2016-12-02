;;; OpenACC syntax highlighting

;;;; 
;;;; Enable Highlighing of OpenACC and OpenMP directives in Fortan 
;;;; 
(when (require 'font-lock nil 'noerror ) 

    (defface openacc-header-face 
    '((t
       :foreground "#e91aff" 
       ;; :background "yellow" 
       :bold       t 
       )) 
    "Face for the header in OpenACC directives " 
    ) 

    (defface openacc-default-face 
    '((t
       :foreground "#aaaaff" 
       ;; :background "yellow" 
       ;; :bold       t 
       )) 
    "Face for openacc directive" 
    ) 

    (defface openacc-command-face 
    '((t
       :foreground "#00ff00" 
       ;; :background "yellow" 
       ;; :bold       t 
       )) 
    "Face for command name in OpenACC directives " 
    ) 

    (defface openacc-clause-face 
    '((t
       :foreground "#f95555" 
       ;; :background "yellow" 
       ;; :bold       t 
       )) 
    "Face for keywords in OpenACC  directives" 
    ) 

  (defvar openacc-header-face  'openacc-header-face)
  (defvar openacc-default-face 'openacc-default-face)
  (defvar openacc-command-face 'openacc-command-face)
  (defvar openacc-clause-face 'openacc-clause-face) 

  
  (defvar acc-commands-common     
    '( ;; Insert here the OpenACC commands shared by both C and Fortran
       "cache" 
       "data"     
       "declare"        
       "host_data"
       "init"
       "kernels"     
       "kernels loop"     
       "loop"
       "parallel"  
       "parallel loop" 
       "routine"
       "set"
       "shutdown"
       "update"
       "wait"
       "atomic read"
       "atomic write"
       "atomic update"
       "atomic capture"
       "enter data"
       "exit data"       
       ))  


  (defvar acc-commands-fortran
    (append  acc-commands-common 
             '( ;; insert here the OpenACC commands for Fortran only 
               "end parallel"
               "end parallel loop"
               "end kernels"
               "end kernels loop"
               "end data"
               "end host_data"
               "end atomic"
               )))

  (defvar acc-commands-c
    (append acc-commands-common 
            '( ;; insert here the OpenACC commands for C only               
              )))
  
  (defvar acc-clauses 
    '( ;; Insert here the OpenACC keywords to highlight
        ; within the clauses 
       "copyin"
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

  ;; Regex describing all known OpenACC command names in fortran
  (defvar acc-commands-regex-f
    (concat "\\_<"
            (replace-regexp-in-string  " " "[ \t]+" (regexp-opt acc-commands-fortran) )             
            "\\_>"
            ))

  ;; Regex describing all known OpenACC command names in C
  (defvar acc-commands-regex-c
    (concat "\\_<"
            (replace-regexp-in-string " " "[ \t]+" (regexp-opt acc-commands-c) )             
            "\\_>"
            ))
  
  (defvar acc-clauses-regex
    (concat "\\_<"
            (replace-regexp-in-string " " "[ \t]+" (regexp-opt  acc-clauses ) )   
            "\\_>"
            ))
  
  ;; Regex to match the OpenACC directive marker in C and in Fortran free and fixed form comments 
  ;; in C:    pragma acc ...
  (defvar acc-header-c   "^[ \t]*#[ \t]*pragma[ \t]+\\(\\<acc\\>\\)[ \t]+" )
  ;; in F90:  !$acc ...
  (defvar acc-header-ffree  "^[ \t]*\\(!$acc\\)[ \t]+" )  
  ;; in F77:  C$acc ...
  (defvar acc-header-ffixed "^\\(C$acc\\)[ \t]" )

  ;; The colorization works the same for all language
  ;;  (1) Identify a line containing a directive with the regexp acc-header-??? 
  ;;      See also anchored-highlighter  in https://www.gnu.org/software/emacs/manual/html_node/elisp/Search_002dbased-Fontification.html
  ;;  (2) then within tha line, colorize:
  ;;      (a) the whole line with openacc-default-face
  ;;      (b) the ACC header with openacc-header-face
  ;;      (c) the clauses with openacc-clause-face
  ;;      (d) the command with openacc-command-face
  ;;    The order (a) .. (d) is important
  ;;
  (font-lock-add-keywords 'c++-mode
                          (list  
                            (list acc-header-c
                                   ( list ".*" '(beginning-of-line) nil  '(0 openacc-default-face t) ) 
                                   ( list acc-header-c   
                                          '(beginning-of-line) nil  '(1 openacc-header-face t) )
                                   ( list acc-clauses-regex
                                          '(beginning-of-line) nil  '(0 openacc-clause-face t) ) 
                                   ( list (concat acc-header-c "\\(" acc-commands-regex-c "\\)")  
                                          '(beginning-of-line) nil  '(2 openacc-command-face t) )
                            )
                          ))

  (font-lock-add-keywords 'c-mode
                          (list  
                            (list acc-header-c
                                   ( list ".*" '(beginning-of-line) nil  '(0 openacc-default-face t) ) 
                                   ( list acc-header-c   
                                          '(beginning-of-line) nil  '(1 openacc-header-face t) )
                                   ( list acc-clauses-regex
                                          '(beginning-of-line) nil  '(0 openacc-clause-face t) ) 
                                   ( list (concat acc-header-c "\\(" acc-commands-regex-c "\\)")  
                                          '(beginning-of-line) nil  '(2 openacc-command-face t) )
                            )
                          ))

  (font-lock-add-keywords 'f90-mode  
                         (list  
                            (list  acc-header-ffree
                                   ( list ".*" '(beginning-of-line) nil  '(0 openacc-default-face t) ) 
                                   ( list acc-header-ffree   
                                          '(beginning-of-line) nil  '(1 openacc-header-face t) )
                                   ( list acc-clauses-regex
                                          '(beginning-of-line) nil  '(0 openacc-clause-face t) ) 
                                   ( list (concat acc-header-ffree "\\(" acc-commands-regex-f "\\)")  
                                          '(beginning-of-line) nil  '(2 openacc-command-face t) )
                            )
                          ))
  
  ;; For F77 (fixed form fortran), we do it twice: 
  ;; First for the Fixed-Form comments and then for the Free-Form comments  
  (font-lock-add-keywords 'fortran-mode  
                         (list  
                            (list  acc-header-ffixed
                                   ( list ".*" '(beginning-of-line) nil  '(0 openacc-default-face t) ) 
                                   ( list acc-header-ffixed  
                                         '(beginning-of-line) nil  '(1 openacc-header-face t) )
                                   ( list acc-clauses-regex
                                          '(beginning-of-line) nil  '(0 openacc-clause-face t) ) 
                                   ( list (concat acc-header-ffixed "\\(" acc-commands-regex-f "\\)")  
                                          '(beginning-of-line) nil  '(2 openacc-command-face t) )
                            )                          
                            (list  acc-header-ffree
                                   ( list ".*" '(beginning-of-line) nil  '(0 openacc-default-face t) ) 
                                   ( list acc-header-ffree
                                         '(beginning-of-line) nil  '(1 openacc-header-face t) )
                                   ( list acc-clauses-regex
                                          '(beginning-of-line) nil  '(0 openacc-clause-face t) ) 
                                   ( list (concat acc-header-ffree "\\(" acc-commands-regex-f "\\)")  
                                          '(beginning-of-line) nil  '(2 openacc-command-face t) )
                            )
                          ))
  
)  ;;;;;; of OpenACC highlighting 

(provide 'openacc-syntax-highlighting-c)

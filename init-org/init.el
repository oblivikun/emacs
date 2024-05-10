;; (put 'mode-line-format 'initial-value (default-toplevel-value 'mode-line-format))
;; (setq-default mode-line-format nil)
;; (dolist (buf (buffer-list))
;;   (with-current-buffer buf (setq mode-line-format nil)))
;; ;; PERF,UX: P
;;remature redisplays/redraws can substantially affect startup
;;   times and/or flash a white/unstyled Emacs frame during startup, so I
;;   try real hard to suppress them until we're sure the session is ready.
(setq-default inhibit-redisplay t
              inhibit-message t)
;; COMPAT: If the above vars aren't reset, Emacs could appear frozen or
;;   garbled after startup (or in case of an startup error).
(defun doom--reset-inhibited-vars-h ()
  (setq-default inhibit-redisplay nil
                ;; Inhibiting `message' only prevents redraws and
                inhibit-message nil)
  (redraw-frame))
(add-hook 'after-init-hook #'doom--reset-inhibited-vars-h)
	  (use-package gcmh
		    :straight t
		    :defer 1
			:config
		  (gcmh-mode 1))



(setq inhibit-startup-message t)
      (use-package straight
        :custom
        
    (setq straight-check-for-modifications 'live-with-find)

        (straight-use-package-by-default t))
          (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  
(setq display-line-numbers-type 'relative)
    

  (setq org-startup-indented t)

(setenv "IN_EMACS" "1")

(use-package dirvish
   :commands (dirvish) ;; Specify the command to load Dirvish
   :config
 (dirvish-override-dired-mode)
 :bind
 
:bind (("C-x d" . dirvish-dispatch))
   )

(use-package treemacs
  :commands (treemacs)
 :config
 (progn
    (add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))
    (treemacs-hide-gitignored-files-mode nil))
 :bind
 (("M-0" . treemacs)))

(setq browse-url-browser-function 'eww-browse-url
      shr-use-colors nil
      shr-bullet "• "
      shr-folding-mode t
      eww-search-prefix "https://html.duckduckgo.com/html?q="
      url-privacy-level '(email agent cookies lastloc)
      browse-url-secondary-browser-function 'browse-url-firefox)
(setq browse-url-browser-function 'eww-browse-url)

(defun display-files-in-grid ()
   "Display files in a grid."
   (let* ((files (directory-files default-directory))
           (max-file-length (apply 'max (mapcar 'length files)))
           (window-width (window-width))
           (num-columns (max 1 (/ window-width (1+ max-file-length))))
           (num-rows (ceiling (/ (length files) num-columns)))
           (current-row 0)
           (current-column 0))
      (dolist (file files)
        (unless (or (string= file ".") (string= file ".."))
          (let ((start (point)))
            (insert (concat "- " file))
            ;; Make the file name clickable to open it in a new buffer
            (make-text-button start (point)
                              'action (lambda (button)
                                       (find-file (button-get button 'file)))
                              'follow-link t
                              'file file)
            ;; Calculate the position for the next file name
            (setq current-column (1+ current-column))
            (if (>= current-column num-columns)
                (progn
                  (setq current-column 0)
                  (setq current-row (1+ current-row)))
              ;; Insert a space between file names
              (insert " "))
            ;; Insert a newline character at the end of each row
            (when (and (= current-column 0) (< current-row (1- num-rows)))
              (insert "\n")))))))
       ;; Record the start time and garbage collections
       (defvar efs/startup-time nil "Variable to store Emacs startup time.")
       (defvar efs/gcs-done nil "Variable to store the number of garbage collections done during startup.")

       (defun efs/display-startup-time ()
        "Calculate and store Emacs startup time and garbage collections."
        (setq efs/startup-time (format "%.2f seconds"
                                        (float-time
                                        (time-subtract after-init-time before-init-time))))
        (setq efs/gcs-done gcs-done))

       (add-hook 'after-init-hook 'efs/display-startup-time)

       (add-hook 'server-after-make-frame-hook 'efs/display-startup-time)
       ;; Define your dashboard function
       (defun my-dashboard ()
        "Display a simple Emacs dashboard."
        (interactive)
        (switch-to-buffer "*My Dashboard*")
        (erase-buffer)
        
        ;; Add your dashboard content here
        
 (insert (propertize "Welcome to My Emacs Dashboard!\n\n"
                          'face '(:height 1.5 :foreground "blue")))
        ;; Display startup time and garbage collections
  (when efs/startup-time
     (insert (propertize (format "Emacs loaded in %s with %d garbage collections.\n \n"
                                   efs/startup-time efs/gcs-done)
                             'face '(:height 1.2 :foreground "green"))))
        ;; Example: List recent files
  
(insert (propertize "Files in Current Directory:\n"
                         'face '(:foreground "red")))
  (display-files-in-grid)
      (goto-char (point-min))
      


      ;; Add more sections as needed
      )

       ;; Ensure the dashboard is displayed at startup
       (add-hook 'emacs-startup-hook 'my-dashboard)
       
     ;; Use server-after-make-frame-hook instead of emacs-startup-hook
     (add-hook 'server-after-make-frame-hook 'my-dashboard)

(add-hook 'emacs-startup-hook 'my-dashboard)

(use-package hydra
  :defer 20
  )

(setq mode-line-end-spaces
         '(""
           display-time-string
           battery-mode-line-string
 	  "GNU Emacs 29.3"
 	      ))
 (defun my-modeline-god-mode-indicator ()
"Return a string indicating God Mode status for the mode line."
(if god-local-mode
     "  "
   "  "))
     (defun my-mode-line/padding ()
     (let ((r-length (length (format-mode-line mode-line-end-spaces))))
       (propertize " "
         'display `(space :align-to (- right ,r-length)))))
 (setq-default mode-line-format
   '("%e"
      " %o "
      "%* "
      my-modeline-buffer-name
      my-modeline-major-mode
            (:eval (my-mode-line/padding))
	    
  (:eval (my-modeline-god-mode-indicator))
       mode-line-end-spaces))
   
   

 (defvar-local my-modeline-buffer-name
   '(:eval
      (when (mode-line-window-selected-p)
        (propertize (format " %s " (buffer-name))
          'face '(t :background "#3355bb" :foreground "white" :inherit bold))))
   "Mode line construct to display the buffer name.")

 (put 'my-modeline-buffer-name 'risky-local-variable t)

 (defvar-local my-modeline-major-mode
   '(:eval
      (list
        (propertize "λ" 'face 'shadow)
        " "
        (propertize (capitalize (symbol-name major-mode)) 'face 'bold)))
   "Mode line construct to display the major mode.")

 (put 'my-modeline-major-mode 'risky-local-variable t)
     (setq-default header-line-format mode-line-format)
       (setq-default mode-line-format nil)

(use-package company
 :defer 10
 :hook (prog-mode . company-mode)
 :config
 (setq-default
    company-idle-delay 0
    company-require-match nil
    ;; also get a drop down
    company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)))

(use-package slime
  :commands (slime slime-connect)
 :defer 10
 :hook (lisp-mode . slime-mode))

(defcustom cl-ide 'slime
      "What IDE to use to evaluate Common Lisp.
Defaults to Sly because it has better integration with Nyxt."
   :options (list 'sly 'slime))

(defvar emacs-with-nyxt-delay
  0.1)

(setq slime-protocol-version 'ignore)

(defun emacs-with-nyxt-connected-p ()
  "Is `cl-ide' connected to nyxt."
  (cond
   ((eq cl-ide 'slime) (slime-connected-p))
   ((eq cl-ide 'sly) (sly-connected-p))))

(defun emacs-with-nyxt--connect (host port)
	  "Connect `cl-ide' to HOST and PORT."
(cond
 ((eq cl-ide 'slime) (slime-connect host port))
 ((eq cl-ide 'sly) (sly-connect host port))))

(defun emacs-with-nyxt-connect (host port)
	  "Connect `cl-ide' to HOST and PORT."
(emacs-with-nyxt--connect host port)
(while (not (emacs-with-nyxt-connected-p))
  (message "Starting %s connection..." cl-ide)
  (sleep-for emacs-with-nyxt-delay)))

(defun emacs-with-nyxt-eval (string)
    "Send STRING to `cl-ide'."
(cond
 ((eq cl-ide 'slime) (slime-repl-eval-string string))
 ((eq cl-ide 'sly) (sly-eval `(slynk:interactive-eval-region ,string)))))

(defun emacs-with-nyxt-send-sexps (&rest s-exps)
  "Evaluate S-EXPS with Nyxt `cl-ide' session."
  (let ((s-exps-string (s-join "" (--map (prin1-to-string it) s-exps))))
    (defun true (&rest args) 't)
    (if (emacs-with-nyxt-connected-p)
	  (emacs-with-nyxt-eval s-exps-string)
	(error (format "%s is not connected to Nyxt. Run `emacs-with-nyxt-start-and-connect-to-nyxt' first" cl-ide)))))

(defun emacs-with-nyxt-current-package ()
  "Return current package set for `cl-ide'."
  (cond
   ((eq cl-ide 'slime) (slime-current-package))
   ((eq cl-ide 'sly) (with-current-buffer (sly-mrepl--find-buffer) (sly-current-package)))))

(defun emacs-with-nyxt-start-and-connect-to-nyxt (&optional no-maximize)
"Start Nyxt with swank capabilities. Optionally skip window maximization with NO-MAXIMIZE."
(interactive)
(async-shell-command (format "nyxt" ;; "nyxt -e \"(nyxt-user::start-swank)\""
                             ))
(while (not (emacs-with-nyxt-connected-p))
  (message (format "Starting %s connection..." cl-ide))
  (ignore-errors (emacs-with-nyxt-connect "localhost" "4006"))
  (sleep-for emacs-with-nyxt-delay))
(while (not (ignore-errors (string= "NYXT-USER" (upcase (emacs-with-nyxt-current-package)))))
  (progn (message "Setting %s package to NYXT-USER..." cl-ide)
         (sleep-for emacs-with-nyxt-delay)))
(emacs-with-nyxt-send-sexps
 `(load "~/quicklisp/setup.lisp")
 `(defun replace-all (string part replacement &key (test #'char=))
    (with-output-to-string (out)
                           (loop with part-length = (length part)
                                 for old-pos = 0 then (+ pos part-length)
                                 for pos = (search part string
                                                   :start2 old-pos
                                                   :test test)
                                 do (write-string string out
                                                  :start old-pos
                                                  :end (or pos (length string)))
                                 when pos do (write-string replacement out)
                                 while pos)))

`(defun eval-in-emacs (&rest s-exps)
   "Evaluate S-EXPS with emacsclient."
   (let ((s-exps-string (replace-all
                         (write-to-string
                          `(progn ,@s-exps) :case :downcase)
                         ;; Discard the package prefix.
                         "nyxt::" "")))
     (format *error-output* "Sending to Emacs:~%~a~%" s-exps-string)
     (uiop:run-program
      (list "emacsclient" "--eval" s-exps-string))))e

`(ql:quickload "cl-qrencode")
`(define-command-global my/make-current-url-qr-code () ; this is going to be redundant: https://nyxt.atlas.engineer/article/qr-url.org
			        "Something else."
   (when (find-mode (current-buffer) 'web-mode)
     (cl-qrencode:encode-png (quri:render-uri (url (current-buffer))) :fpath "/tmp/qrcode.png")
     (uiop:run-program (list "nyxt" "/tmp/qrcode.png"))))

'(define-command-global my/open-html-in-emacs ()
			        "Open buffer html in Emacs."
   (when (find-mode (current-buffer) 'web-mode)
     (with-open-file
	(file "/tmp/temp-nyxt.html" :direction :output
	      :if-exists :supersede
	      :if-does-not-exist :create)
	(write-string (ffi-buffer-get-document (current-buffer)) file)))
   (eval-in-emacs
    `(progn (switch-to-buffer
	       (get-buffer-create ,(render-url (url (current-buffer)))))
	      (erase-buffer)
	      (insert-file-contents-literally "/tmp/temp-nyxt.html")
	      (html-mode)
	      (indent-region (point-min) (point-max))))
   (delete-file "/tmp/temp-nyxt.html"))

`(define-command-global eval-expression ()
 "Prompt for the expression and evaluate it, echoing result to the `message-area'."
 (let ((expression-string
        (first (prompt :prompt "Expression to evaluate"
                       :sources (list (make-instance 'prompter:raw-source))))))
   (echo "~S" (eval (read-from-string expression-string)))))

`(define-configuration nyxt/web-mode:web-mode
   ((keymap-scheme (let ((scheme %slot-default%))
                     (keymap:define-key (gethash scheme:emacs scheme)
                                        "M-:" 'eval-expression)
                     scheme))))

`(defun emacs-with-nyxt-capture-link ()
	(let ((url (quri:render-uri (url (current-buffer)))))
	  (if (str:containsp "youtu" url)
	      (str:concat
	       url
	       "&t="
	       (write-to-string
		(floor
		 (ffi-buffer-evaluate-javascript (current-buffer)
						 (ps:ps
						  (ps:chain document
							    (get-element-by-id "movie_player")
							    (get-current-time))))))
	       "s")
	    url)))

`(define-command-global org-capture ()
	(eval-in-emacs
	 `(let ((org-link-parameters
		 (list (list "nyxt"
			     :store
			     (lambda ()
			       (org-store-link-props
				:type "nyxt"
				:link ,(emacs-with-nyxt-capture-link)
				:description ,(title (current-buffer))))))))
	    (org-capture nil "wN"))
	 (echo "Note stored!")))

`(define-command-global org-roam-capture ()
	(let ((quote (%copy))
	      (link (emacs-with-nyxt-capture-link))
	      (title (prompt
		      :input (title (current-buffer))
		      :prompt "Title of note:"
		      :sources (list (make-instance 'prompter:raw-source))))
	      (text (prompt
		     :input ""
		     :prompt "Note to take:"
		     :sources (list (make-instance 'prompter:raw-source)))))
	  (eval-in-emacs
	   `(let ((_ (require 'org-roam))
		  (file (on/make-filepath ,(car title) (current-time))))
	      (on/insert-org-roam-file
	       file
	       ,(car title)
	       nil
	       (list ,link)
	       ,(car text)
	       ,quote)
	      (find-file file)
	      (org-id-get-create)))
	  (echo "Org Roam Note stored!")))
   `(define-configuration nyxt/web-mode:web-mode
	((keymap-scheme (let ((scheme %slot-default%))
			  (keymap:define-key (gethash scheme:emacs scheme)
					     "C-c o c" 'org-capture)
			  scheme))))
   `(define-configuration nyxt/web-mode:web-mode
	((keymap-scheme (let ((scheme %slot-default%))
			  (keymap:define-key (gethash scheme:emacs scheme)
					     "C-c n f" 'org-roam-capture)
			  scheme))))
   )
  (unless no-maximize
    (emacs-with-nyxt-send-sexps
     '(toggle-fullscreen))))

(defun emacs-with-nyxt-browse-url-nyxt (url &optional buffer-title)
  (interactive "sURL: ")
  (emacs-with-nyxt-send-sexps
   (append
    (list
     'buffer-load
     url)
    (if buffer-title
        `(:buffer (make-buffer :title ,buffer-title))
      nil))))

(defun emacs-with-nyxt-close-nyxt-connection ()
  (interactive)
  (emacs-with-nyxt-send-sexps '(quit)))

(defun browse-url-nyxt (url &optional new-window)
  (interactive "sURL: ")
  (unless (emacs-with-nyxt-connected-p) (emacs-with-nyxt-start-and-connect-to-nyxt))
  (emacs-with-nyxt-browse-url-nyxt url url))

(defun emacs-with-nyxt-search-first-in-nyxt-current-buffer (string)
(interactive "sString to search: ")
(unless (emacs-with-nyxt-connected-p) (emacs-with-nyxt-start-and-connect-to-nyxt))
(emacs-with-nyxt-send-sexps
 `(nyxt/web-mode::highlight-selected-hint
   :link-hint
   (car (nyxt/web-mode::matches-from-json
         (nyxt/web-mode::query-buffer :query ,string)))
   :scroll 't)))

(defun emacs-with-nyxt-make-qr-code-of-current-url ()
(interactive)
(if (file-exists-p "~/quicklisp/setup.lisp")
    (progn
      (unless (emacs-with-nyxt-connected-p) (emacs-with-nyxt-start-and-connect-to-nyxt))
      (emacs-with-nyxt-send-sexps
       '(ql:quickload "cl-qrencode")
       '(cl-qrencode:encode-png (quri:render-uri (url (current-buffer))) :fpath "/tmp/qrcode.png"))
      (find-file "/tmp/qrcode.png")
      (auto-revert-mode))
  (error "You cannot use this until you have Quicklisp installed! Check how to do that at: https://www.quicklisp.org/beta/#installation")))

(defun emacs-with-nyxt-get-nyxt-buffers ()
(when (emacs-with-nyxt-connected-p)
  (read
   (emacs-with-nyxt-send-sexps
    '(map 'list (lambda (el) (slot-value el 'title)) (buffer-list))))))

(defun emacs-with-nyxt-nyxt-switch-buffer (&optional title)
  (interactive)
  (if (emacs-with-nyxt-connected-p)
      (let ((title (or title (completing-read "Title: " (emacs-with-nyxt-get-nyxt-buffers)))))
        (emacs-with-nyxt-send-sexps
         `(switch-buffer :id (slot-value (find-if #'(lambda (el) (equal (slot-value el 'title) ,title)) (buffer-list)) 'id))))
    (error (format "%s is not connected to Nyxt. Run `emacs-with-nyxt-start-and-connect-to-nyxt' first" cl-ide))))

(defun emacs-with-nyxt-get-nyxt-commands ()
	(when (emacs-with-nyxt-connected-p)
	  (read
	   (emacs-with-nyxt-send-sexps
	    `(let ((commands (make-instance 'command-source)))

	       (map 'list (lambda (el) (slot-value el 'name)) (funcall (slot-value commands 'prompter:CONSTRUCTOR) commands)))))))

(defun emacs-with-nyxt-nyxt-run-command (&optional command)
  (interactive)
  (if (emacs-with-nyxt-connected-p)
      (let ((command (or command (completing-read "Execute command: " (emacs-with-nyxt-get-nyxt-commands)))))
        (emacs-with-nyxt-send-sexps `(nyxt::run-async ',(read command))))
    (error (format "%s is not connected to Nyxt. Run `emacs-with-nyxt-start-and-connect-to-nyxt' first" cl-ide))))

(defun emacs-with-nyxt-nyxt-take-over-prompt ()
  (interactive)
  (emacs-with-nyxt-send-sexps
   `(progn
      (defun flatten (structure)
        (cond ((null structure) nil)
              ((atom structure) (list structure))
              (t (mapcan #'flatten structure))))
      
      (defun prompt (&REST args)
        (flet ((ensure-sources (specifiers)
                               (mapcar (lambda (source-specifier)
                                         (cond
                                          ((and (symbolp source-specifier)
                                                (c2cl:subclassp source-specifier 'source))
                                           (make-instance source-specifier))
                                          (t source-specifier)))
                                       (uiop:ensure-list specifiers))))
              (sleep 0.1)
              (let* ((promptstring (list (getf args :prompt)))
                     (sources (ensure-sources (getf args :sources)))
                     (names (mapcar (lambda (ol) (slot-value ol 'prompter:attributes)) (flatten (mapcar (lambda (el) (slot-value el 'PROMPTER::INITIAL-SUGGESTIONS)) sources))))
                     (testing (progn
                                (setq my-names names)
                                (setq my-prompt promptstring)))
                     (completed (read-from-string (eval-in-emacs `(emacs-with-nyxt-nyxt-complete ',promptstring ',names))))
                     (suggestion
                      (find-if (lambda (el) (equal completed (slot-value el 'PROMPTER::ATTRIBUTES))) (flatten (mapcar (lambda (el) (slot-value el 'PROMPTER::INITIAL-SUGGESTIONS)) sources))))
                     (selected-class (find-if (lambda (el) (find suggestion (slot-value el 'PROMPTER::INITIAL-SUGGESTIONS))) sources)))
                (if selected-class
                    (funcall (car (slot-value selected-class 'PROMPTER::ACTIONS)) (list (slot-value suggestion 'PROMPTER:VALUE)))
                  (funcall (car (slot-value (car sources) 'PROMPTER::ACTIONS)) (list completed)))))))))

(defun emacs-with-nyxt-nyxt-complete (prompt names)
  (let* ((completions (--map (s-join "\t" (--map (s-join ": " it) it)) names))
         (completed-string (completing-read (s-append ": " (car prompt)) completions))
         (completed-index (-elem-index  completed-string completions)))
    (if (numberp completed-index)
        (nth completed-index names)
      completed-string)))

(defun emacs-with-nyxt-decode-command (encoded)
  (--> encoded
       (s-split "/" it t)
       reverse
       car
       (s-split "\\." it t)
       car
       base64-decode-string
       read
       eval))

(provide 'emacs-with-nyxt)

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (python-mode . lsp)
	 (haskell-mode . lsp)
	 (c-or-c++-mode . lsp)
	 (go-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
   (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-signature-render-documentation nil)
  (setq lsp-eldoc-hook nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-semantic-tokens-enable nil)
  (setq lsp-enable-folding nil)
  (setq lsp-enable-imenu nil)
  (setq lsp-enable-snippet nil)
  :commands lsp)

(use-package lsp-ui
 :defer 12
 :hook (lsp-mode . lsp-ui-mode))

;; if you are ivy user
(use-package lsp-ivy
  :defer 12
  :commands lsp-ivy-workspace-symbol)

;; (add-hook 'prog-mode-hook #'eglot-ensure)
;; (with-eval-after-load 'eglot
;;  (add-to-list 'eglot-server-programs
;;                '(emacs-lisp-mode . ("emacs-lsp" "--stdio"))))

(defun open-terminal-at-bottom ()
(interactive)
(let ((height (window-body-height)))
  (split-window-below (- height (/ height 4)))) 
(other-window 1)
(term "ksh"))

(defun close-terminal-at-bottom ()
 (interactive)
 (let ((current-window (selected-window)))
    (if (eq 'term-mode (buffer-local-value 'major-mode (window-buffer current-window)))

(delete-window current-window)

(when (and (window-live-p (next-window))
		     (eq 'term-mode (buffer-local-value 'major-mode (window-buffer (next-window)))))
	    (delete-window (next-window))))))

(defun open-python-shell-at-bottom ()
 (interactive)
 (let ((height (window-body-height)))
	(split-window-below (- height (/ height 4)))) 
 (other-window 1)
 (term "python3"))

(defhydra hydra-terminal-python-manager (:color blue)
 "Terminal/Python"
 ("t" open-terminal-at-bottom "Open Terminal")
 ("q" close-terminal-at-bottom "Close Terminal")
 ("p" open-python-shell-at-bottom "Open Python Shell"))

(global-set-key (kbd "C-c t") 'hydra-terminal-python-manager/body)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(use-package org-roam
  :defer 10
 :init
 (setq org-roam-directory (file-truename "~/roam/"))
 :custom
 (org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
 :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
 :config
 (org-roam-db-autosync-mode)
 ;; Additional configuration and custom functions can be added here
 )

(setq org-hide-emphasis-markers t)
    (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(use-package olivetti
  :hook (org-mode . olivetti-mode))
(use-package org-bullets
 :ensure t
 :hook (org-mode . (lambda ()
                      (org-bullets-mode 1)
                      (visual-line-mode)))
 :config
 ;; Additional configuration can go here
 )

(defun my-org-todo-toggle ()
  (interactive)
  (let ((state (org-get-todo-state)))
    (if (string= state "TODO")
        (org-todo "DONE")
      (org-todo "TODO")))
  (org-flag-subtree t))
(define-key org-mode-map (kbd "C-c C-d") 'my-org-todo-toggle)
(defun my-org-insert-todo ()
  (interactive)
  (org-insert-todo-heading nil))
(define-key org-mode-map (kbd "C-c C-t") 'my-org-insert-todo)
(defun org-deadline-in-one-week ()
  (interactive)
  (org-deadline nil "+1w"))
(global-set-key (kbd "C-c d") 'org-deadline-in-one-week)

(setq org-agenda-files '("~/agenda.org"))
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))
(setq org-agenda-todo-ignore-scheduled t)
(setq org-agenda-todo-ignore-deadlines t)
(defun my-split-and-open-todo-list ()
  "Split the window to the side and open the Org agenda."
  (interactive)
  (split-window-right)
  (other-window 1)
  (org-agenda nil "t"))
(global-set-key (kbd "C-c a") 'my-split-and-open-todo-list)

(defhydra hydra-org-export-and-view ()
 "Export and view"
 ("h" (org-html-export-to-html) "Export to HTML")
 ("o" (org-export-to-html-and-open-in-nyxt) "Open in Nyxt")
 ("l" (org-latex-export-to-latex) "Export to LaTeX")
 ("b" (org-beamer-export-to-latex) "Export to Beamer")
 ("d" (org-export-to-docx-and-open) "Export to DOCX")
 ("q" nil "quit"))
(define-key org-mode-map (kbd "C-c C-e") 'hydra-org-export-and-view/body)

(defun org-export-to-docx-and-open ()
 (interactive)
 (let ((docx-file (concat (file-name-base (buffer-file-name)) ".docx")))
    (shell-command (format "pandoc %s -o %s" (buffer-file-name) docx-file))
    (find-file docx-file)))

(defun org-export-to-html-and-open-in-nyxt ()
 "Export the current Org file to HTML and open it in Nyxt."
 (interactive)
 (let ((html-file (org-html-export-to-html)))
    (start-process "Nyxt" nil "nyxt" html-file)
    (add-hook 'kill-emacs-hook
              (lambda ()
                (when (get-process "Nyxt")
                  (delete-process (get-process "Nyxt")))))))

(defun markdown-export-to-html-and-open-in-nyxt ()
 "Export the current Markdown file to HTML and open it in Nyxt."
 (interactive)
 (let ((html-file (markdown-export)))
    (start-process "Nyxt" nil "nyxt" html-file)
    (add-hook 'kill-emacs-hook
              (lambda ()
                (when (get-process "Nyxt")
                 (delete-process (get-process "Nyxt")))))))

(defvar org-export-to-html-and-open-in-nyxt-map (make-sparse-keymap)
 "Keymap for `org-export-to-html-and-open-in-nyxt'.")

(define-key org-export-to-html-and-open-in-nyxt-map (kbd "h o") 'org-export-to-html-and-open-in-nyxt)
(add-hook 'markdown-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-o") 'markdown-export-to-html-and-open-in-nyxt)))

(defun loadup-gen ()
(interactive)
(defun get-loads-from-*Messages* ()
	  (save-excursion
	    (let ((retval ()))
	      (set-buffer "*Messages*")
	      (beginning-of-buffer)
	      (while (search-forward-regexp "^Loading " nil t)
		(let ((start (point)))
		  (search-forward "...")
		  (backward-char 3)
		  (setq retval (cons (buffer-substring-no-properties start (point)) retval))))
	      retval)))
(dolist (file (get-loads-from-*Messages*))
	  (princ (format "(load \"%s\")\n" file))))

(let ((backup-dir "~/.emacs.d/backups")
    (auto-saves-dir "~/.emacs.d/autosaves"))
(dolist (dir (list backup-dir auto-saves-dir))
  (when (not (file-directory-p dir))
    (make-directory dir t)))
(setq backup-directory-alist `(("." . ,backup-dir))
	undo-tree-history-directory-alist `(("." . ,backup-dir))
      auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
      auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
      tramp-backup-directory-alist `((".*" . ,backup-dir))
      tramp-auto-save-directory auto-saves-dir))

(defun dump-load-path ()
  (interactive)
  (with-temp-buffer
    (insert (prin1-to-string `(setq load-path ',load-path)))
    (fill-region (point-min) (point-max))
    (write-file "~/.emacs.d/load-path.el")))

(defun dump-emacs ()
  (interactive)
  (shell-command "emacs --batch -l ~/.edump -eval '(dump-load-path)' -eval '(dump-emacs-portable \"~/emacs.dump\")'"))

(use-package undo-tree
:init
(global-undo-tree-mode)
)

(use-package elcord
 :defer 20
 :hook (prog-mode . elcord-mode)
 :config
 ;; Additional configuration can go here if needed
 )

(use-package auctex
  
:hook (latex-mode . LaTeX-mode-hook)

:config
(setq TeX-show-compilation nil)
(eval-after-load "tex" '(add-to-list 'TeX-command-list
				       '("Makeglossaries" "makeglossaries %s" TeX-run-command nil
					 (latex-mode)
					 :help "Run makeglossaries script, which will choose xindy or makeindex") t))

(font-lock-add-keywords 'latex-mode (list (list "\\(«\\(.+?\\|\n\\)\\)\\(+?\\)\\(»\\)" '(1 'font-latex-string-face t) '(2 'font-latex-string-face t) '(3 'font-latex-string-face t))))

:config
    (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
    (add-hook 'latex-mode-hook 'turn-on-reftex)
    (setq reftex-plug-into-AUCTeX t)
    (add-hook 'LaTeX-mode-hook (function (lambda() (bind-key "C-c C-r" 'reftex-query-replace-document))))
    (add-hook 'LaTeX-mode-hook (function (lambda() (bind-key "C-c C-g" 'reftex-grep-document))))
    (add-hook 'TeX-mode-hook (lambda () (reftex-isearch-minor-mode))))
(setq-default TeX-master nil)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-PDF-mode t)

(defun TeX-remove-macro ()
 (interactive)
 (when (TeX-current-macro)
    (let ((bounds (TeX-find-macro-boundaries))
          (brace (save-excursion
                    (goto-char (1- (TeX-find-macro-end)))
                    (TeX-find-opening-brace))))
      (delete-region (1- (cdr bounds)) (cdr bounds))
      (delete-region (car bounds) (1+ brace)))
    t))
(add-hook 'LaTeX-mode-hook (lambda () (bind-key "M-DEL" 'TeX-remove-macro)))
(setq TeX-view-program-selection '((output-pdf "Zathura")))

(setq rcirc-track-ignore-server-buffer-flag t)
(rcirc-track-minor-mode 1)
(setq alert-default-style 'libnotify)
(setq rcirc-notify-message "message from %s")

(use-package magit
  :commands (magit-clone magit magit-push magit-commit magit-stage-modified magit-stage-file)
  )

(setq nnmail-treat-duplicates t)
(use-package gnus
  :commands (gnus)
  )

  (setq message-send-mail-function 'smtpmail-send-it)

;; (use-package epa-file
;; (epa-file-enable)

(use-package org-mime
   :commands (org-mime-htmlize)
   :config
(setq org-mime-library 'mml))

(defun my-insert-html-signature ()
 (let ((signature "<div style=\"display: block; white-space: nowrap; border: 1px solid #000; text-decoration: underline;\">
    Erel Bitzan, student and gentoo GNU/linux user :D
 </div>"))
    (goto-char (point-max))
    (insert signature)))

(add-hook 'org-mime-html-hook 'my-insert-html-signature)
(add-hook 'message-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c M-o") 'org-mime-htmlize)))
(add-hook 'org-mime-html-hook
2          (lambda ()
            (org-mime-change-element-style
             "pre" (format "color: %s; background-color: %s; padding: 0.5em;"
                           "#E6E1DC" "#232323"))))

(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "blockquote" "border-left: 2px solid gray; padding-left: 4px;")))

(use-package dianyou
  :commands (gnus)
  )

(eval-after-load 'gnus-group
  '(progn
     (defhydra hydra-gnus-group (:color blue)
       "
[_A_] Remote groups (A A) [_g_] Refresh
[_L_] Local groups        [_\\^_] List servers
[_c_] Mark all read       [_m_] Compose new mail
[_G_] Search mails (G G) [_#_] Mark mail
"
       ("A" gnus-group-list-active)
       ("L" gnus-group-list-all-groups)
       ("c" gnus-topic-catchup-articles)
       ("G" dianyou-group-make-nnir-groupx)
       ("g" gnus-group-get-new-news)
       ("^" gnus-group-enter-server-mode)
       ("m" gnus-group-new-mail)
       ("#" gnus-topic-mark-topic)
       ("q" nil))
     (define-key gnus-group-mode-map "y" 'hydra-gnus-group/body)))

(eval-after-load 'gnus-sum
  '(progn
     (defhydra hydra-gnus-summary (:color blue)
       "
[_s_] Show thread   [_F_] Forward (C-c C-f)
[_h_] Hide thread   [_e_] Resend (S D e)
[_n_] Refresh (/ N) [_r_] Reply
[_!_] Mail -> disk  [_R_] Reply with original
[_d_] Disk -> mail  [_w_] Reply all (S w)
[_c_] Read all      [_W_] Reply all with original (S W)
[_#_] Mark          [_G_] Search mails
"
       ("s" gnus-summary-show-thread)
       ("h" gnus-summary-hide-thread)
       ("n" gnus-summary-insert-new-articles)
       ("F" gnus-summary-mail-forward)
       ("!" gnus-summary-tick-article-forward)
       ("d" gnus-summary-put-mark-as-read-next)
       ("c" gnus-summary-catchup-and-exit)
       ("e" gnus-summary-resend-message-edit)
       ("R" gnus-summary-reply-with-original)
       ("r" gnus-summary-reply)
       ("W" gnus-summary-wide-reply-with-original)
       ("w" gnus-summary-wide-reply)
       ("#" gnus-topic-mark-topic)
       ("G" dianyou-group-make-nnir-group)
       ("q" nil))
     (define-key gnus-summary-mode-map "y" 'hydra-gnus-summary/body)))

(eval-after-load 'gnus-art
  '(progn
     (defhydra hydra-gnus-article (:color blue)
       "
[o] Save attachment        [F] Forward
[v] Play video/audio       [r] Reply
[d] CLI to download stream [R] Reply with original
[b] Open external browser  [w] Reply all (S w)
[f] Click link/button      [W] Reply all with original (S W)
[g] Focus link/button
"
       ("F" gnus-summary-mail-forward)
       ("r" gnus-article-reply)
       ("R" gnus-article-reply-with-original)
       ("w" gnus-article-wide-reply)
       ("W" gnus-article-wide-reply-with-original)
       ("q" nil))
     ;; y is not used by default
     (define-key gnus-article-mode-map "y" 'hydra-gnus-article/body)))

(eval-after-load 'message
  '(progn
     (defhydra hydra-message (:color blue)
  "
[_c_] Complete mail address
[_a_] Attach file
[_s_] Send mail (C-c C-c)
"
       ("c" counsel-bbdb-complete-mail)
       ("a" mml-attach-file)
       ("s" message-send-and-exit)
       ("i" dianyou-insert-email-address-from-received-mails)
       ("q" nil))))
(defun message-mode-hook-hydra-setup ()
  (local-set-key (kbd "C-c C-y") 'hydra-message/body))
(add-hook 'message-mode-hook 'message-mode-hook-hydra-setup)

(use-package projectile
  :defer 10
 :hook (prog-mode . projectile-mode)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

(defun select-line ()
 (interactive)
 (let ((delete-selection-mode t))
    (beginning-of-line)
    (set-mark-command nil)
    (end-of-line)
    (setq delete-selection-mode nil))) 
(global-set-key (kbd "C-c l") 'select-line)

(use-package ivy
      :commands (counsel M-x counsel-git counsel-ag counsel-locate counsel-minibuffer-history counsel-describe-variable counsel-find-library counsel-unicode-char)
   :init
   (ivy-mode 1)
   :config
   (setq ivy-use-virtual-buffers t)
   (setq enable-recursive-minibuffers t))

(use-package counsel
 :commands (counsel M-x counsel-git counsel-ag counsel-locate counsel-minibuffer-history counsel-describe-variable counsel-find-library counsel-unicode-char)
 :bind (("M-x" . counsel-M-x)
         ("<f1> f" . counsel-describe-function)
         ("<f1> v" . counsel-describe-variable)
         ("<f1> o" . counsel-describe-symbol)
         ("<f1> l" . counsel-find-library)
         ("<f2> i" . counsel-info-lookup-symbol)
         ("<f2> u" . counsel-unicode-char)
         ("C-c g" . counsel-git)
	 ("C-x  C-f" . counsel-find-file)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag)
         ("C-x l" . counsel-locate)
         ("C-S-o" . counsel-rhythmbox)
         :map minibuffer-local-map
         ("C-r" . counsel-minibuffer-history)))

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

(use-package treemacs-nerd-icons
  :demand t
  :config
  (treemacs-load-theme "nerd-icons"))

(global-set-key (kbd "C-x C-k") 'kill-current-buffer)

;; (use-package system-packages
;;   :defer 20
;;   :config
;;  (setq system-packages-use-sudo t)
;;  (setq system-packages-package-manager 'emerge))

(add-hook 'markdown-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-o") 'markdown-export-to-html-and-open-in-nyxt)))
(use-package indent-guide
 :hook (python-mode . indent-guide-mode)
 :config
 (set-face-background 'indent-guide-face "gray")) ; Set the color of the indent guides

(setq-default TeX-master nil)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-PDF-mode t)

(setq TeX-show-compilation nil)

(use-package solarized-theme
  :defer 10
  )
(defun switch-theme-based-on-time ()
  (interactive)
  (let ((current-hour (string-to-number (format-time-string "%H"))))
    (cond ((and (>= current-hour 20) (<= current-hour 23))
           (disable-theme t)
	   (message "switch")
           (load-theme 'solarized-selenized-dark  ))
          ((and (>= current-hour 9) (<= current-hour 19))
	   (disable-theme t)
	   (message "switch")
           (load-theme 'solarized-selenized-light ))
          ;; Removed the condition for 8 AM to 9 AM
          (t ;; This is the else clause
           (disable-theme t)
	   (message "switch")
           (load-theme 'solarized-selenized-black )))) ;; Load the default theme if none of the conditions are met
  )

    ;; Schedule the theme switch function to run every hour
    (run-at-time "00:00" (* 30 60) 'switch-theme-based-on-time)

(use-package guru-mode
:init
(guru-global-mode +1))

(use-package auto-compile
        :config
        (auto-compile-on-load-mode)
  (auto-compile-on-save-mode)
      )
      (use-package company-quickhelp
        :hook (company-mode . company-quickhelp-mode))
    (use-package go-mode
     :magic ("\\.go\\'" . (lambda () (go-mode 1)))
     :config
     ;; Additional configuration for go-mode can go here
     )

    (use-package lsp-haskell
:defer 10
     )

    (use-package haskell-mode
     :magic ("\\.hs\\'" . (lambda () (haskell-mode 1)))
     :config
     ;; Additional configuration for haskell-mode can go here
     )
      (global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
    (global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
    (global-set-key (kbd "S-C-<down>") 'shrink-window)
    (global-set-key (kbd "S-C-<up>") 'enlarge-window)

(use-package god-mode
 :commands god-local-mode
 :config
 ;; Set the key to toggle God Mode globally
 (global-set-key (kbd "<escape>") #'god-local-mode)
 ;; Ensure no buffers are exempt from God Mode
 (setq god-exempt-major-modes nil)
 (setq god-exempt-predicates nil)
 ;; Disable function key translation if desired
 ;; (setq god-mode-enable-function-key-translation nil)
  :hook ((prog-mode . god-local-mode)
      (text-mode . god-local-mode)))

;; Function to activate God Mode after exiting Dashboard mode

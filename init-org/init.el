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

(setq user-exwm nil) 
          (setq user-vertico t)
(setq user-consult t)
  (setq user-ivy nil)
  (setq user-dashboard nil)
  (setq cool-dashboard t) 
(display-time-mode)
(display-battery-mode)

(setq inhibit-startup-message t)
      (use-package straight
        :custom
        
    (setq straight-check-for-modification 'check-on-save find-when-checking)

        (straight-use-package-by-default t))
          (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  
(setq display-line-numbers-type 'relative)

(setenv "IN_EMACS" "1")

(use-package dirvish
   :init
 (dirvish-override-dired-mode)
:bind (("M-g d" . dirvish-dispatch)
	("C-x d" . dirvish )
	)
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
  
  ;; Check if user-dashboard is set
  (when (and (boundp 'user-dashboard) (not (eq user-dashboard nil)))
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
    (goto-char (point-min))))

  ;; Ensure the dashboard is displayed at startup
;; Check if user-dashboard is set
(when (and (boundp 'user-dashboard) (not (eq user-dashboard nil)))
  ;; Ensure the dashboard is displayed at startup
  (add-hook 'emacs-startup-hook 'my-dashboard)
  
  ;; Use server-after-make-frame-hook instead of emacs-startup-hook
  (add-hook 'server-after-make-frame-hook 'my-dashboard))

(use-package dashboard
  :if cool-dashboard
  :preface
  (defun my/dashboard-banner ()
    "Set a dashboard banner including information on package initialization
  time and garbage collections."""
    (setq dashboard-banner-logo-title
          (format "Emacs ready in %.2f seconds with %d garbage collections."
                  (float-time (time-subtract after-init-time before-init-time)) gcs-done)))
  :config
  (dashboard-setup-startup-hook)
  :hook ((after-init     . dashboard-refresh-buffer)
         (dashboard-mode . my/dashboard-banner)))

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
(defun my-get-mode-icon ()
  "Return an icon for the current major mode."
  (cond ((eq major-mode 'org-mode) "")
        ((eq major-mode 'c-mode) "")
        ((eq major-mode 'c++-mode) "")
	((eq major-mode 'python-mode) "")
	((eq major-mode 'ruby-mode) "")
	((eq major-mode 'emacs-lisp-mode) "")
	((eq major-mode 'dashboard-mode) "")
	((eq major-mode 'haskell-mode) "")
  	((eq major-mode 'sh-mode) "")
    	((eq major-mode 'rust-mode) "")
	((eq major-mode 'go-mode) "")
        (t (capitalize (symbol-name major-mode)))))

(defvar-local my-modeline-major-mode
  '(:eval
     (list
       (propertize "λ" 'face 'shadow)
       " "
       (propertize (my-get-mode-icon) 'face 'bold)))
  "Mode line construct to display the major mode.")

   (put 'my-modeline-major-mode 'risky-local-variable t)

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

(defun open-terminal-at-bottom ()
(interactive)
(let ((height (window-body-height)))
  (split-window-below (- height (/ height 4)))) 
(other-window 1)
(term "sh"))

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

(use-package vertico
:if user-vertico
      :ensure t
      :bind (:map vertico-map
             ("C-j" . vertico-next)
             ("C-k" . vertico-previous)
             ("C-f" . vertico-exit)
             :map minibuffer-local-map
             ("M-h" . backward-kill-word))
      :custom
      (vertico-cycle t)
      :init
      (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

(use-package marginalia
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package ivy
	       :if user-ivy
   :commands (counsel M-x counsel-git counsel-ag counsel-locate counsel-minibuffer-history counsel-describe-variable counsel-find-library counsel-unicode-char)
   :init
   (ivy-mode 1)
    :config
 (setq ivy-use-virtual-buffers t)
    (setq enable-recursive-minibuffers t))

 (use-package counsel
   :if user-ivy
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
(global-set-key (kbd "C-c C-<left>") 'windmove-swap-states-left) 
(global-set-key (kbd "C-c C-<right>") 'windmove-swap-states-right)
  (global-set-key (kbd "C-c C-<up>") 'windmove-swap-states-up)
   (global-set-key (kbd "C-c C-<down>") 'windmove-swap-states-down)

(use-package treemacs-nerd-icons
  :demand t
  :config
  (treemacs-load-theme "nerd-icons"))

(global-set-key (kbd "C-x C-k") 'kill-current-buffer)

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
  )
(load-theme 'solarized-selenized-black)

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
   :commands god-mode-all
   :init
   (god-mode-all)
   :config
   ;; Set the key to toggle God Mode globally
   (global-set-key (kbd "<escape>") #'god-mode-all)
   ;; Ensure no buffers are exempt from God Mode
   (setq god-exempt-major-modes nil)
   (setq god-exempt-predicates nil)
   ;; Disable function key translation if desired
   ;; (setq god-mode-enable-function-key-translation nil)
)

  ;; Function to activate God Mode after exiting Dashboard mode

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package exheres-mode
    :mode ("\\.exlib$" "\\.exheres-.*")
  :straight (
	     :files ("src/*")
		:package "exheres-mode" :host nil :type git :repo "https://gitlab.exherbo.org/exherbo-misc/exheres-mode" ) 
  :config
  ;; Any additional configuration for Exheres mode goes here
  )

(defun insert-org-code-block-if-org-mode ()
  "Insert an org-mode code block if in org-mode."
  (interactive)
  (when (eq major-mode 'org-mode)
    (insert "#+BEGIN_SRC \n\n#+END_SRC")
    (previous-line)))

(defun setup-org-mode-shortcuts ()
  "Set up custom shortcuts for org-mode."
  (local-set-key (kbd "C-c b") 'insert-org-code-block-if-org-mode))

(add-hook 'org-mode-hook 'setup-org-mode-shortcuts)

(use-package exrandr
  :commands (xrandr-interface)
  :straight (:host gitlab :repo "oblivikun/emacs-xrandr"))

(load-file (expand-file-name "personal.el" user-emacs-directory))

(defun activate-conf-mode-for-linux-config ()
    "Activate conf-mode if the file is under /usr/src/linux/*/.config"
    (when (string-match-p "/usr/src/linux/[^/]*/\\.config$" buffer-file-name)
      (kconfig-mode)))
  (use-package kconfig-mode
    :straight (:host github :repo "delaanthonio/kconfig-mode")
    :init
    
(add-hook 'find-file-hook #'activate-conf-mode-for-linux-config)
    ;; Define a function to activate kconfig-mode for .config files under /usr/src/linux

    ;; (with-eval-after-load 'kconfig-mode
    ;;   (add-hook 'find-file-hook #'activate-kconfig-mode-for-linux-config)


  )

(use-package exwm
  :demand t
  :if user-exwm
  :config

(defun increase-brightness ()
    (interactive)
    (shell-command "lux -a 10%"))

(defun decrease-brightness ()
  (interactive)
  (shell-command "lux -s 10%"))

(defun flameshot ()
  (interactive)
  (shell-command "flameshot gui"))

(defun increase-volume ()
                         (interactive)
                         (shell-command "pamixer --increase 5"))

                      (defun decrease-volume ()
                         (interactive)
                         (shell-command "pamixer --decrease 5"))

                      (defun toggle-volume ()
                         (interactive)
                         (shell-command "pamixer --toggle-mute"))



;; These keys should always pass through to Emacs
(setq exwm-input-prefix-keys
  '(?\C-x
    ?\C-u
    ?\C-h
    ?\M-x
    ?\M-`
    ?\M-&
    ?\M-:
    ?\C-\ ))  ;; Ctrl+Space

(define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

(defhydra exwm-window-resize (:timeout 4)
("<left>" (exwm-layout-shrink-window-horizontally 10) "shrink h")
("<right>" (exwm-layout-enlarge-window-horizontally 10) "enlarge h")
("<up>" (exwm-layout-shrink-window 10) "shrink v")
("<down>" (exwm-layout-enlarge-window 10) "enlarge v")
("q" nil "quit" :exit t))

(use-package app-launcher
  :straight '(app-launcher :host github :repo "SebastienWae/app-launcher"))

(unless (get 'exwm-input-global-keys 'saved-value)
                       (setq exwm-input-global-keys
                             `(
                               ([?\s-;] . exwm-reset)
                               ([?\s-w] . exwm-workspace-switch)
			                ([?\s-r] . exwm-window-resize/body)

		  ;; Toggle floating windows
		  ([?\s-t] . exwm-floating-toggle-floating)

		  ;; Toggle fullscreen
		  ([?\s-f] . exwm-layout-toggle-fullscreen)

		  ;; Toggle modeline
		  ([?\s-m] . exwm-layout-toggle-mode-line)

		  ;; Quit current buffer
		  ([?\s-q] . kill-current-buffer)

      ;; Launch applications via shell command
		  ([?\s-d] . app-launcher-run-app)
		  ([?\s-a] . switch-to-buffer)
                          
                               ,@(mapcar (lambda (i)
                                           `(,(kbd (format "s-%d" i)) .
                                             (lambda ()
                                               (interactive)
                                               (exwm-workspace-switch-create ,i))))
                                         (number-sequence 0 9))

    			       ,@(cl-mapcar (lambda (c n)
                             `(,(kbd (format "s-%c" c)) .
                               (lambda ()
                                 (interactive)
                                 (exwm-workspace-move-window ,n)
                                 (exwm-workspace-switch ,n))))
                           '(?\) ?! ?@ ?# ?$ ?% ?^ ?& ?* ?\()
                           ;; '(?\= ?! ?\" ?# ?¤ ?% ?& ?/ ?\( ?\))
                           (number-sequence 0 9))

    			     )))
                     (unless (get 'exwm-input-simulation-keys 'saved-value)
                       (setq exwm-input-simulation-keys
                             '(([?\C-b] . [left])
                               ([?\C-f] . [right])
                               ([?\C-p] . [up])
			       ([?\C-s] . ?\C-f)
                               ([?\C-n] . [down])
                               ([?\C-a] . [home])
                               ([?\C-e] . [end])
                               ([?\M-v] . [prior])
                 	      
                               ([?\C-v] . [next])
                 		  ([?\C-y] . ?\C-v)
                 		  ([?\M-w] . ?\C-c)
                 		  ([?\M-a] . ?\C-a)
                               ([?\C-d] . [delete])
                               ([?\C-k] . [S-end delete])

    )))
                     
                        ;; Bind keys for brightness control
                        (exwm-input-set-key (kbd "<XF86MonBrightnessUp>") 'increase-brightness)
                        (exwm-input-set-key (kbd "<XF86MonBrightnessDown>") 'decrease-brightness)

               	 (exwm-input-set-key (kbd "<print>") 'flameshot)
                        ;; Bind keys for volume control
                        (exwm-input-set-key (kbd "<XF86AudioRaiseVolume>") 'increase-volume)
                        (exwm-input-set-key (kbd "<XF86AudioLowerVolume>") 'decrease-volume)
                        (exwm-input-set-key (kbd "<XF86AudioMute>") 'toggle-volume)

(defun run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun exwm-update-class ()
    (exwm-workspace-rename-buffer exwm-class-name))

  (defun exwm-update-title ()
    (pcase exwm-class-name
      ("Firefox" (exwm-workspace-rename-buffer (format "Firefox: %s" exwm-title)))))
  
(add-hook 'exwm-update-class-hook #'exwm-update-class)

;; When window title updates, use it to set the buffer name
(add-hook 'exwm-update-title-hook #'exwm-update-title)

(require 'exwm-randr)

    (exwm-randr-enable)
            (setq exwm-workspace-show-all-buffers t)
        (setq exwm-randr-workspace-monitor-plist '(2 "eDP1" 3 "HDMI2"))


            (defun update-displays ()
            (run-in-background "autorandr --change --force")
            (set-wallpaper)
            (message "Display config: %s"
                     (string-trim (shell-command-to-string "autorandr --current"))))

(defun set-wallpaper ()
  (interactive)
  ;; NOTE: You will need to update this to a valid background path!
  (start-process-shell-command
      "feh" nil  "feh --bg-tile ~/Pictures/wal2.png"))

(use-package exwm-modeline
      :after (exwm))
    (add-hook 'exwm-init-hook #'exwm-modeline-mode)
           (setq exwm-systemtray-height 16)
    
(setq mouse-autoselect-window t
      focus-follows-mouse t)

           (exwm-init))

(defun my-get-volume-level ()
  "Fetches the current volume level using pamixer."
  (when (not (null user-exwm))
    (shell-command-to-string "pamixer --get-volume-human")))

(defun my-add-volume-indicator-to-mode-line ()
  "Adds a volume indicator to the mode line if user-exwm is not nil."
  (let ((volume-level (my-get-volume-level)))
    (setq mode-line-format
          (append mode-line-format
                  (list (concat "  " volume-level))))))

(my-add-volume-indicator-to-mode-line)

(use-package consult
  :if user-consult
    ;; Replace bindings. Lazily loaded by `use-package'.
    :bind (;; C-c bindings in `mode-specific-map'
           ("C-c M-x" . consult-mode-command)
           ("C-c h" . consult-history)
           ("C-c k" . consult-kmacro)
           ("C-c m" . consult-man)
           ("C-c i" . consult-info)

           ([remap Info-search] . consult-info)
           ;; C-x bindings in `ctl-x-map'
           ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
           ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
           ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
           ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
           ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
           ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
           ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
           ;; Custom M-# bindings for fast register access
           ("M-#" . consult-register-load)
           ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
           ("C-M-#" . consult-register)
           ;; Other custom bindings
           ("M-y" . consult-yank-pop)                ;; orig. yank-pop
           ;; M-g bindings in `goto-map'
           ("M-g e" . consult-compile-error)
           ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
           ("M-g g" . consult-goto-line)             ;; orig. goto-line
           ("M-g o" . consult-org-heading)               ;; Alternative: consult-org-heading
           ("M-g m" . consult-mark)
           ("M-g k" . consult-global-mark)
           ("M-g i" . consult-imenu)
           ("M-g I" . consult-imenu-multi)
           ;; M-s bindings in `search-map'
           ("M-s d" . consult-find)                  ;; Alternative: consult-fd
           ("M-s c" . consult-locate)
           ("M-s g" . consult-grep)
           ("M-s G" . consult-git-grep)
           ("M-s r" . consult-ripgrep)
           ("M-s l" . consult-line)
           ("M-s L" . consult-line-multi)
           ("M-s k" . consult-keep-lines)
           ("M-s u" . consult-focus-lines)
           ;; Isearch integration
           ("M-s e" . consult-isearch-history)
           :map isearch-mode-map
           ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
           ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
           ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
           ;; Minibuffer history
           :map minibuffer-local-map
           ("M-s" . consult-history)                 ;; orig. next-matching-history-element
)                ;; orig. previous-matching-history-element

    ;; Enable automatic preview at point in the *Completions* buffer. This is
    ;; relevant when you use the default completion UI.
    :hook (completion-list-mode . consult-preview-at-point-mode)

    ;; The :init configuration is always executed (Not lazy)
    :init

    ;; Optionally configure the register formatting. This improves the register
    ;; preview for `consult-register', `consult-register-load',
    ;; `consult-register-store' and the Emacs built-ins.
    (setq register-preview-delay 0.5
          register-preview-function #'consult-register-format)

    ;; Optionally tweak the register preview window.
    ;; This adds thin lines, sorting and hides the mode line of the window.
    (advice-add #'register-preview :override #'consult-register-window)

    ;; Use Consult to select xref locations with preview
    (setq xref-show-xrefs-function #'consult-xref
          xref-show-definitions-function #'consult-xref)

    ;; Configure other variables and modes in the :config section,
    ;; after lazily loading the package.
    :config

    ;; Optionally configure preview. The default value
    ;; is 'any, such that any key triggers the preview.
    ;; (setq consult-preview-key 'any)
    ;; (setq consult-preview-key "M-.")
    ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
    ;; For some commands and buffer sources it is useful to configure the
    ;; :preview-key on a per-command basis using the `consult-customize' macro.
    (consult-customize
     consult-theme :preview-key '(:debounce 0.2 any)
     consult-ripgrep consult-git-grep consult-grep
     consult-bookmark consult-recent-file consult-xref
     consult--source-bookmark consult--source-file-register
     consult--source-recent-file consult--source-project-recent-file
     ;; :preview-key "M-."
     :preview-key '(:debounce 0.4 any))

    ;; Optionally configure the narrowing key.
    ;; Both < and C-+ work reasonably well.
    (setq consult-narrow-key "<") ;; "C-+"

    ;; Optionally make narrowing help available in the minibuffer.
    ;; You may want to use `embark-prefix-help-command' or which-key instead.
    ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
  )

(use-package which-key
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.1)
  (which-key-setup-side-window-right))

(setq use-short-answers t)

(use-package spacious-padding
  :custom
  (line-spacing 2)
  :init
  (spacious-padding-mode 1))

(use-package mixed-pitch
  :hook
  (text-mode . mixed-pitch-mode))

(setq split-width-threshold 120
      split-height-threshold nil)

(use-package balanced-windows
  :config
  (balanced-windows-mode))

(use-package helpful
  :bind
  (("C-h f" . helpful-function)
   ("C-h x" . helpful-command)
   ("C-h k" . helpful-key)
   ("C-h v" . helpful-variable)))

(add-hook 'text-mode-hook 'visual-line-mode)

(use-package org
    :custom
    (org-startup-indented t)
    (org-hide-emphasis-markers t)
    (org-startup-with-inline-images t)
    (org-image-actual-width '(450))
    (org-fold-catch-invisible-edits 'error)
    (org-pretty-entities t)
    (org-use-sub-superscripts "{}")
    (org-id-link-to-org-use-id t)
    (org-fold-catch-invisible-edits 'show))


(use-package org-fragtog
  :after org
  :hook
  (org-mode . org-fragtog-mode)
  :custom
  (org-startup-with-latex-preview nil)
  (org-format-latex-options
   (plist-put org-format-latex-options :scale 2)
   (plist-put org-format-latex-options :foreground 'auto)
   (plist-put org-format-latex-options :background 'auto)))

(use-package org-modern
  :hook
  (org-mode . org-modern-mode)
  :custom
  (org-modern-table nil)
  (org-modern-keyword nil)
  (org-modern-timestamp nil)
  (org-modern-priority nil)
  (org-modern-checkbox nil)
  (org-modern-tag nil)
  (org-modern-block-name nil)
  (org-modern-keyword nil)
  (org-modern-footnote nil)
  (org-modern-internal-target nil)
  (org-modern-radio-target nil)
  (org-modern-statistics nil)
  (org-modern-progress nil))

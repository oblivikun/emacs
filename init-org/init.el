



(defun efs/display-startup-time ()
      (message "Emacs loaded in %s with %d garbage collections."
  	       (format "%.2f seconds"
  		       (float-time
  		       (time-subtract after-init-time before-init-time)))
  	       gcs-done))
(defun gc-restore ()
  (setq gc-cons-threshold 1200000))
     (add-hook 'emacs-startup-hook #'gc-restore)
    (add-hook 'emacs-startup-hook #'efs/display-startup-time)
    (straight-use-package 'use-package)
      (setq inhibit-startup-message t)
  (use-package straight
    :custom
    
(setq straight-check-for-modifications 'live-with-find)

    (straight-use-package-by-default t))
      (add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setenv "IN_EMACS" "1")

;; (use-package keycast
;;   :config
;;   (keycast-tab-bar-mode))

(use-package treemacs
  :after (dashboard ivy)
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

(use-package dashboard
  :defer nil
:config
   (dashboard-setup-startup-hook)
   ;; Set the title
   (setq dashboard-banner-logo-title "Oblivikun Emacs")
   ;; Set the banner
   (setq dashboard-startup-banner 'official)

   (setq dashboard-center-content t)
  (setq dashboard-display-icons-p t)     ; display icons on both GUI and terminal
  (setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
   ;; vertically center content
   ; use `nerd-icons' package
  (setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)

(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
 (setq dashboard-vertically-center-content t))

(use-package hydra
  :after (ivy dashboard)
  :defer t
  )

(use-package doom-modeline
 :ensure t
 :hook (after-init . doom-modeline-mode))

(use-package company
 :defer t
 :hook (prog-mode . company-mode)
 :config
 (setq-default
    company-idle-delay 0
    company-require-match nil
    ;; also get a drop down
    company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)))

(use-package slime
  :after (lsp-mode ivy counsel)
 :defer t
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
  :after (ivy counsel)
  :defer t
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
  :after (lsp-mode)
 :defer t
 :hook (lsp-mode . lsp-ui-mode))

;; if you are ivy user
(use-package lsp-ivy
  :after (lsp-mode)
  :defer t
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
 :after (org)
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
  (use-package org-bullets
    :defer nil
    :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
  (add-hook 'org-mode-hook 'visual-line-mode)

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
   :demand t
:config
(global-undo-tree-mode)
)

(use-package elcord
 :defer 20
 :hook (prog-mode . elcord-mode)
 :config
 ;; Additional configuration can go here if needed
 )

(use-package auctex
:defer 20

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
  :defer t
  :after (treemacs ivy)
  )

(setq nnmail-treat-duplicates t)
(use-package gnus
  :defer t
  )

  (setq message-send-mail-function 'smtpmail-send-it)

;; (use-package epa-file
;; (epa-file-enable)

(use-package org-mime
   :after (org gnus)
 :defer t
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
          (lambda ()
            (org-mime-change-element-style
             "pre" (format "color: %s; background-color: %s; padding: 0.5em;"
                           "#E6E1DC" "#232323"))))

(add-hook 'org-mime-html-hook
          (lambda ()
            (org-mime-change-element-style
             "blockquote" "border-left: 2px solid gray; padding-left: 4px;")))

(use-package dianyou
  :after (org gnus)
  :defer tpetersen_mickey_mastering_emacs.pdf
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
  :after (treemacs ivy counsel)
  :config
  (projectile-mode +1)

(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-indexing-method 'native)
(setq projectile-completion-system 'ivy)
(setq projectile-file-exists-remote-cache-expire (* 5 60))
(setq projectile-require-project-root t))

(defun select-line ()
 (interactive)
 (let ((delete-selection-mode t))
    (beginning-of-line)
    (set-mark-command nil)
    (end-of-line)
    (setq delete-selection-mode nil))) 
(global-set-key (kbd "C-c l") 'select-line)

(use-package ivy
    :defer nil
   :config
   (ivy-mode 1)
   (setq ivy-use-virtual-buffers t)
   (setq enable-recursive-minibuffers t))

(use-package counsel
 :after (ivy)
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
  :after (treemacs)
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

(use-package doom-themes
  :defer 10
  )
(defun switch-theme-based-on-time ()
  (interactive)
  (let ((current-hour (string-to-number (format-time-string "%H"))))
    (cond ((and (>= current-hour 20) (<= current-hour 23))
           (disable-theme t)
           (load-theme 'doom-solarized-dark-high-contrast t))
          ((and (>= current-hour 9) (<= current-hour 19))
           (disable-theme t)
           (load-theme 'doom-solarized-light t))
          ;; Removed the condition for 8 AM to 9 AM
          (t ;; This is the else clause
           (disable-theme t)
           (load-theme 'doom-solarized-dark-high-contrast t)))) ;; Load the default theme if none of the conditions are met
  )

    ;; Schedule the theme switch function to run every hour
    (run-at-time "00:00" (* 60 60) 'switch-theme-based-on-time)

(use-package guru-mode
:defer nil
:config
(guru-global-mode +1))

(use-package auto-compile
)
(use-package company-quickhelp
  :after (lsp-mode lsp-ui ivy counsel company)
  :hook (company-mode . company-quickhelp-mode))
(use-package go-mode
  :after (lsp-mode lsp-ui ivy counsel company))
(display-time-mode)
(use-package lsp-haskell
  :after (lsp-mode lsp-ui haskell-mode ivy counsel company))
(use-package haskell-mode
   :defer 20
  :after (lsp-mode lsp-ui ivy counsel company))

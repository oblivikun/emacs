 ;;; package -- summary
;;; Commentary:
;;; Code:


(setq initial-major-mode 'fundamental-mode)
(setq initial-scratch-message 'nil)
(setq jit-lock-stealth-time nil)
(setq jit-lock-defer-time nil)
(setq jit-lock-defer-time 0.05)
(setq jit-lock-stealth-load 200)
 (setq gc-cons-threshold most-positive-fixnum)
(setq custom-safe-themes t)
(use-package gcmh :defer t)
(require 'package
 (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
 ;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t
 )
(add-hook 'emacs-startup-hook
	      (lambda ()
	        (setq gc-cons-threshold  most-positive-fixnum)
	        (require 'gcmh)
		            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                             (time-subtract after-init-time before-init-time)))
                     gcs-done)
		;; (load-theme 'gruvbox-dark-medium) i now embrace light theme
		(load-theme 'gruvbox-light-medium)
	        (gcmh-mode 1)))

(setq inhibit-startup-message t)

(global-display-line-numbers-mode t)
(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))


(setenv "IN_EMACS" "1")
(use-package keycast
  :ensure t
  :config
  (keycast-tab-bar-mode))
(use-package treemacs
 :ensure t
 :config
 (progn
    ;; Your custom configurations here
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))
    (treemacs-hide-gitignored-files-mode nil)))



  
(use-package dashboard
 :ensure t
 :config
 (dashboard-setup-startup-hook)
 ;; Set the title
 (setq dashboard-banner-logo-title "Oblivikun Emacs")
 ;; Set the banner
 (setq dashboard-startup-banner (expand-file-name "branding/logo.png" user-emacs-directory))

 (setq dashboard-center-content t)
(setq dashboard-display-icons-p t)     ; display icons on both GUI and terminal
(setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
 ;; vertically center content
 ; use `nerd-icons' package
(setq dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
 (setq dashboard-vertically-center-content t))
(global-set-key (kbd "M-0") 'treemacs)


(use-package hydra
  :defer t
  :ensure t
  )
;;powerline

(use-package spaceline
 :ensure t
 :config
 (spaceline-spacemacs-theme))

(global-company-mode t)
(use-package company
    :defer t 
    :config
    (global-company-mode t)
    (setq-default
        company-idle-delay 0.05
        company-require-match nil
        company-minimum-prefix-length 0
        ;; also get a drop down
        company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend)
))

(use-package lsp-mode
  :defer 2
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
	 (haskell-mode . lsp)
         ;; if you want which-key integration
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

;; optionally
(use-package lsp-ui
:defer 2
  :commands lsp-ui-mode)

;; if you are ivy user
(use-package lsp-ivy
:defer 2
  :commands lsp-ivy-workspace-symbol)


;; optionally


;; open terminal keybind(
(defun open-terminal-at-bottom ()
 "Split the window and open a terminal in the new window, taking only a quarter of the screen."
 (interactive)
 (let ((height (window-body-height)))
   (split-window-below (- height (/ height 4)))) ; height of top window is 1/2 of the frame height
 (other-window 1)
 (term "/bin/ksh"))
(global-set-key (kbd "C-c t") 'open-terminal-at-bottom)
;; close terminal at bottom
(defun close-terminal-at-bottom ()
 "Close the terminal window at the bottom or the current window if it's a terminal."
 (interactive)
 (let ((current-window (selected-window)))
    (if (eq 'term-mode (buffer-local-value 'major-mode (window-buffer current-window)))
        ;; If the current window is a terminal, close it.
        (delete-window current-window)
      ;; If the current window is not a terminal, check if there's a terminal window below.
      (when (and (window-live-p (next-window))
                 (eq 'term-mode (buffer-local-value 'major-mode (window-buffer (next-window)))))
        (delete-window (next-window))))))

(global-set-key (kbd "C-c q") 'close-terminal-at-bottom)

;; Enable Org mode for .org files

(use-package org
  :defer t
 :ensure t
 :config
 (setq org-todo-keywords
       '((sequence "TODO" "IN-PROGRESS" "DONE")))
 (setq org-todo-keyword-faces
       '(("TODO" :foreground "red" :weight bold)
         ("IN-PROGRESS" :foreground "yellow" :weight bold)
         ("DONE" :foreground "green" :weight bold))))



;;Make Org mode the default for .org files
;;This line is usually the default in recent Emacs versions
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(use-package org-roam
  :defer t
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
;; Make Emacs Bearable
(defun loadup-gen ()
 "Generate the lines to include in the lisp/loadup.el file
to place all of the libraries that are loaded by your InitFile
into the main dumped emacs"
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


(defun dump-load-path ()
  (interactive)
  (with-temp-buffer
    (insert (prin1-to-string `(setq load-path ',load-path)))
    (fill-region (point-min) (point-max))
    (write-file "~/.emacs.d/load-path.el")))

(defun dump-emacs ()
  "Dump current Emacs config."
  (interactive)
  (shell-command "emacs --batch -l ~/.edump -eval '(dump-load-path)' -eval '(dump-emacs-portable \"~/emacs.dump\")'"))

;; org keybinds
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

(use-package undo-tree
 :ensure t
 :config
 (global-undo-tree-mode))



(add-to-list 'load-path "/home/erel/.emacs.d/codeium.el")
(use-package codeium
  :init
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
  )
(use-package elcord
 :defer t
 :ensure t
 :commands elcord-mode
 :config
 (elcord-mode))


(add-to-list 'load-path "/home/erel/.emacs.d/aggressive-indent-mode")
;; agenda
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
(use-package flycheck
  :ensure t
  :defer 2
  :config
  (flycheck-define-checker ascii-spell
  "A spell checker using Ispell or Aspell."
  :command ("aspell" "--list")
  :error-patterns
  ((error line-start
          (file-name) ":" line-end
          "spell-error" (message) line-end))
  :modes (text-mode))
  (add-to-list 'flycheck-checkers 'ascii-spell)
  (global-flycheck-mode)
  )
;; spell checking
;; Load AUCTeX
(load "auctex.el" nil t t)

;; Set AUCTeX to automatically parse the document and enable PDF mode
(setq-default TeX-master nil)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-PDF-mode t)

;; Disable automatic display of compilation log
(setq TeX-show-compilation nil)

;; Add makeglossaries to the TeX command list for easy management of glossaries
(eval-after-load "tex" '(add-to-list 'TeX-command-list
                     '("Makeglossaries" "makeglossaries %s" TeX-run-command nil
                       (latex-mode)
                       :help "Run makeglossaries script, which will choose xindy or makeindex") t))

;; Customize font-lock for AUCTeX to improve readability
(font-lock-add-keywords 'latex-mode (list (list "\\(«\\(.+?\\|\n\\)\\)\\(+?\\)\\(»\\)" '(1 'font-latex-string-face t) '(2 'font-latex-string-face t) '(3 'font-latex-string-face t))))

;; Set up RefTeX for better reference management
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'latex-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(add-hook 'LaTeX-mode-hook (function (lambda() (bind-key "C-c C-r" 'reftex-query-replace-document))))
(add-hook 'LaTeX-mode-hook (function (lambda() (bind-key "C-c C-g" 'reftex-grep-document))))
(add-hook 'TeX-mode-hook (lambda () (reftex-isearch-minor-mode)))

;; Define a function to delete the current macro in AUCTeX
(defun TeX-remove-macro ()
 "Remove current macro and return `t'. If no macro at point, return 'nil'."
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
;; IRC 
(setq rcirc-track-ignore-server-buffer-flag t)
(rcirc-track-minor-mode 1)
(setq alert-default-style 'libnotify)
(setq rcirc-notify-message "message from %s")

(use-package magit
  :defer t
  )
(setq message-send-mail-function 'smtpmail-send-it)
;; GNUS
;; @see https://github.com/redguardtoo/mastering-emacs-in-one-year-guide/blob/master/gnus-guide-en.org
;; gnus-group-mode
(use-package org-mime
 :ensure t
 :config
 (require 'org-mime)
 ;; Set the mail library based on your mail client
 ;; For Gnus, this is set by default
 (setq org-mime-library 'mml)
 ;; For Wanderlust (WL), use 'semi
 ;; (setq org-mime-library 'semi)
 ;; For VM, use 'vm (not yet supported)
 ;; (setq org-mime-library 'vm)
 )
(defun my-insert-html-signature ()
 (let ((signature "<div style=\"display: block; white-space: nowrap; border: 1px solid #000; text-decoration: underline;\">
    Best regards, Your Name Your Position Your Company
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
  :defer t
  :ensure t
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
       ("G" dianyou-group-make-nnir-group)
       ("g" gnus-group-get-new-news)
       ("^" gnus-group-enter-server-mode)
       ("m" gnus-group-new-mail)
       ("#" gnus-topic-mark-topic)
       ("q" nil))
     ;; y is not used by default
     (define-key gnus-group-mode-map "y" 'hydra-gnus-group/body)))

;; gnus-summary-mode
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
     ;; y is not used by default
     (define-key gnus-summary-mode-map "y" 'hydra-gnus-summary/body)))

;; gnus-article-mode
(eval-after-load 'gnus-art
  '(progn
     (defhydra hydra-gnus-article (:color blue)
       "
[_o_] Save attachment        [_F_] Forward
[_v_] Play video/audio       [_r_] Reply
[_d_] CLI to download stream [_R_] Reply with original
[_b_] Open external browser  [_w_] Reply all (S w)
[_f_] Click link/button      [_W_] Reply all with original (S W)
[_g_] Focus link/button
"
       ("F" gnus-summary-mail-forward)
       ("r" gnus-article-reply)
       ("R" gnus-article-reply-with-original)
       ("w" gnus-article-wide-reply)
       ("W" gnus-article-wide-reply-with-original)
       ("q" nil))
     ;; y is not used by default
     (define-key gnus-article-mode-map "y" 'hydra-gnus-article/body)))

;; message-mode
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
;; Git
(setq magit-define-global-key-bindings nil)
;; tab bar
(tab-bar-mode)
;; Projectile
(use-package projectile
  :defer t
  :ensure t
  :config
  (projectile-mode +1)
;; Recommended keymap prefix on Windows/Linux
 (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
 (setq projectile-indexing-method 'native)
 (setq projectile-completion-system 'ivy)
 (setq projectile-file-exists-remote-cache-expire (* 5 60))
 (setq projectile-require-project-root t))

;; IVY
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; (global-set-key "\C-s" 'swiper) I HAtE SWIPER
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
;; Wind Move
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)


(use-package treemacs-nerd-icons
  :config
  (treemacs-load-theme "nerd-icons"))
;; Discord
(defun open-discord-in-buffer ()
 "Open Discord in a new buffer without focusing on it."
 (interactive)
 (let ((discord-buffer (get-buffer-create "*Discord*")))
    (shell-command "discordo" nil discord-buffer)
    (display-buffer discord-buffer nil)))

(use-package exwm
  :defer t
 :if (and (display-graphic-p)
           (executable-find "wmctrl")
           (not (get-buffer "*window-manager*")))
 :config
 (shell-command "wmctrl -m ; echo $?" "*window-manager*" "*window-manager-error*")
 (when (and (get-buffer "*window-manager-error*")
             (eq window-system 'x))
    (exwm-config-example)))


(global-set-key (kbd "C-x C-k") 'kill-current-buffer)



(use-package system-packages
  :defer t
  :config
 (setq system-packages-use-sudo t)
 (setq system-packages-package-manager 'emerge))

;; For writing org files, change nyxt to browser of choice
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

(with-eval-after-load "org"
 (define-key org-mode-map (kbd "C-c C-o") org-export-to-html-and-open-in-nyxt-map))


(add-hook 'markdown-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c C-o") 'markdown-export-to-html-and-open-in-nyxt)))
(use-package indent-guide
 :ensure t
 :hook (python-mode . indent-guide-mode)
 :config
 (set-face-background 'indent-guide-face "gray")) ; Set the color of the indent guides


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(codeium/metadata/api_key "f41f1615-8f88-453d-bb87-5a6bc3e329bf")
 '(custom-safe-themes
   '("3e374bb5eb46eb59dbd92578cae54b16de138bc2e8a31a2451bf6fdb0f3fd81b" "72ed8b6bffe0bfa8d097810649fd57d2b598deef47c992920aef8b5d9599eefe" "d80952c58cf1b06d936b1392c38230b74ae1a2a6729594770762dc0779ac66b7" "2ff9ac386eac4dffd77a33e93b0c8236bb376c5a5df62e36d4bfa821d56e4e20" default))
 '(package-selected-packages
   '(gmail2bbdb ivy-hydra use-package-hydra indent-guide grip-mode org-preview-html which-key keycast treemacs-tab-bar bbdb- counsel-bbdb all-the-icons-gnus spaceline-all-the-icons octicons all-the-icons-ivy all-the-icons-nerd-fonts org-roam-ui nerd-icons-dired nerd-icons-completion nerd-icons-ivy-rich gruvbox-dark-medium gruvbox-themes gcmh snapshot-timemachine project-treemacs treemacs-projectile treemacs-nerd-icons company-jedi counsel exwm system-packages restart-emacs org-download undo-tree haskell-snippets ivy projectile magit rcirc-notify elcord auctex flycheck org-agenda-files-track-ql org-agenda-property org-agenda-files-track org-contrib dashboard aggressive-indent spaceline powerline lsp-haskell lsp-latex lsp-ui gruvbox-theme company))
 '(send-mail-function 'mailclient-send-it))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)

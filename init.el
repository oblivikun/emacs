;;; package -- summary
;;; Commentary:
;;; Code:
(setq gc-cons-threshold-original gc-cons-threshold)
(setq gc-cons-threshold (* 2048 2048 200)) ; Increase threshold

(run-with-idle-timer
 5 nil
 (lambda ()
   (setq gc-cons-threshold gc-cons-threshold-original) ; Reset to original value
   (makunbound 'gc-cons-threshold-original)))

(setq inhibit-startup-message t)

(global-display-line-numbers-mode t)
(add-hook 'treemacs-mode-hook (lambda() (display-line-numbers-mode -1)))
(setq custom-safe-themes t)


(require 'package
 (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
 (package-initialize))
(setenv "IN_EMACS" "1")
(use-package treemacs
 :ensure t
 :defer t
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
 (setq dashboard-startup-banner 'logo)
 (setq dashboard-center-content t)
;; vertically center content
 (setq dashboard-vertically-center-content t))


(global-set-key (kbd "M-0") 'treemacs)


;;powerline

(use-package spaceline
 :ensure t
 :config
 (spaceline-emacs-theme))

(global-company-mode t)
(use-package company
    :defer 0.1
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
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (XXX-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally

(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
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
 :ensure t
 :config
 (setq org-todo-keywords
       '((sequence "TODO" "IN-PROGRESS" "DONE")))
 (setq org-todo-keyword-faces
       '(("TODO" :foreground "red" :weight bold)
         ("IN-PROGRESS" :foreground "yellow" :weight bold)
         ("DONE" :foreground "green" :weight bold))))

;; Make Org mode the default for .org files
;; This line is usually the default in recent Emacs versions
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

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




(use-package lsp-ui
 :commands lsp-ui-mode
 :config
 (setq lsp-ui-sideline-enable t)
 (setq lsp-ui-doc-enable t)
 (setq lsp-ui-sideline-show-hover t)
 (setq lsp-ui-sideline-show-code-actions t)
 (setq lsp-ui-sideline-update-mode 'line)
 (lsp-ui-mode))

(add-to-list 'load-path "/home/erel/.emacs.d/codeium.el")
(use-package codeium
  :init
  (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
  )
(use-package elcord
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

;; spell checking
(global-flycheck-mode)
(flycheck-define-checker ascii-spell
  "A spell checker using Ispell or Aspell."
  :command ("aspell" "--list")
  :error-patterns
  ((error line-start
          (file-name) ":" line-end
          "spell-error" (message) line-end))
  :modes (text-mode))
(add-to-list 'flycheck-checkers 'ascii-spell)
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
;; MPD

(add-hook 'mpc-mode-hook
 (lambda ()
   (keymap-local-set "M-p"        'windmove-up)
   (keymap-local-set "M-n"        'windmove-down)
   (keymap-local-set "M-b"        'windmove-left)
   (keymap-local-set "M-f"        'windmove-right)
   (keymap-local-set "C-<return>" 'mpc-play-at-point)
   (keymap-local-set "<SPC>"      'mpc-toggle-play)
   (keymap-local-set "s"          'mpc-toggle-shuffle)
   (keymap-local-set "n"          'next-line)
   (keymap-local-set "p"          'previous-line)
   (keymap-local-set "f"          'mpc-next)
   (keymap-local-set "b"          'mpc-prev)))

;; Git
(setq magit-define-global-key-bindings nil)
;; tab bar
(tab-bar-mode)
;; Projectile
(projectile-mode +1)
;; Recommended keymap prefix on Windows/Linux
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-indexing-method 'native)
(setq projectile-file-exists-remote-cache-expire (* 5 60))
(setq projectile-require-project-root t)
;; IVY
(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; Wind Move
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)
(use-package winum
 :ensure t
 :config
 (winum-set-keymap-prefix (kbd "C-c"))
 (winum-mode))

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
 :if (and (display-graphic-p)
           (executable-find "wmctrl")
           (not (get-buffer "*window-manager*")))
 :config
 (shell-command "wmctrl -m ; echo $?" "*window-manager*" "*window-manager-error*")
 (when (and (get-buffer "*window-manager-error*")
             (eq window-system 'x))
    (exwm-config-example)))


(global-set-key (kbd "C-x C-k") 'kill-current-buffer)

;; THEME
(add-hook 'emacs-startup-hook
          (lambda ()
            (load-theme 'gruvbox-dark-medium)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(codeium/metadata/api_key "f41f1615-8f88-453d-bb87-5a6bc3e329bf")
 '(custom-safe-themes
   '("72ed8b6bffe0bfa8d097810649fd57d2b598deef47c992920aef8b5d9599eefe" "d80952c58cf1b06d936b1392c38230b74ae1a2a6729594770762dc0779ac66b7" "2ff9ac386eac4dffd77a33e93b0c8236bb376c5a5df62e36d4bfa821d56e4e20" default))
 '(package-selected-packages
   '(exwm system-packages project-treemacs restart-emacs org-download undo-tree treemacs-nerd-icons treemacs-projectile haskell-snippets ivy projectile magit rcirc-notify elcord auctex flycheck org-agenda-files-track-ql org-agenda-property org-agenda-files-track org-contrib dashboard aggressive-indent spaceline powerline lsp-haskell lsp-latex treemacs lsp-ui gruvbox-theme company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

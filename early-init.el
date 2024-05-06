
  (setq default-buffer-file-coding-system 'utf-8)
  (setq initial-major-mode 'fundamental-mode)
  (setq initial-scratch-message 'nil)
  (setq custom-safe-themes t)

(setq load-prefer-newer noninteractive)
(setq gc-cons-threshold #x160000000)
(setq use-package-always-defer t)
(setq package-enable-at-startup nil)
  (setq auto-mode-case-fold nil)
  (setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
;; (when (featurep 'native-compile)
;;   ;; Set the right directory to store the native compilation cache
;;   (let ((path (expand-file-name "eln-cache/" user-emacs-directory)))
;;     (setq-default native-comp-eln-load-path       (list path)
;;                   native-compile-target-directory path)
;;     (when (fboundp 'startup-redirect-eln-cache)
;;       (startup-redirect-eln-cache path)))
;;   (setq-default native-comp-async-report-warnings-errors nil  ;; Silence compiler warnings as they can be pretty disruptive
;;                 native-comp-deferred-compilation         t    ;; Make native compilation happens asynchronously
;;                 package-native-compile                   t)   ;; Compile installed packages
;;   )
(setq-default byte-compile-warnings     '(not obsolete)
      frame-resize-pixelwise    t  ;; Default frame configuration: full screen
      inhibit-startup-message   t
      load-prefer-newer         t  ;; Prefer loading newest compiled .el file
      package-enable-at-startup t
      warning-suppress-log-types '((comp) (bytecomp))
)
;;(setq gc-cons-threshold most-positive-fixnum)

    (unless noninteractive
      ;; PERF: Resizing the Emacs frame (to accommodate fonts that are smaller or
      ;;   larger than the system font) appears to impact startup time
      ;;   dramatically. The larger the delta, the greater the delay. Even trivial
      ;;   deltas can yield up to a ~1000ms loss, depending on font size and
      ;;   `window-system'. PGTK seems least affected and NS/MAC the most.
  ;;    (setq-default inhibit-redisplay t
    ;;                inhibit-message t)
        (put 'site-run-file 'initial-value site-run-file))
      (setq site-run-file nil)
;;(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))

;; use proper .cache folder for eln-cache
 (setq package-user-dir (string-replace ".config" ".cache" package-user-dir))
;; (setcar native-comp-eln-load-path
  ;;     
;; The traditional dance of calming down the garbage collector during init,
;; as that improves startup times. Taken from Doom Emacs [1].
;; [1]: https://github.com/hlissner/doom-emacs/blob/develop/docs/faq.org#how-does-doom-start-up-so-quickly

;; Wait till init to start emacs packages
;(setq package-enable-at-startup nil)


;;(setq package-enable-at-startup nil)

;; max memory available for gc when opening minibuffer

(setq load-prefer-newer noninteractive)


(defvar me/-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist me/-file-name-handler-alist)))

;; Fill whatever space the window manager has given us.
(setq frame-resize-pixelwise t)

;; ;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; ;; font. By inhibiting this, we easily halve startup times with fonts that are
;; ;; larger than the system default.

(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)

(setq inhibit-compacting-font-caches t)

;; Font settings
;; default to utf-8 for all the things
;; (set-charset-priority 'unicode)
;; (setq locale-coding-system 'utf-8
;;   coding-system-for-read 'utf-8
;;   coding-system-for-write 'utf-8)
;; (set-terminal-coding-system 'utf-8)
;; (set-keyboard-coding-system 'utf-8)
;; (set-selection-coding-system 'utf-8)
;; (prefer-coding-system 'utf-8)
;; (setq default-process-coding-system '(utf-8-unix . utf-8-unix))


;; ;; Set default font

  ;;		            (message "Emacs ready in %s with %d garbage collections."
    ;;                   (format "%.2f seconds"
  	 ;;                      (float-time
       ;;                        (time-subtract after-init-time before-init-time)))
  		  ;;     gcs-done)
  		  ;; (load-theme 'gruvbox-dark-medium) i now embrace light theme
  		  ;; (load-theme 'gruvbox-light-medium t)
 
;; Choose a fallback with size comparible to Terminus so that we don't break
;; vterm.

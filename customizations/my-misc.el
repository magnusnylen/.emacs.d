;; Misc
(prefer-coding-system 'utf-8)
(global-linum-mode 1)
(show-paren-mode 1)
(blink-cursor-mode 0)
(global-hl-line-mode 1)

(setq column-number-mode t)
(setq inhibit-startup-screen t)
(setq scroll-bar-mode nil)
(setq size-indication-mode t)
(setq tool-bar-mode nil)

;; Default font
(set-default-font "DejaVu Sans Mono-14")

;; Spaces only (no tab characters at all)!
(setq-default indent-tabs-mode nil)

;; Stop creating ~ files
(setq make-backup-files nil) 

;; Theming
(load-theme 'deeper-blue)
;; PC
;; (setq initial-frame-alist '((top . 15) (left . 400) (width . 160) (height . 60)))
;; MB
;; (setq initial-frame-alist '((top . 50) (left . 250) (width . 140) (height . 55)))
;; Office PC
;; (setq initial-frame-alist '((top . 50) (left . 150) (width . 160) (height . 40)))

;; neotree
(global-set-key [f8] 'neotree-toggle)

;; Fix path so Emacs can find programs/utils
;; (add-to-list 'exec-path "C:/opt/cygwin64/bin")

;; Default directory is ${HOME}
(setq default-directory (concat (getenv "HOME") "/"))

;; Fix Mac's right alt key
;; (setq ns-right-alternate-modifier nil)

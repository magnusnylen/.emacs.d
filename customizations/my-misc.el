;; Misc
(prefer-coding-system 'utf-8)
(global-linum-mode 1)
(show-paren-mode t)
(blink-cursor-mode nil)
(global-hl-line-mode 1)

(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)

(column-number-mode t)
(scroll-bar-mode -1)
(size-indication-mode t)
(tool-bar-mode -1)

;; Default font
(set-default-font "DejaVu Sans Mono-14")

;; Spaces only (no tab characters at all)!
(setq-default indent-tabs-mode nil)

;; Stop creating ~ files
(setq make-backup-files nil) 

;; Theming
(load-theme 'deeper-blue)

;; neotree
(global-set-key [f8] 'neotree-toggle)

;; Enable company mode globally
(global-company-mode)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

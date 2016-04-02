;; https://github.com/emacs-helm/helm

(require 'helm)
(require 'helm-swoop)
(require 'helm-config)
(require 'helm-themes)

;; Use C-j default, or replace with below:
;;(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(helm-mode 1)
(helm-autoresize-mode 1)

(setq helm-mode-fuzzy-match t)
(setq helm-completion-in-region-fuzzy-match t)
(setq helm-M-x-fuzzy-match t)
;; For helm-mini:
;;(setq helm-buffers-fuzzy-matching t
;;      helm-recentf-fuzzy-match t)

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x m") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

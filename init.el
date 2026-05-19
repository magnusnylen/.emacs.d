;;; init.el --- Emacs init file -*- lexical-binding: t; -*-
;;; Commentary:
;; Personal Emacs configuration.
;;; Code:

;; ------------------------------------------------------------------
;; References:
;; - https://github.com/emacs-tw/awesome-emacs
;; ------------------------------------------------------------------

;; ------------------------------------------------------------------
;; Basic  settings
;; ------------------------------------------------------------------

(when (display-graphic-p)
  (tool-bar-mode -1)
  (set-frame-font "CaskaydiaMono NF 15" nil t))
(menu-bar-mode -1)
(setq inhibit-startup-screen t initial-buffer-choice  nil)
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)
(global-display-line-numbers-mode 1)

;; ------------------------------------------------------------------
;; Straight
;; ------------------------------------------------------------------

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         (or (bound-and-true-p straight-base-dir) user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)
(setq straight-use-package-by-default t)
(straight-use-package 'use-package)

;; ------------------------------------------------------------------
;; Inherit correct PATH
;; ------------------------------------------------------------------

(use-package exec-path-from-shell
  :straight t
  :if (memq window-system '(x))
  :config
  (setq exec-path-from-shell-variables
	'("PATH"
	  "MANPATH"
	  "SSH_AUTH_SOCK"
	  "GPG_AGENT_INFO"
	  "LANG"))
  (exec-path-from-shell-initialize))

;; ------------------------------------------------------------------
;; Theme(s)
;; ------------------------------------------------------------------

;; (load-theme 'wombat t)
;; (load-theme 'modus-vivendi-deuteranopia)

(use-package dracula-theme
  :straight t
  :init (load-theme 'dracula t))

;; ------------------------------------------------------------------
;; Misc packages and settings
;; ------------------------------------------------------------------

(use-package vertico
  :straight (vertico :files (:defaults "extensions/*"))
  :init (vertico-mode))

(use-package vertico-posframe
  :after vertico
  :hook (after-init . vertico-posframe-mode)
  :custom (vertico-posframe-poshandler #'posframe-poshandler-frame-center))

(custom-set-variables
 '(vertico-count 15)
 '(vertico-resize nil)
 '(vertico-cycle t))

(use-package orderless
  :straight t
  :custom (completion-styles '(orderless))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :straight t
  :config (marginalia-mode))

(straight-use-package 'yaml-mode)

(straight-use-package 'nftables-mode)

(use-package company
  :straight t
  :config
  (global-company-mode)
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 2)
  (setq company-show-numbers t))

(use-package company-box
  :straight t
  :if (display-graphic-p)
  :after company
  :hook (company-mode . company-box-mode))

;; ------------------------------------------------------------------
;; Eglot, languages..., Flycheck
;; ------------------------------------------------------------------

;; go install golang.org/x/tools/gopls@latest
;; go install honnef.co/go/tools/cmd/staticcheck@latest
;; npm install -g typescript typescript-language-server
;; npm install -g bash-language-server

;; (use-package flycheck
;;   :hook (prog-mode . flycheck-mode))

;; ------------------------------------------------------------------

(provide 'init)

;;; init.el ends here

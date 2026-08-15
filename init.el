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

(tool-bar-mode -1)
(menu-bar-mode -1)
;; (add-to-list 'default-frame-alist '(font . "CaskaydiaMono NF-13"))
(setq inhibit-startup-screen t
      initial-buffer-choice nil
      ring-bell-function 'ignore
      make-backup-files nil)
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
  :if (or (daemonp) (memq window-system '(x pgtk ns mac)))
  :config
  (setq exec-path-from-shell-variables
	'("PATH"
	  "MANPATH"
	  "SSH_AUTH_SOCK"
	  "LANG"))
  (exec-path-from-shell-initialize))

;; ------------------------------------------------------------------
;; Theme(s)
;; ------------------------------------------------------------------

;; (use-package dracula-theme
;;  :straight t
;;  :init (load-theme 'dracula t))

(use-package modus-themes
  :straight t
  :demand t
  :bind
  (("<f5>" . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  (setq modus-themes-to-toggle '(modus-operandi modus-vivendi)
        modus-themes-to-rotate modus-themes-items
        modus-themes-mixed-fonts t
        modus-themes-variable-pitch-ui t
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-headings
        '((agenda-structure . (variable-pitch light 2.2))
          (agenda-date . (variable-pitch regular 1.3))
          (t . (regular 1.15))))

  (modus-themes-include-derivatives-mode 1)
  (modus-themes-load-theme 'modus-vivendi-deuteranopia))

;; ------------------------------------------------------------------
;; Misc packages and settings
;; ------------------------------------------------------------------

;; JSON via built-in tree-sitter mode (Emacs 29+), no package needed
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsonc\\'" . json-ts-mode))

(use-package orderless
  :straight t
  :demand t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil))

(use-package vertico
  :straight (vertico :files (:defaults "extensions/*"))
  :init (vertico-mode)
  :custom
  (vertico-count 20)
  (vertico-resize nil)
  (vertico-cycle t))

(use-package vertico-posframe
  :after vertico
  :hook (after-init . vertico-posframe-mode)
  :custom (vertico-posframe-poshandler #'posframe-poshandler-frame-center))

(use-package marginalia
  :straight t
  :config (marginalia-mode))

(use-package yaml-mode
  :straight t)

(use-package nftables-mode
  :straight t)

(use-package company
  :straight t
  :config
  (global-company-mode)
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 2)
  (setq company-show-numbers t))

(use-package company-box
  :straight t
  :after company
  :hook (company-mode . company-box-mode))

;; ------------------------------------------------------------------
;; TODO: Eglot, languages..., Flycheck
;; ------------------------------------------------------------------

;; go install golang.org/x/tools/gopls@latest
;; go install honnef.co/go/tools/cmd/staticcheck@latest
;; npm install -g typescript typescript-language-server
;; npm install -g bash-language-server

;; ------------------------------------------------------------------

(provide 'init)

;;; init.el ends here

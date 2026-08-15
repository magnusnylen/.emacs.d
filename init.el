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
(if (member "CaskaydiaMono NF" (font-family-list))
    (add-to-list 'default-frame-alist '(font . "CaskaydiaMono NF-13"))
  (add-to-list 'default-frame-alist '(font . "monospace-13")))
(setq inhibit-startup-screen t
      initial-buffer-choice nil
      ring-bell-function 'ignore
      make-backup-files nil)
(global-display-line-numbers-mode 1)

;; ------------------------------------------------------------------
;; Straight
;; ------------------------------------------------------------------

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
;; Theme
;; ------------------------------------------------------------------

(use-package modus-themes
  :straight t
  :demand t
  :bind (("<f5>"     . modus-themes-rotate)
	 ("C-<f5>"   . modus-themes-select)
	 ("M-<f5>"   . modus-themes-load-random))
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

(use-package marginalia
  :straight t
  :config (marginalia-mode))

(use-package yaml-mode
  :straight t)

(use-package nftables-mode
  :straight t)

(use-package corfu
  :straight t
  :init (global-corfu-mode)
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.25)
  (corfu-auto-prefix 2))

(use-package consult
  :straight t
  :bind (("C-x b"   . consult-buffer)
         ("C-s"     . consult-line)
         ("C-M-l"   . consult-imenu)
         ("C-x C-r" . consult-recent-file)
         ("C-c M-x" . consult-mode-command)))

(use-package embark
  :straight t
  :bind (("C-." . embark-act)
         ("M-." . embark-dwim)))

(use-package embark-consult
  :straight t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; ------------------------------------------------------------------
;; Languages: Go, TypeScript, Bash (Eglot + Flymake)
;; ------------------------------------------------------------------

;; Install servers (all on PATH via exec-path-from-shell):
;;   Go tools install to /home/magnus/opt/go/bin (on PATH):
;;     GOBIN=/home/magnus/opt/go/bin go install golang.org/x/tools/gopls@latest
;;     GOBIN=/home/magnus/opt/go/bin go install honnef.co/go/tools/cmd/staticcheck@latest
;;   npm tools install to the nvm bin (on PATH):
;;     npm install -g typescript typescript-language-server bash-language-server

;; Built-in tree-sitter modes for supported languages
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.sh\\'" . bash-ts-mode))

;; LSP via built-in Eglot + Flymake (no Flycheck package needed)
(use-package eglot
  :defer t
  :hook (go-ts-mode        . eglot-ensure)
  (typescript-ts-mode . eglot-ensure)
  (tsx-ts-mode        . eglot-ensure)
  (bash-ts-mode       . eglot-ensure)
  :custom
  (eglot-events-buffer-size 0)
  (eglot-autoshutdown t)
  :config
  (define-key eglot-mode-map (kbd "C-c r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c a") #'eglot-code-actions)
  (add-to-list 'completion-at-point-functions #'eglot-completion-at-point)
  (setq eglot-workspace-configuration
        '((gopls . ((staticcheck . t)
                    (completeUnimported . t)
                    (usePlaceholders . t)
                    (directoryFilters
                     . ["-**/node_modules" "-**/vendor" "-**/third_party"]))))))

;; ------------------------------------------------------------------

(provide 'init)

;;; init.el ends here

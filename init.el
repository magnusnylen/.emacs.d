;; ------------------------------------------------------------------
;; Save Customize data to a separate file so Emacs never writes
;; custom-* blocks into this init file.
;; ------------------------------------------------------------------

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

;; ------------------------------------------------------------------
;; Basic  settings
;; ------------------------------------------------------------------

(tool-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-screen t
      initial-buffer-choice nil
      ring-bell-function 'ignore
      make-backup-files nil)
(global-display-line-numbers-mode 1)

;; Set font the robust way
(defun my/set-font ()
  "Set font if CaskaydiaMono NF is available."
  (when (display-graphic-p)
    (let ((font (if (member "CaskaydiaMono NF" (font-family-list))
                    "CaskaydiaMono NF-13"
                  "monospace-13")))
      (add-to-list 'default-frame-alist `(font . ,font))
      (set-frame-font font nil t))))
;; Apply now if GUI is available
(when (display-graphic-p)
  (my/set-font))
;; Apply to future frames (critical for daemon mode)
(add-hook 'after-make-frame-hook #'my/set-font)

;; ------------------------------------------------------------------
;; Package management (vanilla package.el)
;; ------------------------------------------------------------------

(require 'package)
(setq package-enable-at-startup nil
      package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/"))
      ;; Prefer GNU ELPA (a package available in more than one archive
      ;; is taken from the highest-priority one, without prompting).
      package-archive-priorities '(("gnu" . 10) ("nongnu" . 5) ("melpa" . 0)))
(package-initialize)

;; :ensure installs a package (and its dependencies) when missing.
;; Only packages explicitly marked :ensure are fetched -- the libraries
;; Emacs ships built-in (eglot, project, xref, seq, ...) are left to
;; Emacs, so no duplicate-feature conflicts can occur.
(require 'use-package-ensure)

;; ------------------------------------------------------------------
;; Inherit correct PATH
;; ------------------------------------------------------------------

(use-package exec-path-from-shell
  :ensure t
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
  :ensure t
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

(add-to-list 'auto-mode-alist '("\\.jsonc?\\'" . json-ts-mode))

(use-package which-key
  :ensure t
  :demand t
  :config (which-key-mode 1))

(use-package yaml-mode
  :ensure t)

(use-package nftables-mode
  :ensure t)

(use-package orderless
  :ensure t
  :demand t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil))

(use-package vertico
  :ensure t
  :init (vertico-mode)
  :custom
  (vertico-count 20)
  (vertico-resize nil)
  (vertico-cycle t))

(use-package marginalia
  :ensure t
  :config (marginalia-mode))

(use-package company
  :ensure t
  :config
  (global-company-mode)
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-show-numbers t))

;; ------------------------------------------------------------------
;; Languages: Go, TypeScript, Bash (Eglot + Flymake)
;; ------------------------------------------------------------------

;; Install servers (all on PATH via exec-path-from-shell):
;;   Go tools install:
;;     go install golang.org/x/tools/gopls@latest
;;     go install honnef.co/go/tools/cmd/staticcheck@latest
;;   npm tools install:
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
  (typescript-ts-mode . (lambda () (setq-local indent-tabs-mode nil tab-width 2)))
  (tsx-ts-mode        . (lambda () (setq-local indent-tabs-mode nil tab-width 2)))
  :custom
  (eglot-events-buffer-size 0)
  (eglot-autoshutdown t)
  :config
  (define-key eglot-mode-map (kbd "C-c r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c =") #'eglot-format)
  (add-to-list 'completion-at-point-functions #'eglot-completion-at-point)
  (setq eglot-workspace-configuration
        '((gopls . ((staticcheck . t)
                    (completeUnimported . t)
                    (usePlaceholders . t)
                    (directoryFilters
                     . ["-**/node_modules" "-**/vendor" "-**/third_party"]))))))

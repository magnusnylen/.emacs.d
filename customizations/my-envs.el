;; Default directory is ${HOME}
(setq default-directory (concat (getenv "HOME") "/"))

;; PC
;; (setq initial-frame-alist '((top . 15) (left . 400) (width . 160) (height . 60)))
;; MB
;; (setq initial-frame-alist '((top . 45) (left . 220) (width . 160) (height . 55)))
;; Office PC
;; (setq initial-frame-alist '((top . 50) (left . 150) (width . 160) (height . 40)))

;; Fix path so Emacs can find programs/utils
;; (add-to-list 'exec-path "C:/opt/cygwin64/bin")

;; Fix Mac's right alt key
;; (setq ns-right-alternate-modifier nil)

;; Take care of Mac OS X PATH
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

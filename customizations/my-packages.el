(require 'package)

(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;;(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;;(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/") t)

(package-initialize)

(defvar my-packages)

(setq my-packages '(;;ac-cider
		    ;;auto-complete                    
		    cider
		    clojure-mode
                    company
		    helm
		    helm-swoop
		    helm-themes
		    magit
		    neotree
                    rainbow-delimiters))

(when (not package-archive-contents)
  (package-refresh-contents))

(dolist (package my-packages)
  (when (not (package-installed-p package))
    (package-install package)))

;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here, run 'doom sync' on
;; the command line, then restart Emacs for the changes to take effect.
;; Alternatively, use M-x doom/reload.


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a particular repo, you'll need to specify
;; a `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, for whatever reason,
;; you can do so here with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))
(package! color-theme-sanityinc-tomorrow :recipe (:host github :repo "purcell/color-theme-sanityinc-tomorrow"))
;; (package! org-sidebar :recipe (:host github :repo "alphapapa/org-sidebar"))
;; (package! demo-it)
(package! ivy-posframe :recipe (:host github :repo "tumashu/ivy-posframe"))
(package! eaf :recipe (:host github :repo "manateelazycat/emacs-application-framework"
                       :files ("*.el" "app" "core" "*.py")))
;; (package! calfw :recipe (:host github :repo "kiwanami/emacs-calfw"))
(package! w3m)
(package! sx)
(package! elfeed)
(package! command-log-mode)
(package! ytel)
(package! impatient-mode)
;; (package! theme-magic) ;;Get your emacs themes on the terminal
(package! doct)
(package! org-mime)
(package! bash-completion :disable t)
(package! org-pandoc-import
  :recipe (:host github
           :repo "tecosaur/org-pandoc-import"
           :files ("*.el" "filters" "preprocessors")))
(package! ox-pandoc :recipe (:host github :repo "kawabata/ox-pandoc"))
;(package! emojify)
;(package! dired-hacks :recipe (:host github :repo "Fuco1/dired-hacks"))
;(package! centered-cursor-mode :recipe (:host github :repo "andre-r/centered-cursor-mode.el"))
(package! org-alert :recipe (:host github :repo "spegoraro/org-alert"))
;;                              :files ("org-alert.el")))
;; (package! cstby/solo-jazz-emacs-theme :recipe (:host github :repo "cstby/solo-jazz-emacs-theme"))
;; (package! org-super-agenda :recipe (:host github :repo "alphapapa/org-super-agenda"))
(package! org-ql :recipe (:host github :repo "alphapapa/org-ql"))
;; (package! company-tabnine :recipe (:host github :repo "TommyX12/company-tabnine"
;;                                    :files ("*.el" "*.sh")))
(package! aggressive-indent :recipe (:host github :repo "Malabarba/aggressive-indent-mode"))
(package! lsp-java :recipe (:host github :repo "emacs-lsp/lsp-java"))
(package! dap-mode)
;; (package! emacs-everywhere :recipe (:host github :repo "tecosaur/emacs-everywhere"))
(package! autothemer :recipe (:host github :repo "jasonm23/autothemer"))
(package! shx-for-emacs :recipe (:host github :repo "riscy/shx-for-emacs"))
(package! hledger-mode)

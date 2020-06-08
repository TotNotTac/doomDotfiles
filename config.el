;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Silas de Jong"
      user-mail-address "silas.de.jong@hva.nl")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;;*
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;;;User variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq evil-escape-key-sequence nil
      treemacs-position 'right
      neo-window-position 'left
      neo-window-width 30
      ;; neo-autorefresh t
      )

(setq +pretty-code-symbols '(:name "»"
                             :src_block "»"
                             :src_block_end "«"
                             :quote "“"
                             :quote_end "”"
                             :lambda "λ"
                             :def "ƒ"
                             :defun "ƒ"
                             :composition "∘"
                             :map "↦"
                             :null "∅"
                             :not "￢"
                             :in "∈"
                             :not-in "∉"
                             :and "∧"
                             :or "∨"
                             :for "∀"
                             :some "∃"
                             :tuple "⨂"
                             :pipe ""
                             :dot "•"))

;; Switch to the new window after splitting
(setq evil-split-window-below nil
      evil-vsplit-window-right t)

;; Popup rules

(set-popup-rule! "\\*doom:vterm-popup.*" :side 'right :size 0.3)

;; Mysql
(setq sql-mysql-options '("-s" "--protocol" "tcp" "-P" "3306"))

;;;User functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'sql-interactive-mode-hook 'yas-minor-mode-on)

;; Winum neotree settings
(defun winum-assign-0-to-neotree ()
  (when (string-match-p ".*NeoTree.*" (buffer-name)) 0))


(defun tot/neotree-toggle-function ()
  (interactive)
  (if (neo-global--window-exists-p)
      (if (string-match-p ".\\*NeoTree\\*.*" (buffer-name))
          (neotree-hide)
        ;; else
        (winum-select-window-0))
    ;; else
    (+neotree/open)
    ))

(setq winum-assign-functions '(winum-assign-0-to-neotree))
(setq winum-auto-assign-0-to-minibuffer nil)

(defun tot/save-and-kill-buffer ()
  "Save a buffer before killing"
  (interactive)
  (unless (string-match-p ".*\\*.*\\*.*" (buffer-name))
    (save-buffer))
  (kill-buffer))

(defun tot/kill-buffer-and-close-window ()
  "Kill and save buffer, then close the window"
  (interactive)
  (tot/save-and-kill-buffer)
  (delete-window))

(defun tot/window-split-smart ()
  "Splits window into two. It'll split so the difference between the height and the width of a window is as small as possible"
  (interactive)
  (if (> (window-pixel-height) (window-pixel-width))
      ;; then
      (evil-window-split)
    ;; else
    (evil-window-vsplit)
    ))

;; EShell
(defun tot/eshell-other-window ()
  "Open EShell in another window"
  (interactive)
  (tot/window-split-smart)
  (eshell))

(defun tot/eshell-insert-at-beginning ()
   "Goes to the beginning of prompt and goes into insert mode"
   (interactive)
   (when (eq major-mode 'eshell-mode)
     (eshell-bol)
     (evil-insert-line)))

(defalias 'eshell/o 'find-file)
(defalias 'eshell/sp 'find-file-other-window)

(defun tot/insert-filename ()
  (interactive)
  (counsel--find-file-1
 "Find file: " ""
 'insert
 'test))

(defmacro tot/ivy-read-and-execute (prompt collection &rest args)
  "Wrapper around `ivy-read', except for the COLLECTION is an alist
where the first entry is the selection for `ivy-read' and the second
is a form that will be evaulated if that option is selected.

E.g. (ivy-read-and-execute \"Say \" ((\"hi\" (message \"Hi\"))
                                    (\"bye\" (message \"Bye\"))))
If the you select `hi' then you get the message `Hi'
"
  `(pcase (ivy-read ,prompt ',collection ,@args)
     ,@collection))

;;;User keybindings;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(map!
 :nvime
 "M-n" #'evil-buffer-new
 "M-w" #'tot/save-and-kill-buffer
 "C-M-n" #'+workspace/new
 "C-M-w" #'+workspace/delete
 "M-N" #'tot/window-split-smart
 "M-W" #'evil-window-delete
 "M-i" #'er/expand-region

 (:leader
  "b x" #'tot/kill-buffer-and-close-window
  "p !" #'projectile-run-async-shell-command-in-root
  "o c" #'cfw:open-org-calendar)

 :ni

 "M-f" #'avy-goto-word-1

 (:map org-mode-map
  :localleader
  "s" #'org-sidebar-tree-toggle
  "RET" #'org-sidebar-tree-jump)

 (:map org-agenda-mode-map
  "M-l" #'org-agenda-later
  "M-h" #'org-agenda-earlier)

 (:map yas-minor-mode-map
  :i
  "C-SPC" #'yas-expand)

 ;; Quick window switching with Meta-0..9
 "M-1" 'winum-select-window-1
 "M-2" 'winum-select-window-2
 "M-3" 'winum-select-window-3
 "M-4" 'winum-select-window-4
 "M-5" 'winum-select-window-5
 "M-6" 'winum-select-window-6
 "M-7" 'winum-select-window-7
 "M-8" 'winum-select-window-8
 "M-9" 'winum-select-window-9
 "M-0" #'tot/neotree-toggle-function

 (:leader ;; Backup keybindings for in terminal mode
  "1" 'winum-select-window-1
  "2" 'winum-select-window-2
  "3" 'winum-select-window-3
  "4" 'winum-select-window-4
  "5" 'winum-select-window-5
  "6" 'winum-select-window-6
  "7" 'winum-select-window-7
  "8" 'winum-select-window-8
  "9" 'winum-select-window-9)

 ;; Quick workspace switch with Shift+Meta-0..9
 "C-M-1" '+workspace/switch-to-0
 "C-M-2" '+workspace/switch-to-1
 "C-M-3" '+workspace/switch-to-2
 "C-M-4" '+workspace/switch-to-3
 "C-M-5" '+workspace/switch-to-4
 "C-M-6" '+workspace/switch-to-5
 "C-M-7" '+workspace/switch-to-6
 "C-M-8" '+workspace/switch-to-7
 "C-M-9" '+workspace/switch-to-8
 "C-M-0" '+workspace/switch-to-9

 (:leader
  "b c" #'tot/save-and-kill-buffer
  "/" #'swiper
  "?" #'+ivy/project-search

  "o t" #'tot/eshell-other-window
  "o T" #'eshell))

(add-hook 'eshell-mode-hook
          (lambda ()
            (add-to-list 'eshell-visual-commands "htop")

            (map! :map eshell-mode-map
                  :n
                  "I" #'tot/eshell-insert-at-beginning
                  :ni
                  "M->" #'lispy-slurp
                  "M-<" #'lispy-barf
                  "M-]" #'lispy-forward
                  "M-[" #'lispy-backward
                  "M-DEL" #'lispy-delete-backward)))


;;;Package configuration;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; eclim
(after! 'eclim
  (setq eclim-executable "/home/silas/.eclipse/org.eclipse.platform_4.15.0_155965261_linux_gtk_x86_64/eclimd"
        eclimd-autostart t))

;;;Hooks;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'delete-frame-hook '+workspace/delete)
(add-hook 'emacs-startup-hook 'org-agenda-list)

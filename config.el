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

(setq evil-escape-key-sequence nil)

;; Switch to the new window after splitting
(setq evil-split-window-below nil
      evil-vsplit-window-right t)

;; Popup rules

(set-popup-rule! "\\*doom:vterm-popup.*" :side 'right :size 0.3)

;;;User functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Winum neotree settings
(defun winum-assign-0-to-neotree ()
  (when (string-match-p (buffer-name) ".*\\*NeoTree\\*.*") 0))

(defun tot/neotree-toggle-function ()
  (interactive)
  (if (neo-global--window-exists-p)
      (if (string-match-p (buffer-name) ".\\*NeoTree\\*.*")
          (neotree-hide)
        ;; else
        (winum-select-window-0))
    ;; else
    (+neotree/open)
    ))

(setq winum-assign-functions '(winum-assign-0-to-neotree))
(defun tot/save-and-kill-buffer ()
  "Save a buffer before killing"
  (interactive)
  (unless (string-match-p ".*\\*.*\\*.*" (buffer-name))
    (save-buffer))
  (kill-buffer))

(defun tot/window-split-smart ()
  "Splits window into two. It'll split so the difference between the height and the width of a window is as small as possible"
  (interactive)
  (if (> (window-pixel-height) (window-pixel-width))
      ;; then
      (evil-window-split)
    ;; else
    (evil-window-vsplit)
    ))

;;;User keybindings;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(map!
 ;; Yasnippet
 :ni
 "C-SPC" #'yas-expand

 :nvime
 "M-n" #'evil-buffer-new
 "M-w" #'tot/save-and-kill-buffer
 "C-M-n" #'+workspace/new
 "C-M-w" #'+workspace/delete
 "M-N" #'tot/window-split-smart
 "M-W" #'evil-window-delete

 (:map org-agenda-mode-map
   "M-l" #'org-agenda-later
   "M-h" #'org-agenda-earlier)

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
 "M-0" 'tot/neotree-toggle-function

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
   "?" #'+ivy/project-search))

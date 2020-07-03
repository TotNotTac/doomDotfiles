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
(setq doom-theme 'doom-dracula)
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

;; Eshell
(add-hook
 'eshell-mode-hook
 (lambda ()
   (setq pcomplete-cycle-completions nil)))

;; Capture templates
(after! org
  (push '("s" "Schedule" entry (file+olp+datetree "~/org/agenda.org")
          "* %?\nSCHEDULED %T" :time-prompt t)
        org-capture-templates))

;; w3m
(map! :map w3m-mode-map
      :i
      "j" #'w3m-next-anchor
      "k" #'w3m-previous-anchor
      "K" #'w3m-scroll-down
      "J" #'w3m-scroll-up
      "/" #'evil-search-forward
      "?" #'evil-search-backward
      "n" #'evil-search-next
      "N" #'evil-search-previous
      "M-/" #'swiper)

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
      (split-window-below)
    ;; else
    (split-window-right)
    ))

;; SX mode
(defun tot/sx/display-question ()
  (interactive)
  (delete-other-windows)
  (sx-question-mode--display
   (tabulated-list-get-id)
   (tot/window-split-smart)))

(defun tot/sx/search-stackoverflow (query)
  (interactive "sSearch query: ")

  (sx-search "stackoverflow" query))

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

(defun tot/make-mc-in-selection (start end)
  (interactive "r")
  (evil-exit-visual-state)
  (goto-char start)
  (let (
        (match-pos start)
        (regex-string (read-string "regex: ")))
    (ignore-errors
      (re-search-forward regex-string)
      (while (<= (point) end)
        (left-char)
        (evil-mc-make-cursor-here)
        (right-char)
        (re-search-forward regex-string))))
  (evil-mc-skip-and-goto-prev-cursor))

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

(defmacro tot/add-digit-argument-def (name digit)
  `(defun ,name (&optional arg)
    (interactive "P")
    (when arg
      (mapc (lambda (x)
              (setq unread-command-events (nconc unread-command-events (list x)))
              )
            (string-to-vector (number-to-string arg))
            ))
    (setq unread-command-events (nconc unread-command-events (list ,digit))))
  )

(defun diff-last-two-kills (&optional diff)
  "Diff last couple of things in the kill-ring. With prefix open ediff."
  (interactive "P")
  (let* ((old "/tmp/old-kill")
         (new "/tmp/new-kill")
         (prev-ediff-quit-hook ediff-quit-hook))
    (cl-flet ((kill-temps
               ()
               (dolist (f (list old new))
                 (kill-buffer (find-buffer-visiting f)))
               (setq ediff-quit-hook prev-ediff-quit-hook)))
      (with-temp-file new
        (insert (current-kill 0 t)))
      (with-temp-file old
        (insert (current-kill 1 t)))
      (if (not diff)
          (progn
            (add-hook 'ediff-quit-hook #'kill-temps)
            (ediff old new))
        (diff old new "-u" t)))))

(defalias 'diff-last-two-clipboard-items 'diff-last-two-kills)

;; (defun tot/add-digit-argument (&optional arg)
;;   (interactive "P")
;;   (when arg
;;     (mapc (lambda (x)
;;             (setq unread-command-events (nconc unread-command-events (list x)))
;;             )
;;           (string-to-vector (number-to-string arg))
;;           ))
;;   (setq unread-command-events (nconc unread-command-events (list 49))))

(progn
  (tot/add-digit-argument-def tot/add-digit-argument-1 49)
  (tot/add-digit-argument-def tot/add-digit-argument-2 50)
  (tot/add-digit-argument-def tot/add-digit-argument-3 51)
  (tot/add-digit-argument-def tot/add-digit-argument-4 51)
  (tot/add-digit-argument-def tot/add-digit-argument-5 52)
  (tot/add-digit-argument-def tot/add-digit-argument-6 53)
  (tot/add-digit-argument-def tot/add-digit-argument-7 54)
  (tot/add-digit-argument-def tot/add-digit-argument-8 55)
  (tot/add-digit-argument-def tot/add-digit-argument-9 56)
  (tot/add-digit-argument-def tot/add-digit-argument-0 57))

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
  "S" #'org-sidebar-tree-toggle
  "RET" #'org-sidebar-tree-jump)

 (:map org-agenda-mode-map
  "M-l" #'org-agenda-later
  "M-h" #'org-agenda-earlier)

 (:map yas-minor-mode-map
  :i
  "C-SPC" #'yas-expand)

 (:map ranger-mode-map
 "M-1" 'winum-select-window-1
 "M-2" 'winum-select-window-2
 "M-3" 'winum-select-window-3
 "M-4" 'winum-select-window-4
 "M-5" 'winum-select-window-5
 "M-6" 'winum-select-window-6
 "M-7" 'winum-select-window-7
 "M-8" 'winum-select-window-8
 "M-9" 'winum-select-window-9)

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
  "s s" #'tot/sx/search-stackoverflow)
 :v
 "s" #'tot/make-mc-in-selection)

(map! :map sx-question-list-mode-map
      :n
      "RET" #'tot/sx/display-question
      :ni
      "TAB" #'other-window
      "q" #'kill-current-buffer)

(map! :map sx-question-mode-map
      :ni
      "q" #'kill-buffer-and-window
      "TAB" #'other-window
      :i
      "k" #'sx-question-mode-previous-section
      "j" #'sx-question-mode-next-section)

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

;; (use-package eaf
;;   :load-path "/usr/share/emacs/site-lisp/eaf")

(use-package spotify
  :load-path "/home/silas/repositories/spotify.el"
  :config
  (load! "personal.el")
  (define-key spotify-mode-map (kbd "C-c .") 'spotify-command-map))

;; (defhydra spotify-hydra-main (:color green :hint nil)
;;   "
;; Current track: % -28`spotify-player-status

;; ^Tracks^                       ^Playback^               ^Search
;; ^^^^────────────────────────────────────────────
;; _h_: previous track            _j_:   volume down       _t_: Track
;; _l_: next track                _k_:   volume up         _p_: Playlists
;; _a_: add track to playlist     _SPC_: toggle playback   _P_: Personal playlists
;;  "
;;   ("h" spotify-previous-track :exit (not hydra-prefix-arg))
;;   ("l" spotify-next-track :exit (not hydra-prefix-arg))
;;   ("j" spotify-volume-down)
;;   ("k" spotify-volume-up)
;;   ("t" spotify-track-search :exit (not hydra-prefix-arg))
;;   ("p" spotify-playlist-search :exit t)
;;   ("P" spotify-my-playlists :exit t)
;;   ("a" spotify-track-add :exit t)
;;   ("SPC" spotify-toggle-play :exit (not hydra-prefix-arg)))

(defhydra spotify-hydra-main (:color green :hint nil)
  ""
  ("h" spotify-previous-track "Previous" :exit (not hydra-prefix-arg) :column "Tracks")
  ("l" spotify-next-track "Next" :exit (not hydra-prefix-arg) :column "Tracks")
  ("SPC" spotify-toggle-play "Toggle" :exit (not hydra-prefix-arg) :column "Playback")
  ("j" spotify-volume-down "Volume down" :column "Playback")
  ("k" spotify-volume-up "Volume up" :column "Playback")
  ("t" spotify-track-search "Search" :exit (not hydra-prefix-arg) :column "Tracks")
  ("p" spotify-playlist-search "Search" :exit t :column "Playlists")
  ("P" spotify-my-playlists "My playlists" :exit t :column "Playlists")
  ("a" spotify-track-add "Add to playlist" :exit t :column "Playlists"))


(defun tot/display-spotify-hydra (&optional arg)
  (interactive "P")
  (setq hydra-prefix-arg arg)
  (spotify-hydra-main/body))


(map!
 :leader "o s" 'tot/display-spotify-hydra)


;;;Hooks;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'delete-frame-hook '+workspace/delete)
(add-hook 'emacs-startup-hook 'org-agenda-list)

(remove-hook! '(org-mode-hook
               markdown-mode-hook
               TeX-mode-hook
               rst-mode-hook
               mu4e-compose-mode-hook
               message-mode-hook
               git-commit-mode-hook)
             #'flyspell-mode)

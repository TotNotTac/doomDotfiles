(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(elfeed-feeds
   '("https://feeds.nos.nl/nosnieuwsalgemeen" "https://www.youtube.com/feeds/videos.xml?channel_id=UCVw8WSz1c_cazwOA0Yk_P_w"))
 '(org-startup-folded 'show2levels)
 '(safe-local-variable-values
   '((eval org-babel-execute-buffer)
     (compile-command "make exec")
     (haskell-font-lock-quasi-quote-modes
      ("hsx" . html-mode)
      ("hamlet" . shakespeare-hamlet-mode)
      ("shamlet" . shakespeare-hamlet-mode)
      ("whamlet" . shakespeare-hamlet-mode)
      ("xmlQQ" . xml-mode)
      ("xml" . xml-mode)
      ("cmd" . shell-mode)
      ("sh_" . shell-mode)
      ("jmacro" . javascript-mode)
      ("jmacroE" . javascript-mode)
      ("json" . json-mode)
      ("aesonQQ" . json-mode)
      ("parseRoutes" . haskell-yesod-parse-routes-mode))
     (haskell-font-lock-quasi-quote-modes)
     (haskell-process-type . ghci)
     (cider-shadow-cljs-default-options . "app")
     (haskell-process-use-ghci . t)
     (haskell-indent-spaces . 4)
     (eval progn
      (tide-mode)
      (tide-restart-server))
     (eval setq lsp-clients-angular-language-server-command
      (let
          ((curr-proj-root
            (projectile-project-root)))
        `("node" ,(concat curr-proj-root "node_modules/@angular/language-server")
          "--ngProbeLocations" ,(concat curr-proj-root "node_modules")
          "--tsProbeLocations" ,(concat curr-proj-root "node_modules")
          "--stdio")))
     (haskell-compile-command "nix-build && result/bin/app")))
 '(send-mail-function 'mailclient-send-it)
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 25)
 '(warning-suppress-log-types '((after-save-hook)))
 '(warning-suppress-types '((doom-switch-buffer-hook))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-branch-current ((t (:box (:line-width (2 . 2) :color "black")))))
 '(magit-head ((t (:box nil :inherit magit-branch-local))))
 '(org-modern-statistics ((t (:inherit org-checkbox-statistics-todo))))
 '(ts-fold-replacement-face ((t (:foreground nil :box nil :inherit font-lock-comment-face :weight light)))))

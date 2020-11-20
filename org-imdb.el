(require 'dom)

(defun org-imdb-capture-title ()
  "Reads for an Imdb title. If there's more than one possible canditate, ask the user to make a selction. Returns a formatted org-mode string"
  (let* ((query (read-string "Imdb title: "))
         (dom (with-current-buffer (url-retrieve-synchronously (concat "https://www.imdb.com/find?q=" query "&s=tt&ref_=fn_al_tt_mr"))
                (libxml-parse-html-region (point-min) (point-max))))
         (canditates (mapcar (lambda (x) `(,(string-trim (dom-texts x)) .
                                      ,(concat "https://www.imdb.com" (dom-attr (dom-by-tag x 'a) 'href))))
                             (dom-children (dom-by-class dom "^findList$"))))
         (url (cdr (assoc (completing-read "Select a candidate: " canditates nil t (downcase query))
                          canditates)))
         (recipe (org-imdb-fetch-url url)))
    (org-imdb-get-org-recipe-string recipe)))

(defun org-imdb-capture-url ()
  "Reads for an Imdb url. Returns a formatted org-mode string"
  (let* ((url (read-string "imdb url: "))
         (recipe (org-imdb-fetch-url url)))
    (org-imdb-get-org-recipe-string recipe)))

(defun org-imdb-get-org-recipe-string (recipe)
  "Builds the recipe in a temporary buffer. Returns the formatted org-mode string"
  (with-temp-buffer (org-mode)
                    (org-imdb-insert-recipe recipe)
                    (buffer-string)))

(defun org-imdb-fetch-url (url)
  "Fetch movie properties of imdb url"

  (with-current-buffer (url-retrieve-synchronously url)
    (let ((dom (libxml-parse-html-region (point-min) (point-max))))

      `((title . ,(string-trim (dom-text (dom-by-tag (dom-by-class dom "^title_wrapper$")
                                                     'h1))))
        (url . ,(progn url))
        (time . ,(string-trim (dom-text (dom-by-tag (dom-by-class dom "^title_block$")
                                                    'time))))
        (genres . ,(mapcar (lambda (x) (car (last x)))
                           (seq-filter (lambda (x) (string-match "^/search/title\\?genres" (dom-attr x 'href)))
                                       (dom-by-tag (dom-by-class (dom-by-class dom "^title_block$")
                                                                 "^subtext$")
                                                   'a))))

        (rating . ,(dom-text (dom-by-tag (dom-by-tag (dom-by-class dom "^ratingValue$") 'strong)
                                         'span)))
        (summary . ,(string-trim (dom-texts (dom-by-class (dom-by-class dom "^plot_summary")
                                                          "^summary_text$"))))))))

(defun org-imdb-insert-recipe (recipe)
  "Inserts RECIPE"
  (org-insert-heading)
  (insert (cdr (assoc 'title recipe)))
  (org-return)
  (org-set-property "url" (cdr (assoc 'url recipe)))
  (org-set-property "time" (cdr (assoc 'time recipe)))
  (org-set-property "rating" (cdr (assoc 'rating recipe)))
  (org-insert-subheading t)
  (insert "genres")
  (org-return)
  (mapcar (lambda (x) (progn (insert (format "%s " (string-trim x))) ;; stolen from https://github.com/Chobbes/org-chef/blob/master/org-chef-utils.el#L56
                        (org-cycle)
                        (org-delete-backward-char 1)
                        (org-ctrl-c-minus)
                        (org-return)))
          (cdr (assoc 'genres recipe)))
  (org-insert-heading)
  (insert "Summary")
  (org-return)
  (insert (cdr (assoc 'summary recipe)))
  (goto-char (point-min))
  (delete-char 2))

(provide 'org-imdb)

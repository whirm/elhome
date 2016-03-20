(require 'initsplit)
(setq initsplit-default-directory elhome-settings-directory)


;; Ease-of-use feature
;;
;; If initsplit would load xxx-settings as a way of ensuring its
;; customizations aren't clobbered, try to load xxx instead (which
;; will trigger the loading of xxx-settings anyway).  Because it is
;; normal for xxx to be loaded before xxx-settings, the other order is
;; often untested, and only discovered at customization time.
;; Although the file can usually be fixed by adding a simple `(require
;; 'xxx)', the following usually avoids the error in the first place.  Note,
;; however, that if xxx-settings uses symbols from elsewhere,
;; e.g. xxx-yyy, it will still need to load or require that library.
(defun elhome-initsplit-load (file)
  "Causes FILE to be loaded.  If FILE is an xxx-settings file in
`elhome-settings-directory', first loads the `xxx' library if possible"
  (unless
      (and
       ;; Is this file in the right directory?
       (string= (file-name-directory file)
                (expand-file-name
                 (file-name-as-directory elhome-settings-directory)))
       ;; Does it exist?
       (ignore-errors (find-library-name file) t)

       (let* ((f (file-name-nondirectory file))
              (lib (when (string-match elhome-settings-file-regexp f)
                     (match-string 1 f))))
         ;; if it's an xxx-settings file, try to load xxx
         (ignore-errors (load-library lib) t)))
    ;; otherwise, fall back to the default initsplit behavior
    (initsplit-load-if-exists file)))
(setq initsplit-load-function 'elhome-initsplit-load)

(require 'package)
(setq package-archives
    '(("marmalade" . "http://marmalade-repo.org/packages/")
      ("melpa" . "http://melpa.milkbox.net/packages/")
      ("org" . "http://orgmode.org/elpa/")))

(setq package-list '(clojure-mode
                     clojure-test-mode
                     magit
                     evil
                     soothe-theme
                     solarized-theme
                     sublime-themes
                     paredit
                     nrepl
                     idle-highlight-mode
                     ))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(dolist (package package-list)
  (when (not (package-installed-p package))
    (package-install package)))

(idle-highlight-mode 't)

(defun remove-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(evil-mode 1)

(add-to-list 'load-path "~/.emacs.d")
(let ((default-directory "~/.emacs.d"))
  (normal-top-level-add-subdirs-to-load-path))

(load-library "clojure-config.el")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("dc46381844ec8fcf9607a319aa6b442244d8c7a734a2625dac6a1f63e34bc4a6" "d0ff5ea54497471567ed15eb7279c37aef3465713fb97a50d46d95fe11ab4739" "d293542c9d4be8a9e9ec8afd6938c7304ac3d0d39110344908706614ed5861c9" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "62b86b142b243071b5adb4d48a0ab89aefd3cf79ee3adc0bb297ea873b36d23f" "f89e21c3aef10d2825f2f079962c2237cd9a45f4dc1958091be8a6f5b69bb70c" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "787574e2eb71953390ed2fb65c3831849a195fd32dfdd94b8b623c04c7f753f0" default)))
 '(recenter-positions (quote (15.0 85.0))))
(load-theme 'hickey)
(global-linum-mode t)
(setq linum-format "%d\u2502")

(xterm-mouse-mode)

(setq scroll-step 1
      scroll-conservatively 10000)
(setq scroll-margin 7)

(show-paren-mode)

; (set-face-attribute 'default nil :font "DejaVu Sans Mono")
(set-default-font "DejaVu Sans Mono")

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

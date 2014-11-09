(require 'package)
(setq package-archives
      '(("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.milkbox.net/packages/")
        ("org" . "http://orgmode.org/elpa/")
        ))

(setq package-list '(clojure-mode
                     clojure-test-mode
                     magit
                     evil
                     soothe-theme
                     solarized-theme
                     sublime-themes
		     zenburn-theme
		     ir-black-theme
                     paredit
                     cider
                     idle-highlight-mode
		     tramp
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

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(add-to-list 'load-path "~/.emacs.d/clojure")
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
 '(custom-safe-themes (quote ("c7359bd375132044fe993562dfa736ae79efc620f68bab36bd686430c980df1c" "7d4d00a2c2a4bba551fcab9bfd9186abe5bfa986080947c2b99ef0b4081cb2a6" "0ebe0307942b6e159ab794f90a074935a18c3c688b526a2035d14db1214cf69c" "53c542b560d232436e14619d058f81434d6bbcdc42e00a4db53d2667d841702e" "e26780280b5248eb9b2d02a237d9941956fc94972443b0f7aeec12b5c15db9f3" "e80a0a5e1b304eb92c58d0398464cd30ccbc3622425b6ff01eea80e44ea5130e" "4a60f0178f5cfd5eafe73e0fc2699a03da90ddb79ac6dbc73042a591ae216f03" "16248150e4336572ff4aa21321015d37c3744a9eb243fbd1e934b594ff9cf394" "a774c5551bc56d7a9c362dca4d73a374582caedb110c201a09b410c0ebbb5e70" "9bcb8ee9ea34ec21272bb6a2044016902ad18646bd09fdd65abae1264d258d89" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "33c5a452a4095f7e4f6746b66f322ef6da0e770b76c0ed98a438e76c497040bb" "dc46381844ec8fcf9607a319aa6b442244d8c7a734a2625dac6a1f63e34bc4a6" "d0ff5ea54497471567ed15eb7279c37aef3465713fb97a50d46d95fe11ab4739" "d293542c9d4be8a9e9ec8afd6938c7304ac3d0d39110344908706614ed5861c9" "e16a771a13a202ee6e276d06098bc77f008b73bbac4d526f160faa2d76c1dd0e" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "62b86b142b243071b5adb4d48a0ab89aefd3cf79ee3adc0bb297ea873b36d23f" "f89e21c3aef10d2825f2f079962c2237cd9a45f4dc1958091be8a6f5b69bb70c" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "787574e2eb71953390ed2fb65c3831849a195fd32dfdd94b8b623c04c7f753f0" default)))
 '(recenter-positions (quote (15.0 85.0))))
;; (load-theme 'solarized-light)
(load-theme 'solarized-dark)

(xterm-mouse-mode)

(setq scroll-step 1
      scroll-conservatively 10000)
(setq scroll-margin 7)

(show-paren-mode)
(setq-default line-spacing 1)

(set-default-font "ProggyCleanTTSZ 12")

(require 'paren)
(set-face-background 'show-paren-match (face-background 'default))
(set-face-attribute 'show-paren-match nil :weight 'normal)

(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups"))))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(define-key evil-visual-state-map "\\\\" 'comment-or-uncomment-region)

(savehist-mode 1)

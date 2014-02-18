(require 'clojure-mode)
(require 'nrepl)

; (print
; "(ns user
;    (:require [clojure.java.io :as io]
;              [clojure.string :as c-str]
;              [clojure.pprint :refer [pprint]]
;              [clojure.repl :as c-repl]
;              [clojure.test :as c-test]
;              [clojure.tools.namespace.repl :refer [refresh refresh-all]]
;              [clojure.java.classpath :as cp]))"
; )

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'clojure-mode-hook          #'enable-paredit-mode)
(add-hook 'nrepl-mode-hook            #'enable-paredit-mode)

(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)

(add-hook 'nrepl-repl-mode-hook 'rainbow-delimiters-mode)

(define-key evil-normal-state-map (kbd "M-.") nil)
(eval-after-load 'evil-mode
  (global-set-key (kbd "M-.") 'nrepl-jump))

(define-key evil-insert-state-map (kbd "TAB") nil)
(eval-after-load 'evil-mode
  (global-set-key (kbd "TAB") 'nrepl-indent-and-complete-symbol))

; (setq lisp-indent-offset 1)

(define-key evil-insert-state-map (kbd "RET") nil)
(eval-after-load 'evil-mode
  (global-set-key (kbd "RET") 'newline-and-indent))

(defun refresh ()
  (interactive)
  (insert "(require '[clojure.tools.namespace.repl :refer [refresh refresh-all]]) (refresh)"))

(defun trace ()
  (interactive)
  (insert "(require '[clojure.tools.trace :as tr])"))

(defun pprint ()
  (interactive)
  (insert "(require '[clojure.pprint :refer [pprint]])"))

(defun refresh-nrepl ()
  (interactive)
  (refresh)
  (pprint))

(global-set-key (kbd "C-c c r f") 'refresh-nrepl)

(setq nrepl-pop-to-repl-buffer-on-connect nil)

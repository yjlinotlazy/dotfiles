;; Disable GUI
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq use-dialog-box t)
(setq use-file-dialog nil)
(setq-default frame-title-format '("%b  -  GNU Emacs"))

;; Hide the startup screen
(setq inhibit-startup-screen t)

(setq completion-ignore-case t)
(setq case-fold-search t)

(set-frame-font "Hack 14")

(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; case insensitive search
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t
      completion-category-defaults nil
      completion-category-overrides nil
      completion-styles '(basic))

(load-theme 'dracula t)

;;dark mode
(set-variable 'frame-background-mode 'dark)

;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;'(package-selected-packages '(emacs-color-theme-solarized standard-themes)))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;)

(add-to-list 'load-path "~/.emacs.d/auto-dark/")
(require 'auto-dark)
(auto-dark-mode)

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(dracula-theme emacs-color-theme-solarized markdown-mode org-modern
		   standard-themes tangotango-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))

;;from https://christiantietze.de/posts/2021/02/emacs-org-todo-doing-done-checkbox-cycling/
(setq org-agenda-files '("~/org"))
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "PROG(p)" "|" "DONE(d)"))))

(defun org-todo-if-needed (state)
  "Change header state to STATE unless the current item is in STATE already."
  (unless (string-equal (org-get-todo-state) state)
    (org-todo state)))

(defun ct/org-summary-todo-cookie (n-done n-not-done)
  "Switch header state to DONE when all subentries are DONE, to TODO when none are DONE, and to DOING otherwise"
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo-if-needed (cond ((= n-done 0)
                               "TODO")
                              ((= n-not-done 0)
                               "DONE")
                              (t
                               "PROG")))))
(add-hook 'org-after-todo-statistics-hook #'ct/org-summary-todo-cookie)

(defun ct/org-summary-checkbox-cookie ()
  "Switch header state to DONE when all checkboxes are ticked, to TODO when none are ticked, and to DOING otherwise"
  (let (beg end)
    (unless (not (org-get-todo-state))
      (save-excursion
        (org-back-to-heading t)
        (setq beg (point))
        (end-of-line)
        (setq end (point))
        (goto-char beg)
        ;; Regex group 1: %-based cookie
        ;; Regex group 2 and 3: x/y cookie
        (if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]"
                               end t)
            (if (match-end 1)
                ;; [xx%] cookie support
                (cond ((equal (match-string 1) "100%")
                       (org-todo-if-needed "DONE"))
                      ((equal (match-string 1) "0%")
                       (org-todo-if-needed "TODO"))
                      (t
                       (org-todo-if-needed "PROG")))
              ;; [x/y] cookie support
              (if (> (match-end 2) (match-beginning 2)) ; = if not empty
                  (cond ((equal (match-string 2) (match-string 3))
                         (org-todo-if-needed "DONE"))
                        ((or (equal (string-trim (match-string 2)) "")
                             (equal (match-string 2) "0"))
                         (org-todo-if-needed "TODO"))
                        (t
                         (org-todo-if-needed "PROG")))
                (org-todo-if-needed "PROG"))))))))
(add-hook 'org-checkbox-statistics-hook #'ct/org-summary-checkbox-cookie)

;;show agenda at startup
(add-hook 'serve-after-make-frame-hook 'org-agenda-list)

(defun emacs-startup-screen ()
  "display agenda and all todos"
  (org-agenda nil "n"))
(add-hook 'emacs-startup-hook #'emacs-startup-screen)

;;open todo file at startup
(find-file "~/org/todo.org")

;; change initial height
;; update for different monitor set up
(setq initial-frame-alist
      (append initial-frame-alist
          '(
        (height . 90)
        (width . 120)
        (left . 900)
        )))

;;https://brunoarine.com/blog/refresh-agenda-on-file-change/
(defun my/redo-all-agenda-buffers ()
  (interactive)
  (dolist (buffer (buffer-list))
    (when (derived-mode-p 'org-agenda-mode)
      (org-agenda-maybe-redo))))

(add-hook 'org-mode-hook
          (lambda ()
            (add-hook 'after-save-hook 'my/redo-all-agenda-buffers nil 'make-it-local)))

(auto-dark-mode)

(use-package auto-dark
      :ensure t
      :custom
      (auto-dark-themes '((wombat) (leuven))) ; Replace with your desired dark and light themes
      :hook
      :init (auto-dark-mode))

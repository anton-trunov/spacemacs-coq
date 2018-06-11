;;; packages.el --- coq Layer packages File for Spacemacs
;;
;; Copyright (c) 2016 Tej Chajed
;;
;; Based on original version by Olivier Verdier
;;
;; Author: Tej Chajed <tchajed@mit.edu>
;; URL: https://github.com/tchajed/spacemacs-coq
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq coq-packages
      '(
        company-coq
        (proof-general :location (recipe
                                  :fetcher github
                                  :repo "ProofGeneral/PG"
                                  :files ("*")))

        ))

(setq coq-excluded-packages '())

(defun setup-coq-keys-for-map (state)
  (evil-define-key state coq-mode-map
    (kbd "<f3>") #'proof-assert-next-command-interactive)
  (evil-define-key state coq-mode-map
    (kbd "<f4>") #'company-coq-proof-goto-point)
  (evil-define-key state coq-mode-map
    (kbd "<f2>") #'proof-undo-last-successful-command))

(defun setup-coq-keys ()
  (setup-coq-keys-for-map 'normal)
  (setup-coq-keys-for-map 'insert))

(defun hide-mode-statuses ()
  (diminish 'company-mode)
  (diminish 'hs-minor-mode)
  (diminish 'outline-minor-mode)
  (diminish 'company-mode)
  (diminish 'holes-mode))

(defun setup-eldoc ()
  (setq-local eldoc-documentation-function
              (lambda ()
                (-if-let* ((symbol (company-coq-symbol-at-point)))
                    (company-coq-meta-symbol symbol))))
  (eldoc-mode))

(defun coq-scratch ()
  "Open a new scratch buffer with coq-mode activated"
  (interactive)
  (let (($buf (generate-new-buffer "coq-scratch")))
    (switch-to-buffer $buf)
    (coq-mode)
    (setq buffer-offer-save t)
    $buf))

(defun coq/init-company-coq ()
  (use-package company-coq
    :defer t
    :init
    (add-hook 'coq-mode-hook #'company-coq-mode)
    (add-hook 'coq-mode-hook #'setup-coq-keys)
    (add-hook 'coq-mode-hook #'hide-mode-statuses)
    (when coq-enable-eldoc
      (add-hook 'coq-mode-hook #'setup-eldoc))
    (spacemacs/declare-prefix-for-mode
      'coq-mode
      "mi" "coq/insert")
    (spacemacs/set-leader-keys-for-major-mode 'coq-mode
      "il" 'company-coq-lemma-from-goal
      "im" 'company-coq-insert-match-construct
      "d" 'company-coq-jump-to-definition)))

(defun coq/init-proof-general ()
  "Initialize Proof General."
  ;; Setup from Proof General README, using a Homebrew path. Proof General
  ;; lazily loads from proof-site, so there's no need to use-package it.
  ;; (load "/usr/local/share/emacs/site-lisp/proof-general/generic/proof-site")
  (use-package proof-site
    :mode ("\\.v\\'" . coq-mode)
    :defer t
    :init
    (progn
      (setq coq/proof-general-load-path
            (concat (configuration-layer/get-elpa-package-install-directory
                     'proof-general) "generic")
            proof-three-window-mode-policy 'hybrid
            proof-script-fly-past-comments t
            proof-splash-seen t)
      (add-to-list 'load-path coq/proof-general-load-path))
    (dolist (prefix '(("ml" . "pg/layout")
                      ("mp" . "pg/prover")
                      ("ma" . "pg/ask-prover")
                      ("mai" . "show-implicits")
                      ("maa" . "show-all") ; a is for "all"
                      ("mg" . "pg/goto")))
      (spacemacs/declare-prefix-for-mode
        'coq-mode
        (car prefix) (cdr prefix)))
    (spacemacs/set-leader-keys-for-major-mode 'coq-mode
      ;; Basic proof management and navigation
      "n" 'proof-assert-next-command-interactive
      "u" 'proof-undo-last-successful-command
      "." 'proof-goto-point
      "e" 'proof-goto-end-of-locked
      ;; Layout
      "ll" 'proof-layout-windows
      "lc" 'pg-response-clear-displays
      "lp" 'proof-prf
      ;; Prover Interaction
      "pi" 'proof-interrupt-process
      "px" 'proof-shell-exit
      "pr" 'proof-retract-buffer
      "pb" 'proof-process-buffer
      ;; Prover queries ('ask prover')
      "af" 'proof-find-theorems
      "ap" 'coq-Print
      "ac" 'coq-Check
      "ab" 'coq-About
      "aip" 'coq-Print-with-implicits
      "aic" 'coq-Check-show-implicits
      "aib" 'coq-About-with-implicits
      "aap" 'coq-Print-with-all
      "aac" 'coq-Check-show-all
      "aab" 'coq-About-with-all
      ;; Moving the point (goto)
      "ga" 'proof-goto-command-start
      "ge" 'proof-goto-command-end
      ;; Insertions
      "ie" 'coq-end-Section)
    ;; Workaround for evil performance bug (see
    ;; https://github.com/olivierverdier/spacemacs-coq/issues/6 for details).
    ;; Essentially the cursor color is changed rapidly when navigating the proof
    ;; in insert mode. This ensures the insert and normal mode colors are the
    ;; same, which generally avoids this problem.
    (add-hook 'coq-mode-hook
              (lambda ()
                (setq-local
                 evil-insert-state-cursor
                 (cons
                  (car evil-normal-state-cursor)
                  (cdr evil-insert-state-cursor)))))
    (add-hook 'coq-mode-hook
              (lambda ()
                (purpose-add-user-purposes
                 :modes
                 '((proof-response-mode . response)
                   (proof-goals-mode . goals)))))))

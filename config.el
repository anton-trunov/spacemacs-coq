;;; config.el --- Coq layer configuration file for Spacemacs
;;
;; Copyright (c) 2018 Anton Trunov
;;
;; Author: Anton Trunov <anton.a.trunov@gmail.com>
;; URL: https://github.com/anton-trunov/spacemacs-coq
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(spacemacs|define-jump-handlers coq-mode)

(defvar coq-enable-eldoc nil
  "If non nil then eldoc-mode is enabled in the Coq layer.")

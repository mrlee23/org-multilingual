;;; org-multilingual.el --- Org Mode multilingual preprocessor.

;; Copyright (C) 2018 Dongsoo Lee

;; Author: Dongsoo Lee <mrlee603@gmail.com>
;; Maintainer: Dongsoo Lee <mrlee603@gmail.com>
;; Created: 2018-02-11 18:49:09
;; 

;;; Commentary:

;; 

;;; Code:

(require 'subr-x)
(require 'org)

(defvar org-multilingual-lang-codes '(ab aa af ak sq am ar an hy as av ae ay az bm ba eu be bn bh bi bs br bg my ca ch ce ny zh zh-Hans zh-Hant cv kw co cr hr cs da dv nl dz en eo et ee fo fj fi fr ff gl gd gv ka de el kl gn gu ht ha he hz hi ho hu is io ig id, in ia ie iu ik ga it ja jv kl kn kr ks kk km ki rw rn ky kv kg ko ku kj lo la lv li ln lt lu lg lb gv mk mg ms ml mt mi mr mh mo mn na nv ng nd ne no nb nn ii oc oj cu or om os pi ps fa pl pt pa qu rm ro ru se sm sg sa sr sh st tn sn ii sd si ss sk sl so nr es su sw ss sv tl ty tg ta tt te th bo ti to ts tr tk tw ug uk ur uz ve vi vo wa cy wo fy xh yi ji yo za zu)
  "These codes are from ISO 639-1 Language Codes.")

(defvar org-multilingual-lang-code-regex "\\([a-zA-Z-]\\{2,\\}\\)"
  "Lang code regex with group.")
(defvar org-multilingual-property-regexp "\n[ \t]*:PROPERTIES:\\(.*\\)\n[ \t]*:END:"
  "Property regex.")
(defvar org-multilingual-block-regexp (format "\n[ \t]*#\\+BEGIN_LANG [ \t]*%s[^\n]*\n\\(.*\\)\n[ \t]*#\\+END_LANG" org-multilingual-lang-code-regex)
  "Block regex with lang code group and contents.")
(defvar org-multilingual-inline-regexp (format "^[ \t]*#\\+LANG_%s[ \t]*:\\([^\n]*\\)\n?" org-multilingual-lang-code-regex)
  "Inline regex with lang code group and contents.")
(defvar org-multilingual-quote-regexp (format "@@LANG_%s:\\([^@]*\\)@@" org-multilingual-lang-code-regex)
  "Quote regex with lang code group and contents.")

(defun org-multilingual-normalize-code (code)
  "Normalize CODE as symbol type."
  (when (symbolp code)
	(setq code (symbol-name code)))
  (when (stringp code)
	(setq code (string-trim code))
	(intern (downcase code))))

(defun org-multilingual-exists-code (code)
  "Return t if CODE is involved in ISO 639-1 Language Codes standard or nil."
  (unless (symbolp code)
	(setq code (org-multilingual-normalize-code code)))
  (member code org-multilingual-lang-codes))

(defun org-multilingual-replacer (source-lang target-lang contents)
  "If SOURCE-LANG and TARGET-LANG are equal, return CONTENTS or empty string."
  (unless (org-multilingual-exists-code source-lang)
	(error "This LANG('%s') is not involved in language codes." source-lang))
  (if (eq (org-multilingual-normalize-code source-lang)
		  (org-multilingual-normalize-code target-lang))
	  contents ""))

(defun org-multilingual-replace-block (str lang)
  "Replace block type matched STR matched LANG."
  (replace-regexp-in-string
   org-multilingual-block-regexp
   (lambda (str)
	 (message "HI")
	 (org-multilingual-replacer (match-string 1 str) lang (concat "\n" (match-string 2 str))))
   str t))

(defun org-multilingual-replace-inline (str lang)
  "Replace inline type matched STR matched LANG."
  (replace-regexp-in-string
   org-multilingual-inline-regexp
   (lambda (str)
	 (org-multilingual-replacer (match-string 1 str) lang (match-string 2 str)))
   str t))

(defun org-multilingual-replace-quote (str lang)
  "Replace quote type matched STR matched LANG."
  (replace-regexp-in-string
   org-multilingual-quote-regexp
   (lambda (str)
	 (org-multilingual-replacer (match-string 1 str) lang (match-string 2 str)))
   str t))

(provide 'org-multilingual)

;;; org-multilingual.el ends here

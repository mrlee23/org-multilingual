(add-to-list 'load-path "./")
(require 'org-multilingual)
(require 'ert)

(ert-deftest org-multilingual-replace-block-test ()
  (let ((data "#+BEGIN_LANG EN
Contents
#+END_LANG

#+BEGIN_LANG ES
contenido
#+END_LANG

#+BEGIN_LANG KO
내용
#+END_LANG

#+BEGIN_LANG ZH
内容
#+END_LANG

#+BEGIN_LANG JA
内容
#+END_LANG"))
	(should (equal (org-multilingual-replace-block data 'en) "
Contents



"))
	(should (equal (org-multilingual-replace-block data 'es) "

contenido


"))
	(should (equal (org-multilingual-replace-block data 'ko) "


내용

"))
	(should (equal (org-multilingual-replace-block data 'zh) "



内容
"))
	(should (equal (org-multilingual-replace-block data 'ja) "




内容"))
	(should (equal (org-multilingual-replace-block (replace-regexp-in-string "\n\n" "\n" data) 'en) "\nContents"))
	(should (equal (org-multilingual-replace-block (replace-regexp-in-string "\n\n" "\n" data) 'es) "\ncontenido"))
	(should (equal (org-multilingual-replace-block (replace-regexp-in-string "\n\n" "\n" data) 'ko) "\n내용"))
	(should (equal (org-multilingual-replace-block (replace-regexp-in-string "\n\n" "\n" data) 'zh) "\n内容"))
	(should (equal (org-multilingual-replace-block (replace-regexp-in-string "\n\n" "\n" data) 'ja) "\n内容"))
	))

(ert-deftest org-multilingual-replace-inline-test ()
  (let ((data "#+LANG_EN: Hello World!
#+LANG_ES: Hello Mundo!
#+LANG_KO: 안녕 World!
#+LANG_ZH: 你好 World!
#+LANG_JA: こんにちは World!"))
	(should (equal (org-multilingual-replace-inline data 'en) " Hello World!"))
	(should (equal (org-multilingual-replace-inline data 'es) " Hello Mundo!"))
	(should (equal (org-multilingual-replace-inline data 'ko) " 안녕 World!"))
	(should (equal (org-multilingual-replace-inline data 'zh) " 你好 World!"))
	(should (equal (org-multilingual-replace-inline data 'ja) " こんにちは World!"))
	))

(ert-deftest org-multilingual-replace-quote-test ()
  (let ((data "Hello @@LANG_EN:World@@!
Hello @@LANG_ES:Mundo@@!
@@LANG_KO:안녕@@ World!
你好 @@LANG_ZH:World@@!
こんにちは @@LANG_JA:World@@!"))
	(should (equal (org-multilingual-replace-quote data 'en) "Hello World!
Hello !
 World!
你好 !
こんにちは !"))
	(should (equal (org-multilingual-replace-quote data 'es) "Hello !
Hello Mundo!
 World!
你好 !
こんにちは !"))
	(should (equal (org-multilingual-replace-quote data 'ko) "Hello !
Hello !
안녕 World!
你好 !
こんにちは !"))
	(should (equal (org-multilingual-replace-quote data 'zh) "Hello !
Hello !
 World!
你好 World!
こんにちは !"))
	(should (equal (org-multilingual-replace-quote data 'ja) "Hello !
Hello !
 World!
你好 !
こんにちは World!"))
	))

(provide 'org-multilingual-test)
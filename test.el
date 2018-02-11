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
	(should (equal (org-multilingual-replace-block data 'en) "#+BEGIN_LANG EN
Contents
#+END_LANG



"))
	(should (equal (org-multilingual-replace-block (replace-regexp-in-string "\n\n" "\n" data) 'en) "#+BEGIN_LANG EN
Contents
#+END_LANG")))
  )

(provide 'org-multilingual-test)

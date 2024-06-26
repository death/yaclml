;; -*- lisp -*-

(in-package :it.bese.yaclml)

;;;; * YACLML tags mapping to HTML4 tags.

(defparameter +xhtml-strict-doctype+
  "\"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"")
(defparameter +xhtml-transitional-doctype+
  "\"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/transitional.dtd\"")
(defparameter +xhtml-frameset-doctype+
  "\"-//W3C//DTD XHTML 1.0 Frameset//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\"")

;;;; ** Helper macro fer defining the tag macros

(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun make-effective-attributes (attributes)
    (with-collector (attrs)
      (dolist (attr attributes)
        (case attr
          (:core
           (attrs 'class 'id 'style 'title)
           ;; HTMX attributes
           (attrs 'hx-get 'hx-post 'hx-on 'hx-push-url
                  'hx-select 'hx-select-oob 'hx-swap
                  'hx-swap-oob 'hx-target 'hx-trigger
                  'hx-vals 'hx-boost 'hx-confirm
                  'hx-delete 'hx-disable 'hx-disabled-elt
                  'hx-disinherit 'hx-encoding 'hx-ext
                  'hx-headers 'hx-history 'hx-history-elt
                  'hx-include 'hx-indicator 'hx-params
                  'hx-patch 'hx-preserve 'hx-prompt
                  'hx-put 'hx-replace-url 'hx-request
                  'hx-sse 'hx-sync 'hx-validate 'hx-vars
                  'hx-ws)
           (attrs 'data-hx-get 'data-hx-post 'data-hx-on
                  'data-hx-push-url 'data-hx-select
                  'data-hx-select-oob 'data-hx-swap
                  'data-hx-swap-oob 'data-hx-target
                  'data-hx-trigger 'data-hx-vals 'data-hx-boost
                  'data-hx-confirm 'data-hx-delete
                  'data-hx-disable 'data-hx-disabled-elt
                  'data-hx-disinherit 'data-hx-encoding
                  'data-hx-ext 'data-hx-headers 'data-hx-history
                  'data-hx-history-elt 'data-hx-include
                  'data-hx-indicator 'data-hx-params
                  'data-hx-patch 'data-hx-preserve
                  'data-hx-prompt 'data-hx-put 'data-hx-replace-url
                  'data-hx-request 'data-hx-sse 'data-hx-sync
                  'data-hx-validate 'data-hx-vars 'data-hx-ws))
          (:i18n
           (attrs 'dir 'lang))
          (:event
           (attrs 'onclick 'ondblclick
                  'onkeydown 'onkeypress
                  'onkeyup 'onmousedown
                  'onmousemove 'onmouseout
                  'onmouseover 'onmouseup))
          (t
           (attrs attr))))
      (attrs))))

(defmacro def-empty-html-tag (name &rest attributes)
  "Define a tag that has `End Tag` set to Forbidden and `Empty`
set to Empty according to:
http://www.w3.org/TR/1999/REC-html401-19991224/index/elements.html
used so generated XHTML would follow guidelines described in
http://www.w3.org/TR/xhtml1/#guidelines"
  (let ((effective-attributes (make-effective-attributes attributes)))
    (with-unique-names (custom-attributes)
      `(deftag ,name (&attribute ,@effective-attributes
                                 &allow-custom-attributes ,custom-attributes)
         (emit-empty-tag ,(string-downcase (symbol-name name))
                         (list ,@(iter (for attr :in effective-attributes)
                                   (collect (string-downcase (symbol-name attr)))
                                   (collect attr)))
                         ,custom-attributes)))))

(defmacro def-html-tag (name &rest attributes)
  (let ((effective-attributes (make-effective-attributes attributes)))
    (with-unique-names (custom-attributes)
      `(deftag ,name (&attribute ,@effective-attributes
                                 &allow-custom-attributes ,custom-attributes &body body)
         (emit-open-tag ,(string-downcase (symbol-name name))
                        (list ,@(iter (for attr :in effective-attributes)
                                  (collect (string-downcase (symbol-name attr)))
                                  (collect attr)))
                        ,custom-attributes)
         (emit-body body)
         (emit-close-tag ,(string-downcase (symbol-name name)))))))

(defun href (base &rest params)
  (with-output-to-string (href)
    (write-string base href)
    (when params
      (write-char #\? href)
      (loop
	for (key value . rest) on params by #'cddr
	do (etypecase key
             (string (write-string key href))
             (symbol (write-string (string-downcase key) href)))
	do (write-char #\= href)
	do (princ value href)
	when rest
	do (write-char #\& href)))))

;;;; * All HTML4 tags

;;;; This list taken from http://www.wdvl.com/Authoring/HTML/4/Tags

(def-html-tag <:a :core :i18n :event
  accesskey
  charset
  coords
  href
  hreflang
  name
  onblur
  onfocus
  rel
  rev
  shape
  tabindex
  target
  type)

(def-html-tag <:abbr :core :event :i18n)

(def-html-tag <:acronym :core :event :i18n)

(def-html-tag <:address :core :event :i18n)

(def-empty-html-tag <:area :core :event :i18n
  alt
  accesskey
  coords
  href
  nohref
  onblur
  onfocus
  shape
  tabindex)

(def-html-tag <:b :core :event :i18n)

(def-empty-html-tag <:base href)

(def-html-tag <:bdo :i18n
  id
  style
  title)

(def-html-tag <:big :core :event :i18n)

(def-html-tag <:blockquote :core :event :i18n
  cite)

(def-html-tag <:body :core :i18n :event
  onload
  onunload)

(def-empty-html-tag <:br :core)

(def-html-tag <:button :core :event :i18n
  accesskey
  disabled
  name
  onblur
  onfocus
  tabindex
  type
  value
  formmethod)

(def-html-tag <:caption :core :event :i18n)

(def-html-tag <:cite :core :event :i18n)

(def-html-tag <:code :core :event :i18n)

(def-empty-html-tag <:col :core :event :i18n
  align
  char
  charoff
  span
  valign
  width)

(def-html-tag <:colgroup :core :event :i18n
  align
  char
  charoff
  span
  valign
  width)

(def-html-tag <:dd :core :event :i18n)

(def-html-tag <:del :core :event :i18n
  cite
  datetime)

(def-html-tag <:dfn :core :event :i18n)

(def-html-tag <:div :core :event :i18n)

(def-html-tag <:dl :core :event :i18n)

(def-html-tag <:dt :core :event :i18n)

(def-html-tag <:em :core :event :i18n)

(def-html-tag <:fieldset :core :event :i18n)

(def-html-tag <:form :core :event :i18n
  action
  accept-charset
  enctype
  method
  name
  onreset
  onsubmit
  target)

(def-empty-html-tag <:frame :core
  frameborder
  longdesc
  marginheight
  marginwidth
  noresize
  scrolling
  src)

(def-html-tag <:frameset :core
  cols
  onload
  olunload
  rows)

(def-html-tag <:h1 :core :event :i18n)

(def-html-tag <:h2 :core :event :i18n)

(def-html-tag <:h3 :core :event :i18n)

(def-html-tag <:h4 :core :event :i18n)

(def-html-tag <:h5 :core :event :i18n)

(def-html-tag <:h6 :core :event :i18n)

(def-html-tag <:head :i18n
  profile)

(def-empty-html-tag <:hr :core :event width align)

(deftag <:html (&attribute dir lang prologue doctype
                           &allow-custom-attributes custom-attributes
                           &body body)
  (assert (or (and (not prologue)
                   (not doctype))
              (xor prologue doctype)) () "You can only specify one of PROLOGUE or DOCTYPE")
  (when doctype
    (emit-code `(awhen ,doctype
                  (princ "<!DOCTYPE html PUBLIC " *yaclml-stream*)
                  (princ it *yaclml-stream*)
                  (princ (strcat ">" ~%) *yaclml-stream*))))
  (when prologue
    (emit-code `(awhen ,prologue
                  (princ it *yaclml-stream*))))
  (emit-open-tag "html" (list* "dir" dir "lang" lang custom-attributes))
  (emit-body body)
  (emit-close-tag "html"))

(def-html-tag <:i :core :event :i18n)

(def-html-tag <:iframe :core
  frameborder
  longdesc
  marginheight
  marginwidth
  name
  scrolling
  src
  width
  height)

(def-empty-html-tag <:img :core :event :i18n
  alt
  src
  height
  ismap
  longdesc
  usemap
  width)

(def-empty-html-tag <:input :core :event :i18n
  accept
  accesskey
  alt
  checked
  disabled
  max
  maxlength
  min
  multiple
  name
  onblur
  onchange
  onfocus
  onselect
  oninput
  placeholder
  readonly
  required
  size
  src
  step
  tabindex
  type
  usemap
  value
  width
  height)

(def-html-tag <:output :core :event :i18n
  for
  form
  name)

(def-html-tag <:ins :core :event :i18n
  cite
  datetime)

(def-html-tag <:kbd :core :event :i18n)

(def-html-tag <:label :core :event :i18n
  accesskey
  for
  onblur
  onfocus)

(def-html-tag <:legend :core :event :i18n
  accesskey)

(def-html-tag <:li :core :event :i18n)

(def-empty-html-tag <:link :core :event :i18n
  charset
  href
  hreflang
  media
  rel
  rev
  type
  integrity
  crossorigin)

(def-html-tag <:map :core :event :i18n
  name)

(def-empty-html-tag <:meta :i18n
  content
  http-equiv
  name
  scheme
  charset)

(def-html-tag <:noframes :core :event :i18n)

(def-html-tag <:noscript :core :event :i18n)

(def-html-tag <:object :core :event :i18n
  archive
  classid
  codebase
  codetype
  data
  declare
  height
  name
  standby
  tabindex
  type
  usemap
  width)

(def-html-tag <:ol :core :event :i18n)

(def-html-tag <:optgroup :core :event :i18n
  label
  disabled)

(def-html-tag <:option :core :event :i18n
  disabled
  label
  selected
  value)

(def-html-tag <:p :core :event :i18n)

(def-empty-html-tag <:param
  name
  id
  type
  value
  valuetype)

(def-html-tag <:pre :core :event :i18n)

(def-html-tag <:q :core :event :i18n
  cite)

(def-html-tag <:samp :core :event :i18n)

(def-html-tag <:script
  type
  charset
  defer
  src
  title
  language)

(def-html-tag <:select :core :event :i18n
  disabled
  multiple
  name
  accesskey
  onblur
  onfocus
  onchange
  size
  tabindex)

(def-html-tag <:small :core :event :i18n)

(def-html-tag <:span :core :event :i18n)

(def-html-tag <:strong :core :event :i18n)

(def-html-tag <:style :i18n
  type
  media
  title)

(def-html-tag <:sub :core :event :i18n)

(def-html-tag <:sup :core :event :i18n)

(def-html-tag <:table :core :event :i18n
  border
  cellpadding
  cellspacing
  frame
  summary
  width)

(def-html-tag <:tbody :core :event :i18n
  align
  char
  charoff
  valign)

(def-html-tag <:td :core :event :i18n
  abbr
  align
  axis
  char
  charoff
  colspan
  headers
  rowspan
  scope
  valign
  width)

(def-html-tag <:textarea :core :event :i18n
  cols
  rows
  accesskey
  disables
  name
  onblur
  onchange
  onfocus
  onselect
  readonly
  tabindex)

(def-html-tag <:tfoot :core :event :i18n)

(def-html-tag <:th :core :event :i18n
  abbr
  align
  axis
  char
  charoff
  colspan
  headers
  rowspan
  scope
  valign)

(def-html-tag <:thead :core :event :i18n
  align
  char
  charoff
  valign)

(def-html-tag <:title :i18n)

(def-html-tag <:tr :core :event :i18n
  align
  char
  charoff
  valign)

(def-html-tag <:tt :core :event :i18n)

(def-html-tag <:ul :core :event :i18n)

(def-html-tag <:var :core :event :i18n)

(deftag <:embed (&allow-other-attributes others)
  (emit-empty-tag "embed" others))

;; Copyright (c) 2002-2005, Edward Marco Baringer
;; All rights reserved.
;;
;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are
;; met:
;;
;;  - Redistributions of source code must retain the above copyright
;;    notice, this list of conditions and the following disclaimer.
;;
;;  - Redistributions in binary form must reproduce the above copyright
;;    notice, this list of conditions and the following disclaimer in the
;;    documentation and/or other materials provided with the distribution.
;;
;;  - Neither the name of Edward Marco Baringer, nor BESE, nor the names
;;    of its contributors may be used to endorse or promote products
;;    derived from this software without specific prior written permission.
;;
;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;; A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
;; OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
;; LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
;; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

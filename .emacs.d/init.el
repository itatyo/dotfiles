;; パスを通す
(setenv "PATH"
        (concat '"/usr/local/bin:" (getenv "PATH")))

; 言語を日本語にする
(set-language-environment 'Japanese)

; 極力UTF-8とする
(prefer-coding-system 'utf-8)

; メニューバーを隠す
(tool-bar-mode -1)

; 編集行のハイライト
(global-hl-line-mode)

; C-h でバックスペース
(global-set-key "\C-h" 'delete-backward-char)

; font
;(set-face-attribute 'default nil
;        :family "ＭＳ ゴシック"
;        :height 90)
;(set-fontset-font "fontset-default"
;        'japanese-jisx0208
;        '("ＭＳ ゴシック" . "jisx0208-sjis"))

; ファイル名の文字コード指定(for windows)
;(setq file-name-coding-system 'sjis)

(when (>= emacs-major-version 23)
 (set-face-attribute 'default nil
                     :family "monaco"
                     :height 140)
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0208
  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'japanese-jisx0212
  '("Hiragino Maru Gothic Pro" . "iso10646-1"))
 (set-fontset-font
  (frame-parameter nil 'font)
  'mule-unicode-0100-24ff
  '("monaco" . "iso10646-1"))
 (setq face-font-rescale-alist
      '(("^-apple-hiragino.*" . 1.2)
        (".*osaka-bold.*" . 1.2)
        (".*osaka-medium.*" . 1.2)
        (".*courier-bold-.*-mac-roman" . 1.0)
        (".*monaco cy-bold-.*-mac-cyrillic" . 0.9)
        (".*monaco-bold-.*-mac-roman" . 0.9)
        ("-cdac$" . 1.3))))

; ウィンドウ設定
(if (boundp 'window-system)
    (setq initial-frame-alist
          (append (list
                   '(foreground-color . "azure3") ;; 文字が白
                   '(background-color . "black") ;; 背景は黒
                   '(border-color     . "black")
                   '(mouse-color      . "white")
                   '(cursor-color     . "white")
                   '(cursor-type      . box)
                   '(menu-bar-lines . 1)
                   '(width . 120) ;; ウィンドウ幅
                   '(height . 60) ;; ウィンドウの高さ
                   '(alpha . 85) ;; 透過設定
                   ;'(top . 60) ;;表示位置
                   ;'(left . 140) ;;表示位置
                   )
                  initial-frame-alist)))
(setq default-frame-alist initial-frame-alist)

; オープニングメッセージを表示しない
(setq inhibit-startup-message t)

; 矩形選択
; http://taiyaki.org/elisp/sense-region/src/sense-region.el
(autoload 'sense-region-on "sense-region"
  "System to toggle region and rectangle." t nil)
(sense-region-on)

; tab, 全角スペースを表示する
;;(defface my-face-r-1 '((t (:background "gray15"))) nil)
(defface my-face-b-1 '((t (:background "gray"))) nil)
(defface my-face-b-2 '((t (:background "gray26"))) nil)
(defface my-face-u-1 '((t (:foreground "SteelBlue" :underline t))) nil)
;;(defvar my-face-r-1 'my-face-r-1)
(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("\t" 0 my-face-b-2 append)
     ("　" 0 my-face-b-1 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     ;;("[\r]*\n" 0 my-face-r-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

; 対応する括弧を強調
(show-paren-mode 1)

; 終了時のカーソル位置記憶等
; http://emacs-session.sourceforge.net/
(require 'session)
(add-hook 'after-init-hook 'session-initialize)

; http://www.emacswiki.org/emacs/download/auto-install.el
(require 'auto-install)
(setq auto-install-directory "/Applications/Emacs.app/Contents/Resources/site-lisp")
(add-to-list 'load-path "/Applications/Emacs.app/Contents/Resources/site-lisp")

;(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

;anything.el(M-x auto-install-batch RET anything)
(require 'anything-startup)
(define-key global-map (kbd "C-;") 'anything) ;
; http://repo.or.cz/w/anything-config.git/blob_plain/master:/extensions/make-filelist.rb
; sudo ruby make-filelist.rb > /tmp/all.filelist
(setq anything-c-filelist-file-name "/tmp/all.filelist")
(setq anything-grep-candidates-fast-directory-regexp "^/tmp")
(setq anything-sources
      '(anything-c-source-buffers+
;	anything-c-source-colors
	anything-c-source-recentf
	anything-c-source-man-pages
	anything-c-source-emacs-commands
	anything-c-source-emacs-functions
	anything-c-source-files-in-current-dir
	)
)

; https://github.com/m2ym/popwin-el
;(require 'popwin)
;(setq display-buffer-function 'popwin:displauy-buffer)

; http://www.cx4a.org/pub/auto-complete.el
(require 'auto-complete)
(global-auto-complete-mode t)

; M-x install-elisp-from-emacswiki RET color-moccur.el
;(require 'color-moccur)
;(setq moccur-split-word t)

;M-x install-elisp-from-emacswiki auto-async-byte-compile.el
;自動バイトコンパイル
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)

; ファイル自動保存
; http://0xcc.net/misc/auto-save/auto-save-buffers.el
(require 'auto-save-buffers)
(run-with-idle-timer 0.5 t 'auto-save-buffers) 

; (例)C-a で行頭に移った後、C-a を押下するとバッファトップに移動
; M-x install-elisp http://www.emacswiki.org/cgi-bin/wiki/download/sequential-command.el
; M-x install-elisp http://www.emacswiki.org/cgi-bin/wiki/download/sequential-command-config.el
(require 'sequential-command-config)
(global-set-key "\C-a" 'seq-home)
(global-set-key "\C-e" 'seq-end)
(when (require 'org nil t)
  (define-key org-mode-map "\C-a" 'org-seq-home)
  (define-key org-mode-map "\C-e" 'org-seq-end))
(define-key esc-map "u" 'seq-upcase-backward-word)
(define-key esc-map "c" 'seq-capitalize-backward-word)
(define-key esc-map "l" 'seq-downcase-backward-word)

; 全角,半角文字の間にスペース挿入(ファイルセーブ時に自動実行)
; M-x install-elisp http://taiyaki.org/elisp/mell/src/mell.el
; M-x install-elisp http://taiyaki.org/elisp/text-adjust/src/text-adjust.el
(require 'text-adjust)
(defun text-adjust-space-before-save-if-needed ()
  (when (memq major-mode
              '(org-mode text-mode mew-draft-mode myhatena-mode))
    (text-adjust-space-buffer)))
(defalias 'spacer 'text-adjust-space-buffer)
(add-hook 'before-save-hook 'text-adjust-space-before-save-if-needed)

; org-remember
(require 'org-install)
(setq org-startup-truncated nil)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(org-remember-insinuate)
(setq org-directory "~/memo/")
(setq org-default-notes-file (concat org-directory "agenda.org"))
(setq org-remember-templates
      '(("Todo" ?t "** TODO %?\n   %i\n   %a\n   %t" nil "Inbox")
        ("Bug" ?b "** TODO %?   :bug:\n   %i\n   %a\n   %t" nil "Inbox")
        ("Idea" ?i "** %?\n   %i\n   %a\n   %t" nil "New Ideas")
        ))

; sticky shift
(defvar sticky-key ";")
(defvar sticky-list
  '(("a" . "A")("b" . "B")("c" . "C")("d" . "D")("e" . "E")("f" . "F")("g" . "G")
    ("h" . "H")("i" . "I")("j" . "J")("k" . "K")("l" . "L")("m" . "M")("n" . "N")
    ("o" . "O")("p" . "P")("q" . "Q")("r" . "R")("s" . "S")("t" . "T")("u" . "U")
    ("v" . "V")("w" . "W")("x" . "X")("y" . "Y")("z" . "Z")
    ("1" . "!")("2" . "@")("3" . "#")("4" . "$")("5" . "%")("6" . "^")("7" . "&")
    ("8" . "*")("9" . "(")("0" . ")")
    ("`" . "~")("[" . "{")("]" . "}")("-" . "_")("=" . "+")("," . "<")("." . ">")
    ("/" . "?")(";" . ":")("'" . "\"")("\\" . "|")
    ))
(defvar sticky-map (make-sparse-keymap))
(define-key global-map sticky-key sticky-map)
(mapcar (lambda (pair)
          (define-key sticky-map (car pair)
            `(lambda()(interactive)
               (setq unread-command-events
                     (cons ,(string-to-char (cdr pair)) unread-command-events)))))
        sticky-list)
(define-key sticky-map sticky-key '(lambda ()(interactive)(insert sticky-key)))

;; ruby-mode
(add-to-list 'load-path "~/.emacs.d/ruby-mode")
(autoload 'ruby-mode "ruby-mode" "Mode for editing ruby source files" t)
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys)))

;; ruby-electric.el — electric editing commands for ruby files
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))

;; set ruby-mode indent
(setq ruby-indent-level 2)
(setq ruby-indent-tabs-mode nil)

;; cd .emacs.d/
;; git clone git://github.com/eschulte/rinari.git
;; cd rinari
;; git submodule init
;; git submodule update
;; rhtml
;; cd .emacs.d/
;; git clone git://github.com/eschulte/rhtml.git

;; Interactively Do Things (highly recommended, but not strictly required)
;(require 'ido)
;(ido-mode t)

;; Rinari
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)

;; http://code.google.com/p/yasnippet/
;; git clone https://github.com/eschulte/yasnippets-rails.git ~/.emacs.d/yasnippets-rails
;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/snippets")
;; rails-snippets
(yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets")

;; flymake for ruby
(require 'flymake)
;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
(let* ((temp-file (flymake-init-create-temp-buffer-copy
'flymake-create-temp-inplace))
(local-file (file-relative-name
temp-file
(file-name-directory buffer-file-name))))
(list "ruby" (list "-c" local-file))))
(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
(add-hook
'ruby-mode-hook
'(lambda ()
;; Don't want flymake mode for ruby regions in rhtml files
(if (not (null buffer-file-name)) (flymake-mode))
;; エラー行で C-c d するとエラーの内容をミニバッファで表示する
(define-key ruby-mode-map "\C-cd" 'credmp/flymake-display-err-minibuf)))

(defun credmp/flymake-display-err-minibuf ()
"Displays the error/warning for the current line in the minibuffer"
(interactive)
(let* ((line-no (flymake-current-line-no))
(line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
(count (length line-err-info-list))
)
(while (> count 0)
(when line-err-info-list
(let* ((file (flymake-ler-file (nth (1- count) line-err-info-list)))
(full-file (flymake-ler-full-file (nth (1- count) line-err-info-list)))
(text (flymake-ler-text (nth (1- count) line-err-info-list)))
(line (flymake-ler-line (nth (1- count) line-err-info-list))))
(message "[%s] %s" line text)
)
)
(setq count (1- count)))))

; 即時反映 M-x eval-current-buffer
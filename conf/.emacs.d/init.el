; -*- mode: emacs-lisp; lexical-binding: t; -*-

;;
;; Set beginning window size
;;

;; window-system is deprecated, use display-graphic-t instead
;; (if (window-system)
;;     (set-frame-width  (selected-frame) 100))
;; (if (window-system)
;;     (set-frame-height (selected-frame) 40))

(defun set-frame-size-according-to-resolution ()
(interactive)
(if (display-graphic-p)
(progn
  ;; use 120 char wide window for largeish displays
  ;; and smaller 80 column windows for smaller displays
  ;; pick whatever numbers make sense for you
  (if (> (x-display-pixel-width) 1280)
         (add-to-list 'default-frame-alist (cons 'width 160))
         (add-to-list 'default-frame-alist (cons 'width 80)))
  ;; for the height, subtract a couple hundred pixels
  ;; from the screen height (for panels, menubars and
  ;; Whatnot), then divide by the height of a char to
  ;; get the height we want
  (add-to-list 'default-frame-alist
       (cons 'height (/ (- (x-display-pixel-height) 200)
                        (frame-char-height))))
  (redraw-frame))))


(set-frame-size-according-to-resolution)


;;
;; Emacs package servers
;;

(require 'package)
(add-to-list 'package-archives '("tromey" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(setq package-user-dir (expand-file-name "elpa/" user-emacs-directory))
(package-initialize)

;; Work around an Emacs v26 bug.
;; https://www.reddit.com/r/emacs/comments/cdei4p/failed_to_download_gnu_archive_bad_request/
(when (version< emacs-version "27")
 (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

;; Install use-package that we require for managing all other dependencies
(unless (package-installed-p 'use-package)
 (package-refresh-contents)
 (package-install 'use-package))

;; Enable use-package
(eval-when-compile
 (require 'use-package))
(setq use-package-always-ensure t)
(use-package org
 :pin gnu)

;; Add my own module path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))



;;
;; Fontaine
;;
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/fontaine")

;; (require 'fontaine)

;; (setq fontaine-latest-state-file
;;       (locate-user-emacs-file "fontaine-latest-state.eld"))

;; ;; Aporetic is my highly customised build of Iosevka:
;; ;; <https://github.com/protesilaos/aporetic>.
;; (setq fontaine-presets
;;       '((small
;; 	 :default-family "Aporetic Serif Mono"
;; 	 :default-height 90
;; 	 :variable-pitch-family "Aporetic Sans")
;; 	(regular) ; like this it uses all the fallback values and is named `regular'
;; 	(medium
;; 	 :default-weight semilight
;; 	 :default-height 115
;; 	 :bold-weight extrabold)
;; 	(large
;; 	 :inherit medium
;; 	 :default-height 150)
;; 	(presentation
;; 	 :default-height 180)
;; 	(t
;; 	 ;; I keep all properties for didactic purposes, but most can be
;; 	 ;; omitted.  See the fontaine manual for the technicalities:
;; 	 ;; <https://protesilaos.com/emacs/fontaine>.
;; 	 :default-family "Aporetic Sans Mono"
;; 	 :default-weight regular
;; 	 :default-height 100

;; 	 :fixed-pitch-family nil ; falls back to :default-family
;; 	 :fixed-pitch-weight nil ; falls back to :default-weight
;; 	 :fixed-pitch-height 1.0

;; 	 :fixed-pitch-serif-family nil ; falls back to :default-family
;; 	 :fixed-pitch-serif-weight nil ; falls back to :default-weight
;; 	 :fixed-pitch-serif-height 1.0

;; 	 :variable-pitch-family "Aporetic Serif"
;; 	 :variable-pitch-weight nil
;; 	 :variable-pitch-height 1.0

;; 	 :mode-line-active-family nil ; falls back to :default-family
;; 	 :mode-line-active-weight nil ; falls back to :default-weight
;; 	 :mode-line-active-height 1.0

;; 	 :mode-line-inactive-family nil ; falls back to :default-family
;; 	 :mode-line-inactive-weight nil ; falls back to :default-weight
;; 	 :mode-line-inactive-height 0.98

;; 	 :header-line-family nil ; falls back to :default-family
;; 	 :header-line-weight nil ; falls back to :default-weight
;; 	 :header-line-height 0.9

;; 	 :line-number-family nil ; falls back to :default-family
;; 	 :line-number-weight nil ; falls back to :default-weight
;; 	 :line-number-height 0.9

;; 	 :tab-bar-family nil ; falls back to :default-family
;; 	 :tab-bar-weight nil ; falls back to :default-weight
;; 	 :tab-bar-height 1.0

;; 	 :tab-line-family nil ; falls back to :default-family
;; 	 :tab-line-weight nil ; falls back to :default-weight
;; 	 :tab-line-height 1.0

;; 	 :bold-family nil ; use whatever the underlying face has
;; 	 :bold-weight bold

;; 	 :italic-family nil
;; 	 :italic-slant italic

;; 	 :line-spacing nil)))

;; ;; Set the last preset or fall back to desired style from `fontaine-presets'
;; ;; (the `regular' in this case).
;; (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))

;; ;; Persist the latest font preset when closing/starting Emacs and
;; ;; while switching between themes.
;; (fontaine-mode 1)

;; ;; fontaine does not define any key bindings.  This is just a sample that
;; ;; respects the key binding conventions.  Evaluate:
;; ;;
;; ;;     (info "(elisp) Key Binding Conventions")
;; (define-key global-map (kbd "C-c f") #'fontaine-set-preset)

;;
;; Common sense stuff
;;

;; Disable the splash screen and its messages (to enable them again, replace the t with 0)
(setq inhibit-splash-screen t
     inhibit-startup-message t)

;; Enable transient mark mode
(transient-mark-mode 1)

;; Track recently opened files
(recentf-mode 1)
(setq recentf-max-saved-items 100)

;; Don't ring the bell
(setq ring-bell-function 'ignore)

;; Turn off visible bell (to enable it again, replace 0 with t
(setq visible-bell 0)

;; Use visual line mode to wrap by word boundaries
(global-visual-line-mode)

;; Enable the mouse in the terminal
(xterm-mouse-mode)

;; Enable the mouse's wheel
(mouse-wheel-mode)

;; Enable repeating keys
(repeat-mode)

;; Turn on delete selection, aka overwrite
;;(delete-selection-mode)

;; Use Y or N in leiu of Yes or No
(fset 'yes-or-no-p 'y-or-n-p)

;; Map C-x C-b to ibuffer-mode
(global-set-key [remap list-buffers] 'ibuffer)

;; Sort apropos results by best matches
(setq apropos-sort-by-scores t)

;; Ignore case during searches
;;(setq case-fold-search t)

;; Treat kill/copy of current unmarked line as if marked as a region
(use-package whole-line-or-region
 :ensure t
 :init (whole-line-or-region-global-mode))

;; Handle RO attempted "kills"
(defadvice whole-line-or-region-kill-region
   (before whole-line-or-region-kill-read-only-ok activate)
 (interactive "p")
 (unless kill-read-only-ok (barf-if-buffer-read-only)))

;; M-o key binding to switch windows
(global-set-key (kbd "M-o") 'other-window)

;; Allow changing windows in cardinal directions, S-<right>, S-<left>, S-<up>, S-<down>
(windmove-default-keybindings)

;; Turn on tab bar history
(tab-bar-mode)
(tab-bar-history-mode)
(global-set-key (kbd "M-[") 'tab-bar-history-back)
(global-set-key (kbd "M-]") 'tab-bar-history-forward)

;; Allow search to use M-\<, M-\>, C-v, M-v
(setq isearch-allow-motion 't)

;; Use dired-x
(require 'dired-x)

;; Dictionary
(global-set-key (kbd "M-#") 'dictionary-lookup-definition)

;;
;; Customize appearance
;;

;; Hide tool bar
(tool-bar-mode 0)

;; Show menu bar
(menu-bar-mode 1)

;; Show scroll bars
;;(when (fboundp 'scroll-bar-mode)
;;  (scroll-bar-mode 1)
;;  (set-scroll-bar-mode 'right))
(set-scroll-bar-mode nil)

;; We want all the icons for different modes
(when (display-graphic-p)
(require 'all-the-icons))
;; or
(use-package all-the-icons
 :if (display-graphic-p))

;;
;; Modeline
;;
;; (require 'powerline)
;; (powerline-default-theme)
(use-package doom-modeline
 :ensure t
 :init (doom-modeline-mode 1))

;; Set a default "theme", without manually confirming

;; Use `nord8` from Nord's "Frost" palette as background color.
(setq nord-region-highlight "frost")

;; Use `nord4` from Nord's "Snow Storm" palette as background color.
;;(setq nord-region-highlight "snowstorm")

(use-package nord-theme
 :ensure t
 :init
 (load-theme 'nord t))

;; Turn on font lock mode globally
(global-font-lock-mode)

;; Font fallbacks
(cond
((member "Consolas" (font-family-list))
 (set-face-attribute 'default nil :font "Consolas-10"))
((member "Fira Code" (font-family-list))
 (set-face-attribute 'default nil :font "Fira Code-11"))
((member "Menlo" (font-family-list))
 (set-face-attribute 'default nil :font "Menlo-11"))
((member "DejaVu Sans Mono" (font-family-list))
 (set-face-attribute 'default nil :font "DejaVu Sans Mono-11"))
((member "Monaco" (font-family-list))
 (set-face-attribute 'default nil :font "Monaco"))
((member "Cascadia Code" (font-family-list))
 (set-face-attribute 'default nil :font "Cascadia Code-11"))
((member "Inconsolata" (font-family-list))
 (set-face-attribute 'default nil :font "Inconsolata-11"))
((member "Ubuntu Mono" (font-family-list))
 (set-face-attribute 'default nil :font "Ubuntu Mono-11")))

;; Include PragmataPro font ligatures
(require 'pragmatapro-module)

;; Enables font ligature globally in all buffers.  You can also do it
;; per mode with `ligature-mode'.
(global-ligature-mode)

;; Set fixed-pitch default font
(face-spec-set
'fixed-pitch
'((t :family
     (cond
          ((member "Consolas" (font-family-list)) "Consolas")
        (t "Monospace"))))
'face-defface-spec)

;;
;; General Settings
;;

;; Autosaves location in case of crashes
(setq auto-save-list-file-prefix "~/.autosaves/.saves-")


;; Server for emacsclient
(server-start)


;; Workaround for dealing with Windblows cut/paste
(setq select-active-regions nil)
(setq select-enable-clipboard 't)
(setq select-enable-primary nil)
(setq interprogram-cut-function #'gui-select-text)


;;
;; These are helpful and lightweight
;;

;; which-key will show you options for partially completed keybindings
;; It's extremely useful for packages with many keybindings like Projectile.
(use-package which-key
 :ensure t
 :config
 (which-key-mode +1))

;;
;; Selectrum is useful but now deprecated by Vertico
;;
;; Use selectrum for completions
;; (use-package selectrum
;;   :ensure
;;   :init
;;   (selectrum-mode)
;;   :custom
;;   (completion-styles '(flex substring partial-completion)))

;; Use Prescient to sort and filter candidate completions
(use-package prescient :ensure t)
(use-package vertico-prescient :ensure t)
(use-package company-prescient :ensure t)

;; Use Prescient with Emacs 30+ completion framework
(when (version< emacs-version "30")
 (setq completion-preview-sort-function #'prescient-completion-sort))

(use-package nerd-icons-completion
 :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
 :config
 (nerd-icons-completion-mode))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
 ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
 ;; available in the *Completions* buffer, add it to the
 ;; `completion-list-mode-map'.
 :bind (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))

 ;; The :init section is always executed.
 :init

 ;; Marginalia must be activated in the :init section of use-package such that
 ;; the mode gets enabled right away. Note that this forces loading the
 ;; package.
 (marginalia-mode))


;; (use-package all-the-icons-completion
;;   :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
;;   :init
;;   (all-the-icons-completion-mode))


;;
;; Vertico selection framework
;;
(use-package vertico
 :ensure t
 ;;:custom

 ;; (vertico-scroll-margin 0) ;; Different scroll margin
 ;; (vertico-count 20) ;; Show more candidates
 ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
 ;; (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
 :config
 (vertico-prescient-mode)
 :init
 (vertico-mode +1))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
 :init
 (savehist-mode))

;; Emacs minibuffer configurations.
(use-package emacs
 :custom
 ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
 ;; to switch display modes.
 (context-menu-mode t)
 ;; Support opening new minibuffers from inside existing minibuffers.
 (enable-recursive-minibuffers t)
 ;; Hide commands in M-x which do not work in the current mode.  Vertico
 ;; commands are hidden in normal buffers. This setting is useful beyond
 ;; Vertico.
 (read-extended-command-predicate #'command-completion-default-include-p)
 ;; Do not allow the cursor in the minibuffer prompt
 (minibuffer-prompt-properties
  '(read-only t cursor-intangible t face minibuffer-prompt)))

;; Optionally use the `orderless' completion style.
(use-package orderless
 :custom
 ;; Configure a custom style dispatcher (see the Consult wiki)
 ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
 ;; (orderless-component-separator #'orderless-escapable-split-on-space)
 (completion-styles '(orderless basic))
 (completion-category-overrides '((file (styles partial-completion))))
 (completion-category-defaults nil) ;; Disable defaults, use our settings
 (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Add an ▶ to the current candidate
(defvar +vertico-current-arrow t)

(cl-defmethod vertico--format-candidate :around
 (cand prefix suffix index start &context ((and +vertico-current-arrow
                                                (not (bound-and-true-p vertico-flat-mode)))
                                           (eql t)))
 (setq cand (cl-call-next-method cand prefix suffix index start))
 (if (bound-and-true-p vertico-grid-mode)
     (if (= vertico--index index)
         (concat #("▶" 0 1 (face vertico-current)) cand)
       (concat #("_" 0 1 (display " ")) cand))
   (if (= vertico--index index)
       (concat
        #(" " 0 1 (display (left-fringe right-triangle vertico-current)))
        cand)
     cand)))

(keymap-set vertico-map "RET" #'vertico-directory-enter)
(keymap-set vertico-map "DEL" #'vertico-directory-delete-char)
(keymap-set vertico-map "M-DEL" #'vertico-directory-delete-word)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)


;;
;; Shells
;;
(defun my-buffer-face-mode-pragmatapro ()
   (interactive)
   (setq buffer-face-mode-face '(:inherit default :family "PragmataPro Mono Liga" :height 105))
   (ligature-mode)
   (buffer-face-mode))
(add-hook 'eshell-mode-hook 'my-buffer-face-mode-pragmatapro)
(add-hook 'shell-mode-hook 'my-buffer-face-mode-pragmatapro)

(defun eshell/e (file)
  "Open FILE using Emacs' find-file command."
  (interactive "fOpen file: ")
  (find-file file))

;;(add-hook 'eshell-mode-hook (lambda ()
;;  (define-key eshell-mode-map (kbd "e") 'eshell/e))) ;; This binds 'e' as a key



;;
;; Utilities
;;
(defun dos2unix ()
 "Convert a DOS formatted text buffer to UNIX format"
 (interactive)
 (set-buffer-file-coding-system 'undecided-unix nil))

(defun unix2dos ()
 "Convert a UNIX formatted text buffer to DOS format"
 (interactive)
 (set-buffer-file-coding-system 'undecided-dos nil))

;; Edit a file as root
(defun sudo ()
 "Use TRAMP to `sudo' the current buffer."
 (interactive)
 (when buffer-file-name
   (find-alternate-file
    (concat "/sudo:root@localhost:"
            buffer-file-name))))


;;
;; Documention modes
;;

;; Info
(defun my-Info-mode-hook ()
 (face-remap-add-relative 'default :family "iA Writer Quattro V"))
(add-hook 'Info-mode-hook 'my-Info-mode-hook)

;; ePub (nov.el)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; PDF
(use-package pdf-tools
 :ensure t
 :init
 (pdf-tools-install))

(use-package pdf-view-restore
 :after pdf-tools
 :config
 (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))
(setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")

;; Markdown
(defun my-markdown-mode-hook ()
 (interactive)
   (emojify-mode)
   (buffer-face-mode))
(add-hook 'markdown-mode-hook 'my-markdown-mode-hook)

;;
;; Programming modes...
;;


;; Override programming mode settings
(defun my-prog-mode-hook ()
 ;; I love PragmataPro for source code...
 (face-remap-add-relative 'default :family "PragmataPro Mono Liga" :height 105)

 ;; Italicize comments
 '(font-lock-comment-delimiter-face ((t (:slant italic))))
 '(font-lock-comment-face ((t (:slant italic))))
 '(font-lock-doc-face ((t (:slant italic))))

 ;; Line numbers
 (display-line-numbers-mode)
 (column-number-mode)

 ;; Show the highlight line
 (hl-line-mode)

 ;; On the fly checking of spelling in strings and comments
 (flyspell-prog-mode)
)
(add-hook 'prog-mode-hook 'my-prog-mode-hook)
(add-hook 'yaml-ts-mode-hook 'my-prog-mode-hook)

;; Make sure files end in a newline
(setq require-final-newline t)

;; Undo prettifying symbols under point, "cursor," or just before point
(setq prettify-symbols-unprettify-at-point 'right-edge)

;; Tree-Sitter: Syntacticle analysis
(setq treesit-language-source-alist
      '(
	(bash "https://github.com/tree-sitter/tree-sitter-bash" "v0.23.3")
	(bitbake "https://github.com/tree-sitter-grammars/tree-sitter-bitbake")
	(c "https://github.com/tree-sitter/tree-sitter-c" "v0.23.6")
	(cmake "https://github.com/uyha/tree-sitter-cmake")
	(cpp "https://github.com/tree-sitter/tree-sitter-cpp" "v0.23.4")
	(elisp "https://github.com/Wilfred/tree-sitter-elisp")
	(json "https://github.com/tree-sitter/tree-sitter-json")
	(make "https://github.com/alemuller/tree-sitter-make")
	(markdown "https://github.com/ikatyang/tree-sitter-markdown")
	(python "https://github.com/tree-sitter/tree-sitter-python" "v0.23.6")
	(rust "https://github.com/tree-sitter/tree-sitter-rust.git" "v0.23.3")
	(toml "https://github.com/tree-sitter/tree-sitter-toml")
	(bitbake "https://github.com/tree-sitter-grammars/tree-sitter-bitbake")
	(yaml "https://github.com/ikatyang/tree-sitter-yaml")
	))

;; Remap programming major modes to Tree-Sitter
(setq major-mode-remap-alist
      '(
	(sh-mode . bash-ts-mode)
	(bash-mode . bash-ts-mode)
	(c-mode . c-ts-mode)
	(cpp-mode . c++-ts-mode)
	(c++-mode . c++-ts-mode)
	(json-mode . json-ts-mode)
	(python-mode . python-ts-mode)
	(toml-mode . toml-ts-mode)
	(yaml-mode . yaml-ts-mode)
	))

;; Have Emacs recognize Bitbake files using tree-sitter...
(add-to-list 'auto-mode-alist '("\\.bb\\'" . bitbake-ts-mode))
(add-to-list 'auto-mode-alist '("\\.bbappend\\'" . bitbake-ts-mode))


;; Customizations for all of c-mode, c++-mode, and objc-mode
(defun my-c-ts-mode-hook ()
 '(c-ts-mode-indent-style . 'bsd)
 '(c-ts-mode-indent-offset . 2)

 (setq tab-width 8
	;; this will make sure spaces are used instead of tabs
       indent-tabs-mode nil)

 ;; Soft tabstops on 2 spaces - M-i
 (setq tab-stop-list '(2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 66 68 70 72 74 76 78 80 82 84 86 88 90 92 94 96 98 100 102 104 106 108 110 112 114 116 118 120))

 (setq comment-column 80)
 (setq comment-fill-column 80)
 (setq comment-style 'extra-line)

 ;; other customizations
 (electric-indent-mode)
 (electric-pair-mode)
 )
(add-hook 'c-ts-mode-hook 'my-c-ts-mode-hook)
(add-hook 'cpp-ts-mode-hook 'my-c-ts-mode-hook)
(add-hook 'c++-ts-mode-hook 'my-c-ts-mode-hook)

;; Setup hideshow mode for C/C++/Rust/Lisp/Java
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'rustic-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)

;; Max Bling
(setq font-lock-maximum-decoration t)

;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; rustic = basic rust-mode + additions

(use-package rustic
 :ensure
 :bind (:map rustic-mode-map
             ("M-j" . lsp-ui-imenu)
             ("M-?" . lsp-find-references)
             ("C-c C-c l" . flycheck-list-errors)
             ("C-c C-c a" . lsp-execute-code-action)
             ("C-c C-c r" . lsp-rename)
             ("C-c C-c q" . lsp-workspace-restart)
             ("C-c C-c Q" . lsp-workspace-shutdown)
             ("C-c C-c s" . lsp-rust-analyzer-status))
 :config
 ;; uncomment for less flashiness
 ;; (setq lsp-eldoc-hook nil)
 ;; (setq lsp-enable-symbol-highlighting nil)
 ;; (setq lsp-signature-auto-activate nil)

 ;; Enable electric pairing of delimiters
 (electric-pair-mode nil)

 ;; comment to disable rustfmt on save
 (setq rustic-format-on-save t)
 (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
 ;; Treat snake case as one word
 ;;(superword-mode)

 (setq tab-width 8
    ;; this will make sure spaces are used instead of tabs
       indent-tabs-mode nil)

  ;; Soft tabstops on 4 spaces - M-i
  (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))

 ;; so that run C-c C-c C-r works without having to confirm, but don't try to
 ;; save rust buffers that are not file visiting. Once
 ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
 ;; no longer be necessary.
 (when buffer-file-name
   (setq-local buffer-save-without-query t))
 (add-hook 'before-save-hook 'lsp-format-buffer nil t))


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; For rust-analyzer integration

(use-package lsp-mode
 :ensure
 :commands lsp
 :custom
 ;; what to use when checking on-save. "check" is default, I prefer clippy
 (lsp-rust-analyzer-cargo-watch-command "clippy")
 (lsp-eldoc-render-all t)
 (lsp-idle-delay 0.6)
 ;; enable / disable the hints as you prefer:
 (lsp-inlay-hint-enable t)
 ;; These are optional configurations. See https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-chaining-hints for a full list
 (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
 (lsp-rust-analyzer-display-chaining-hints t)
 (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
 (lsp-rust-analyzer-display-closure-return-type-hints t)
 (lsp-rust-analyzer-display-parameter-hints nil)
 (lsp-rust-analyzer-display-reborrow-hints nil)
 (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
 :ensure
 :commands lsp-ui-mode
 :custom
 ;; Bad wrapping with sideline when you don't set this.
 (custom-set-faces '(markdown-code-face ((t (:inherit default)))))
 (lsp-ui-peek-always-show t)
 (lsp-ui-sideline-show-hover t)
 (lsp-ui-doc-enable nil)
 :config (progn
           ;;
           ;; 2022-03-28 - fix sideline height computation
           ;;
           (defun lsp-ui-sideline--compute-height nil
             "Return a fixed size for text in sideline."
             (let ((fontHeight (face-attribute 'lsp-ui-sideline-global :height)))
               (if (null text-scale-mode-remapping)
                   '(height
                     (if (floatp fontHeight) fontHeight
                       (/ (face-attribute 'lsp-ui-sideline-global :height) 100.0)
                       )
                     ;; readjust height when text-scale-mode is used
                     (list 'height
                           (/ 1 (or (plist-get (cdr text-scale-mode-remapping) :height)
                                    1)))))))

           ;;
           ;; 2022-03-28 - fix sideline alignment
           ;;
           (defun lsp-ui-sideline--align (&rest lengths)
             "Align sideline string by LENGTHS from the right of the window."
             (list (* (window-font-width nil 'lsp-ui-sideline-global)
                      (+ (apply '+ lengths) (if (display-graphic-p) 1 2))))))

 )


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; inline errors

(use-package flycheck :ensure)


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; auto-completion and code snippets

(use-package yasnippet
 :ensure
 :config
 (yas-reload-all)
 (add-hook 'prog-mode-hook 'yas-minor-mode)
 (add-hook 'text-mode-hook 'yas-minor-mode))

(use-package company
 :ensure
 :config
 (company-prescient-mode)
 :bind
 (:map company-active-map
             ("C-n". company-select-next)
             ("C-p". company-select-previous)
             ("M-<". company-select-first)
             ("M->". company-select-last))
 (:map company-mode-map
       ("<tab>". tab-indent-or-complete)
       ("TAB". tab-indent-or-complete)))

(defun company-yasnippet-or-completion ()
 (interactive)
 (or (do-yas-expand)
     (company-complete-common)))

(defun check-expansion ()
 (save-excursion
   (if (looking-at "\\_>") t
     (backward-char 1)
     (if (looking-at "\\.") t
       (backward-char 1)
       (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
 (let ((yas/fallback-behavior 'return-nil))
   (yas/expand)))

(defun tab-indent-or-complete ()
 (interactive)
 (if (minibufferp)
     (minibuffer-complete)
   (if (or (not yas/minor-mode)
           (null (do-yas-expand)))
       (if (check-expansion)
           (company-complete-common)
         (indent-for-tab-command)))))


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; Create / cleanup rust scratch projects quickly

(use-package rust-playground :ensure)


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; for Cargo.toml and other config files

(use-package toml-mode :ensure)


;; -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
;; setting up debugging support with dap-mode

;; (use-package exec-path-from-shell
;;   :ensure
;;   :init (exec-path-from-shell-initialize))

  (setq dap-cpptools-extension-version "1.13.8")

  (with-eval-after-load 'lsp-rust
    (require 'dap-cpptools))

  (with-eval-after-load 'dap-cpptools
    ;; Add a template specific for debugging Rust programs.
    ;; It is used for new projects, where I can M-x dap-edit-debug-template
    (dap-register-debug-template "Rust::CppTools Run Configuration"
                                 (list :type "cppdbg"
                                       :request "launch"
                                       :name "Rust::Run"
                                       :MIMode "gdb"
                                       :miDebuggerPath "rust-gdb"
                                       :environment []
                                       :program "${workspaceFolder}/target/debug/hello / replace with binary"
                                       :cwd "${workspaceFolder}"
                                       :console "external"
                                       :dap-compilation "cargo build"
                                       :dap-compilation-dir "${workspaceFolder}")))

  (with-eval-after-load 'dap-mode
    (setq dap-default-terminal-kind "integrated") ;; Make sure that terminal programs open a term for I/O in an Emacs buffer
    (dap-auto-configure-mode +1))


;; (when (executable-find "lldb-mi")
;;  (use-package dap-mode
;;    :ensure
;;    :config
;;    (dap-ui-mode)
;;    (dap-ui-controls-mode 1)

;;    (require 'dap-lldb)
;;    (require 'dap-gdb-lldb)
;;    ;; installs .extension/vscode
;;    (dap-gdb-lldb-setup)
;;    (dap-register-debug-template
;;     "Rust::LLDB Run Configuration"
;;     (list :type "lldb"
;;           :request "launch"
;;           :name "LLDB::Run"
;; 	   :gdbpath "rust-lldb"
;;           ;; uncomment if lldb-mi is not in PATH
;;           ;; :lldbmipath "path/to/lldb-mi"
;;           ))))


;;
;; Org Mode
;;
;;(require 'org)

;; with org-mac-link message:// links are handed over to the macOS system,
;; which has built-in handling. On Windows and Linux, we can use thunderlink!
(when (not (string-equal system-type "darwin"))
  ;; modify this for your system
  (setq thunderbird-program "/usr/bin/thunderbird")

  (defun org-message-thunderlink-open (slash-message-id)
    "Handler for org-link-set-parameters that converts a standard message:// link into
   a thunderlink and then invokes thunderbird."
    ;; remove any / at the start of slash-message-id to create real message-id
    (let ((message-id
           (replace-regexp-in-string (rx bos (* "/"))
                                     ""
                                     slash-message-id)))
      (start-process
       (concat "thunderlink: " message-id)
       nil
       thunderbird-program
       "-thunderlink"
       (concat "thunderlink://messageid=" message-id)
       )))
  ;; on message://aoeu link, this will call handler with //aoeu
  (org-link-set-parameters "message" :follow #'org-message-thunderlink-open))


;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/org"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Open URLs usin firefox
(defun browse-url-at-point-firefox (&optional ARG)
 (interactive)
 (let ((url (browse-url-url-at-point)))
   (if url
	(browse-url-firefox url ARG)
     (error "No URL fount"))))
(define-key org-mode-map (kbd "C-c C-o") 'browse-url-at-point-firefox)

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Remap the change priority keys to use the UP or DOWN key
(define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
(define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

;; Make Org mode work with files ending in .org
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen

(let* ((variable-tuple
       (cond ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
             ((x-list-fonts "Verdana")         '(:font "Verdana"))
             ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
	      ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
             ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
             (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
      (base-font-color     (face-foreground 'default nil 'default))
      (headline           `(:inherit default :weight bold)))

(custom-theme-set-faces
'user
`(org-level-8 ((t (,@headline ,@variable-tuple))))
`(org-level-7 ((t (,@headline ,@variable-tuple))))
`(org-level-6 ((t (,@headline ,@variable-tuple))))
`(org-level-5 ((t (,@headline ,@variable-tuple))))
`(org-level-4 ((t (,@headline ,@variable-tuple :height 120))))
`(org-level-3 ((t (,@headline ,@variable-tuple :height 130))))
`(org-level-2 ((t (,@headline ,@variable-tuple :height 140))))
`(org-level-1 ((t (,@headline ,@variable-tuple :height 150))))
`(org-document-title ((t (,@headline ,@variable-tuple :height 160 :underline nil))))))


;; Capture templates
(setq org-capture-templates
     '(    

       ("j" "Work Log Entry"
        entry (file+datetree "~/org/work-log.org")
        "* %?"
        :empty-lines 0)

	("n" "Note"
        entry (file+headline "~/org/notes.org" "Random Notes")
        "** %?"
        :empty-lines 0)

	("g" "General To-Do"
        entry (file+headline "~/org/todos.org" "General Tasks")
        "* TODO [#B] %?\n:Created: %T\n "
        :empty-lines 0)

	("c" "Code To-Do"
        entry (file+headline "~/org/todos.org" "Code Related Tasks")
        "* TODO [#B] %?\n:Created: %T\n%i\n%a\nProposed Solution: "
        :empty-lines 0)

	("m" "Meeting"
        entry (file+datetree "~/org/meetings.org")
        "* %? :meeting:%^g \n:Created: %T\n** Attendees\n*** \n** Notes\n** Action Items\n*** TODO [#A] "
        :tree-type week
        :clock-in t
        :clock-resume t
        :empty-lines 0)

	))


;; TODO states
(setq org-todo-keywords
     '((sequence "TODO(t)" "PLANNING(p)" "IN-PROGRESS(i@/!)" "VERIFYING(v!)" "BLOCKED(b@)"  "|" "DONE(d!)" "OBE(o@!)" "WONT-DO(w@/!)" )
        ))

;; TODO colors
(setq org-todo-keyword-faces
     '(
       ("TODO" . (:foreground "GoldenRod" :weight bold))
       ("PLANNING" . (:foreground "DeepPink" :weight bold))
       ("IN-PROGRESS" . (:foreground "Cyan" :weight bold))
       ("VERIFYING" . (:foreground "DarkOrange" :weight bold))
       ("BLOCKED" . (:foreground "Red" :weight bold))
       ("DONE" . (:foreground "LimeGreen" :weight bold))
       ("OBE" . (:foreground "LimeGreen" :weight bold))
       ("WONT-DO" . (:foreground "LimeGreen" :weight bold))
       ))

;; Tags
(setq org-tag-alist '(
                     ;; Ticket types
                     (:startgroup . nil)
                     ("@bug" . ?b)
                     ("@feature" . ?u)
                     ("@spike" . ?j)                      
                     (:endgroup . nil)

                     ;; Ticket flags
                     ("@write_future_ticket" . ?w)
                     ("@emergency" . ?e)
                     ("@research" . ?r)

                     ;; Meeting types
                     (:startgroup . nil)
                     ("scrum" . ?g)
		      ("requirements" . ?d)
                     ("sprint_retro" . ?r)
		      ("review" . ?v)
		      ("planning" . ?l)
		      ("customer" . ?c)
		      ("program" . ?p)
		      ("briefing" . ?b)
		      ("security" . ?x)
		      ("status" . ?s)
                     (:endgroup . nil)

                     ;; Code TODOs tags
                     ("QA" . ?q)
                     ("backend" . ?k)
                     ("broken_code" . ?c)
                     ("frontend" . ?f)

                     ;; Special tags
                     ("CRITICAL" . ?x)
                     ("obstacle" . ?o)

                     ;; Meeting tags
                     ("HR" . ?h)
                     ("general" . ?l)
                     ("meeting" . ?m)
                     ("misc" . ?z)
                     ("planning" . ?p)

                     ;; Work Log Tags
                     ("accomplishment" . ?a)
                     ))

;; Tag colors
(setq org-tag-faces
     '(
       ("planning"  . (:foreground "mediumPurple1" :weight bold))
       ("backend"   . (:foreground "royalblue1"    :weight bold))
       ("frontend"  . (:foreground "forest green"  :weight bold))
       ("QA"        . (:foreground "sienna"        :weight bold))
       ("meeting"   . (:foreground "yellow1"       :weight bold))
       ("CRITICAL"  . (:foreground "red1"          :weight bold))
       )
     )

;; Agenda View "d"
(defun air-org-skip-subtree-if-priority (priority)
 "Skip an agenda subtree if it has a priority of PRIORITY.

   PRIORITY may be one of the characters ?A, ?B, or ?C."
 (let ((subtree-end (save-excursion (org-end-of-subtree t)))
       (pri-value (* 1000 (- org-lowest-priority priority)))
       (pri-current (org-get-priority (thing-at-point 'line t))))
   (if (= pri-value pri-current)
       subtree-end
     nil)))

(setq org-agenda-skip-deadline-if-done t)

(setq org-agenda-custom-commands
     '(

       ;; Daily Agenda & TODOs
       ("d" "Daily agenda and all TODOs"

        ;; Display items with priority A
        ((tags "PRIORITY=\"A\""
               ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                (org-agenda-overriding-header "High-priority unfinished tasks:")))

         ;; View 7 days in the calendar view
         (agenda "" ((org-agenda-span 7)))

         ;; Display items with priority B (really it is view all items minus A & C)
         (alltodo ""
                  ((org-agenda-skip-function '(or (air-org-skip-subtree-if-priority ?A)
                                                  (air-org-skip-subtree-if-priority ?C)
                                                  (org-agenda-skip-if nil '(scheduled deadline))))
                   (org-agenda-overriding-header "ALL normal priority tasks:")))

         ;; Display items with pirority C
         (tags "PRIORITY=\"C\""
               ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                (org-agenda-overriding-header "Low-priority Unfinished tasks:")))
         )

        ;; Don't compress things (change to suite your tastes)
        ((org-agenda-compact-blocks nil)))

       ;; Erik's Super View
       ("e" "Erik's Super View"
        (
         (agenda ""
                 (
                  (org-agenda-remove-tags t)                                       
                  (org-agenda-span 7)
                  )
                 )

         (alltodo ""
                  (
                   ;; Remove tags to make the view cleaner
                   (org-agenda-remove-tags t)
                   (org-agenda-prefix-format "  %t  %s")                    
                   (org-agenda-overriding-header "CURRENT STATUS")

                   ;; Define the super agenda groups (sorts by order)
                   (org-super-agenda-groups
                    '(
                      ;; Filter where tag is CRITICAL
                      (:name "Critical Tasks"
                             :tag "CRITICAL"
                             :order 0
                             )
                      ;; Filter where TODO state is IN-PROGRESS
                      (:name "Currently Working"
                             :todo "IN-PROGRESS"
                             :order 1
                             )
                      ;; Filter where TODO state is PLANNING
                      (:name "Planning Next Steps"
                             :todo "PLANNING"
                             :order 2
                             )
                      ;; Filter where TODO state is BLOCKED or where the tag is obstacle
                      (:name "Problems & Blockers"
                             :todo "BLOCKED"
                             :tag "obstacle"                              
                             :order 3
                             )
                      ;; Filter where tag is @write_future_ticket
                      (:name "Tickets to Create"
                             :tag "@write_future_ticket"
                             :order 4
                             )
                      ;; Filter where tag is @research
                      (:name "Research Required"
                             :tag "@research"
                             :order 7
                             )
                      ;; Filter where tag is meeting and priority is A (only want TODOs from meetings)
                      (:name "Meeting Action Items"
                             :and (:tag "meeting" :priority "A")
                             :order 8
                             )
                      ;; Filter where state is TODO and the priority is A and the tag is not meeting
                      (:name "Other Important Items"
                             :and (:todo "TODO" :priority "A" :not (:tag "meeting"))
                             :order 9
                             )
                      ;; Filter where state is TODO and priority is B
                      (:name "General Backlog"
                             :and (:todo "TODO" :priority "B")
                             :order 10
                             )
                      ;; Filter where the priority is C or less (supports future lower priorities)
                      (:name "Non Critical"
                             :priority<= "C"
                             :order 11
                             )
                      ;; Filter where TODO state is VERIFYING
                      (:name "Currently Being Verified"
                             :todo "VERIFYING"
                             :order 20
                             )
                      )
                    )
                   )
                  )
         ))
       ))


;;
;; Saved by Customize
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(nord))
 '(custom-safe-themes
   '("a7d492b6d2d0940ef70f376e82e94144c2493a5a687c514f607a45587920f803"
     "a5b8812270156398a2d93358c0ffd9525fc4fcc4ecb9844aa040e54613146a24"
     "0ca4a8417a19ecbbf4538550b90424bf11d5e8caff99c605165cf0a058b52fef"
     "5fbc6b52931e112ad0f9938a6e68ec84ec07ef9e203b5c80e4fc1cda81dc5fa8"
     "5a4cdc4365122d1a17a7ad93b6e3370ffe95db87ed17a38a94713f6ffe0d8ceb"
     default))
 '(package-selected-packages
   '(ag all-the-icons-completion all-the-icons-dired all-the-icons-ivy
	all-the-icons-ivy-rich all-the-icons-nerd-fonts async bitbake
	bitbake-ts-mode breadcrumb cargo cargo-mode comment-tags
	company company-prescient consult consult-dash
	consult-eglot-embark csv-mode dap-mode default-text-scale
	doom-modeline dumb-jump eglot elgrep embark embark-consult
	emojify excorporate exec-path-from-shell find-file-in-project
	find-file-in-repository flycheck flyspell-correct fontawesome
	fzf gnuplot gnuplot-mode highlight-doxygen
	ligature-pragmatapro lsp-treemacs lsp-ui magit-delta
	marginalia nerd-icons-completion nerd-icons-ivy-rich
	nord-theme nov octicons orderless org org-super-agenda
	orgtbl-ascii-plot pdf-tools pdf-view-restore power-mode
	prescient projectile projectile-ripgrep rg rust-playground
	rustic spaceline-all-the-icons tokyonight-themes toml-mode
	transient treemacs treemacs-all-the-icons treemacs-icons-dired
	treemacs-magit treemacs-nerd-icons treemacs-projectile
	treemacs-tab-bar treesit-auto vertico vertico-prescient
	wfnames which-key with-editor yaml-mode yasnippet
	zenburn-theme))
 '(safe-local-variable-values '((ffip-project-root . "~/proj/ngsri/cla-apps/"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#2E3440" :foreground "#D8DEE9" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 100 :width normal :foundry "MS  " :family "Consolas"))))
 '(eshell-ls-backup ((t (:foreground "#D8DEE9"))))
 '(eshell-ls-directory ((t (:inherit font-lock-function-name-face :foreground "#5E81AC"))))
 '(eshell-ls-executable ((t (:foreground "#8FBCBB" :weight bold))))
 '(eshell-ls-special ((t (:foreground "#EBCB8B" :weight bold))))
 '(eshell-ls-symlink ((t (:inherit font-lock-keyword-face :foreground "#5E81AC" :underline t))))
 '(eshell-prompt ((t (:foreground "#A3BE8C" :weight bold))))
 '(fixed-pitch ((((type graphic)) :family "Aporetic Sans Mono" :height 0.9)))
 '(font-lock-comment-face ((t (:slant italic))))
 '(font-lock-doc-face ((t (:slant italic))))
 '(info-title-1 ((t (:inherit info-title-2 :height 0.8))))
 '(lsp-headerline-breadcrumb-separator-face ((t (:inherit shadow :foreground "#88c0d0" :height 0.8))))
 '(lsp-inlay-hint-type-face ((t (:inherit lsp-inlay-hint-face :height 0.95))))
 '(markdown-code-face ((t (:inherit default :font "Consolas"))))
 '(menu ((t (:background "#3b4252" :foreground "#81a1c1" :height 0.9 :family "Source Sans Pro"))))
 '(mode-line ((t (:background "#4C566A" :foreground "#88C0D0" :height 1.0))))
 '(org-document-title ((t (:inherit default :weight bold :font "Source Sans Pro" :height 160 :underline nil))))
 '(org-level-1 ((t (:inherit default :weight bold :font "Source Sans Pro" :height 150))))
 '(org-level-2 ((t (:inherit default :weight bold :font "Source Sans Pro" :height 140))))
 '(org-level-3 ((t (:inherit default :weight bold :font "Source Sans Pro" :height 130))))
 '(org-level-4 ((t (:inherit default :weight bold :font "Source Sans Pro" :height 120))))
 '(org-level-5 ((t (:inherit default :weight bold :font "Source Sans Pro"))))
 '(org-level-6 ((t (:inherit default :weight bold :font "Source Sans Pro"))))
 '(org-level-7 ((t (:inherit default :weight bold :font "Source Sans Pro"))))
 '(org-level-8 ((t (:inherit default :weight bold :font "Source Sans Pro"))))
 '(shr-h1 ((t (:weight bold :height 0.9))))
 '(tab-bar ((t (:inherit variable-pitch :font "Source Sans Pro" :height 100 :background "#2E3440" :foreground "#88c0d0"))))
 '(tab-bar-tab ((t (:inherit tab-bar :background "#2E3440" :foreground "#88c0d0" :box (:line-width (1 . 1) :style released-button)))))
 '(tab-bar-tab-highlight ((t (:height 110 :background "#3b4252" :foreground "#88c0d0" :box (:line-width (1 . 1))))))
 '(tab-bar-tab-inactive ((t (:inherit tab-bar-tab :background "#3b4252" :foreground "#4c566a" :box (1 . 1)))))
 '(tooltip ((t (:background "#4C566A" :foreground "#D8DEE9" :height 1.1 :family "Source Sans Pro"))))
 '(variable-pitch ((((type graphic)) :family "iA Writer Quattro V" :height 1.0)))
 '(variable-pitch-text ((t (:inherit variable-pitch :family "iA Writer Quartro V")))))

 ;; '(lsp-ui-sideline-current-symbol ((((background light)) (:foreground "black" :weight ultra-bold :box (:line-width (1 . -1) :color "black") :height 1.0 :family "Consolas")) (t (:foreground "white" :weight ultra-bold :box (:line-width (1 . -1) :color "white") :height 1.0 :family "Consolas"))))
 ;; '(lsp-ui-sideline-global ((t (:family "Consolas"))))
 ;; '(lsp-ui-sideline-symbol ((t (:foreground "grey" :box (:line-width (1 . -1) :color "grey") :height 1.0 :family "Consolas"))))
 ;; '(lsp-ui-sideline-symbol-info ((t (:slant italic :height 1.0 :family "Consolas"))))


 ;; '(tab-bar ((((type graphic)) :height 100 :background "#2e3440" :foreground "#81a1c1")))
 ;; '(tab-bar-tab ((t (:inherit tab-bar :background "#4c566a" :box (:line-width (1 . 1) :style released-button)))))
 ;; '(tab-bar-tab-highlight ((t (:height 100 :background "#3b4252" :foreground "#81a1c1" :box (:line-width (1 . 1) :style released-button)))))
 ;; '(tab-bar-tab-inactive ((t (:inherit tab-bar-tab :height 110 :background "#2e3440" :for
;;				      eground "#4c566a"))))

 ;; '(tab-bar ((t (:inherit variable-pitch :font "Source Sans Pro" :height 110 :background "#2E3440" :foreground "#81A1C1"))))
 ;; '(tab-bar-tab ((t (:inherit tab-bar :background "#4c566a" :box (:line-width (1 . 1) :style released-button)))))
 ;; '(tab-bar-tab-highlight ((t (:height 110 :background "#3b4252" :foreground "#81a1c1" :box (:line-width (1 . 1) :style released-button)))))
 ;; '(tab-bar-tab-inactive ((t (:inherit tab-bar-tab :height 110 :background "#2e3440" :foreground "#D8DEE9"))))

;; Set the point, aka cursor, for high visibility
(set-cursor-color "red")

;;
;; Adjust minibuffer face to be smaller
;;
(defvar-local my-minibuffer-font-remap-cookie nil
  "The current face remap of `my-minibuffer-set-font'.")

(defface my-minibuffer-default
  '((t :height 0.9))
  "Face for the minibuffer and the Completions.")

(defun my-minibuffer-set-font ()
  (setq-local my-minibuffer-font-remap-cookie
              (face-remap-add-relative 'default 'my-minibuffer-default)))

(add-hook 'minibuffer-mode-hook #'my-minibuffer-set-font)

;;
;; Magit - a git porcelain
;;
(add-to-list 'load-path "~/.emacs.d/site-lisp/magit/lisp")
(require 'magit)

(with-eval-after-load 'info
 (info-initialize)
 (add-to-list 'Info-directory-list
              "~/.emacs.d/site-lisp/magit/Documentation/"))

;; autocompletes filenames in current git repository
;;  fails back to regular find-file outside of repo
(global-set-key (kbd "C-x f") 'find-file-in-repository)

(with-eval-after-load 'magit-mode
 (add-hook 'after-save-hook 'magit-after-save-refresh-status t))

;;
;; Projectile
;;
;; Optional: ag is nice alternative to using grep with Projectile
(use-package ag
 :ensure t)

(use-package projectile
 :ensure t
 :init
 (setq projectile-project-search-path '(("~/proj/ngsri" 1)))
 :config
 ;; I typically use this keymap prefix on macOS
 (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
 ;; On Linux, however, I usually go with another one
 (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
 (global-set-key (kbd "C-c p") 'projectile-command-map)
 (projectile-mode +1))

;; Enable caching in large projects
(setq projectile-enable-caching t)

;; Use "fd" to find files in project
(setq ffip-use-rust-fd t)


;; If non-nil, cause imenu to see `doom-modeline' declarations.
;; This is done by adjusting `lisp-imenu-generic-expression' to
;; include support for finding `doom-modeline-def-*' forms.
;; Must be set before loading doom-modeline.
(setq doom-modeline-support-imenu t)

;; How tall the mode-line should be. It's only respected in GUI.
;; If the actual char height is larger, it respects the actual height.
(setq doom-modeline-height 12)

;; How wide the mode-line bar should be. It's only respected in GUI.
(setq doom-modeline-bar-width 4)

;; Whether to use hud instead of default bar. It's only respected in GUI.
(setq doom-modeline-hud nil)

;; The limit of the window width.
;; If `window-width' is smaller than the limit, some information won't be
;; displayed. It can be an integer or a float number. `nil' means no limit."
(setq doom-modeline-window-width-limit 85)

;; Override attributes of the face used for padding.
;; If the space character is very thin in the modeline, for example if a
;; variable pitch font is used there, then segments may appear unusually close.
;; To use the space character from the `fixed-pitch' font family instead, set
;; this variable to `(list :family (face-attribute 'fixed-pitch :family))'.
(setq doom-modeline-spc-face-overrides nil)

;; How to detect the project root.
;; nil means to use `default-directory'.
;; The project management packages have some issues on detecting project root.
;; e.g. `projectile' doesn't handle symlink folders well, while `project' is unable
;; to hanle sub-projects.
;; You can specify one if you encounter the issue.
(setq doom-modeline-project-detection 'auto)

;; Determines the style used by `doom-modeline-buffer-file-name'.
;;
;; Given ~/Projects/FOSS/emacs/lisp/comint.el
;;   auto => emacs/l/comint.el (in a project) or comint.el
;;   truncate-upto-project => ~/P/F/emacs/lisp/comint.el
;;   truncate-from-project => ~/Projects/FOSS/emacs/l/comint.el
;;   truncate-with-project => emacs/l/comint.el
;;   truncate-except-project => ~/P/F/emacs/l/comint.el
;;   truncate-upto-root => ~/P/F/e/lisp/comint.el
;;   truncate-all => ~/P/F/e/l/comint.el
;;   truncate-nil => ~/Projects/FOSS/emacs/lisp/comint.el
;;   relative-from-project => emacs/lisp/comint.el
;;   relative-to-project => lisp/comint.el
;;   file-name => comint.el
;;   file-name-with-project => FOSS|comint.el
;;   buffer-name => comint.el<2> (uniquify buffer name)
;;
;; If you are experiencing the laggy issue, especially while editing remote files
;; with tramp, please try `file-name' style.
;; Please refer to https://github.com/bbatsov/projectile/issues/657.
(setq doom-modeline-buffer-file-name-style 'auto)

;; Whether display icons in the mode-line.
;; While using the server mode in GUI, should set the value explicitly.
(setq doom-modeline-icon t)

;; Whether display the icon for `major-mode'. It respects option `doom-modeline-icon'.
(setq doom-modeline-major-mode-icon t)

;; Whether display the colorful icon for `major-mode'.
;; It respects `nerd-icons-color-icons'.
(setq doom-modeline-major-mode-color-icon t)

;; Whether display the icon for the buffer state. It respects option `doom-modeline-icon'.
(setq doom-modeline-buffer-state-icon t)

;; Whether display the modification icon for the buffer.
;; It respects option `doom-modeline-icon' and option `doom-modeline-buffer-state-icon'.
(setq doom-modeline-buffer-modification-icon t)

;; Whether display the lsp icon. It respects option `doom-modeline-icon'.
(setq doom-modeline-lsp-icon t)

;; Whether display the time icon. It respects option `doom-modeline-icon'.
(setq doom-modeline-time-icon t)

;; Whether display the live icons of time.
;; It respects option `doom-modeline-icon' and option `doom-modeline-time-icon'.
(setq doom-modeline-time-live-icon t)

;; Whether to use an analogue clock svg as the live time icon.
;; It respects options `doom-modeline-icon', `doom-modeline-time-icon', and `doom-modeline-time-live-icon'.
(setq doom-modeline-time-analogue-clock t)

;; The scaling factor used when drawing the analogue clock.
(setq doom-modeline-time-clock-size 0.7)

;; Whether to use unicode as a fallback (instead of ASCII) when not using icons.
(setq doom-modeline-unicode-fallback nil)

;; Whether display the buffer name.
(setq doom-modeline-buffer-name t)

;; Whether highlight the modified buffer name.
(setq doom-modeline-highlight-modified-buffer-name t)

;; When non-nil, mode line displays column numbers zero-based.
;; See `column-number-indicator-zero-based'.
(setq doom-modeline-column-zero-based t)

;; Specification of \"percentage offset\" of window through buffer.
;; See `mode-line-percent-position'.
(setq doom-modeline-percent-position '(-3 "%p"))

;; Format used to display line numbers in the mode line.
;; See `mode-line-position-line-format'.
(setq doom-modeline-position-line-format '("L%l"))

;; Format used to display column numbers in the mode line.
;; See `mode-line-position-column-format'.
(setq doom-modeline-position-column-format '("C%c"))

;; Format used to display combined line/column numbers in the mode line. See `mode-line-position-column-line-format'.
(setq doom-modeline-position-column-line-format '("%l:%c"))

;; Whether display the minor modes in the mode-line.
(setq doom-modeline-minor-modes nil)

;; If non-nil, a word count will be added to the selection-info modeline segment.
(setq doom-modeline-enable-word-count nil)

;; Major modes in which to display word count continuously.
;; Also applies to any derived modes. Respects `doom-modeline-enable-word-count'.
;; If it brings the sluggish issue, disable `doom-modeline-enable-word-count' or
;; remove the modes from `doom-modeline-continuous-word-count-modes'.
(setq doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))

;; Whether display the buffer encoding.
(setq doom-modeline-buffer-encoding t)

;; Whether display the indentation information.
(setq doom-modeline-indent-info nil)

;; Whether display the total line number。
(setq doom-modeline-total-line-number nil)

;; Whether display the icon of vcs segment. It respects option `doom-modeline-icon'."
(setq doom-modeline-vcs-icon t)

;; The maximum displayed length of the branch name of version control.
(setq doom-modeline-vcs-max-length 15)

;; The function to display the branch name.
(setq doom-modeline-vcs-display-function #'doom-modeline-vcs-name)

;; Alist mapping VCS states to their corresponding faces.
;; See `vc-state' for possible values of the state.
;; For states not explicitly listed, the `doom-modeline-vcs-default' face is used.
(setq doom-modeline-vcs-state-faces-alist
     '((needs-update . (doom-modeline-warning bold))
       (removed . (doom-modeline-urgent bold))
       (conflict . (doom-modeline-urgent bold))
       (unregistered . (doom-modeline-urgent bold))))

;; Whether display the icon of check segment. It respects option `doom-modeline-icon'.
(setq doom-modeline-check-icon t)

;; If non-nil, only display one number for check information if applicable.
(setq doom-modeline-check-simple-format nil)

;; The maximum number displayed for notifications.
(setq doom-modeline-number-limit 99)

;; Whether display the project name. Non-nil to display in the mode-line.
(setq doom-modeline-project-name t)

;; Whether display the workspace name. Non-nil to display in the mode-line.
(setq doom-modeline-workspace-name t)

;; Whether display the perspective name. Non-nil to display in the mode-line.
(setq doom-modeline-persp-name t)

;; If non nil the default perspective name is displayed in the mode-line.
(setq doom-modeline-display-default-persp-name nil)

;; If non nil the perspective name is displayed alongside a folder icon.
(setq doom-modeline-persp-icon t)

;; Whether display the `lsp' state. Non-nil to display in the mode-line.
(setq doom-modeline-lsp t)

;; Whether display the GitHub notifications. It requires `ghub' package.
(setq doom-modeline-github nil)

;; The interval of checking GitHub.
(setq doom-modeline-github-interval (* 30 60))

;; Whether display the modal state.
;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
(setq doom-modeline-modal t)

;; Whether display the modal state icon.
;; Including `evil', `overwrite', `god', `ryo' and `xah-fly-keys', etc.
(setq doom-modeline-modal-icon t)

;; Whether display the modern icons for modals.
(setq doom-modeline-modal-modern-icon t)

;; When non-nil, always show the register name when recording an evil macro.
(setq doom-modeline-always-show-macro-register nil)

;; Whether display the mu4e notifications. It requires `mu4e-alert' package.
;;(setq doom-modeline-mu4e nil)
;; also enable the start of mu4e-alert
;;(mu4e-alert-enable-mode-line-display)

;; Whether display the gnus notifications.
(setq doom-modeline-gnus t)

;; Whether gnus should automatically be updated and how often (set to 0 or smaller than 0 to disable)
(setq doom-modeline-gnus-timer 2)

;; Wheter groups should be excludede when gnus automatically being updated.
(setq doom-modeline-gnus-excluded-groups '("dummy.group"))

;; Whether display the IRC notifications. It requires `circe' or `erc' package.
(setq doom-modeline-irc t)

;; Function to stylize the irc buffer names.
(setq doom-modeline-irc-stylize 'identity)

;; Whether display the battery status. It respects `display-battery-mode'.
(setq doom-modeline-battery t)

;; Whether display the time. It respects `display-time-mode'.
(setq doom-modeline-time t)

;; Whether display the misc segment on all mode lines.
;; If nil, display only if the mode line is active.
(setq doom-modeline-display-misc-in-all-mode-lines t)

;; The function to handle `buffer-file-name'.
(setq doom-modeline-buffer-file-name-function #'identity)

;; The function to handle `buffer-file-truename'.
(setq doom-modeline-buffer-file-truename-function #'identity)

;; Whether display the environment version.
(setq doom-modeline-env-version t)
;; Or for individual languages
(setq doom-modeline-env-enable-python t)
(setq doom-modeline-env-enable-ruby t)
(setq doom-modeline-env-enable-perl t)
(setq doom-modeline-env-enable-go t)
(setq doom-modeline-env-enable-elixir t)
(setq doom-modeline-env-enable-rust t)

;; Change the executables to use for the language version string
(setq doom-modeline-env-python-executable "python") ; or `python-shell-interpreter'
(setq doom-modeline-env-ruby-executable "ruby")
(setq doom-modeline-env-perl-executable "perl")
(setq doom-modeline-env-go-executable "go")
(setq doom-modeline-env-elixir-executable "iex")
(setq doom-modeline-env-rust-executable "rustc")

;; What to display as the version while a new one is being loaded
(setq doom-modeline-env-load-string "...")

;; By default, almost all segments are displayed only in the active window. To
;; display such segments in all windows, specify e.g.
(setq doom-modeline-always-visible-segments '(mu4e irc))

;; Hooks that run before/after the modeline version string is updated
(setq doom-modeline-before-update-env-hook nil)
(setq doom-modeline-after-update-env-hook nil)


;; Fixes for running off the right side of the modeline
(setq all-the-icons-scale-factor 1.1)
;;(doom-modeline-def-modeline 'main '(bar matches buffer-info remote-host buffer-position parrot selection-info))

;;
;; consult
;;
;; Example configuration for Consult
(use-package consult
 ;; Replace bindings. Lazily loaded by `use-package'.
 :bind (;; C-c bindings in `mode-specific-map'
        ("C-c M-x" . consult-mode-command)
        ("C-c h" . consult-history)
        ("C-c k" . consult-kmacro)
        ("C-c m" . consult-man)
        ("C-c i" . consult-info)
        ([remap Info-search] . consult-info)
        ;; C-x bindings in `ctl-x-map'
        ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
        ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
        ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
        ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
        ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
        ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
        ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
        ;; Custom M-# bindings for fast register access
        ("M-#" . consult-register-load)
        ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
        ("C-M-#" . consult-register)
        ;; Other custom bindings
        ("M-y" . consult-yank-pop)                ;; orig. yank-pop
        ;; M-g bindings in `goto-map'
        ("M-g e" . consult-compile-error)
        ("M-g r" . consult-grep-match)
        ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
        ("M-g g" . consult-goto-line)             ;; orig. goto-line
        ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
        ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
        ("M-g m" . consult-mark)
        ("M-g k" . consult-global-mark)
        ("M-g i" . consult-imenu)
        ("M-g I" . consult-imenu-multi)
        ;; M-s bindings in `search-map'
        ("M-s d" . consult-find)                  ;; Alternative: consult-fd
        ("M-s c" . consult-locate)
        ("M-s g" . consult-grep)
        ("M-s G" . consult-git-grep)
        ("M-s r" . consult-ripgrep)
        ("M-s l" . consult-line)
        ("M-s L" . consult-line-multi)
        ("M-s k" . consult-keep-lines)
        ("M-s u" . consult-focus-lines)
        ;; Isearch integration
        ("M-s e" . consult-isearch-history)
        :map isearch-mode-map
        ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
        ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
        ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
        ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
        ;; Minibuffer history
        :map minibuffer-local-map
        ("M-s" . consult-history)                 ;; orig. next-matching-history-element
        ("M-r" . consult-history))                ;; orig. previous-matching-history-element

 ;; Enable automatic preview at point in the *Completions* buffer. This is
 ;; relevant when you use the default completion UI.
 :hook (completion-list-mode . consult-preview-at-point-mode)

 ;; The :init configuration is always executed (Not lazy)
 :init

 ;; Tweak the register preview for `consult-register-load',
 ;; `consult-register-store' and the built-in commands.  This improves the
 ;; register formatting, adds thin separator lines, register sorting and hides
 ;; the window mode line.
 (advice-add #'register-preview :override #'consult-register-window)
 (setq register-preview-delay 0.5)

 ;; Use Consult to select xref locations with preview
 (setq xref-show-xrefs-function #'consult-xref
       xref-show-definitions-function #'consult-xref)

 ;; Configure other variables and modes in the :config section,
 ;; after lazily loading the package.
 :config

 ;; Optionally configure preview. The default value
 ;; is 'any, such that any key triggers the preview.
 ;; (setq consult-preview-key 'any)
 ;; (setq consult-preview-key "M-.")
 ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
 ;; For some commands and buffer sources it is useful to configure the
 ;; :preview-key on a per-command basis using the `consult-customize' macro.
 (consult-customize
  consult-theme :preview-key '(:debounce 0.2 any)
  consult-ripgrep consult-git-grep consult-grep consult-man
  consult-bookmark consult-recent-file consult-xref
  consult-source-bookmark consult-source-file-register
  consult-source-recent-file consult-source-project-recent-file
  ;; :preview-key "M-."
  :preview-key '(:debounce 0.4 any))

 ;; Optionally configure the narrowing key.
 ;; Both < and C-+ work reasonably well.
 (setq consult-narrow-key "<") ;; "C-+"

 ;; Optionally make narrowing help available in the minibuffer.
 ;; You may want to use `embark-prefix-help-command' or which-key instead.
 ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
 )

 (use-package consult-dash
 :bind (("M-s d" . consult-dash))
 :config
 ;; Use the symbol at point as initial search term
 (consult-customize consult-dash :initial (thing-at-point 'symbol)))

(use-package embark
 :ensure t

 :bind
 (("C-." . embark-act)         ;; pick some comfortable binding
  ("C-;" . embark-dwim)        ;; good alternative: M-.
  ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

 :init

 ;; Optionally replace the key help with a completing-read interface
 (setq prefix-help-command #'embark-prefix-help-command)

 ;; Show the Embark target at point via Eldoc. You may adjust the
 ;; Eldoc strategy, if you want to see the documentation from
 ;; multiple providers. Beware that using this can be a little
 ;; jarring since the message shown in the minibuffer can be more
 ;; than one line, causing the modeline to move up and down:

 ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
 ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

 ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
 ;; (context-menu-mode 1)
 ;; (add-hook 'context-menu-functions #'embark-context-menu 100)

 :config

 ;; Hide the mode line of the Embark live/completions buffers
 (add-to-list 'display-buffer-alist
              '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                nil
                (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
 :ensure t ; only need to install it, embark loads it after consult if found
 :hook
 (embark-collect-mode . consult-preview-at-point-mode))


;;
;; Projectile
;;

;; Optional: ag is nice alternative to using grep with Projectile
(use-package ag
 :ensure t)

(use-package projectile
 :ensure t
 :init
 (setq projectile-project-search-path '(("~/proj" 1)))
 :config
 ;; I typically use this keymap prefix on macOS
 (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
 ;; On Linux, however, I usually go with another one
 (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
 (global-set-key (kbd "C-c p") 'projectile-command-map)
 (projectile-mode +1))


;;
;; Hippie Expand
;;
(global-set-key [remap dabbrev-expand] 'hippie-expand)

;; Use dumb-jump for xref
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

(defun emacs-uri-handler (uri)
  "Handles emacs URIs in the form: emacs:///path/to/file/LINENUM"
  (save-match-data
    (if (string-match "emacs://\\(.*\\)/\\([0-9]+\\)$" uri)
        (let ((filename (match-string 1 uri))
              (linenum (match-string 2 uri)))
          (while (string-match "\\(%20\\)" filename)
            (setq filename (replace-match " " nil t filename 1)))
          (with-current-buffer (find-file filename)
            (goto-line (string-to-number linenum))))
      (beep)
      (message "Unable to parse the URI <%s>"  uri))))

;;
;; sshfs
;;
(defconst mpn-file-remote-mount-points
  (mapcar (lambda (d) (directory-file-name
                       (expand-file-name d)))
          '("~/.guinea"))
  "List of locations where remote file systems have been mounted.
Each directory listed must be an absolute expanded path and must
not end with a slash.")

(push (let ((re (regexp-opt mpn-file-remote-mount-points nil)))
        (list (concat "\\`" re "\\(?:/\\|\\'\\)")
              (concat temporary-file-directory "remote")
              t))
      auto-save-file-name-transforms)

(defun mpn-file-remote-mount-p (&optional file-name)
  "Return whether FILE-NAME is under a remote mount point.
Use ‘buffer-file-name’ if FILE-NAME is not given.  List of remote
mount points is defined in ‘mpn-file-remote-mount-points’
variable."
  (when-let ((name (or file-name buffer-file-name)))
    (let ((dirs mpn-file-remote-mount-points)
          (name-len (length name))
          dir dir-len matched)
      (while (and dirs (not matched))
        (setq dir (car dirs)
              dirs (cdr dirs)
              dir-len (length dir)
              matched (and (> name-len dir-len)
                           (eq ?/ (aref name dir-len))
                           (eq t (compare-strings name 0 dir-len
                                                  dir 0 dir-len)))))
      matched)))

(defun mpn-dont-lock-remote-files ()
  "Set ‘create-lockfiles’ to nil if buffer opens a remote file.
Use ‘mpn-file-remote-mount-p’ to determine whether opened file is
remote or not.  Do nothing if ‘create-lockfiles’ is already nil."
  (and create-lockfiles
       (mpn-file-remote-mount-p)
       (setq-local create-lockfiles nil)))

(add-hook 'find-file-hook #'mpn-dont-lock-remote-files)

;; (use-package eglot
;;   :config
;;   (setq eglot-events-buffer-size 0
;;         eglot-ignored-server-capabilities '(:inlayHintProvider)
;;         eglot-confirm-server-initiated-edits nil))

;; (use-package rustic
;;   :config
;;   ; Tell rustic where to find the cargo binary
;;   (setq rustic-cargo-bin-remote "/usr/local/cargo/bin/cargo")
;;   (setq rustic-lsp-client 'eglot))

;;
;; Remote hosts
;;
(defun guinea ()
  (interactive)
  (dired "/sshx:etheisen@guinea:/home/etheisen")
  )

(defun labrat ()
  (interactive)
  (dired "/sshx:etheisen@labrat:/home/etheisen")
  )

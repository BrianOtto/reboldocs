REBOL [
	title: "Parse Aid"
	file: %parse-aid.r
	author: "Marco Antoniazzi"
	Copyright: "(C) 2011,2012,2013 Marco Antoniazzi. All Rights reserved"
	email: [luce80 AT libero DOT it]
	date: 26-10-2013
	version: 0.6.2
	Purpose: "Help make and test parse rules"
	History: [
		0.5.1 [03-09-2011 "First version"]
		0.5.2 [04-09-2011 "modified resizing"]
		0.5.3 [17-09-2011 "Added balancing, changed save format (using strings to preserve comments)"]
		0.5.4 [18-09-2011 "Modified infinite loop exit mode,fixed scrollers"]
		0.5.5 [24-09-2011 "added shift-selecting"]
		0.5.6 [05-01-2012 "added results auto-scrolling"]
		0.5.7 [22-01-2012 "little bug fix in error handling"]
		0.5.8 [05-05-2012 "added undo (Ctrl+Z) and redo (Ctrl+R)"]
		0.5.9 [14-12-2012 "Fixed undo if no field has focus"]
		0.6.0 [19-03-2013 "Integrates Brett Handley's parse-analysis-view"]
		0.6.1 [13-07-2013 "Added saving before every parse"]
		0.6.2 [26-10-2013 "Fixed to work on R3 (with vid1r3.r)"]
	]
	comment: {28-Aug-2011 GUI automatically generated by VID_build. Author: Marco Antoniazzi
		For help on using visualize see comments in %parse-analysis-view.r and documentation at wwww.rebol.org
	}
	library: [
		level: 'intermediate
		platform: 'all
		type: 'tool
		domain: 'parse
		tested-under: [View 2.7.8.3.1 Saphir-View 2.101.0.3.1]
		support: none
		license: 'BSD
		see-also: none
	]
	thumbnail: http://i40.tinypic.com/2s0zo5d.png
	todo: {
		- parse blocks
		- undo
		- ask to save before exit if something modified
		- scroll-wheel
		- add tips&tricks
	}
]
;************* set correct path to vid1r3.r3 and sdk sources (or use empty string to use default path to sdk) ********************
if all [system/version/1 >= 2 system/version/2 >= 101] [do/args %../../r3/local/vid1r3.r3 %../../sdk-2706031/rebol-sdk-276/source]

; file , undo
	change_title: func [/modified] [
		clear find/tail main-window/text "- "
		if modified [append main-window/text "*"]
		append main-window/text to-string last split-path any [job-name %Untitled]
		main-window/changes: [text] show main-window
	]
	open_file: func [/local file-name temp-list job] [
		until [
			file-name: request-file/title/keep/only/filter "Load a rules file" "Load" "*.r"
			if none? file-name [exit]
			exists? file-name
		]

		job-name: file-name
		temp-list: load file-name
		if not-equal? first temp-list 'Parse_Aid-block [alert "Not a valid Parse-Aid file" exit]
		if not-equal? second temp-list 1 [alert "Not a valid Parse-Aid file" exit]
		job: temp-list

		set-face check-clear-res get job/clear-res
		set-face check-spaces get job/spaces
		set-face field-main-rule job/main-rule
		set-face area-charsets job/charsets
		set-face area-rules job/rules
		set-face area-test job/test

		named: yes
		change_title
		saved?: yes
	]
	save_file: func [/as /no-flash /local file-name filt ext response job f1] [
		;if empty? job [return false]
		if not named [as: true]

		if as [
			filt: "*.r"
			ext: %.r
			file-name: request-file/title/keep/only/save/filter "Save as Rebol file" "Save" filt
			if none? file-name [return false]
			if not-equal? suffix? file-name ext [append file-name ext]
			response: true
			if exists? file-name [response: request rejoin [{File "} last split-path file-name {" already exists, overwrite it?}]]
			if response <> true [return false]
			job-name: file-name
			named: yes
		]
		unless no-flash [f1: flash/with join "Saving to: " job-name main-window]

		job: reduce [
			'Parse_Aid-block 1
			'clear-res get-face check-clear-res
			'spaces get-face check-spaces
			'main-rule get-face field-main-rule
			'charsets get-face area-charsets
			'rules get-face area-rules
			'test get-face area-test
		]
		save job-name job

		unless no-flash [
			wait 1.3
			unview/only f1
			change_title
		]
		saved?: yes
	]
	undo: does [
		if all [system/view/focal-face system/view/focal-face/parent-face/style = 'area-scroll] [system/view/focal-face/parent-face/undo]
	]
	redo: does [
		if system/view/focal-face/parent-face/style = 'area-scroll [system/view/focal-face/parent-face/redo]
	]
; rules
	charsets-block: copy [
		digit: charset [#"0" - #"9"]
		upper: charset [#"A" - #"Z"]
		lower: charset [#"a" - #"z"]
		alpha: union upper lower
		alpha_: union alpha charset "_"
		alpha_digit: union alpha_ digit
		hexdigit: union digit charset "abcdefABCDEF"
		bindigit: charset "01"
		space: charset " ^-^/"
	]
	rules-block: copy [
		digits: [some digit]
		sp*: [any space]
		sp+: [some space]
		
		area-code: ["(" 3 digit ")"]
		local-code: [3 digit "-" 4 digit]
		phone-num: [opt area-code copy var local-code (print ["number:" var])]
	]

	err?: func [blk /local arg1 arg2 arg3 message err][;11-Feb-2007 Guest2
		if not error? err: try blk [return :err]
		err: disarm err
		arg1: any [attempt [get in err 'arg1] 'unset]
		arg2: get in err 'arg2
		arg3: get in err 'arg3
		message: get err/id
		if block? message [bind message 'arg1]
		print ["** ERROR: " form reduce message]
		none
	]
	prin: func [value] [
		either 100000 > length? get-face area-results [ ; avoid fill mem
			set-face area-results append get-face area-results form reduce value
			system/view/vid/vid-feel/move-drag area-results/vscroll/pane/3 1 ; autoscroll down
		][
			alert "ERROR. Probable infinite loop."
			reset-face area-results
			throw
		]
	]
	print: func [value] [prin value prin newline]
	parse_test: func [/local result] [
		if get-face check-clear-res [reset-face area-results]
		if get-face check-save [save_file/no-flash]
		result: err? [
			do load get-face area-charsets
			do load get-face area-rules
			do pick [parse/all parse] get-face check-spaces copy get-face area-test get load get-face field-main-rule
		]
		text-parsed/color: white
		show text-parsed
		wait .1 ; to see the activity
		either logic? result [
			text-parsed/color: 80 + either result [green] [red]
			text-parsed/text: uppercase form result
		] [
			text-parsed/text: "ERROR"
		]
		show text-parsed
	]
; gui
	;do %../gui/area-scroll-style.r ;Copyright: {GNU Less General Public License (LGPL) - Copyright (C) Didier Cadieu 2004} 
	do to-string decompress ; %area-scroll-style.r Copyright: {GNU Less General Public License (LGPL) - Copyright (C) Didier Cadieu 2004} 
		64#{
		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
		IAAA
		}
	resize-faces: func [siz [pair!] /move] [
		area-charsets/ar/line-list: none ; to reactivate auto-wrapping
		resize-face/no-show area-charsets area-charsets/size + (siz * 1x0)

		area-rules/ar/line-list: none ; to reactivate auto-wrapping
		resize-face/no-show area-rules area-rules/size + (siz * 1x2)

		text-test/offset/x: text-test/offset/x + siz/x
		area-test/offset/x: area-test/offset/x + siz/x

		text-results/offset: text-results/offset + siz
		area-results/offset: area-results/offset + siz
		if move [siz: 0x0 - siz]
		resize-face/no-show area-test area-test/size + siz
		resize-face/no-show area-results area-results/size + siz
	]
	feel-move: [
		engage-super: :engage
		engage: func [face action event /local prev-offset] [
			engage-super face action event
			if (action = 'down) [
				face/user-data: event/offset
			]
			if find [over away] action [
				prev-offset: face/offset
				face/offset/x: face/offset/x + event/offset/x - face/user-data/x ; We cannot modify face/old-offset but why not use it?
				face/offset/x: first confine face/offset face/size area-charsets/offset + 100x0 area-test/offset + area-test/size - 100x0

				if prev-offset <> face/offset [
					resize-faces/move (face/offset - prev-offset * 1x0)
					show main-window
				]
			]
			;show face
		]
	]
	;append system/view/VID/vid-styles area-style ; add to master style-sheet
	main-window: center-face layout [
		styles area-style
		do [sp: 4x4] origin sp space sp
		Across
		btn "(O)pen..." #"^O" [open_file]
		btn "(S)ave" #"^S" [save_file]
		pad (sp * -1x0)
		btn "as..." [save_file/as]
		;check-line "save also test" on
		check-save: check-line "before every parse"
		btn "Visualise" sky [visualise]
		check-ignore: check-line "and ignore charsets" off
		space sp
		btn "Clear (T)est" #"^T" [reset-face area-test]
		btn "Clear R(e)sults" #"^e" [reset-face area-results]
		check-clear-res: check-line "before every parse"
		return
		btn "(P)arse" #"^P" yellow [parse_test]
		check-spaces: check-line "also spaces" on
		;check-line "on rules update" on
		text "with this rule:" bold
		field-main-rule: field "phone-num" 300x22
		text bold "Result:"
		text-parsed: text bold as-is "  NONE  " black white center
		return
		Below
		guide
		style area-scroll area-scroll 400x200 hscroll vscroll font-name font-fixed para [origin: 2x0 Tabs: 10]
		text bold "Charsets"
		area-charsets: area-scroll wrap
		text-rules: text bold "Rules"
		area-rules: area-scroll wrap
		return
		button-balance: button "|" 6x450 gray feel feel-move edge [size: 1x1]
		return
		text-test: text bold "Test"
		area-test: area-scroll "(707)467-8000" with [append init [deflag-face self/ar 'tabbed ]]
		text-results: text bold "Results"
		area-results: area-scroll silver read-only
		key escape (sp * 0x-1) [ask_close]
		key #"^Z" (sp * 0x-1) [undo]
		key #"^R" (sp * 0x-1) [redo]
	]
	main-window/user-data: reduce ['size main-window/size]
	insert-event-func func [face event /local siz] [
		switch event/type [
			close [
				if event/face = main-window [ask_close]
				if event/face = vis-win [unview/only vis-win]
				return none
			]
			resize [
				face: main-window
				siz: face/size - face/user-data/size / 2     ; compute size difference / 2
				face/user-data/size: face/size          ; store new size

				resize-faces siz
				button-balance/offset: button-balance/offset + (siz * 1x0)
				button-balance/size: button-balance/size + (siz * 0x2)
				show main-window
			]
		]
		event
	]
	visualise: func [/local modul ruls] [
		modul: all [
			any [
				attempt [do load %parse-analysis.r]
				if confirm "File %parse-analysis.r not found in current directory, download it?" [
					modul: attempt [do load request-download/to http://www.rebol.org/download-a-script.r?script-name=parse-analysis.r %parse-analysis.r]
				]
			]
			any [
				attempt [do load %parse-analysis-view.r]
				if confirm "File %parse-analysis-view.r not found in current directory, download it?" [
					modul: attempt [do load request-download/to http://www.rebol.org/download-a-script.r?script-name=parse-analysis-view.r %parse-analysis-view.r]
				]
			]

			visualise-parse: func [
				{Displays your input and highlights the parse rules.}
				data [string! block!] {Input to the parse.}
				rules [block! object!] {Block of words or an object containing rules. Each word must identify a Parse rule to be hooked.}
				body [block!] {Invoke Parse on your input.}
				/ignore {Exclude specific terms from result.} exclude-terms [block!] {Block of words representing rules.}
				/local result block tokens
			][
				if not ignore [exclude-terms: copy []]
				view/new center-face layout [title "Visualise Parse" label "Tokenising input..."]
				err?  [
					tokens: tokenise-parse/all-events/ignore rules body exclude-terms
					if block? data [
						block: data
						data: mold block
						convert-block-to-text-tokens/text block tokens data
					]
				]
				unview
				if block? tokens [view/new vis-win: make-token-stepper data tokens]
			]
			do get-face area-charsets
			do get-face area-rules
			ruls: context load join get-face area-charsets get-face area-rules 
			visualise-parse/ignore
				copy get-face area-test
				ruls
				[do pick [parse/all parse] get-face check-spaces copy get-face area-test get in ruls to-word get-face field-main-rule]
				either get-face check-ignore [load get-face area-charsets][[]]
		]
	]
	ask_close: does [
		either not saved? [
			switch request ["Exit without saving?" "Yes" "Save" "No"] reduce [
				yes [quit]
				no [if save_file [quit]]
			]
		][
			if confirm "Exit now?" [quit]
			;quit
		]
	]
; main
	
	set-face area-charsets trim mold/only charsets-block
	set-face area-rules trim mold/only rules-block

	job-name: none
	named: no
	saved?: yes
	
	vis-win: none
	
	main-title: join copy System/script/header/title " - Untitled"
	view/title/options main-window main-title reduce ['resize 'min-size main-window/size + system/view/title-size + 8x10 + system/view/resize-border]

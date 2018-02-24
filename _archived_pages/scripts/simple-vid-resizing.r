REBOL [
	Title: "Simplified VID resizing"
	Date: 10-04-2016
	Version: 1.2.2
	File: %simple-vid-resizing.r
	Author: "Marco Antoniazzi"
	Rights: "Copyright (C) 2015 Marco Antoniazzi"
	Purpose: "Helps create resizing VID guis"
	eMail: [luce80 AT libero DOT it]
	History: [
		1.0.0 [15-08-2013 "First version"]
		1.0.1 [16-08-2013 "Changed case/all with switch/all"]
		1.0.2 [21-10-2013 "Adapted to R3 (with vid1r3.r3)"]
		1.1.0 [22-12-2014 "changed resize-deep to resize-faces"]
		1.2.0 [24-01-2015 "fixed R2 pair! rounding errors, reduced resizer block"]
		1.2.1 [24-07-2015 "added win-resizer"]
		1.2.2 [10-04-2016 "fixed insert-event-func"]
	]
	Help: { I have noticed that in many of my resizable guis there are only a few widgets that move or change size
		when the window is resized and they move or change size only to "follow" the window borders.
		In these situations the resizing algorithm is very simple and so I have created this "patch" to
		let you create resizable guis in a very simple way.

		Use the words: move-x, move-y, move-xy, resize-x, resize-y, resize-xy in a layout block to let a
		widget movement or dimensioning "follow" the window borders.
		Use: resize [<offset/x> <offset/y> <size/x> <size/y>] to set multiple values. Note that you
		can use any number inside the block
	}
	Category: [util vid view]
	library: [
		level: 'intermediate
		platform: 'all
		type: 'how-to
		domain: [gui vid]
		tested-under: [View 2.7.8.3.1 Atronix-View 3.0.0.3.3]
		support: none
		license: 'BSD
		see-also: none
	]
	comment: "2-Sep-2012 GUI automatically generated by VID_build. Author: Marco Antoniazzi"
]
;**** please set correct path to vid1r3.r3 and sdk sources (or use empty string to use default path to sdk) ****
if all [system/version > 2.9.0 not value? 'mimic-do-event] [do/args %../../r3/local/vid1r3.r3 %../../sdk-2706031/rebol-sdk-276/source]

resizer-ctx: context [
	if not system/version > 2.7.8.100 [
	set 'view func [
		"Displays a window face."
		view-face [object!]
		/new "Creates a new window and returns immediately"
		/offset xy [pair!] "Offset of window on screen"
		/options opts [block! word!] "Window options [no-title no-border resize]"
		/title text [string!] "Window bar title"
		/local scr-face
		][
		scr-face: system/view/screen-face  ; reduces path overhead
		if find scr-face/pane view-face [return view-face] ; should bring to top !!!
		either any [new empty? scr-face/pane][
			view-face/text: any [
				view-face/text
				all [system/script/header system/script/title]
				copy ""
			]
			new: all [not new empty? scr-face/pane]
			append scr-face/pane view-face
		][change scr-face/pane view-face]
		; Use window-feel, not default feel, unless the user
		; has set their own feel (keep user's feel)
		if all [
			system/view/vid
			view-face/feel = system/view/vid/vid-face/feel
		][
			view-face/feel: system/view/window-feel
		]
		if offset [view-face/offset: xy]
		if options [view-face/options: opts]
		if title [view-face/text: text]
		;;;;;;;;;;;; patch
		view-face/feel: make view-face/feel [old-size: view-face/size]
		;;;;;;;;;;;;
		show scr-face
		;show view-face
		if new [do-events]
		view-face
	]
	]
	;
	resize-faces: func [face [object!] siz [pair!] /local decis][
		if block? get in face 'pane [
			foreach face face/pane [
				if attempt [face/feel/resizer][
					decis: face/feel/decis
					; using <decis> to avoid rounding errors of R2 integer pair! 
					if none? decis/1 [decis/1: face/offset/x]
					decis/1: decis/1 + (siz/x * face/feel/resizer/1)

					if none? decis/2 [decis/2: face/offset/y]
					decis/2: decis/2 + (siz/y * face/feel/resizer/2)

					face/offset: as-pair decis/1 decis/2

					if none? decis/3 [decis/3: face/size/x]
					decis/3: decis/3 + (siz/x * face/feel/resizer/3)

					if none? decis/4 [decis/4: face/size/y]
					decis/4: decis/4 + (siz/y * face/feel/resizer/4)
					either in face 'resize [
						face/resize as-pair decis/3 decis/4
					][
						face/size: as-pair decis/3 decis/4
					]
				]
			]
		]
	]
	;
	insert-event-func func [face event /local siz][
		if event/type = 'resize [
			face: event/face
			if in face/feel 'old-size [
				siz: face/size - face/feel/old-size     ; compute size difference
				face/feel/old-size: face/size          ; store new size

				resize-faces face siz
				show face
			]
		]
		event
	]
	; VID new facets
	insert tail svv/facet-words reduce [
		'move-x 'move-y 'move-xy 'resize-x 'resize-y 'resize-xy func [new args][
			if none? new/feel [new/feel: make face/feel [decis: reduce [none none none none] resizer: copy [0 0 0 0]]]
			if not in new/feel 'resizer [new/feel: make new/feel [decis: reduce [none none none none] resizer: copy [0 0 0 0]]]
			switch/all first args [
				move-x [new/feel/resizer/1: 1]
				move-y [new/feel/resizer/2: 1]
				move-xy [new/feel/resizer/1: 1 new/feel/resizer/2: 1]
				resize-x [new/feel/resizer/3: 1]
				resize-y [new/feel/resizer/4: 1]
				resize-xy [new/feel/resizer/3: 1 new/feel/resizer/4: 1]
			]
			args
		]
		'resize func [new args][
			if none? new/feel [new/feel: make face/feel [decis: reduce [none none none none] resizer: none]]
			if not in new/feel 'resizer [new/feel: make new/feel [decis: reduce [none none none none] resizer: none]]
			new/feel/resizer: copy reduce second args
			next args
		]
	]
]

do ; just comment this line to avoid executing examples
[
	do [flush_events: func [{12-May-2007 Anton Rolls}] [
		; Remove the event-port
		remove find system/ports/wait-list system/view/event-port
		
		; Clear the event port of queued events
		while [pick system/view/event-port 1][]
		
		; Re-add the event-port to the wait-list
		insert system/ports/wait-list system/view/event-port
	]]
	
	;do head remove back back tail load %simple\simple-win-resizer-style.r


	req-win: layout [
		do [sp: 4x4] origin sp space sp 
		style text text black feel none
		style btn btn 24x24 
		Across 
			btn "<"
			btn ">"
			btn "^^"
			field 365 resize-x
			pad (sp * -1x0)
			arrow down white 24x24 move-x
			btn "+" 252.223.44 move-x
		return 
			text-list 500x200 resize-xy
		return
			field 336 resize [0 1 1 0]
			pad 0x2 
			text "Filter:" move-xy
			pad 0x-2 
			choice "All files (*.*)" "Rebol files (*.r)" 120 move-xy
		return 
			pad 0x10 
			check-line "Show hidden files" move-y
			pad 172x0 
			btn "Select" 150 resize [0 1 .75 0]
			btn "Cancel" 50 resize [.75 1 .25 0] #"^(esc)" [unview]
		return
			;sizer: win-resizer
	;]
			sizer: box 21x21 move-xy edge [size: 1x1 effect: 'ibevel color: 128.128.128.50]
				effect [
					draw [
						line-width 1
						pen 255.255.255.50 line 2x20 20x2 line 7x20 20x7 line 12x20 20x12
						pen 128.128.128.50 line 3x20 20x3 line 8x20 20x8 line 13x20 20x13
					]
				]
				feel [
					engage: func [face action event /local root-face] [
						if flag-face? face disabled [exit]
						if action = 'down [face/data: event/offset] 
						if action = 'up [face/data: none] 
						if all [face/data find [over away] action] [
							flush_events
							face/offset: max (face/user-data) face/offset + event/offset - face/data
							root-face: find-window face
							root-face/size: face/offset + face/size
							show root-face
						]
					]
				]
	]

	; put sizer on window's bottom-right corner and keep it there
	sizer/user-data: sizer/offset: req-win/size - sizer/size 

	view/options req-win 'resize
	
	; A final note: this patch gives the opportunity to think about an other kind of sizing behaviour for guis.
	; Normally in complex gui frameworks the widgets have: min-size, def-size, max-size and sometimes even
	; hard-min-size and hard-max-size. These covers almost 100% of situations.
	; But we could have a different situation (that I already use in many of my scripts)
	; You build the gui in its minimum size, then you open the window in some default size (there is not a max size).
	; This, with a resizing algorithm as the one presented here, covers 80% of situations.
]

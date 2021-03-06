Rebol []

; all scripts that had no code were deleted (e.g. stubs and "download here" ones)
; all scripts with Needs: [2.100.96] had that line commented out
; all scripts with Rebol 3 syntax had that code commented out (share-file.r is the only one)
; scripts must be saved as UTF-8 NO BOM if Jekyll complains about the byte sequence
; scripts that use liquid syntax (i.e. {% or {{) must have {% raw %} {% endraw %} tags added

scriptDir: %../_archived_pages/scripts/

foreach fileName read scriptDir [
    ext: back back tail to-string fileName
    
    if ext = ".r" [
        probe fileName
        
        path: to-file join scriptDir fileName
        script: load/header path
        
        jekyll: copy []

        append jekyll "---"
        append jekyll "section: ^"scripts^""
        
        if find script/1 'title [
            title: script/1/title
            replace/all title "^"" "&quot;"
            append jekyll join "title: ^"" [title "^""]
        ]
        
        if find script/1 'author [
            author: script/1/author
            append jekyll join "author: ^"" [author "^""]
        ]
        
        if find script/1 'date [
            uploaded: script/1/date
            append jekyll join "uploaded: ^"" [to-date uploaded "^""]
        ]
        
        if find script/1 'library [
            library: make object! script/1/library
            
            either find library 'license [
                append jekyll join "license: ^"" [library/license "^""]
            ][
                append jekyll "license: ^"none^""
            ]
        ]
        
        if find script/1 'purpose [
            purpose: to-string script/1/purpose
            replace/all purpose "^"" "&quot;"
            replace/all purpose "®" "&trade;"
            append jekyll join "excerpt: ^"" [purpose "^""]
        ]
        
        if find script/1 'library [
            library: make object! script/1/library
            
            either find library 'domain [
                domain: form library/domain
                
                replace/all domain " " ", "
                
                if domain/1 != "[" [ insert domain "[" insert tail domain "]" ]
                append jekyll join "categories: " [domain]
            ][
                append jekyll "categories: [none]"
            ]
        ]
        
        append jekyll "---"
        append jekyll join "{% include_relative " [fileName " %}"]
        
        pathForHTML: to-file join scriptDir [fileName ".html"]
        
        write pathForHTML ""
        write/lines pathForHTML jekyll
    ]
]
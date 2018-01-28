parse/case str rules: [
    collect into points [
        while [
            copy point [
                ["-" | number] to 
                [" " | "," | "-" | end]
            ]
            
            any [" " | ","]
            
            keep (load point)
        ]
    ]
]
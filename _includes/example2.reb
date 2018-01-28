makeUUID: function [
    "Generates a Version 4 UUID"
][
    data: collect [
        loop 16 [keep -1 + random/secure 256]
    ]
    
    data/7: data/7 and* 15 or* 64
    data/9: data/9 and* 63 or* 128
    
    data: enbase/base to binary! data 16
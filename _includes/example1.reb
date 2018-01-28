records: copy [
    1 ["name" "John Smith" "age" 35]
]

insert tail records [
    2 ["name" "Mary Smith" "age" 25]
]

; display all the user records
for-each [id user] records [
    print [id "-" user/2 "is" user/4]
]
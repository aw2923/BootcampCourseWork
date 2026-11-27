# next: skip to the next iteration of a loop 

for (i in 1:10) {
    if ((i %% 2) == 0)
        next
    print(i)
}
import random

sum = 0

for x in range(500000):
    roll = random.randint(1,10)
    if roll == 1 or roll== 2:
        roll = random.randint(1, 10)
        sum += roll
    else:
        sum += roll

    
print (sum/ 500000)
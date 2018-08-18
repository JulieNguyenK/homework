import csv, os

votes_total = 0
candidates = dict()
proportion = dict()

file = open("election_data.csv", 'r')
poll_reader = csv.reader(file)
next(poll_reader) #skip header row
file.close

#fills candidates dictionary with names as keys, votes counted as values
for row in poll_reader:
    votes_total += 1    #counts total cotes
    if row[2] in candidates:    #checks for candidate name in candidate dictionary, adds vote to name
        candidates[row[2]] += 1
    else:
        candidates[row[2]] = 1

#output_path = os.path.join("election winner.csv")
with open("election winner.csv", 'w') as csvfile:
    csvwriter = csv.writer(csvfile, delimiter = ',')
    print('Election Results')
    csvwriter.writerow(['Election Results'])
    print(f'Total votes {votes_total}')
    csvwriter.writerow([f'Total votes {votes_total}'])

    for name in candidates:
        proportion[name] = candidates[name]/votes_total * 100
        print(f'{name}: {round(proportion[name], 2)}% ({candidates[name]})')
        csvwriter.writerow([f'{name}: {round(proportion[name], 2)}% ({candidates[name]})'])

    winner_name =max(candidates, key=candidates.get)
    print(f'Winner: {winner_name}')
    csvwriter.writerow([f'Winner: {winner_name}'])

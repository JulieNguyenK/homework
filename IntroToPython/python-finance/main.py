import csv
import os

budget_file = open('budget_data.csv')
budget_reader = csv.reader(budget_file)

next(budget_reader)
total_months = 0
monthly_profit = []
monthly_difference = []
sum_difference = 0 
total = 0
max_profit = float("-inf")
min_profit = float("inf")
max_month = ""
min_month = ""

for row in budget_reader:
    total_months += 1
    profit = int(row[1])
    monthly_profit.append(profit)
    total = total + profit

    if profit > max_profit:
        max_profit = profit
        max_month = row[0]

    if profit < min_profit:
        min_profit = profit
        min_month = row[0]

budget_file.close()

for i in range(len(monthly_profit)-1):
    monthly_difference.append(monthly_profit[i+1]-monthly_profit[i])

sum_difference = sum(monthly_difference)
ave_difference = round(sum_difference / len(monthly_difference), 2)

print ("Financial Analysis")
print ("----------------------------")
print(f'Total months: {total_months}')  
print(f'Total profit: $ {total}')
print(f'Average change: {ave_difference}')
print(f'Greatest Increase in Profits: {max_month} (${max(monthly_difference)})')
print(f'Greatest Decrease in Profits: {min_month} (${min(monthly_difference)})')

#output_path = os.path.join("..", "bankAnalysis.csv")
with open('bankAnalysis.csv', 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile, delimiter = ',')
    csvwriter.writerow (["Financial Analysis"])
    csvwriter.writerow(["----------------------------"])
    csvwriter.writerow([f'Total months: {total_months}'])  
    csvwriter.writerow([f'Total profit: $ {total}'])
    csvwriter.writerow([f'Average change: {ave_difference}'])
    csvwriter.writerow([f'Greatest Increase in Profits: {max_month} (${max(monthly_difference)})'])
    csvwriter.writerow([f'Greatest Decrease in Profits: {min_month} (${min(monthly_difference)})'])
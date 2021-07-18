import json
import csv


f = open('transcript.json')

input_data = json.load(f)

# print(len(data['data']))
dictionary = {}
dict_list =[]
for i in range(len(input_data['data'])):
    data = input_data['data'][i]
    data['studentID'] = i+500
    data['middleName'] = "kumar"+str(i+500)
    dict_list.append(data)
    # print(type(data))
dictionary['data'] = dict_list

print(dictionary)
with open("sample.json","w+") as file:
    json.dump(dictionary,file)

# print(dictionary)

# f = open("sample.csv","w")
# csv_file = csv.writer(f)
# data = dictionary['data']
# keys = data[0].keys()
# with open("sample.csv","w",newline='') as output_file:
#     dict_writer = csv.DictWriter(output_file,keys)
#     dict_writer.writeheader()
#     dict_writer.writerows(data)

    

        
    
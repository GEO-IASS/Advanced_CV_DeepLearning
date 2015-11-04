import argparse
import random as ra


def vic_train_test(input_file):
    file_tables=dict()
    patient_tables=dict()
    failed_strings=list()
    with open(input_file) as f:
        for line in f:
            try:
                filename,grade=line.split(" ")
                key=filename[0:16]
                grade=int(grade)
                if key not in file_tables:
                    file_tables[key]=list()
                else:
                    file_tables[key].append("/data/lehhou/data/patches_5X/"+line)
                if grade not in patient_tables:
                    patient_tables[grade]=set()
                else:
                    patient_tables[grade].add(key)
            except:
                failed_strings.append(line)

    #create the train set
#    with open("vic_train.txt","w") as f2:
#        train_num=0
#        expect_train_num=70000
#        while train_num<expect_train_num:
#            while train_num<40000:
#                key=patient_tables[0].pop()
#                candidates=file_tables[key]
#                for i in xrange(len(candidates)):
#                    f2.write(candidates[i])
#                train_num+=len(candidates)
#            key=patient_tables[1].pop()
#            candidates=file_tables[key]
#            for i in xrange(len(candidates)):
#                f2.write(candidates[i])
#            train_num+=len(candidates)
#
#    #create the test set
#    with open("vic_test.txt","w") as f3:
#        test_num=0
#        expect_test_num=10000
#        while test_num<expect_test_num:
#            while test_num<5000:
#                key=patient_tables[0].pop()
#                candidates=file_tables[key]
#                for i in xrange(len(candidates)):
#                    f3.write(candidates[i])
#                test_num+=len(candidates)
#            key=patient_tables[1].pop()
#            candidates=file_tables[key]
#            for i in xrange(len(candidates)):
#                f3.write(candidates[i])
#            test_num+=len(candidates)

        patients=file_tables.keys()
        ra.shuffle(patients)
        train_list=patients[0:len(patients)/2]
        test_list=patients[len(patients)/2:]
    with open("vic_train1.txt","w") as f2:
        for key in train_list:
            candidates=file_tables[key]
            ra.shuffle(candidates)
            candidates=candidates[0:len(candidates)/10]
            for item in candidates:
                f2.write(item)

    with open("vic_test1.txt","w") as f3:
        for key in test_list:
            candidates=file_tables[key]
            ra.shuffle(candidates)
            candidates=candidates[0:len(candidates)/10]
            for item in candidates:
                f3.write(item)


if __name__=="__main__":
    argparser=argparse.ArgumentParser()
    argparser.add_argument("input_file",type=str,help="Input File")
    args=argparser.parse_args()
    input_file=args.input_file
    vic_train_test(input_file)


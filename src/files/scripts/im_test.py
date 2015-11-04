#/usr/bin/python
import argparse
import random as ra


def im_test(input_file):
    failed_string=list()
    im_table=dict()
    with open(input_file) as f:
        for line in f:
            try:
                filename,grade=line.split(" ")
                im_id=filename[30:53]
                if im_id not in im_table:
                    im_table[im_id]=list()
                else:
                    im_table[im_id].append(line)
            except:
                failed_string.append(line)

    ids=im_table.keys()
    ra.shuffle(ids)
    test_list=ids[0:5]

    with open("im_test_7.txt","w") as f1:
        for item in test_list:
            patches=im_table[item]
            for patch in patches:
                f1.write(patch)


if __name__=="__main__":
    argparser=argparse.ArgumentParser()
    argparser.add_argument("input_file",type=str,help="Input File")
    args=argparser.parse_args()
    input_file=args.input_file
    im_test(input_file)


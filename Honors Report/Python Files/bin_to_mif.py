import sys
from numpy import binary_repr


lines = []
radix = ("BIN", "HEX", "OCT", "DEC", "UNS")


def main():

    if len(sys.argv) != 2:
        print('open binary file'); sys.exit(1)
    f = open(sys.argv[1], 'r')
    file_name = sys.argv[1]

    while True:
        line = f.readline()
        if not line: 
            break
        lines.append(line.strip().replace('\t',''))
    f.close()
    
    #remove whitespace
    for i in lines:
        if i == '':
            lines.remove(i)

    #get memory info 
    width = int(input("Enter memory word width: "))
    depth = input("Enter memory depth: ")

    memory_list = []
    #add file contents to a new list
    for i in range(len(lines)):
        memory_list.insert(i, lines[i])
    print(memory_list)

    #loop through list to add zeros in any register not written to by input file
    for i in range(int(depth)-len(memory_list)):
        memory_list.append(binary_repr(0, width=width))
    print(memory_list)

    #convert list into an indexed dictionary
    indexed_list = {index: value for index, value in enumerate(memory_list)}
    print(indexed_list)


    output_file = open(file_name.replace('.hack', '.mif'), 'w')

    output_file.write('\n' + 'WIDTH=' + str(width) + ';\n' + 'DEPTH=' + str(depth) + ';\n')
    output_file.write('\n' + 'ADDRESS_RADIX=UNS;' + '\n' + 'DATA_RADIX=BIN;' + '\n')
    output_file.write('\n' + 'CONTENT BEGIN' + '\n')
    for i in range(len(indexed_list)):
        output_file.write('\t' + str(i) + '   :   ' +  indexed_list.get(i) + ';\n')
    output_file.write('END;')

main()
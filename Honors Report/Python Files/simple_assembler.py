import sys
import re
from numpy import binary_repr

#lists to store symbol_extracted_asmd corresponding addresses
lines, line_addr = [], [] 

#built in symbols
symbolTable =  { "R0"   : 0,    "R1"     : 1,       "R2"  : 2,    "R3"   : 3,
            "R4"   : 4,    "R5"     : 5,       "R6"  : 6,    "R7"   : 7,
            "R8"   : 8,    "R9"     : 9,       "R10" : 10,   "R11"  : 11,
            "R12"  : 12,   "R13"    : 13,      "R14" : 14,   "R15"  : 15,
            "SP"   : 0,    "LCL"    : 1,       "ARG" : 2,    "THIS" : 3,
            "THAT" : 4,    "SCREEN" : 16384,   "KBD" : 24576}

class code:
    _destc = ['', 'M', 'D', 'DM', 'A', 'AM', 'AD', 'ADM']
    _compc = {'0' : 42, '1' : 63, '-1' : 58, 'D' : 12, 'A' : 48, '!D' : 13, '!A' : 49, '-D' : 15, '-A' :51,
              'D+1' : 31, 'A+1' : 55, 'D-1' : 14, 'A-1' : 50, 'D+A' : 2, 'D-A' : 19, 'A-D' : 7, 
              'D&A' : 0, 'D|A' : 21, 'M' : 112, '!M' : 113, '-M' : 115, 'M+1' : 119, 'M-1' : 114, 'D+M' : 66, 
              'D-M' : 83, 'M-D' : 71, 'D&M' : 64, 'D|M' : 85}
    _jumpc = ['', 'JGT', 'JEQ', 'JGE', 'JLT', 'JNE', 'JLE', 'JMP']

    def get_binaryC(self, dest, comp, jump):

        destc = str(binary_repr(self._destc.index(dest), width=3))
        compc = str(binary_repr(self._compc.get(comp), width=7))
        jumpc = str(binary_repr(self._jumpc.index(jump), width=3))
        return '111' + compc + destc + jumpc
    
class C_INSTRUCTION():
    dest = r'(?:(M|D|DM|A|AM|AD|ADM)=)?'
    comp = r'(=0|=1|=-1|D|A|!D|!A|-D|-A|D+1|A+1|D-1|A-1|D+A|D-A|A-D|D&A|D\|A|M|!M|-M|M+1|M-1|D+M|D-M|M-D|D&M|D\|M)'
    jump = r'(?:;(JGT|JEQ|JGE|JLT|JNE|JLE|JMP)?)'

    c_instr = re.compile(r"(?<!@)%s%s%s?" % (dest, comp, jump))

    def getDest(instruction):
        if '=' in instruction:
            return re.split("=", instruction)[0]
        else:
            return ""
    def getComp(instruction):
        list = re.split("=|;", instruction)
        if '=' in instruction:
            return list[1]
        else:
            return list[0]
        
    def getJump(instruction):
        if ';' in instruction:
            return re.split(";", instruction)[1]
        else:
            return ""
   
    def isCInstruction(instruction):
        if C_INSTRUCTION.c_instr.search(instruction):
            return True
        else:
            return False     
    


#opens file and reads lines into "lines" list

def main():
    if len(sys.argv) != 2:
        print('open .asm file'); sys.exit(1)
    f = open(sys.argv[1], 'r')
    file_name = sys.argv[1]

    while True:
        line = f.readline()
        if not line: 
            break
        lines.append(line.strip())
    f.close()


    #first pass strips symbol formatting and saves string and corresponding line in symbol table
    
    #initialize starting register for user-declared variables
    variable_starting_reg = 16
    
    #remove whitespace
    for i in lines:
        if i == '':
            lines.remove(i)
    
    #remove comments
    asm_whitespace_removed = list(filter(lambda x: x.find("//") == -1, lines))
    #symbol_extracted_asm = list(filter(lambda x: x.find("") == -1, symbol_extracted_asm))

    #parse each line looking for (labels) to add to symbol table
    #   label_index accounts for line deletion each time a label is found
    #       ensures label is associated with correct memory address
    label_index = 0
    for i in range(len(asm_whitespace_removed)):
        #if symbol_extracted_asm[i].find("//") != -1:
            #symbol_extracted_asm[i] = symbol_extracted_asm[i][0:symbol_extracted_asm[i].find("//")]
       
        if asm_whitespace_removed[i].find('(') != -1:
            symbolTable[asm_whitespace_removed[i].replace('(','').replace(')', '')] = i - label_index
            label_index += 1
   
    #checks @xxx instructions for type
    #   if a instruction - does nothing
    #   if reference to a label - (matches label in symbol table) changes line to address value associated
    #       with label in symbol table
    #   if variable declaration - adds to symbol table with address value starting at 16 and incrementing 
    #       for each subsequent variable declaration
    for i in range(len(asm_whitespace_removed.copy())):
        if asm_whitespace_removed[i].startswith('@'):
            if asm_whitespace_removed[i].replace('@', '').isdigit():
                continue
            elif asm_whitespace_removed[i].replace('@', '') in symbolTable:
                asm_whitespace_removed[i] = str(symbolTable[asm_whitespace_removed[i].replace('@', '')])
            else:
                symbolTable[asm_whitespace_removed[i].replace('@', '')] = variable_starting_reg
                asm_whitespace_removed[i] = str(variable_starting_reg)
                variable_starting_reg += 1
        
    #create updated instruction list with labels removed now that they are saved in symbol table
    symbol_extracted_asm = list(filter(lambda x: x.find("(") == -1, asm_whitespace_removed))

    #for some reason, empty string at end of list so remove whitespace again
    for i in symbol_extracted_asm:
        if i == '':
            symbol_extracted_asm.remove(i)
    
    for i in range(len(symbol_extracted_asm)):

        #if L instruction, get address from symbol table- else A instruction:
        if symbol_extracted_asm[i].startswith('@'):
            symbol_extracted_asm[i] = binary_repr(int(symbol_extracted_asm[i].replace('@', '')), width=16)
    
        #if C instruction, gets each field- converts into binary and saves to list
        #elif C_INSTRUCTION.isCInstruction(symbol_extracted_asm[i]):
        elif symbol_extracted_asm[i].isdigit():
            symbol_extracted_asm[i] = binary_repr(int(symbol_extracted_asm[i]), width=16)

        elif C_INSTRUCTION.isCInstruction(symbol_extracted_asm[i]):
            dest = str(C_INSTRUCTION.getDest(symbol_extracted_asm[i]))
            comp = str(C_INSTRUCTION.getComp(symbol_extracted_asm[i]))
            jump = str(C_INSTRUCTION.getJump(symbol_extracted_asm[i]))
            current_instruction = code()

            try: 
                symbol_extracted_asm[i] = current_instruction.get_binaryC(dest, comp, jump)
            except(ValueError):
                print(f"c instruction wrong syntax line {i}")
        else:
            continue
        
    
    try:
        output_file = open(file_name.replace('.asm', '.hack'), 'x')
        print(file_name.replace('.asm', '.hack') + " was sucessfully created in current directory")
    except:
        menu_options = ("a", "b")

        while True:
            print()
            print(f"File {file_name.replace('.asm', '.hack')} already exists.")
            print('would you like to: (a) overwrite file (b) create new file')
            print()
            user_selection = input()
       
            if user_selection in menu_options:
                break
            else:
                print('would you like to: (1) overwrite file\n (2) create new file')
        
        if user_selection == 'a':
            output_file = open(file_name.replace('.asm', '.hack'), 'w')
            print(file_name.replace('.asm', '.hack') + " was sucessfully overwritten")
        else:
            
            print("specify a new name: ")
            new_name = input()
            output_file = open(new_name + ('.hack'), 'w')
            print(new_name + ('.hack') + " was sucessfully created in current directory")
                
    finally:
    
        for i in range(len(symbol_extracted_asm)):
                output_file.write(symbol_extracted_asm[i] + '\n')

if __name__ == "__main__":
    main()
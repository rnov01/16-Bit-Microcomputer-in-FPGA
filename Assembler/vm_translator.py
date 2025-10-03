import sys
import re


#class VM_stack: 
    #def push(line, stack_pointer):
        #pass
    #def pop():
        #pass


vm_segment = {'SP' : 'SP', 'local' : 'LCL', 'argument' : 'ARG', 'this' : 'THIS', 'that' : 'THAT',
              'pointer' : 4, 'temp' : 'TEMP', 'static' : 16}

def push(line, stack_pointer):
    pass
def isPush(instruction):
    if re.search("^push", instruction):
        return True
    else:
        return False
    
def isPop(instruction):
    if re.search(r"^pop", instruction):
        return True
    else:
        return False
    
def isPushConstant(instruction):
    if re.search(r"^push constant", instruction):
        return True
    else:
        return False
    
def getSegment(instruction):
    segment = r'(local|argument|static|constant|this|that|pointer|temp)' 
    return re.findall(segment, instruction)[0]
def getI(instruction):
    return re.findall('\d$', instruction)[0]

#writes asm code for push instructions (with local, argument, this or that)
def setPush(segment, i):
    assembly.append(f"@{vm_segment.get(segment)}")
    assembly.append("D=M")
    assembly.append(f"@{i}")
    assembly.append("A=D+A")
    assembly.append("D=M")
    assembly.append("@SP")
    assembly.append("A=M")
    assembly.append("M=D")
    incrementSP()

#writes asm code for push instructions (constant)
def setPushConstant(i):
    assembly.append(f"@{i}")
    assembly.append("D=A")
    assembly.append("@SP")
    assembly.append("A=M")
    assembly.append("M=D")
    incrementSP()

def setPop(segment, i):
    decrementSP()
    assembly.append("@SP")
    assembly.append("A=M")
    assembly.append("D=M")
    assembly.append(f"@{vm_segment.get(segment)}")
    assembly.append("D=D+M") #d reg holds popped value + base segment address
    assembly.append(f"@{i}")
    assembly.append("D=D+A") #d reg holds popped value + segment[i]
    assembly.append("@SP")
    assembly.append("A=M") #set a reg to popped value
    assembly.append("AM=D-A")  #set segment[i] to popped value  





def incrementSP():
    assembly.append("@SP")
    assembly.append("M=M+1")
def decrementSP():
    assembly.append("@SP")
    assembly.append("M=M-1")
    

lines=[]
assembly=[]
#opens vm file
def openFile():
    if len(sys.argv) != 2:
        print('open .vm file'); sys.exit(1)

    f = open(sys.argv[1], 'r')
    file_name = sys.argv[1]

    while True:
        line = f.readline()
        if not line: 
            break
        lines.append(line.strip())
    f.close()
    return lines

#strips whitespace and deletes comments
def stripFile(file):
    for i in lines:
        if i == '':
            lines.remove(i)

    vm_whitespace_removed = list(filter(lambda x: x.find("//") == -1, lines))
    return vm_whitespace_removed

def getInstr(line):
    if isPush(line):
        #get segment, get i, translate, write to assembly list
        print(str(getSegment(line)))
        print(str(getI(line)))
        print(assembly)
        print(str(getSegment(line)) in list(vm_segment))
        #for i in vm_segment:
            #print(i)
            #print(vm_segment[i])
        if isPushConstant(getSegment(line)):
            setPushConstant(getI(line))
        else:
            setPush(getSegment(line), getI(line))
            #if str(getSegment(line)) == i:

                #assembly.append(f"@{vm_segment.get(getSegment(line))}")
                #setPush()
                #print(assembly)
        print(assembly)

    if isPop(line):
        pass

def main():
    vm = openFile()
    vm = stripFile(vm)
    print(vm)
    for i in vm:
        getInstr(i)
        
main()

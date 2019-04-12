
def findReg(reg):
  # regNum=reg[2:]
  # return '{0:016b}'.format(int(regNum))
  if (reg == "$r0"):
    reg1 = "0000"
  elif (reg == "$r1"):
    reg1 = "0001"
  elif (reg == "$r2"):
    reg1 = "0010"
  elif (reg == "$r3"):
    reg1 = "0011"
  elif (reg == "$r4"):
    reg1 = "0100"
  elif (reg == "$r5"):
    reg1 = "0101"      
  elif (reg == "$r6"):
    reg1 = "0110"
  elif (reg == "$r7"):
    reg1 = "0111"
  elif (reg == "$r8"):
    reg1 = "1000"
  elif (reg == "$r9"):
    reg1 = "1001"
  elif (reg == "$r10"):
    reg1 = "1010"  
  elif (reg == "$r11"):
    reg1 = "1011"      
  elif (reg == "$r12"):
    reg1 = "1100"
  elif (reg == "$r13"):
    reg1 = "1101"
  elif (reg == "$r15"):
    reg1 = "1111"
  else: 
    print("register not found: ", reg)
  return reg1

def toBinary(n, z):
    return ''.join(str(1 & int(n) >> i) for i in range(z)[::-1])

def findOp(reg):
  # regNum=reg[2:]
  # return '{0:016b}'.format(int(regNum))
  if (reg == "add"):
    reg1 = "00000"
  elif (reg == "addc"):
    reg1 = "00000"
  elif (reg == "lshc"):
    reg1 = "00001"
  elif (reg == "lsh"):
    reg1 = "00010"
  elif (reg == "sub"):
    reg1 = "00011"   
  elif (reg == "subc"):
    reg1 = "00011"	
  elif (reg == "addi"):
    reg1 = "00100"
  elif (reg == "ld"):
    reg1 = "00101"  
  elif (reg == "st"):
    reg1 = "00110"      
  elif (reg == "jmp"):
    reg1 = "00111"
  elif (reg == "cmp"):
    reg1 = "01000"
  elif (reg == "beq"):
    reg1 = "01001"
  elif (reg == "bne"):
    reg1 = "01010"
  elif (reg == "blt"):
    reg1 = "01011"
  elif (reg == "ble"):
    reg1 = "01100"
  elif (reg == "bgt"):
    reg1 = "01101"
  elif (reg == "bge"):
    reg1 = "01110"
  elif (reg == "LABL"):
    reg1 = "01111"
  else: 
    print("opcode not found")

  return reg1

print('Running Lab3:'+'\n\n\n\n')



#fileObj = open("filename", "mode") 
filename = "Assembly.txt"

read_file = open(filename, "r") 

#Print read_file

#w_file is the file we are writing to

w_file = open("Machine3.txt", "w")
#w_file.write("000000000" + '\n')
#w_file.write("000000000" + '\n')

#Open a file name and read each line
#to strip \n newline chars
#lines = [line.rstrip('\n') for line in open('filename')]  

#1. open the file
#2. for each line in the file,
#3.     split the string by white spaces
#4.      if the first string == SET then op3 = 0, else op3 = 1
#5.   
newList = []

with open(filename, 'r') as f:
  for line in f:
    print (line)
    str_array = line.split()
    # process out comments
    commInd=0
    for i in range(len(str_array)):
      print(str_array[i])
      if '/' in str_array[i]:
        commInd=i
        break
      commInd+=1


    newList.append(str_array[0:commInd]) #add to our 2d List


    print (str_array)
    print (str_array[0:commInd])

  for instr in range(len(newList)):
    x=""
    instruction = newList[instr][0]
    if instruction == "add" or instruction=="addc" or instruction=="sub" or instruction=="subc":
      opcode = findOp(instruction)
      writeReg = findReg(newList[instr][1])
      readReg1 = findReg(newList[instr][2])
      readReg2 = findReg(newList[instr][3])
    
      if instruction == "add" or instruction=="sub":
        x = opcode + writeReg + "\n" + readReg1 + readReg2 + '0'
      else:
	      x = opcode + writeReg + "\n" + readReg1 + readReg2 + '1'
      print (x)



    elif instruction=='lsh' or instruction=='lshc' or instruction=='ld':
      opcode = findOp(instruction)
      writeReg = findReg(newList[instr][1])
      readReg1 = findReg(newList[instr][2])

      x = opcode + writeReg + "\n" + readReg1 + '0000'+ '0'
      print (x)

    elif instruction=='addi':
      opcode = findOp(instruction)
      writeReg = findReg(newList[instr][1])
      readReg1 = findReg(newList[instr][2])
      imm = toBinary(newList[instr][3], 5)

      x = opcode + writeReg + "\n" + readReg1 + imm
      print (x)

    elif instruction=='st' or instruction=='cmp':
      opcode = findOp(instruction)
      readReg1 = findReg(newList[instr][1])
      readReg2 = findReg(newList[instr][2])

      x = opcode + '0000' + "\n" + readReg1 + readReg2 +'0'
      print (x)

    elif instruction=="LABL":
      opcode = findOp(instruction)
      x=opcode+'0000'+'\n'+'000000000'

    elif instruction=='jmp' or instruction=="bne" or instruction=="beq" or instruction=="blt" or instruction=="ble" or instruction=="bgt" or instruction=="bge":
      opcode = findOp(instruction)
      name= newList[instr][1]
      saveLbl =0
      for lblInd in range(len(newList)):
        if newList[lblInd][0]=="LABL":
          if newList[lblInd][1]==name:
            saveLbl=lblInd*2
            break
      if(saveLbl==0):
	      print("label not found for line ",instr)
      stringValue = toBinary(saveLbl, 13)
      
      x = opcode + stringValue[0:4] + "\n" + stringValue[4:]
      print (x)
    
    else:
      print("instruction not found on line ",instr)
      # convert saveLbl to binary
          
      # x = opcode + '0000' + "\n" + readReg1 + readReg2 +'0'
      #print (x)
    
    w_file.write(x + '\n')

w_file.close()
   
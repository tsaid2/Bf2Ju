@warn "There are more '<' than '>'. There is a risk of negative pointer "
@warn "Something went wrong: Main.main.BfInterpreter.MermoryBfVM(\"Memory: 1 => 1 (0) , 2000 => 1 (0)\") " 
global p=1 # pointer 
cells = fill(UInt8(0),(0+50),1)
while (cells[p] != 0)
   global p
   p -= 2
end
p += 1
cells[p] =  cells[p]== 0 ? UInt8(255) : (cells[p] - 3) 
cells[p] = (cells[p] + 1) % 256 
cells[p] =  cells[p]== 0 ? UInt8(255) : (cells[p] - 1) 
cells[p] = (cells[p] + 3) % 256 
while (cells[p] != 0)
   global p
   p += 1
   try
      print("insert a byte :"); cells[p] = UInt8(readline()[1])
   catch
      print("insert a byte :"); cells[p] = UInt8(0)
   end
end
p -= 1
while (cells[p] != 0)
   global p
   print(Char(cells[p]))
   p -= 1
end

global p=1 # pointer 
cells = fill(UInt8(0),(3+50),1)
p += 1
cells[p] = (cells[p] + 4) % 256 
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

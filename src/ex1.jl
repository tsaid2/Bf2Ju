global p=1 # pointer 
cells = fill(UInt8(0),(1+50),1)
cells[p] = (cells[p] + 1) % 256 
while (cells[p] != 0)
   global p
   try
      print("insert a byte :"); cells[p] = UInt8(readline()[1])
   catch
      print("insert a byte :"); cells[p] = UInt8(0)
   end
   print(Char(cells[p]))
end

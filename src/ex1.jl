@warn "Something went wrong: Main.main.BfInterpreter.MermoryBfVM("Memory: 1 => 1 (0) , 2000 => 1 (0)") "
global p=1 # pointer
cells = fill(UInt8(0),(0+50),1)
cells[p] =  cells[p]== 0 ? UInt8(255) : (cells[p] - 1)
try
   print("insert a byte :"); cells[p] = UInt8(readline()[1])
catch
   print("insert a byte :"); cells[p] = UInt8(0)
end
while (cells[p] != 0)
   global p
   p += 1
end
cells[p] =  cells[p]== 0 ? UInt8(255) : (cells[p] - 1)
cells[p] = (cells[p] + 1) % 256
try
   print("insert a byte :"); cells[p] = UInt8(readline()[1])
catch
   print("insert a byte :"); cells[p] = UInt8(0)
end
p += 1
p -= 1
while (cells[p] != 0)
   global p
   cells[p] = (cells[p] + 1) % 256
   p -= 1
   cells[p] =  cells[p]== 0 ? UInt8(255) : (cells[p] - 1)
   p += 1
end
try
   print("insert a byte :"); cells[p] = UInt8(readline()[1])
catch
   print("insert a byte :"); cells[p] = UInt8(0)
end
cells[p] = (cells[p] + 1) % 256
p -= 1
print(Char(cells[p]))
cells[p] = (cells[p] + 2) % 256
try
   print("insert a byte :"); cells[p] = UInt8(readline()[1])
catch
   print("insert a byte :"); cells[p] = UInt8(0)
end
p += 1
cells[p] = (cells[p] + 1) % 256
try
   print("insert a byte :"); cells[p] = UInt8(readline()[1])
catch
   print("insert a byte :"); cells[p] = UInt8(0)
end
while (cells[p] != 0)
   global p
   p += 1
end
cells[p] = (cells[p] + 2) % 256
print(Char(cells[p]))
cells[p] = (cells[p] + 1) % 256
cells[p] =  cells[p]== 0 ? UInt8(255) : (cells[p] - 1)
while (cells[p] != 0)
   global p
   print(Char(cells[p]))
   cells[p] =  cells[p]== 0 ? UInt8(255) : (cells[p] - 1)
end
p -= 1
p += 1

p=1 # pointer 
cells = fill(UInt8(0),0,1)
cells[p] = (cells[p] + 1) % 256 
cells[p] = (cells[p] + 1) % 256 
while (cells[p] != 0)
   cells[p] = (cells[p] - 1) % 256 
   cells[p] = (cells[p] - 1) % 256 

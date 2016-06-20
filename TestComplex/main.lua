require("ZeroBraineProjects/dvdlualib/complex")

local function LogLine(sStr)
  io.write(tostring(sStr).."\n")
end

io.stdout:setvbuf("no")

LogLine("Default to zero and string to number")
A = Complex()
B = Complex("asd","asd")
C = Complex(1,"1")
D = Complex("1","1")
E = Complex("1",1)
F = ToComplex({1,1})
G = ToComplex("{1,1}")
H = ToComplex("1+i1")
I = ToComplex("1+1i")
J = A + B + C + D + E + F + G + H + I

LogLine(tostring(J).." = {7,7}")

--
A = Complex(5,5)
B = A ^ A
C = Complex(2,2)
C:Pow(2)
LogLine(tostring(C).." = {0,8}")
C:Pow("2")
LogLine(tostring(C).." = {-64,0}")
LogLine(tostring(B).." = {145.2340,316.5763}")

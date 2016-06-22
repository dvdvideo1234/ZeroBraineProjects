require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/complex")


local function LogLine(sStr)
  io.write(tostring(sStr).."\n")
end

io.stdout:setvbuf("no")
--[[
LogLine("Default to zero and string to number")
A = Complex()           ;  LogLine(A and tostring(A) or "A missing")
B = Complex("asd","asd");  LogLine(B and tostring(B) or "B missing")
C = Complex(1,"1")      ;  LogLine(C and tostring(C) or "C missing")
D = Complex("1","1")    ;  LogLine(D and tostring(D) or "D missing")
E = Complex("1",1)      ;  LogLine(E and tostring(E) or "E missing")
F = ToComplex({1,1})    ;  LogLine(F and tostring(F) or "F missing")
G = ToComplex("{1,1}")  ;  LogLine(G and tostring(G) or "G missing")
H = ToComplex("1+i1")   ;  LogLine(H and tostring(H) or "H missing")
I = ToComplex("2,2")    ;  LogLine(I and tostring(I) or "I missing")
LogLine("-------------------TESTS----------------")
J = ToComplex("{[3,3]")   ;  LogLine(J and tostring(J) or "1 missing")
J = ToComplex("|{[3,3]}|")   ;  LogLine(J and tostring(J) or "2 missing")
J = ToComplex("/[3,3]")   ;  LogLine(J and tostring(J) or "3 missing")
J = ToComplex("[3,]")   ;  LogLine(J and tostring(J) or "4 missing")
J = ToComplex("[3]")   ;  LogLine(J and tostring(J) or "5 missing")

]]
J = ToComplex("[4+j5")   ;  LogLine(J and tostring(J) or "6 missing")
















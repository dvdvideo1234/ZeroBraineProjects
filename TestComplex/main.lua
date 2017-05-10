require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/complex")

io.stdout:setvbuf("no")

logStatus(nil,"---------------Basic: Complex---------------")
A = Complex()           ;  logStatus(nil,A and tostring(A) or "A missing")
B = Complex("asd","asd");  logStatus(nil,B and tostring(B) or "B missing")
C = Complex(1,"1")      ;  logStatus(nil,C and tostring(C) or "C missing")
D = Complex("1","1")    ;  logStatus(nil,D and tostring(D) or "D missing")
E = Complex("1",1)      ;  logStatus(nil,E and tostring(E) or "E missing")
logStatus(nil,"---------------Advanced: Tab-2Complex---------------")
F = ToComplex({1,-3})    ;  logStatus(nil,F and tostring(F) or "F missing")
F = ToComplex({Real=1,Imag=-3})    ;  logStatus(nil,F and tostring(F) or "F missing")
F = ToComplex({real=1,imag=-3})    ;  logStatus(nil,F and tostring(F) or "F missing")
F = ToComplex({Re=1,Im=-3})    ;  logStatus(nil,F and tostring(F) or "F missing")
F = ToComplex({re=1,im=-3})    ;  logStatus(nil,F and tostring(F) or "F missing")
F = ToComplex({R=1,I=-3})    ;  logStatus(nil,F and tostring(F) or "F missing")
F = ToComplex({r=1,i=-3})    ;  logStatus(nil,F and tostring(F) or "F missing")
F = ToComplex({x=1,y=-3})    ;  logStatus(nil,F and tostring(F) or "F missing")
logStatus(nil,"---------------Advanced: Str-2Complex---------------")
G = ToComplex("{-1,1}")  ;  logStatus(nil,G and tostring(G) or "G missing")
I = ToComplex("2,-2")    ;  logStatus(nil,I and tostring(I) or "I missing")
J = ToComplex("{[+3,-3]}")   ;  logStatus(nil,J and tostring(J) or "1 missing")
J = ToComplex("{[-3,-3]")   ;  logStatus(nil,J and tostring(J) or "2 missing")
J = ToComplex("/[3,3]/")   ;  logStatus(nil,J and tostring(J) or "3 missing")
J = ToComplex("[3,]")   ;  logStatus(nil,J and tostring(J) or "4 missing")
J = ToComplex("[3]")   ;  logStatus(nil,J and tostring(J) or "5 missing")
logStatus(nil,"---------------Advanced: Str-I-2Complex---------------")
H = ToComplex("3 - 6i")   ;  logStatus(nil,H and tostring(H) or "H2 missing")
H = ToComplex("3 - i6")   ;  logStatus(nil,H and tostring(H) or "H1 missing")
J = ToComplex("-0.8+0.156i")   ;  logStatus(nil,J and tostring(J) or "6 missing")
J = ToComplex("-0.8+ i 0.156")   ;  logStatus(nil,J and tostring(J) or "6 missing")
logStatus(nil,"---------------Advanced: Str-I-2Complex with brackets---------------")
J = ToComplex("[4+j5]")   ;  logStatus(nil,J and tostring(J) or "6 missing")


logStatus(nil,"---------------Advanced: Operations---------------")
logStatus(nil,"Add{0, 6}"..tostring(ToComplex("3 + 3i") + ToComplex("3 - 3i")))
logStatus(nil,"Sub{6, 0}"..tostring(ToComplex("3 + 3i") - ToComplex("3 - 3i")))
logStatus(nil,"Mul{4,-3}"..tostring(ToComplex("2 + i*1") * ToComplex("1 - 2i")))
logStatus(nil,"Mul{0.8,-0.6}"..tostring(ToComplex("2 + 1*i") / ToComplex("1 + 2i")))

logStatus(nil,"---------------Advanced: Roots---------------")
local CT = ToComplex("-.5+1*i")

local tAns = {"{0.898127,0.500739}",
              "{-0.500739,0.898127}",
              "{-0.898127,-0.500739}",
              "{0.500739,-0.898127}"}
local tRoo, iCnt = CT:getRoots(4), 1
while(tRoo[iCnt]) do
  tRoo[iCnt]:Round(6)
  if(tAns[iCnt] == tostring(tRoo[iCnt])) then
    logStatus(nil,"<"..tostring(tAns[iCnt]).."> = <"..tostring(tRoo[iCnt]).."> OK")
  else logStatus(nil,"<"..tostring(tAns[iCnt]).."> ~ <"..tostring(tRoo[iCnt]).."> FAIL") end
  iCnt = iCnt + 1
end
logStatus(nil,"---------------Advanced: Power---------------")
local c = (CT ^ 5);    c:Print("\n")
local c = (CT ^ 0.20); c:Print("\n")
local c = (CT ^ CT);   c:Print("\n")

ToComplex("1.59"):Round(1):Print("\n")

logStatus(nil,"\nTests done")


require("ZeroBraineProjects/dvdlualib/common")
require("ZeroBraineProjects/dvdlualib/complex")

io.stdout:setvbuf("no")

LogLine("---------------Basic: Complex---------------")
A = Complex()           ;  LogLine(A and tostring(A) or "A missing")
B = Complex("asd","asd");  LogLine(B and tostring(B) or "B missing")
C = Complex(1,"1")      ;  LogLine(C and tostring(C) or "C missing")
D = Complex("1","1")    ;  LogLine(D and tostring(D) or "D missing")
E = Complex("1",1)      ;  LogLine(E and tostring(E) or "E missing")
LogLine("---------------Advanced: Tab-2Complex---------------")
F = ToComplex({1,-3})    ;  LogLine(F and tostring(F) or "F missing")
F = ToComplex({Real=1,Imag=-3})    ;  LogLine(F and tostring(F) or "F missing")
F = ToComplex({real=1,imag=-3})    ;  LogLine(F and tostring(F) or "F missing")
F = ToComplex({Re=1,Im=-3})    ;  LogLine(F and tostring(F) or "F missing")
F = ToComplex({re=1,im=-3})    ;  LogLine(F and tostring(F) or "F missing")
F = ToComplex({R=1,I=-3})    ;  LogLine(F and tostring(F) or "F missing")
F = ToComplex({r=1,i=-3})    ;  LogLine(F and tostring(F) or "F missing")
F = ToComplex({x=1,y=-3})    ;  LogLine(F and tostring(F) or "F missing")
LogLine("---------------Advanced: Str-2Complex---------------")
G = ToComplex("{-1,1}")  ;  LogLine(G and tostring(G) or "G missing")
I = ToComplex("2,-2")    ;  LogLine(I and tostring(I) or "I missing")
J = ToComplex("{[+3,-3]}")   ;  LogLine(J and tostring(J) or "1 missing")
J = ToComplex("[-3,-3]}")   ;  LogLine(J and tostring(J) or "2 missing")
J = ToComplex("/[3,3]/")   ;  LogLine(J and tostring(J) or "3 missing")
J = ToComplex("[3,]")   ;  LogLine(J and tostring(J) or "4 missing")
J = ToComplex("[3]")   ;  LogLine(J and tostring(J) or "5 missing")
LogLine("---------------Advanced: Str-I-2Complex---------------")
H = ToComplex("3 - 6i")   ;  LogLine(H and tostring(H) or "H2 missing")
H = ToComplex("3 - i6")   ;  LogLine(H and tostring(H) or "H1 missing")
LogLine("---------------Advanced: Str-I-2Complex with brackets---------------")
J = ToComplex("[4+j5]")   ;  LogLine(J and tostring(J) or "6 missing")
















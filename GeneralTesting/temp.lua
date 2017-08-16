require("ZeroBraineProjects/dvdlualib/common")

local E2Lib = {}

E2Lib.optable_inv = {
	add = "+",
	sub = "-",
	mul = "*",
	div = "/",
	mod = "%",
	exp = "^",
	ass = "=",
	aadd = "+=",
	asub = "-=",
	amul = "*=",
	adiv = "/=",
	inc = "++",
	dec = "--",
	eq = "==",
	neq = "!=",
	lth = "<",
	geq = ">=",
	leq = "<=",
	gth = ">",
	band = "&&",
	bor = "||",
	bxor = "^^",
	bshr = ">>",
	bshl = "<<",
	["not"] = "!",
	["and"] = "&",
	["or"] = "|",
	qsm = "?",
	col = ":",
	def = "?:",
	com = ",",
	lpa = "(",
	rpa = ")",
	lcb = "{",
	rcb = "}",
	lsb = "[",
	rsb = "]",
	dlt = "$",
	trg = "~",
	imp = "->",
	fea = "foreach",
}

E2Lib.optable = {}

for token, op in pairs(E2Lib.optable_inv) do
	local current = E2Lib.optable
	for i = 1, #op do
		local c = op:sub(i, i)
		local nxt = current[c]
		if not nxt then
			nxt = {}
			current[c] = nxt
		end

		if i == #op then
			nxt[1] = token
		else
			if not nxt[2] then
				nxt[2] = {}
			end

			current = nxt[2]
		end
	end
end

logTable(E2Lib.optable, "ops")

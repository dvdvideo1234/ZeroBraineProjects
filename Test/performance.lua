-- package.path = package.path..";".."E:/Documents/Lua-Projs/ZeroBraineIDE/myprograms/?.lua"
local common = require('dvdlualib/common')

util = {}

function util.TypeToString( v )

	local iD = TypeID( v )

	if ( iD == TYPE_VECTOR or iD == TYPE_ANGLE ) then
		return string.format( "%.2f %.2f %.2f", v:Unpack() )
	end
	
	if ( iD == TYPE_NUMBER ) then
		return util.NiceFloat( v )
	end

	return tostring( v )

end

util.TypeToString(1)






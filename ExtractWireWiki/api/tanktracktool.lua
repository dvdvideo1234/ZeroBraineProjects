local API = {
  NAME = "setPiston",
  FLAG = {
    icon = true,  -- (TRUE) Use icons for arguments
    erro = true,  -- (TRUE) Generate an error on dupe or no docs
    extr = false, -- (TRUE) Use the external wiremod types
    remv = false, -- (TRUE) Replace void type with empty string
    quot = true,  -- (TRUE) Place backticks on words containing control symbols or all-upper
    qref = true,  -- (TRUE) Quote the string in the link reference
    prep = true,  -- (TRUE) Replace key in the link pattern in the replace table. Call formatting
    mosp = true,  -- (TRUE) Enables monospace font for the function names
    nxtp = false, -- (TRUE) Utilizes the wire NUMBER datatype when one is not provided ( forced )
    wdsc = true   -- (TRUE) Outputs the direct wire-based description in the markdown overhead
  },
  POOL = {
    {name="MAKE",cols={"Instance creator", "Out", "Description"},size={34,5,13},algn={"<","|","<"}},
    {name="APPLY",cols={"Crankshaft extensions", "Out", "Description"},size={46,5,13},algn={"<","|","<"}},
    {name="SETUP",cols={"General functions", "Out", "Description"},size={34,5,13},algn={"<","|","<"}}
  },
  FILE = {
    exts = "tanktracktool",
    base = "F:/GIT/TankTrackTool",
    path = "data/wiki",
    slua = "lua/entities/gmod_wire_expression2/core/custom",
    repo = "https://github.com/shadowscion/Primitive",
    blob = "blob/master",
    desc = {
      ["Expression2"] = "Expression 2 examples",
      ["backup"] = "Excel for compating output",
      ["pictures"] = "Contains addon pictures",
      ["workshop"] = "Workshop related control crap",
      ["lua"] = "Contains all GLua wiremod sub-addons",
      ["cl_wire_e2_piston_timing.lua"] = "Piston API description",
      ["wire_e2_piston_timing.lua"] = "Piston API implementation",
      ["workshop_publish.bat"] = "Automatic workshop publisher for windows"
    }
  },
  TYPE = {
    OBJ = "e",
    FRM = "type-%s.png",
    LNK = "https://raw.githubusercontent.com/dvdvideo1234/ZeroBraineProjects/master/ExtractWireWiki/types/%s"
  },
  REPLACE = {
    ["MASK"] = "https://wiki.garrysmod.com/page/Enums/MASK",
    ["COLLISION_GROUP"] = "https://wiki.garrysmod.com/page/Enums/COLLISION_GROUP",
    ["Material_surface_properties"] = "https://developer.valvesoftware.com/wiki/Material_surface_properties",
    ["sign"] = "https://en.wikipedia.org/wiki/Sign_function",
    ["wave"] = "https://en.wikipedia.org/wiki/Sine",
    ["triangular"] = "https://en.wikipedia.org/wiki/Triangle_wave",
    ["cross product"] = "https://en.wikipedia.org/wiki/Cross_product",
    ["trochoid"] = "https://en.wikipedia.org/wiki/Trochoid",
    ["ramp"] = "https://en.wikipedia.org/wiki/Ramp_function",
    ["exponential"] = "https://en.wikipedia.org/wiki/Exponentiation",
    ["square root"] = "https://en.wikipedia.org/wiki/Square_root",
    ["local axis"] = "https://en.wikipedia.org/wiki/Cartesian_coordinate_system",
    ["coefficient"] = "https://en.wikipedia.org/wiki/Coefficient",
    ["logarithmic"] = "https://en.wikipedia.org/wiki/Logarithm",
    ["logarithmic"] = "https://en.wikipedia.org/wiki/Trapezoid"
  },
  HDESC = {
    top = "local E2Helper = {Descriptions = {}};",
    bot = "return E2Helper.Descriptions",
    dsc = "E2Helper.Descriptions"
  }
}

-- API.DSCHUNK = [===[ ]===]

return API

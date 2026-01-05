local dir = require("directories")
      dir.addPath("myprograms",
                  "ZeroBraineProjects",
                  "CorporateProjects",
                  -- When not located in general directory search in projects
                  "ZeroBraineProjects/dvdlualib",
                  "ZeroBraineProjects/ExtractWireWiki")
      dir.addBase("D:/Programs/LuaIDE")
      dir.addBase("C:/Programs/ZeroBraineIDE").setBase(2)

local chatbot = require("chatbot")
local common = require("common")

local sBas = common.stringGetChunkPath()

local prompt = "You are an expert on Bulgarian philology. Translate to Bulgarian [%s]."
      prompt = prompt.." I need only the final result/conclusion."
      prompt = prompt.." Do not quote the result or add aditional spaces/punctoation."
local bot = chatbot.getNew("Translate"):setJSON("dkjson"); print("Bot created:", tostring(bot))
      bot:setKey("${GROQ_API_CHAT_KEY}")
      bot:setAPI("https://api.groq.com/openai/v1/chat/completions")
if(not bot:isValid()) then error("Bot is invalid!") end
      
local fin = assert(io.open(sBas.."in.properties", "rb"))
local cur, fmt = fin:seek(), "%5.2f%%[O]" -- Get the current pointer
local siz = fin:seek("end"); fin:seek("set", cur)
local fou = assert(io.open(sBas.."out.properties", "wb"))
local row, abr, lib, cnt = fin:read("*line"), "", "", 1000
while(row and cnt > 0) do
  cur = fin:seek() 
  print(fmt:format(cur/siz*100), row)
  local s, e = row:find("=", 1, true)
  if(s and e) then
    abr = row:sub(1, s-1)
    lib = row:sub(e+1, -1)
    bot:Request({
      model = "llama-3.1-8b-instant",  -- or "mixtral-8x7b-32768"
      messages = {{role = "user", content = prompt:format(lib)}},
      temperature = 0.6,
      max_tokens = 1024
    })
    local res = bot:Response({
      protocol = "tlsv1_2",
      options  = "all",
      timeout  = 20
    })
    if(bot:getStatus() == 200) then
      local body = bot:getBody(true)
      if(body) then
        lib = body.choices[1].message.content
      else
        bot:Dump()
        break
      end
    else
      bot:Dump()
      break
    end
    print("      [T]", abr.."="..lib)
    fou:write(abr.."="..lib.."\n")
  else
    print("      [K]", row)
    fou:write(row.."\n")
  end
  row = fin:read("*line")
  common.timeDelay(1)
  cnt = cnt - 1
end

fou:flush()
fou:close()
fin:close()

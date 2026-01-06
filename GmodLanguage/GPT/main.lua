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

local prompt = "Translate to Bulgarian [%s]."
      prompt = prompt.." I need only the final result/conclusion."
      prompt = prompt.." Do not quote the result or add aditional spaces/punctoation."
local bot = chatbot.getNew("BG"):setJSON("dkjson")
      bot:setKey("$GROQ_API_CHAT_KEY", api_key):setTimer(10, 5)
      bot:setAPI("https://api.groq.com/openai/v1/chat/completions")
if(not bot:isValid()) then error("Bot is invalid!") end
print("Bot created:", tostring(bot))

local tAbr = {}

do
  local fou = assert(io.open(sBas.."out.properties", "rb"))
  local row = fou:read("*line")
  while(row) do
    local s, e = row:find("=", 1, true)
    if(s and e) then
      abr = row:sub(1, s-1)
      tAbr[abr] = true
      print("      [A]", abr)
    else
      tAbr[row] = true
      print("      [R]", row)
    end
    row = fou:read("*line")
  end; fou:close()
end

local new = common.isDryTable(tAbr)
local fin = assert(io.open(sBas.."in.properties", "rb"))
local cur, fmt = fin:seek(), "%5.2f%%[O]" -- Get the current pointer
local siz = fin:seek("end"); fin:seek("set", cur)
local fou = assert(io.open(sBas.."out.properties", new and "wb" or "ab"))
local row, abr, lib = fin:read("*line"), "", ""
while(row) do
  while(not bot:isTimer()) do
    print(bot:getTimer("|")..": "..os.clock())
  end
  local s, e = row:find("=", 1, true)
  if(s and e) then
    abr = row:sub(1, s-1)
    if(not tAbr[abr]) then
      common.timeDelay(0.1)
      cur = fin:seek() 
      print(fmt:format(cur/siz*100), row)
      lib = row:sub(e+1, -1)
      bot:Request({
        model = "llama-3.1-8b-instant",  -- or "mixtral-8x7b-32768"
        messages = {{role = "user", content = prompt:format(lib)}},
        temperature = 0.6,
        max_tokens = 50
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
          bot:Error("Body is missing", true)
          break
        end
      else
        bot:Error("Wrong post status ["..bot:getStatus().."]", true)
        break
      end
      print("      [T]", abr.."="..lib)
      fou:write(abr.."="..lib.."\n")
    end
  else
    print("      [K]", row)
    fou:write(row.."\n")
  end
  row = fin:read("*line")
end

fou:flush()
fou:close()
fin:close()


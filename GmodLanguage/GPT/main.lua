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

local sBas = "GmodLanguage/GPT"

local url = "https://api.groq.com/openai/v1/chat/completions"
local prompt = "Translate the abbreviation to Bulgarian \"%s\". I need only the final result/conclusion."
local abrev = "tool.test.reload=Reload the testing method"

local bot = chatbot.getNew()
bot:JSON("dkjson")
local rem = bot:Remote(url, "${GROQ_API_CHAT_KEY}")
bot:Request({
  model = "llama-3.1-8b-instant",  -- or "mixtral-8x7b-32768"
  messages = {{role = "user", content = prompt:format(abrev)}},
  temperature = 0.7,
  max_tokens = 1024
})
local res = bot:Response({
  protocol = "tlsv1_2",
  options  = "all",
  timeout  = 20
})

print(tostring(bot))

if(bot:getStatus() == 200) then
  local body = bot:getBody(true)
  if(body) then
    print(body.choices[1].message.role)
    print(body.choices[1].message.content)
  else
    bot:Dump()
  end
else
  bot:Dump()
end


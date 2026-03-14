local curl = require("plenary.curl")
-- local bot = require("capynote.bot")

---@class cn.Http
local http = {}

http.base_url = "https://discord.com/api/v10/"

---@param endpoint string
---@param opts {endpoint: string, body?: string}
function http.post(endpoint, body)
  return http.curl("post", {
    endpoint = endpoint,
    body = body,
  })
end

---@param endpoint string
---@param opts {endpoint: string, body?: string}
function http.get(endpoint, body)
  return http.curl("get", {
    endpoint = endpoint,
    body = body,
  })
end

---@private
---@param method string
---@param params {endpoint: string, body?: string}
function http.curl(method, params)
  local url = http.base_url .. params.endpoint

  params.headers = {
    -- ["Authorization"] = "Bot " .. bot.token,
    ["Content-Type"] = "application/json",
  }
  params.body = vim.json.encode(params.body)

  local res = curl[method](url, params)
  return res
end

return http

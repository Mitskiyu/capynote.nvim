---@class cn.Commands
local cmd = {}

function cmd.oauth()
  require("capynote.oauth").server()
end

---@param args {args: string}
function cmd.exec(args)
  local subcmd = args.args
  local fn = cmd.commands[subcmd]
  if fn then
    fn()
  else
    vim.notify("Unknown command: " .. subcmd)
  end
end

function cmd.setup()
  vim.api.nvim_create_user_command("Capy", cmd.exec, {
    bar = true,
    bang = true,
    nargs = "?",
    desc = "Capy",
  })
end

---@type table<string, function>
cmd.commands = {
  setup = cmd.oauth,
}

return cmd

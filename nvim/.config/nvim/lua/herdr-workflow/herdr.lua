local M = {}

local function run(args)
  local cmd = { "herdr", unpack(args) }
  local r = vim.system(cmd, { text = true }):wait()
  if r.code ~= 0 then
    local err = r.stderr ~= "" and r.stderr or ("exit " .. r.code)
    error("herdr error: " .. err)
  end
  return r
end

local function parse_json(stdout)
  local ok, data = pcall(vim.json.decode, stdout)
  if not ok or type(data) ~= "table" then
    return nil
  end
  return data
end

function M.split(direction, from_pane)
  from_pane = from_pane or vim.env.HERDR_PANE_ID
  local r = run({
    "pane", "split",
    "--pane", from_pane,
    "--direction", direction,
    "--cwd", vim.fn.getcwd(),
    "--no-focus",
  })
  local data = parse_json(r.stdout)
  if not data or not data.result or not data.result.pane then
    error("no se pudo crear panel herdr")
  end
  return data.result.pane.pane_id
end

function M.run(pane_id, command)
  run({ "pane", "run", pane_id, command })
end

function M.rename(pane_id, label)
  run({ "pane", "rename", pane_id, label })
end

function M.start_opencode(pane_id, name, callback)
  vim.system({ "herdr", "agent", "start", name, "--kind", "opencode", "--pane", pane_id }, { text = true }, function(r)
    vim.schedule(function()
      callback(r)
    end)
  end)
end

function M.list_agents()
  local r = run({ "agent", "list" })
  local data = parse_json(r.stdout)
  return (data and data.result and data.result.agents) or {}
end

function M.find_agent_pane(kind)
  local tab = vim.env.HERDR_TAB_ID
  if not tab then
    return nil
  end
  for _, a in ipairs(M.list_agents()) do
    if a.agent == kind and a.tab_id == tab then
      return a.pane_id
    end
  end
  return nil
end

function M.list_panes()
  local ws = vim.env.HERDR_WORKSPACE_ID
  if not ws then
    return {}
  end
  local r = run({ "pane", "list", "--workspace", ws })
  local data = parse_json(r.stdout)
  return (data and data.result and data.result.panes) or {}
end

function M.find_pane_by_label(label)
  for _, p in ipairs(M.list_panes()) do
    if p.label == label or p.title == label then
      return p.pane_id
    end
  end
  return nil
end

local function neighbors(pane_id)
  local out = {}
  for _, dir in ipairs({ "left", "right", "up", "down" }) do
    local ok, r = pcall(run, { "pane", "neighbor", "--pane", pane_id, "--direction", dir })
    if ok then
      local data = parse_json(r.stdout)
      local n = data and data.result and data.result.neighbor
        and data.result.neighbor.neighbor_pane_id
      if n then
        out[#out + 1] = { dir = dir, pane = n }
      end
    end
  end
  return out
end

function M.focus(pane_id)
  local start = vim.env.HERDR_PANE_ID
  if not start or start == pane_id then
    return
  end
  local queue = { { pane = start, path = {} } }
  local seen = { [start] = true }
  local visited = 0
  while #queue > 0 and visited < 20 do
    local node = table.remove(queue, 1)
    visited = visited + 1
    for _, nb in ipairs(neighbors(node.pane)) do
      if not seen[nb.pane] then
        seen[nb.pane] = true
        local path = vim.list_extend({}, node.path)
        path[#path + 1] = nb.dir
        if nb.pane == pane_id then
          for _, dir in ipairs(path) do
            run({ "pane", "focus", "--direction", dir })
          end
          return
        end
        queue[#queue + 1] = { pane = nb.pane, path = path }
      end
    end
  end
end

return M

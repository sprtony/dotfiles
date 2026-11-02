local M = {}

function M.find_project_root()
  local dir = vim.fn.getcwd()
  while dir ~= "/" do
    if vim.uv.fs_stat(dir .. "/.vscode/sftp.json") then
      return dir
    end
    if vim.uv.fs_stat(dir .. "/.git") then
      return dir
    end
    dir = vim.fn.fnamemodify(dir, ":h")
  end
  return nil
end

function M.read_sftp_config(root)
  local path = root .. "/.vscode/sftp.json"
  local f = io.open(path, "r")
  if not f then
    return nil
  end
  local raw = f:read("*a")
  f:close()
  local ok, cfg = pcall(vim.json.decode, raw)
  if not ok then
    return nil
  end
  return cfg
end

function M.is_project()
  return M.find_project_root() ~= nil
end

return M

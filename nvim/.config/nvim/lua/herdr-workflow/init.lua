local M = {}
local config = require("herdr-workflow.config")
local herdr = require("herdr-workflow.herdr")
local lftp = require("herdr-workflow.lftp")
local mc = require("herdr-workflow.mc")

M.config = {
  opencode_name = "opencode",
  ftp_manager = "mc",
}

local state = {
  opencode_pane = nil,
  ftp_pane = nil,
}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO)
end

local function run_lftp(cmd, ok_msg, err_msg, on_ok)
  local stderr = {}
  vim.fn.jobstart(cmd, {
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            stderr[#stderr + 1] = line
          end
        end
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        local detail = table.concat(stderr, "\n")
        notify(err_msg .. (detail ~= "" and (": " .. detail) or ""), vim.log.levels.ERROR)
      else
        if ok_msg then
          notify(ok_msg)
        end
        if on_ok then
          vim.schedule(on_ok)
        end
      end
    end,
  })
end

local function relative_path(root, path)
  root = root:gsub("/$", "")
  if path:sub(1, #root + 1) == root .. "/" then
    return path:sub(#root + 2)
  end
  return path
end

local function sanitize_agent_name(input)
  input = (input or ""):lower()
  input = input:gsub("[^a-z0-9_-]", "")
  input = input:gsub("^[^a-z]+", "")
  if input == "" then
    return "opencode"
  end
  return input:sub(1, 32)
end

local function opencode_panel_name()
  local tab = vim.env.HERDR_TAB_ID or ""
  if tab == "" then
    return "opencode"
  end
  return sanitize_agent_name("opencode-" .. tab)
end

local function ensure_in_herdr()
  if vim.env.HERDR_ENV ~= "1" then
    notify("No estás dentro de un espacio herdr", vim.log.levels.ERROR)
    return false
  end
  return true
end

local function project_info()
  local root = config.find_project_root()
  if not root then
    notify("No se encontró proyecto (.vscode/sftp.json o .git)", vim.log.levels.ERROR)
    return nil, nil
  end
  local cfg = config.read_sftp_config(root)
  return root, cfg
end

function M.open_opencode()
  if not ensure_in_herdr() then
    return
  end
  local label = opencode_panel_name()
  local pane = herdr.find_agent_pane("opencode") or herdr.find_pane_by_label(label)
  if pane then
    herdr.focus(pane)
    state.opencode_pane = pane
    return
  end
  local new_pane = herdr.split("right")
  state.opencode_pane = new_pane
  herdr.rename(new_pane, label)
  herdr.start_opencode(new_pane, label, function(r)
    if r.code ~= 0 then
      notify("No se pudo iniciar opencode: " .. (r.stderr or ""), vim.log.levels.ERROR)
    else
      notify("Opencode listo")
    end
  end)
end

function M._open_ftp_panel(manager)
  if not ensure_in_herdr() then
    return
  end
  local root, cfg = project_info()
  if not root then
    return
  end
  if not cfg then
    notify("No hay .vscode/sftp.json para este proyecto", vim.log.levels.ERROR)
    return
  end

  local slug = (vim.fn.fnamemodify(root, ":t"):gsub("[^%w]", "-"))
  local label = "ftp-" .. slug

  local pane = herdr.find_pane_by_label(label)
  if pane then
    herdr.focus(pane)
    state.ftp_pane = pane
    return
  end

  local opencode_label = opencode_panel_name()
  local from_pane = state.opencode_pane or herdr.find_agent_pane("opencode") or herdr.find_pane_by_label(opencode_label)
  if not from_pane then
    notify("Abre opencode primero con <leader>ho", vim.log.levels.WARN)
    return
  end

  local new_pane = herdr.split("down", from_pane)
  state.ftp_pane = new_pane
  herdr.rename(new_pane, label)

  local cmd
  if manager == "mc" then
    cmd = mc.interactive_cmd(root, cfg)
  else
    cmd = lftp.interactive_cmd(root, cfg)
  end
  herdr.run(new_pane, cmd)
end

function M.open_ftp_panel()
  M._open_ftp_panel(M.config.ftp_manager)
end

function M.open_ftp_lftp()
  M._open_ftp_panel("lftp")
end

function M.diff_remote()
  local root, cfg = project_info()
  if not root or not cfg then
    return
  end
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    notify("Buffer sin archivo", vim.log.levels.WARN)
    return
  end
  local rel = relative_path(root, file)
  local dest = vim.fn.tempname() .. "-" .. vim.fn.fnamemodify(rel, ":t")
  local cmd = lftp.download_file_cmd(root, cfg, rel, dest)
  run_lftp(cmd, nil, "Error descargando archivo remoto", function()
    vim.cmd("diffsplit " .. vim.fn.fnameescape(dest))
  end)
end

function M.upload_current()
  local root, cfg = project_info()
  if not root or not cfg then
    return
  end
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    notify("Buffer sin archivo", vim.log.levels.WARN)
    return
  end
  local rel = relative_path(root, file)
  local cmd = lftp.upload_file_cmd(root, cfg, file, rel)
  run_lftp(cmd, "Archivo subido", "Error subiendo archivo")
end

function M.download_current()
  local root, cfg = project_info()
  if not root or not cfg then
    return
  end
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    notify("Buffer sin archivo", vim.log.levels.WARN)
    return
  end
  local rel = relative_path(root, file)
  local cmd = lftp.download_file_cmd(root, cfg, rel, file)
  run_lftp(cmd, "Archivo bajado", "Error bajando archivo", function()
    vim.cmd("edit!")
  end)
end

function M.upload_dir(path)
  local root, cfg = project_info()
  if not root or not cfg then
    return
  end
  path = path or root
  local rel = relative_path(root, path)
  if rel == "" then
    rel = "."
  end
  local cmd = lftp.mirror_up_cmd(root, cfg, path, rel)
  run_lftp(cmd, "Carpeta subida", "Error subiendo carpeta")
end

function M.download_dir(path)
  local root, cfg = project_info()
  if not root or not cfg then
    return
  end
  path = path or root
  local rel = relative_path(root, path)
  if rel == "" then
    rel = "."
  end
  local cmd = lftp.mirror_down_cmd(root, cfg, rel, path)
  run_lftp(cmd, "Carpeta bajada", "Error bajando carpeta")
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  vim.api.nvim_create_user_command("HerdrOpencode", M.open_opencode, { desc = "Abrir panel de opencode" })
  vim.api.nvim_create_user_command("HerdrFtpPanel", M.open_ftp_panel, { desc = "Abrir panel FTP" })
  vim.api.nvim_create_user_command("HerdrFtpLftp", M.open_ftp_lftp, { desc = "Abrir panel lftp" })
  vim.api.nvim_create_user_command("HerdrFtpDiff", M.diff_remote, { desc = "Diff con archivo remoto" })
  vim.api.nvim_create_user_command("HerdrFtpUpload", M.upload_current, { desc = "Subir archivo actual" })
  vim.api.nvim_create_user_command("HerdrFtpDownload", M.download_current, { desc = "Bajar archivo actual" })
  vim.api.nvim_create_user_command("HerdrFtpUploadDir", function()
    M.upload_dir()
  end, { desc = "Subir carpeta del proyecto" })
  vim.api.nvim_create_user_command("HerdrFtpDownloadDir", function()
    M.download_dir()
  end, { desc = "Bajar carpeta del proyecto" })

  vim.keymap.set("n", "<leader>ho", "<cmd>HerdrOpencode<cr>", { desc = "Abrir opencode" })
  vim.keymap.set("n", "<leader>hf", "<cmd>HerdrFtpPanel<cr>", { desc = "Abrir panel FTP (mc)" })
  vim.keymap.set("n", "<leader>hF", "<cmd>HerdrFtpLftp<cr>", { desc = "Abrir panel lftp" })
  vim.keymap.set("n", "<leader>hd", "<cmd>HerdrFtpDiff<cr>", { desc = "Diff con remoto" })
  vim.keymap.set("n", "<leader>hu", "<cmd>HerdrFtpUpload<cr>", { desc = "Subir archivo" })
  vim.keymap.set("n", "<leader>hU", "<cmd>HerdrFtpUploadDir<cr>", { desc = "Subir carpeta" })
  vim.keymap.set("n", "<leader>hx", "<cmd>HerdrFtpDownload<cr>", { desc = "Bajar archivo" })
  vim.keymap.set("n", "<leader>hX", "<cmd>HerdrFtpDownloadDir<cr>", { desc = "Bajar carpeta" })

  if vim.g.herdr_workflow_auto_opencode ~= false and config.is_project() and vim.env.HERDR_ENV == "1" and not vim.env.HERDR_NVIM_HANDOFF then
    vim.defer_fn(function()
      M.open_opencode()
    end, 800)
  end
end

return M

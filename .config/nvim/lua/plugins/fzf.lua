return {
  {
    "ibhagwan/fzf-lua",
    opts = function(_, opts)
      local config = require("fzf-lua").config
      -- Prevent Trouble stealing the ctrl-t mapping to open in a new tab
      config.defaults.actions.files["ctrl-t"] = require("fzf-lua").actions.file_tabedit
    end,
  },
}

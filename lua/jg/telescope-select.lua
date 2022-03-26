local M = {}

function M.setup()
  vim.ui.select = M.select
end

function M.select(items, opts, on_choice)
  local action_set = require('telescope.actions.set')
  local actions = require('telescope.actions')
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local state = require('telescope.actions.state')

  opts = opts or {}
  on_choice = on_choice or function() end

  pickers.new({
    prompt_title = opts.prompt or '',
    finder = finders.new_table({
      results = items,
      entry_maker = function(item)
        local text = (opts.format_item or tostring)(item)
        return { display = text, ordinal = text, value = item }
      end,
    }),
    sorter = conf.generic_sorter(),
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = { width = 60, height = 16 },
    },
    results_title = false,
    attach_mappings = function()
      action_set.select:replace(function(prompt_bufnr)
        actions.close(prompt_bufnr, false)
        local selected = state.get_selected_entry() or {}
        on_choice(selected.value, selected.index)
      end)

      return true
    end,
  }):find()
end

return M

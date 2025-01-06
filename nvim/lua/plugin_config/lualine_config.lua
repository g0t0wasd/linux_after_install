return {
    'nvim-lualine/lualine.nvim',
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,
                -- theme = 'gruvbox_dark',
                -- theme = 'codedark',
                theme = 'carbonfox',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {},
                always_divide_middle = true,
                globalstatus = false,
            },
            sections = {
                lualine_a = { 'mode' },
                lualine_b = { { 'branch', fmt = function(str) return str:sub(1, 10) end }, 'diff', 'diagnostics' },
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                        shorting_target = 10
                    },
                    {
                        function()
                            local navic = require('nvim-navic')
                            return navic.get_location()
                        end,
                        cond = function()
                            local navic = require('nvim-navic')
                            return navic.is_available()
                        end
                    },
                },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' },
                lualine_z = { 'location' }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { 'filename' },
                lualine_x = { 'location' },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            extensions = {},
        }
    end
}

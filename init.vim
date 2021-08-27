" =============================================================================
"                             Source ~/.vim/vimrc
" =============================================================================
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vim/vimrc
let g:python3_host_prog = '~/.nvim.venv/bin/python'

" =============================================================================
"                              Plugin Management
" =============================================================================
call plug#begin('~/.config/nvim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'folke/lsp-colors.nvim'
Plug 'morhetz/gruvbox'
Plug 'cocopon/iceberg.vim'
Plug 'doums/darcula'
Plug 'psf/black'
Plug 'JuliaEditorSupport/julia-vim'
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'nvim-treesitter/nvim-treesitter', {'branch': '0.5-compat', 'do': 'TSUpdate'}
call plug#end()

" Overriding settings in my own plugins
" -------------------------------------
" Don't pop up the quickfix menu automatically - we have the language server
let g:py_nolint=1


" =============================================================================
"                        Language Server Configuration
" =============================================================================
" Copied from the suggestions in the nvim-lspconfig README:
" https://github.com/neovim/nvim-lspconfig
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<CMD>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<CMD>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<CMD>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<CMD>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<CMD>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<CMD>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<CMD>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<CMD>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<CMD>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<CMD>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<CMD>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<CMD>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<CMD>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<CMD>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<leader>f", "<CMD>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "pyright", "bashls", "julials" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF

autocmd Filetype julia setlocal omnifunc=v:lua.vim.lsp.omnifunc

function! LspLocationList()
  lua vim.lsp.diagnostic.set_loclist({open_loclist = false})
endfunction

augroup lsp_loclist
  autocmd!
  autocmd BufWrite,BufEnter,InsertLeave * :call LspLocationList()
augroup END

" Diagnostics colors
lua << EOF
require("lsp-colors").setup {
  Error = "#db4b4b",
  Warning = "#e0af68",
  Information = "#0db9d7",
  Hint = "#10B981"
}
EOF

" Activate LSP colors
colo darcula

" treesitter modules
lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- Modules and its options go here
  highlight = { enable = true },
  incremental_selection = { enable = true },
  textobjects = { enable = true },
}
EOF

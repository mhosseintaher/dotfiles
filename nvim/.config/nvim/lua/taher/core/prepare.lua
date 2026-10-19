-- No plugin ships rplugin/ and nothing calls :python3/:ruby/:perl or a node host,
-- so skip the provider hosts instead of pinning pyenv/nvm/rbenv versions
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

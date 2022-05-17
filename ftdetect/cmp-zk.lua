local zk_dir = vim.env.ZK_DIR
if zk_dir ~= nil then
    vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWinEnter" }, {
        pattern = zk_dir .. "/*",
        callback = function() 
            vim.cmd[[setfiletype zk]]
            vim.cmd[[runtime! syntax/markdown.vim syntax/markdown/*.vim]]
        end,
        group = vim.api.nvim_create_augroup("ZKFileType", {})
    })
end

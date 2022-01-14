autocmd BufNewFile,BufRead *.blade.php set filetype=blade
autocmd BufWritePost *.blade.php call CocAction('format')

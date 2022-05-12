# cmp-zk
nvim-cmp source for local zettlekasten. This is really just for personal use and I'll likely hardcode lots of values and functionality, but go crazy if you get some use out of it.

## setup
```lua
require"cmp".setup {
    sources = {
        { name = "zk" }
    }
}
```

## usage
trigger to show tags with '#'
trigger to show notes with '['

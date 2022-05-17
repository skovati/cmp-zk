# cmp-zk
nvim-cmp source for local zettlekasten. This is really just for personal use and I'll likely hardcode lots of values and functionality, but go crazy if you get some use out of it.

## philosophy
I've been searching for an editor agnostic solution to a terminal based zettlekasten repo, and couldn't find anything, so naturally I made Yet Another Solution. This repo acts as documentation for the entire note-taking solution as the accompanying script lives in my [dotfiles repo](https://github.com/skovati/dotfiles). The [script](https://github.com/skovati/dotfiles/blob/master/bin/.local/bin/zk) handles creation of new notes (either zettlekasten or daily journals) with ISO8601-based UUIDs, encryption and decryption of the notes repo, and management of the remote git repo. The script will essentially decrypt notes, create a new one, open `$EDITOR`, and then encrypt and push the notes. This is done so my repo can stay entirely editor agnostic.

This cmp-zk plugin on the other hand is obviously nvim specific. It offers the convenience of referencing other notes or tags while writing a new note using nvim-cmp completion.

## installation
```lua
require("packer").startup(function(use)
    use("skovati/cmp-zk")
end
```

## config
### register with cmp
```lua
require("cmp").setup({
    sources = {
        { name = "zk" }
    }
})
```
### set ZK_DIR environment variable
```sh
    # in e.g. ~/.zshrc
    export ZK_DIR=~/docs/zk
```

## usage

- trigger to show tags with '*'
- trigger to show notes with '['

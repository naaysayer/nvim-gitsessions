# nvim-gitsessions

Lua version of [gitsession vim plugin](https://github.com/wting/gitsessions.vim/blob/master/plugin/gitsessions.vim)
Neovim plugin that automatically saves and loads sessions for a git based projects, based on branch name.

## Note
This plugin is still in development, so there is are unknown bugs and missing features.

Basically it uses [(neo)vim :mksession](https://neovim.io/doc/user/usr_21.html#21.4) and :source commands to save and load sessions,
i am just tired to use them manually.

## Usage

Load plugin with your plugin manager, for example with lazy:

```lua
{ "naaysayer/nvim-gitsessions" }
```

plugin options and default values:
```lua
require("nvim-gitsessions").setup({
    manual = true, -- save/load sessions manually, instead of using VimLeave and VimEnter events
    path-- by default uses stdpath("data"), so it will be saved in ~/.local/share/nvim/data/nvim-gitsessions
})
```

Plugin provides commands:

    NvimGitSessionsSave - save current session
    NvimGitSessionsLoad - load session for current branch

# License MIT

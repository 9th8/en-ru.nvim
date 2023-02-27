## macOS
1. Install [input-source-switcher](https://github.com/vovkasm/input-source-switcher)
```
git clone https://github.com/9th8/input-source-switcher.git
cd input-source-switcher
mkdir build && cd build
cmake ..
make
make install
```
2. Install this plugin
* Lazy
```
--input language auto-switcher
  "9th8/en-ru.nvim",
```
2. Add the setup line to your config
```
require('en-ru').setup()
```


## About
This plugin uses autocommands to 'listen' when you are entering and exiting Insert mode, or when Neovim gets or loses focus, and libcalls to change your layout.

* **When leaving insert mode:**
1) Save the current layout
2) Switch to the US layout

* **When entering Insert mode:**
1. Switch to the previously saved layout

* **When Neovim gets focus:**
1. Save the current layout
2. Switch to the US layout if Normal mode or Visual mode is the current mode

* **When Neovim loses focus:**
1. Switch to the previously saved layout

# CCRunX
Better version of the [ccrun](https://github.com/daelvn/ccrun) wrapper. This is a wrapper around CCEmuX which will let you create environments and run your projects inside CCEmuX.

## Installing
This should be as easy as cloning this repo (`git clone https://github.com/daelvn/ccrunx.git`), making the script an executable if it isn't already (`chmod +x ./ccrunx`) and running it. It's recommendable that you put this script in your path. If you need to install CCEmuX, you can easily download it from the AUR as ccemux-git (Arch). This requires you to install the dependences `lrunkit` and `ltext` manually.

Additionally, you can download the whole package using LuaRocks: `luarocks install ccrunx`, although you will still have to download CCEmuX.

## Usage
First, you should configure an environment for your project.
```
$ ccrunx configure project
```
Where `project` will be the name of your folder. After this, all you have to do is run the project, which will copy the contents of `project/` into the computer ID. You can do it like this:
```
$ ccrunx run project [-i <id>|--id <id>]
```
The ID defaults to 0. If you want to create a new ID, you can use:
```
$ ccrunx new project 255
```
Optionally, you can attach certain files to an environment, which will permanently store them in place.
```
$ ccrunx attach project rom-extra/
```
Now, every time that you run the project, the files from rom-extra/ will be always moved to `id:/`

## Credits
Thanks to the guys at [CCEmux](https://github.com/CCEmuX/CCEmuX) for this amazing emulator!


-- cc/ccrunx | 03.12.2018
-- By daelvn
--> # ccrunx
--> CCEmuX wrapper
import chain, execute                 from require "lrunkit"
{:title, :arrow, :dart, :bullet, :error} = require "ltext"
{:mkdir}                                 = require "lfs"
argparse                                 = require "argparse"

table.unpack or= unpack or ->

--> Collect arguments
local argl
with argparse!
  \name "ccrunx"
  \description "Wrapper for running folders as CCEmuX computers"
  \epilog "https://ccrunx.daelvn.ga"

  \command_target "mode"

  with \option "-v --version"
    \description "Prints the ccrunx version"
    \action -> print "ccrunx 1.0"

  with \command "run r"
    \description "Run an environment"
    \target "run"
    with \argument "folder"
      \description "Run this folder as environment"
      \args 1
    with \option "-i --id"
      \description "Computer ID"
      \default "0"

  with \command "configure c"
    \description "Configures ccrunx to run folders in this directory"
    \target "configure"
    with \argument "folder"
      \description "Environment name"
      \args 1
    with \option "-i --id"
      \description "Computer ID"
      \default "0"
    with \option "-t --timeout"
      \description "Timeout for running CCEmuX"
      \default "5s"

  with \command "attach a"
    \description "Attach another folder to the environment"
    \target "attach"
    with \argument "environment"
      \description "Name of the environment"
      \args 1
    with \argument "folder"
      \description "Folder to attach"
      \args 1

  with \command "new n"
    \description "Creates a new ID in an environment"
    \target "new"
    with \argument "environment"
      \description "Name of the environment"
      \args 1
    with \argument "id"
      \description "ID for the computer"
      \args 1

  argl = \parse!


--> ## configure
--> Function for configuring ccrunx
configure = ->
  (chain table.unpack {
    -> print arrow "Configuring ccrunx"
    -> print dart "Creating folder .ccrunx/#{argl.folder}"
    -> mkdir ".ccrunx"
    -> mkdir ".ccrunx/#{argl.folder}"
    -> print dart "Running CCEmuX shortly to generate configuration files"
    execute "timeout #{argl.timeout} ccemux -d .ccrunx/#{argl.folder} &> /dev/null"
    -> print dart "Creating computer/ folder"
    -> mkdir ".ccrunx/#{argl.folder}/computer"
    -> mkdir ".ccrunx/#{argl.folder}/computer/#{argl.id}"
    -> print dart "Create attach/ folder"
    -> mkdir ".ccrunx/#{argl.folder}/attach"
    -> print bullet "Done!" }) !

--> ## copy_files
--> Copies the files of folder argl.folder to .ccrunx/argl.folder/computer/argl.id
copy_files = ->
  (chain table.unpack {
    -> print arrow "Copying files into #{argl.id}:/"
    -> print dart "Deleting old environment"
    execute "rm -rf .ccrunx/#{argl.folder}/computer/#{argl.id}/*"
    -> print dart "Attaching files from .ccrunx/#{argl.folder}/attach/ to .ccrunx/#{argl.folder}/computer/#{argl.id}"
    execute "cp -r .ccrunx/#{argl.folder}/attach/* .ccrunx/#{argl.folder}/computer/#{argl.id}"
    -> print dart "Copying files from #{argl.folder} to .ccrunx/#{argl.folder}/computer/#{argl.id}"
    execute "cp -r #{argl.folder}/* .ccrunx/#{argl.folder}/computer/#{argl.id}/"
    -> print bullet "Done!" })!

--> ## attach
--> Attach a folder into an environment
attach = ->
  (chain table.unpack {
    -> print arrow "Attaching #{argl.folder} to environment #{argl.environment}"
    -> print dart "Copying files from #{argl.folder} to .ccrunx/#{argl.environment}/attach/"
    execute "cp -r #{argl.folder}/* .ccrunx/#{argl.environment}/attach/"
    -> print bullet "Done!" })!

--> ## new
--> Creates a new computer inside an environment
new = ->
  (chain table.unpack {
    -> print arrow "Creating a new computer #{argl.id} in #{argl.environment}"
    -> print dart "Creating computer/#{argl.id} folder"
    -> mkdir ".ccrunx/#{argl.environment}/computer/#{argl.id}" })!

--> ## run
--> Opens CCEmuX
run = ->
  (execute "ccemux -d .ccrunx/#{argl.folder}")!

switch argl.mode
  when "configure" then configure!
  when "attach"    then attach!
  when "new"       then new!
  when "run"
    copy_files!
    run!
  else
    print error "This shouldn't be displaying. Good job!"
    os.exit!

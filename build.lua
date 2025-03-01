return {
  
    -- basic settings:
    name = 'HighFlyingRogue', -- name of the game for your executable
    developer = 'Himanshu Sinha', -- dev name used in metadata of the file
    output = 'dist', -- output location for your game, defaults to $SAVE_DIRECTORY
    version = '1.1', -- 'version' of your game, used to name the folder in output
    love = '11.5', -- version of LÖVE to use, must match github releases
    ignore = {}, -- folders/files to ignore in your project
    icon = 'assets/sprites/red_ballon.png', -- 256x256px PNG icon for game, will be converted for you
  }
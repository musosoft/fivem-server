--------------------------------------------
--------------------------------------------
--  Script    : dsCarSystem               --
--  Developer : WinMew ดูดมาจาก dyztiny    --
--  และ winmew ก็ขาย สุดท้ายก็หลุด            --
--  Discord  : https://discord.gg/rD6UD4m --
--------------------------------------------
--------------------------------------------

fx_version 'adamant'

game 'gta5'

description 'wmCarSystem By. WinMew'

files {
    'html/index.html',
    'html/css/styles.css',
    'html/js/index.js',
    'html/img/Engin_PS.png',
    'html/img/BELT.png',
    'html/img/cruise.png'
}

client_script {
	'config.lua',
	'client/function.lua',
    'client/main.lua'
}

ui_page 'html/index.html'

dependencies {
	-- 'esx_legacyfuel'
}
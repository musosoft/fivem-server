fx_version 'adamant'

game 'gta5'

name 'azael_ui-announcements'

description 'UI - Server Announcements'

version '1.1.6'

author 'Azael Dev'

url 'https://fivem.azael.dev/digishop/azael-ui-announcements'

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/app.js',
	'html/style.css',
	'html/images/*.png'
}

server_script {
	'config.server.js',
	'server/main.js'
}

client_scripts {
	'config.client.js',
	'client/main.js'
}

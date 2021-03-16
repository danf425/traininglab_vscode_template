[Unit]
Description=Code Server

[Service]
User=chef
Group=chef
Environment=PASSWORD=${workstation_user_password}
ExecStart=/usr/bin/code-server /home/chef

[Install]
WantedBy=default.target
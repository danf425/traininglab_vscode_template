[Unit]
Description=Code Server

[Service]
User=someuser
Group=someuser
Environment=PASSWORD=${workstation_user_password}
ExecStart=/usr/bin/code-server /home/someuser

[Install]
WantedBy=default.target
import socket
address = [ip for ip in socket.gethostbyname_ex(socket.gethostname())[2] if not ip.startswith("127.")][:1][0]
file_ = open('../OGLEngine/OGLEngine/OtherSources/IPAddress', 'w')
file_.write(address)
file_.close()

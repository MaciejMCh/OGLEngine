import socket

address = "localhost"
for ip in socket.gethostbyname_ex(socket.gethostname())[2]:
	if not ip.startswith("127"):
		address = ip
print(address)

file_ = open('../OGLEngine/OGLEngine/OtherSources/IPAddress', 'w')
file_.write(address)
file_.close()
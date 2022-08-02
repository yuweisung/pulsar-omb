[zookeeper]
%{ for index,ip in zookeepers ~}
zookeeper-${index+1} ansible_host=${ip}
%{ endfor ~}
[bookie]
%{ for index,ip in bookies ~}
bookie-${index+1} ansible_host=${ip}
%{ endfor ~}
[broker]
%{ for index,ip in brokers ~}
broker-${index+1} ansible_host=${ip}
%{ endfor ~}
[proxy]
%{ for index,ip in proxy ~}
proxy-${index+1} ansible_host=${ip}
%{ endfor ~}
[client]
%{ for index,ip in client ~}
client-${index+1} ansible_host=${ip}
%{ endfor ~}
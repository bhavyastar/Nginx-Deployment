[public_hosts]
public_instance ansible_host=${public_ip} ansible_user=ec2-user

[private_hosts]
%{ for idx, ip in private_ips ~}
private_instance_${idx + 1} ansible_host=${ip} ansible_user=ec2-user landing_page_content="${idx == 0 ? "<html><head><title>Instance 1</title></head><body><h1>Welcome to Instance 1!</h1></body></html>" : "<html><head><title>Instance 2</title></head><body><h1>Welcome to Instance 2!</h1></body></html>"}"
%{ endfor ~}

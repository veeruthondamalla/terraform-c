resource "null_resource" "copyhtml" {
      count="${var.environment == "dev" ? 1 : 3}"

    connection {
    type = "ssh"
    host = aws_instance.public-instances[count.index].public_ip
    user = "ec2-user"
    private_key = file("cftemp_1.pem")
    }
  
#   provisioner "file" {
#     source      = "index.html"
#     destination = "/tmp/index.html"
#   }
 
  provisioner "file" {
    source      = "htd.sh"
    destination = "/tmp/htd.sh"
  }

# provisioner "remote-exec" {
#       inline = [
#       "sudo chmod 700 -R htd.sh",
#       "sudo sh htd.sh",
#     ]

  
# }

    provisioner "local-exec" {
        # command = "echo ${self.private_ip}, ${self.public_ip} >> local-exec.txt"
        command = "echo ${aws_instance.public-instances[count.index].public_ip}, ${aws_instance.public-instances[count.index].private_ip} >> local-exec.txt"

    }
  
  depends_on = [ aws_instance.public-instances ]
  
  }
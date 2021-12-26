resource "aws_instance" "public-instances" {
    # count="${var.environment == "dev" ? 1 : 3}"
    count=1
    #ami = var.imagename
    ami = "${lookup(var.amis,var.aws_region, "ap-south-1")}"
    #ami = "${data.aws_ami.my_ami.id}"
    # availability_zone = "us-east-1a"
    instance_type = "t2.micro"
    key_name = "cftemp_1"
    subnet_id = "${element(aws_subnet.public-subnets.*.id,count.index)}"
    vpc_security_group_ids = ["${aws_security_group.allow_http.id}"]
    associate_public_ip_address = true	
    provisioner "local-exec"{
       //command = "echo ${element(aws_subnet.public-subnets.*.id,count.index)} >> private_public.txt"
        command = "echo ${self.private_ip}>> somefile.txt"
    }



    user_data = <<EOF
                #!/bin/bash
                sudo yum update -y
                yum install httpd.x86_64 -y
                sudo service httpd start
            EOF

    tags = {
        Name = "Server-${count.index+1}"
    #     Env = "Prod"
    #     Owner = "Sree"
	# CostCenter = "ABCD"
    }


}


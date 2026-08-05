resource "aws_vpc" "shopsphere_vpc" {
    
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "shopsphere-vpc"
    }
  
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.shopsphere_vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
  tags = {
    Name = "shopsphere_public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.shopsphere_vpc.id
    cidr_block = "10.0.2.0/24"
    tags = {
      Name = "shopsphere_private_subnet"
    }
  
}

resource "aws_internet_gateway" "shopsphere_internet_gateway" {
    vpc_id = aws_vpc.shopsphere_vpc.id
    tags = {
        Name = "shopsphere_igw"
    }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.shopsphere_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.shopsphere_internet_gateway.id

    }
    tags = {
     Name =   "shopsphere_public_rt"
    }
}

resource "aws_route_table_association" "shopsphere_route_table_association" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
  
}

resource "aws_security_group" "shopsphere_sg" {
  vpc_id = aws_vpc.shopsphere_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "shopsphere_sg"
  }
}


resource "aws_key_pair" "shopsphere_key" {
    key_name = "shopsphere_key"
    public_key = file("C:/Users/Sheikh Aamir/.ssh/shopsphere-key.pub")

  
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_instance" "my_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "m7i-flex.large"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.shopsphere_sg.id]
  key_name               = "shopsphere_key"

 root_block_device {
  volume_size = 25
  volume_type = "gp3"
}

  tags = {
    Name = "shopsphere_server"
  }
}
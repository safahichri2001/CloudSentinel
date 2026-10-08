terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.16.0"
}

provider "aws" {
  region = "us-east-1"
}

# ============================================================
# CloudSentinel - VPC
# ============================================================

resource "aws_vpc" "cloudsentinel" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "cloudsentinel-vpc"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}

# ============================================================
# Public Subnets
# ============================================================

resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.cloudsentinel.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "cloudsentinel-public-1"
    Project     = "CloudSentinel"
    Environment = "lab"
    Tier        = "public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.cloudsentinel.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name        = "cloudsentinel-public-2"
    Project     = "CloudSentinel"
    Environment = "lab"
    Tier        = "public"
  }
}

# ============================================================
# Private Subnets
# ============================================================

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.cloudsentinel.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "cloudsentinel-private-1"
    Project     = "CloudSentinel"
    Environment = "lab"
    Tier        = "private"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.cloudsentinel.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name        = "cloudsentinel-private-2"
    Project     = "CloudSentinel"
    Environment = "lab"
    Tier        = "private"
  }
}

# ============================================================
# Internet Gateway
# ============================================================

resource "aws_internet_gateway" "cloudsentinel" {
  vpc_id = aws_vpc.cloudsentinel.id

  tags = {
    Name        = "cloudsentinel-igw"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}

# ============================================================
# Public Route Table
# ============================================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.cloudsentinel.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloudsentinel.id
  }

  tags = {
    Name        = "cloudsentinel-public-rt"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}

# ============================================================
# Public Route Table Associations
# ============================================================

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# ============================================================
# Private Route Table
# ============================================================

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.cloudsentinel.id

  tags = {
    Name        = "cloudsentinel-private-rt"
    Project     = "CloudSentinel"
    Environment = "lab"
  }
}

# ============================================================
# Private Route Table Associations
# ============================================================

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
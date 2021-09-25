terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.15.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "nodered_image" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
  count = 1
  length = 4
  special = false
  upper = false
}

#Start a container
resource "docker_container" "nodered_container" {
  count = 1
  name  = join("-", ["nodered", random_string.random[count.index].result])
  image = docker_image.nodered_image.latest
  ports {
    internal = 1880
    #external = 1880
  }
}


# resource "random_string" "random2" {
#   length = 5
#   special = false
#   upper = false
# }

# Start a container
# resource "docker_container" "nodered_container" {
#   name  = join("-", ["nodered", random_string.random.result])
#   image = docker_image.nodered_image.latest
#   ports {
#     internal = 1880
#     #external = 1880
#   }
# }

# resource "docker_container" "nodered_container2" {
#   name  = join("-", ["nodered2", random_string.random2.result])
#   image = docker_image.nodered_image.latest
#   ports {
#   internal = 1880
#   #external = 1880
#   }
# }

output "container-name" {
  value = docker_container.nodered_container[*].name
  description = "The name of the container"
}

output "IP-Address" {
  value = [for i in docker_container.nodered_container[*]: join(":", [i.ip_address],i.ports[*]["external"])]
  description = "The IP address and external port of the container"
}

# output "IP-Address-Of-Node01" {
#   value = join (":", [docker_container.nodered_container[0].ip_address, docker_container.nodered_container[0].ports[0].external])
#   description = "The IP address and external port of the container"
# }

# output "IP-Address-Of-Node02" {
#   value = join (":", [docker_container.nodered_container[1].ip_address, docker_container.nodered_container[0].ports[0].external])
#   description = "The IP address and external port of the container"
# }
# output "Container-Name-Of-Node02" {
#   value = docker_container.nodered_container[1].name
#   description = "The name of the container"
# }
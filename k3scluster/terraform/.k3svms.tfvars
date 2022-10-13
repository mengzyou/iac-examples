vms = [
  {
    name   = "control"
    cpu    = 1
    memory = 1024
    ip     = 10
    groups = ["k3s"]
    vars   = {
      role = "server"
    }
  },
  {
    name   = "worker1"
    cpu    = 1
    memory = 1024
    ip     = 21
    groups = ["k3s"]
    vars = {
      role = "agent"
    }
  },
  {
    name   = "worker2"
    cpu    = 1
    memory = 1024
    ip     = 22
    groups = ["k3s"]
    vars = {
      role = "agent"
    }
  }
]

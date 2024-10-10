locals{
  metadata = {
    user-data = <<-EOF
      #cloud-config
      users:
        - name: yeti
          groups: sudo
          shell: /bin/bash
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          ssh_authorized_keys:
            - ${file("~/.ssh/id_ed25519.pub")}
      EOF
  }
}
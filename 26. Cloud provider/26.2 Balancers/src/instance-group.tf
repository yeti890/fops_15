// Create Service Account
resource "yandex_iam_service_account" "sa-instance-group" {
    name                    = "sa-for-instance-group"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "instance-group-editor" {
    folder_id               = var.folder_id
    role                    = "editor"
    member                  = "serviceAccount:${yandex_iam_service_account.sa-instance-group.id}"
}

// Create instance group
resource "yandex_compute_instance_group" "instance-group" {
    name                    = "instance-group"
    folder_id               = var.folder_id
    service_account_id      = yandex_iam_service_account.sa-instance-group.id

    instance_template {
        resources {
            cores           = var.vm_resources.lamp.cores
            memory          = var.vm_resources.lamp.memory
            core_fraction   = var.vm_resources.lamp.core_fraction
        }
        boot_disk {
            initialize_params {
                image_id    = var.vm_resources.lamp.image_id
            }
        }
        network_interface {
            network_id      = yandex_vpc_network.develop.id
            subnet_ids      = [yandex_vpc_subnet.public_subnet.id]
            nat             = true
        }
        scheduling_policy {
            preemptible     = true
        }
        metadata = {
            ssh-keys        = "centos:${file("~/.ssh/id_ed25519.pub")}"
            user-data       = <<EOF
#!/bin/bash
apt install httpd -y
cd /var/www/html
echo '<html><img src="http://${yandex_storage_bucket.vologin-bucket.bucket_domain_name}/bucket_image.webp"/></html>' > index.html
service httpd start
EOF
      }
   }

    scale_policy {
        fixed_scale {
            size = 3
        }
    }

    allocation_policy {
        zones = [var.subnets.public.zone]
    }

    deploy_policy {
        max_unavailable  = 1
        max_creating     = 3
        max_expansion    = 1
        max_deleting     = 1
        startup_duration = 3
    }

     health_check {
        http_options {
            port    = 80
            path    = "/"
        }
    }

    depends_on = [
        yandex_storage_bucket.vologin-bucket
    ]

    load_balancer {
        target_group_name = "target-group"
    }
}
resource "google_compute_instance" "app" {
  count        = var.vm_count
  name         = "reddit-app${count.index + 1}-${trimspace(var.env)}"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["reddit-app-${trimspace(var.env)}"]

  # Определение загрузочного диска
  boot_disk {
    initialize_params {
      image = var.app_disk_image
      size  = 10
      type  = "pd-ssd"
    }
  }

  # Определение сетевого интерфейса
  network_interface {
    # Сеть, к которой присоединить данный интерфейс
    network = "default"
    access_config {}
  }

  connection {
    type  = "ssh"
    host  = self.network_interface[0].access_config[0].nat_ip
    user  = var.deploy_user
    agent = false
    # путь до приватного ключа
    private_key = file(var.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      var.enable_provision ? "cat /dev/null" : "echo Provision disabled!"
    ]
  }

  provisioner "remote-exec" {
    script = var.enable_provision ? "${path.module}/install_docker.sh" : null
  }

  provisioner "file" {
    content     = var.enable_provision ? file("${path.module}/deploy.sh") : "empty content"
    destination = var.enable_provision ? "/tmp/deploy.sh" : "/dev/null"
  }

  provisioner "remote-exec" {
    inline = [
      var.enable_provision ? "chmod +x /tmp/deploy.sh && /tmp/deploy.sh ${var.image_to_run} && rm -f /tmp/deploy.sh" : "cat /dev/null"
    ]
  }

  depends_on = [var.vm_depends_on]
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default-${trimspace(var.env)}"
  # Название сети, в которой действует правило
  network = "default"
  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }
  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]
  # Правило применимо для инстансов с перечисленными тэгами
  target_tags = ["reddit-app-${trimspace(var.env)}"]
}

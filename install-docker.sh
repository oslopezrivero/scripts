#!/bin/bash

# Actualizar la lista de paquetes e instalar los paquetes necesarios
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Crear el directorio para las llaves si no existe
sudo install -m 0755 -d /etc/apt/keyrings

# Descargar la llave GPG de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Agregar el repositorio de Docker a las fuentes de Apt
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Actualizar la lista de paquetes después de agregar el nuevo repositorio
sudo apt-get update

# Instalar Docker y sus componentes
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 1. Agregar al usuario actual al grupo Docker
sudo usermod -aG docker $USER
echo "Usuario $USER añadido al grupo docker. Es posible que necesites reiniciar la sesión para que los cambios surtan efecto."

# 2. Configurar la rotación de logs
sudo mkdir -p /etc/docker
echo '{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}' | sudo tee /etc/docker/daemon.json > /dev/null
echo "Rotación de logs configurada: tamaño máximo 10MB, hasta 3 archivos de logs."

# 3. Configurar Docker para iniciar al arrancar el sistema
sudo systemctl enable docker
echo "Docker configurado para iniciar automáticamente con el sistema."

# Reiniciar Docker para aplicar la configuración de logs
sudo systemctl restart docker
echo "Docker instalado y configurado exitosamente."

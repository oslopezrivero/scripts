#!/bin/bash

# Actualizar el sistema
echo "Actualizando el sistema..."
apt update && apt upgrade -y

# Instalación de paquetes requeridos
echo "Instalando paquetes necesarios..."
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Agregar la clave de GPG para Kubernetes
echo "Agregando clave de GPG de Kubernetes..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Agregar repositorio al Sourcelist
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Actualizar la lista de paquetes
echo "Actualizando lista de paquetes..."
apt update

# Instalar kubelet, kubeadm y kubectl
echo "Instalando kubelet, kubeadm y kubectl..."
apt install -y kubelet kubeadm kubectl

# Deshabilitar actualizaciones automáticas para estos paquetes
echo "Deshabilitando actualizaciones automáticas de kubelet, kubeadm y kubectl..."
apt-mark hold kubelet kubeadm kubectl

# Habilitar y arrancar kubelet
echo "Habilitando y arrancando kubelet..."
systemctl enable kubelet
systemctl start kubelet

# Verificar las versiones instaladas
echo "Verificando versiones instaladas..."
kubectl version --client && kubeadm version && kubelet --version

echo "¡Instalación completa!"

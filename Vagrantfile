Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "jenkins-vm"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = 2
  end

  config.vm.provision "shell", inline: <<-SHELL
    echo "[INFO] Actualizando sistema..."
    apt-get update -y
    apt-get upgrade -y

    echo "[INFO] Instalando Java 17, Git y Docker..."
    apt-get install -y openjdk-17-jdk git docker.io curl gnupg lsb-release software-properties-common apt-transport-https

    echo "[INFO] Agregando usuario vagrant al grupo docker..."
    usermod -aG docker vagrant

    echo "[INFO] Agregando clave GPG y repositorio de Jenkins..."
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

    echo "[INFO] Instalando Jenkins..."
    apt-get update -y
    apt-get install -y jenkins

    echo "[INFO] Habilitando y arrancando servicios..."
    systemctl enable docker
    systemctl start docker
    systemctl enable jenkins
    systemctl start jenkins

    echo "[INFO] Jenkins instalado y corriendo en http://localhost:8080"
  SHELL
end


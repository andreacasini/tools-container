FROM centos

RUN dnf update -y \
&& dnf install python3-pip -y \
&& dnf install vim nano curl git iproute wget libicu epel-release -y \
&& dnf install screen -y \
&& pip3 install --upgrade pip \
&& pip install --upgrade ansible \
&& pip install --upgrade pyvmomi \
&& pip install --upgrade pywinrm \
&& pip install --upgrade paramiko \
&& pip install --upgrade jmespath \
&& rpm -ivh https://github.com/PowerShell/PowerShell/releases/download/v6.2.6/powershell-6.2.6-1.rhel.7.x86_64.rpm \
&& pwsh -c 'Install-Module -Name VMware.PowerCLI -Scope AllUsers -SkipPublisherCheck -AcceptLicense -Force' \
&& pwsh -c 'Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false' \
&& dnf install sshpass -y \ 
&& yum clean all \
&& rm -rf /var/cache/yum \
&& curl -L https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip | gunzip > /usr/local/bin/terraform \
&& chmod +x /usr/local/bin/terraform \
&& curl -L https://github.com/vmware/govmomi/releases/download/v0.23.0/govc_linux_amd64.gz | gunzip > /usr/local/bin/govc \
&& chmod +x /usr/local/bin/govc \
&& curl -L https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-v0.15.4-x86_64-unknown-linux-gnu.tar.gz -o /tmp/bat.tar.gz \
&& tar xzvf /tmp/bat.tar.gz -C /tmp \
&& cp /tmp/bat-*/bat /usr/local/bin/ && rm -rf /tmp/bat* \
&& rm -f /root/anaconda* \
&& rm -f /root/original* \
&& echo "export PS1='\[\e[31;1m\]\u@\h: \[\033[01;34m\]\W # \[\033[00m\]'" >> ~/.bashrc \
&& echo "alias ls='ls --color'" >> ~/.bashrc \
&& echo "alias ll='ls -l'" >> ~/.bashrc \
&& echo "alias t='terraform'" >> ~/.bashrc \
&& echo "alias tv='terraform validate'" >> ~/.bashrc \
&& echo "alias ta='terraform apply -auto-approve'" >> ~/.bashrc \
&& echo "alias ta2='terraform apply -auto-approve -parallelism=2'" >> ~/.bashrc \
&& echo "alias tp='terraform plan | grep -E \"#\"'" >> ~/.bashrc \
&& echo "termcapinfo xterm* ti@:te@" >> ~/.screenrc \
&& echo "defscrollback 2000000" >> ~/.screenrc \
&& git config --global http.sslVerify false \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.18.4/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl-1-18-4 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.17.7/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl-1-17-7 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.16.11/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl-1-16-11 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.15.12/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl-1-15-12 \
&& chmod +x /usr/local/bin/kubectl-1* \
&& ln -s /usr/local/bin/kubectl-1-18-4 /usr/local/bin/kubectl \
&& echo "v1.1! > /root/version.txt

CMD [ "/bin/bash" ]

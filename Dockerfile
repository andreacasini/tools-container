FROM ubuntu

RUN apt-get update -y \
&& TZ="Europe/Rome" DEBIAN_FRONTEND="noninteractive" apt-get install tzdata -y \
&& apt-get install python3-pip -y \
&& apt-get install vim nano curl git wget -y \
&& apt-get install screen bash-completion ldap-utils neofetch tmux unzip liblttng-ust0 -y \
&& pip3 install --upgrade pip \
&& pip install --upgrade ansible \
&& pip install --upgrade pyvmomi \
&& pip install --upgrade pywinrm \
&& pip install --upgrade paramiko \
&& pip install --upgrade jmespath

RUN echo "setw -g mouse on" >> ~/.tmux.conf

RUN apt --fix-broken install -y

RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.1.3/powershell_7.1.3-1.ubuntu.20.04_amd64.deb -o /tmp/powershell.deb \
&& dpkg -i /tmp/powershell.deb \
&& pwsh -c 'Install-Module -Name VMware.PowerCLI -Scope AllUsers -SkipPublisherCheck -AcceptLicense -Force' \
&& pwsh -c 'Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false' \
&& apt install sshpass -y \
&& rm -f /tmp/powershell.deb

RUN apt autoremove --purge

RUN curl -L https://releases.hashicorp.com/terraform/0.15.0/terraform_0.15.0_linux_amd64.zip | gunzip > /usr/local/bin/terraform \
&& chmod +x /usr/local/bin/terraform

RUN curl -L https://github.com/vmware/govmomi/releases/download/v0.25.0/govc_Linux_x86_64.tar.gz -o /tmp/govc.tar.gz \
&& tar xzvf /tmp/govc.tar.gz -C /tmp \
&& cp /tmp/govc /usr/local/bin \
&& rm -rf /tmp/govc*

RUN curl -L https://github.com/sharkdp/bat/releases/download/v0.18.0/bat-v0.18.0-x86_64-unknown-linux-gnu.tar.gz -o /tmp/bat.tar.gz \
&& tar xzvf /tmp/bat.tar.gz -C /tmp \
&& cp /tmp/bat-*/bat /usr/local/bin/ && rm -rf /tmp/bat*

RUN echo "export PS1='\[\e[31;1m\]\u@\h: \[\033[01;34m\]\W # \[\033[00m\]'" >> ~/.bashrc \
&& echo "alias ls='ls --color'" >> ~/.bashrc \
&& echo "alias ll='ls -l'" >> ~/.bashrc \
&& echo "alias rm='rm -f'" >> ~/.bashrc \
&& echo "alias t='terraform'" >> ~/.bashrc \
&& echo "alias tv='terraform validate'" >> ~/.bashrc \
&& echo "alias ta='terraform apply -auto-approve'" >> ~/.bashrc \
&& echo "alias ta2='terraform apply -auto-approve -parallelism=2'" >> ~/.bashrc \
&& echo "alias tp='terraform plan | grep -E \"#\"'" >> ~/.bashrc \
&& echo "alias cat='bat -p'" >> ~/.bashrc \
&& echo "termcapinfo xterm* ti@:te@" >> ~/.screenrc \
&& echo "defscrollback 2000000" >> ~/.screenrc

RUN git config --global http.sslVerify false

RUN curl -L https://github.com/flavio/kuberlr/releases/download/v0.3.1/kuberlr_0.3.1_linux_amd64.tar.gz -o /tmp/kuberlr.tar.gz \
&& tar xzvf /tmp/kuberlr.tar.gz -C /tmp \
&& cp /tmp/kuberlr*/kuberlr /usr/local/bin/kuberlr \
&& rm -rf /tmp/kuberlr* \
&& mkdir -p ~/.kuberlr/linux-amd64 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubectl -o ~/.kuberlr/linux-amd64/kubectl-1.18.6 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.17.9/bin/linux/amd64/kubectl -o ~/.kuberlr/linux-amd64/kubectl-1.17.9 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.16.13/bin/linux/amd64/kubectl -o ~/.kuberlr/linux-amd64/kubectl-1.16.13 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.15.12/bin/linux/amd64/kubectl -o ~/.kuberlr/linux-amd64/kubectl-1.15.12 \
&& chmod +x ~/.kuberlr/linux-amd64/kubectl-1* \
&& ln -s /usr/local/bin/kuberlr /usr/local/bin/kubectl \
&& kubectl completion bash >/etc/bash_completion.d/kubectl \
&& echo "alias k='kubectl'" >> ~/.bashrc \
&& echo 'complete -F __start_kubectl k' >> ~/.bashrc

RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx \
&& ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx \
&& ln -s /opt/kubectx/kubens /usr/local/bin/kubens \
&& echo "alias kctx='kubectx'" >> ~/.bashrc \
&& echo "alias kns='kubens'" >> ~/.bashrc \
&& git clone --depth 1 https://github.com/junegunn/fzf.git /opt/fzf \
&& /opt/fzf/install --all

RUN curl -L https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz -o /tmp/helm.tar.gz \
&& tar xzvf /tmp/helm.tar.gz -C /tmp \
&& cp /tmp/linux-amd64/helm /usr/local/bin/ \
&& rm -rf /tmp/helm.tar.gz /tmp/linux-amd64

RUN curl -L https://github.com/andreazorzetto/yh/releases/download/v0.4.0/yh-linux-amd64.zip | gunzip > /usr/local/bin/yh \
&& chmod +x /usr/local/bin/yh

RUN git clone https://github.com/heptiolabs/ktx.git /tmp/ktx \
&& cp /tmp/ktx/ktx ~/.ktx \
&& cp /tmp/ktx/ktx-completion.sh ~/.ktx-completion.sh \
&& echo "source ~/.ktx" >> ~/.bashrc \
&& echo "source ~/.ktx-completion.sh" >> ~/.bashrc \
&& rm -rf /tmp/ktx

RUN echo "v2.0.0" > /root/version.txt

WORKDIR /root
CMD [ "/bin/bash" ]

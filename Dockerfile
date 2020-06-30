FROM centos

RUN dnf update -y \
&& dnf install python3-pip -y \
&& dnf install vim nano curl git iproute wget libicu epel-release -y \
&& dnf install screen bash-completion openldap-clients -y \
&& pip3 install --upgrade pip \
&& pip install --upgrade ansible \
&& pip install --upgrade pyvmomi \
&& pip install --upgrade pywinrm \
&& pip install --upgrade paramiko \
&& pip install --upgrade jmespath

RUN rpm -ivh https://github.com/PowerShell/PowerShell/releases/download/v6.2.6/powershell-6.2.6-1.rhel.7.x86_64.rpm \
&& pwsh -c 'Install-Module -Name VMware.PowerCLI -Scope AllUsers -SkipPublisherCheck -AcceptLicense -Force' \
&& pwsh -c 'Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false' \
&& dnf install sshpass -y

RUN yum clean all \
&& rm -rf /var/cache/yum

RUN curl -L https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip | gunzip > /usr/local/bin/terraform \
&& chmod +x /usr/local/bin/terraform

RUN curl -L https://github.com/vmware/govmomi/releases/download/v0.23.0/govc_linux_amd64.gz | gunzip > /usr/local/bin/govc \
&& chmod +x /usr/local/bin/govc

RUN curl -L https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-v0.15.4-x86_64-unknown-linux-gnu.tar.gz -o /tmp/bat.tar.gz \
&& tar xzvf /tmp/bat.tar.gz -C /tmp \
&& cp /tmp/bat-*/bat /usr/local/bin/ && rm -rf /tmp/bat*

RUN rm -f /root/anaconda* \
&& rm -f /root/original*

RUN echo "export PS1='\[\e[31;1m\]\u@\h: \[\033[01;34m\]\W # \[\033[00m\]'" >> ~/.bashrc \
&& echo "alias ls='ls --color'" >> ~/.bashrc \
&& echo "alias ll='ls -l'" >> ~/.bashrc \
&& echo "alias t='terraform'" >> ~/.bashrc \
&& echo "alias tv='terraform validate'" >> ~/.bashrc \
&& echo "alias ta='terraform apply -auto-approve'" >> ~/.bashrc \
&& echo "alias ta2='terraform apply -auto-approve -parallelism=2'" >> ~/.bashrc \
&& echo "alias tp='terraform plan | grep -E \"#\"'" >> ~/.bashrc \
&& echo "alias cat='bat -p'" \
&& echo "termcapinfo xterm* ti@:te@" >> ~/.screenrc \
&& echo "defscrollback 2000000" >> ~/.screenrc

RUN git config --global http.sslVerify false

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.18.5/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl-1-18-5 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.17.8/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl-1-17-8 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.16.12/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl-1-16-12 \
&& curl -L https://storage.googleapis.com/kubernetes-release/release/v1.15.12/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl-1-15-12 \
&& chmod +x /usr/local/bin/kubectl-1* \
&& ln -s /usr/local/bin/kubectl-1-18-5 /usr/local/bin/kubectl \
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

RUN curl -L https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz -o /tmp/helm.tar.gz \
&& tar xzvf /tmp/helm.tar.gz -C /tmp \
&& cp /tmp/linux-amd64/helm /usr/local/bin/ \
&& rm -rf /tmp/helm.tar.gz /tmp/linux-amd64 \
&& helm repo add stable https://kubernetes-charts.storage.googleapis.com/

RUN echo "v1.3.14" > /root/version.txt

WORKDIR /root
CMD [ "/bin/bash" ]

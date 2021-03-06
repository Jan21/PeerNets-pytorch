FROM floydhub/pytorch:1.0.0-gpu.cuda9cudnn7-py3.38 
MAINTAINER Taekmin Kim <tantara.tm@gmail.com>

ENV LC_ALL C
ENV APP_PATH /base

# for docker hub
COPY . $APP_PATH
# for docker hub
# RUN mkdir -p $APP_PATH

WORKDIR $APP_PATH

RUN wget -O models.tar.gz https://dl.dropbox.com/s/aopkbovd8e5meuc/models.tar.gz
RUN tar -xvzf models.tar.gz

RUN apt-get update
RUN apt-get install -y screen htop git vim

RUN pip install cython
RUN pip install pip --upgrade
RUN pip install cffi opencv-python scipy easydict matplotlib pyyaml tqdm==4.19.9
RUN pip install torchvision
RUN pip install torch-scatter torch-sparse torch-cluster torch-spline-conv torch-geometric
RUN pip install adversarial-robustness-toolbox

# ssh
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:pytorchkr' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

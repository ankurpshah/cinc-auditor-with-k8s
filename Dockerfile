FROM ruby:3.0

COPY .gemrc /root/.gemrc
COPY Gemfile /root/Gemfile

RUN wget http://downloads.cinc.sh/files/unstable/cinc-auditor/5.22.3/ubuntu/22.04/cinc-auditor_5.22.3-1_amd64.deb && \
    dpkg -i cinc-auditor_5.22.3-1_amd64.deb && \
    rm cinc-auditor_5.22.3-1_amd64.deb

RUN wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip && \
    unzip terraform_1.5.0_linux_amd64.zip && mv terraform /usr/local/bin/ && rm terraform_1.5.0_linux_amd64.zip

RUN gem install bundler --no-doc && cd /root && bundle install

ENTRYPOINT [ "bundle", "exec","kitchen" ]

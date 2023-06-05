FROM ubuntu:jammy

RUN apt update -y && apt install curl -y && \
    curl http://downloads.cinc.sh/files/unstable/cinc-auditor/5.22.3/ubuntu/22.04/cinc-auditor_5.22.3-1_amd64.deb -o ./cinc-auditor_5.22.3-1_amd64.deb && \
    dpkg -i cinc-auditor_5.22.3-1_amd64.deb && \
    rm cinc-auditor_5.22.3-1_amd64.deb

ENTRYPOINT [ "cinc-auditor" ]

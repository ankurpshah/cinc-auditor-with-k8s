title 'Check Required Deployment present'

control "bb-kubernetes-deploy-kronos-kube-system-coredns" do
  title 'Ensure coredns deployment exists'
  desc 'Ensure coredns deployment exists with required labels and metadata'
  impact 1.0

  tag k8s_type: 'deployment'
  tag k8s_deploy_name: 'coredns'
  tag k8s_ns_name: 'kube-system'

  describe "Namespace: kube-system, Deployment: coredns" do
      subject { k8s_deployment(name: 'coredns', namespace: 'kube-system') }
      it { should exist }
      it { should have_label('k8s-app','kube-dns') }
      it { should have_label('kubernetes.io/name','CoreDNS') }
      its('metadata') { should_not be_nil }
      its('annotations') { should_not be_empty }
  end

  describe k8sobjects(api: 'v1', type: 'pods', namespace: 'kube-system', labelSelector: 'k8s-app=kube-dns') do 
      it { should exist }
      its('count') { should eq 1 }
  end

  k8sobjects(api: 'v1', type: 'pods', namespace: 'kube-system', labelSelector: 'k8s-app=kube-dns').items.each do |pod|
      describe "#{pod.namespace}/#{pod.name} pod" do
          subject { k8s_pod(namespace: pod.namespace, name: pod.name) }
          it { should_not have_latest_container_tag }
          it { should be_running }
      end
      describe "#{pod.namespace}/#{pod.name} pod" do
          subject { k8s_container(namespace: pod.namespace, pod_name: pod.name, name: 'coredns') }
          it { should exist }
          its('image') { should eq 'rancher/mirrored-coredns-coredns:1.10.1' }
          its('args') { should eq %w[-conf /etc/coredns/Corefile] }
          its('command') { should be_nil }
          its('resources') { should include({ :requests => { :cpu => '100m', :memory => '70Mi' }}) }
          its('resources') { should include({ :limits => { :memory => '170Mi' }}) }
      end
  end
end

control "bb-kubernetes-deploy-kronos-kube-system-traefik" do
  title 'Ensure traefik deployment exists'
  desc 'Ensure traefik deployment exists with required labels and metadata'
  impact 1.0

  tag k8s_type: 'deployment'
  tag k8s_deploy_name: 'traefik'
  tag k8s_ns_name: 'kube-system'

  describe "Namespace: kube-system, Deployment: traefik" do
      subject { k8s_deployment(name: 'traefik', namespace: 'kube-system') }
      it { should exist }
      it { should have_label('app.kubernetes.io/instance', 'traefik-kube-system') }
      it { should have_label('app.kubernetes.io/name','traefik') }
      its('metadata') { should_not be_nil }
      its('annotations') { should_not be_empty }
  end

  describe k8sobjects(api: 'v1', type: 'pods', namespace: 'kube-system', labelSelector: 'svccontroller.k3s.cattle.io/svcname=traefik') do 
      it { should exist }
      its('count') { should eq 3 }
  end

  k8sobjects(api: 'v1', type: 'pods', namespace: 'kube-system', labelSelector: 'svccontroller.k3s.cattle.io/svcname=traefik').items.each do |pod|
      describe "#{pod.namespace}/#{pod.name} pod" do
          subject { k8s_pod(namespace: pod.namespace, name: pod.name) }
          it { should_not have_latest_container_tag }
          it { should be_running }
      end
      describe "#{pod.namespace}/#{pod.name}/lb-tcp-80 pod" do
          subject { k8s_container(namespace: pod.namespace, pod_name: pod.name, name: 'lb-tcp-80') }
          it { should exist }
          its('image') { should eq 'rancher/klipper-lb:v0.4.3' }
          its('imagePullPolicy') { should eq 'IfNotPresent' }
          its('args') { should be_nil }
          its('command') { should be_nil }
          its('resources') { should be {} }
      end
      describe "#{pod.namespace}/#{pod.name}/lb-tcp-443 pod" do
          subject { k8s_container(namespace: pod.namespace, pod_name: pod.name, name: 'lb-tcp-443') }
          it { should exist }
          its('image') { should eq 'rancher/klipper-lb:v0.4.3' }
          its('imagePullPolicy') { should eq 'IfNotPresent' }
          its('args') { should be_nil }
          its('command') { should be_nil }
          its('resources') { should be {} }
      end
  end
end

control "bb-kubernetes-deploy-kronos-kube-system-local-path-provisioner" do
  title 'Ensure local-path-provisioner deployment exists'
  desc 'Ensure local-path-provisioner deployment exists with required labels and metadata'
  impact 1.0

  tag k8s_type: 'deployment'
  tag k8s_deploy_name: 'local-path-provisioner'
  tag k8s_ns_name: 'kube-system'

  describe "Namespace: kube-system, Deployment: local-path-provisioner" do
      subject { k8s_deployment(name: 'local-path-provisioner', namespace: 'kube-system') }
      it { should exist }
      its('metadata') { should_not be_nil }
      its('annotations') { should_not be_empty }
  end
end

control "bb-kubernetes-deploy-kronos-kube-system-metrics-server" do
  title 'Ensure metrics-server deployment exists'
  desc 'Ensure metrics-server deployment exists with required labels and metadata'
  impact 1.0

  tag k8s_type: 'deployment'
  tag k8s_deploy_name: 'metrics-server'
  tag k8s_ns_name: 'kube-system'

  describe "Namespace: kube-system, Deployment: metrics-server" do
      subject { k8s_deployment(name: 'metrics-server', namespace: 'kube-system') }
      it { should exist }
      it { should have_label('k8s-app','metrics-server') }
      its('metadata') { should_not be_nil }
      its('annotations') { should_not be_empty }
  end
end

control "bb-kubernetes-deploy-kronos-default-nginx-deployment" do
  title 'Ensure nginx-deployment deployment exists'
  desc 'Ensure nginx-deployment deployment exists with required labels and metadata'
  impact 1.0

  tag k8s_type: 'deployment'
  tag k8s_deploy_name: 'nginx-deployment'
  tag k8s_ns_name: 'default'

  describe "Namespace: default, Deployment: nginx-deployment" do
      subject { k8s_deployment(name: 'nginx-deployment') }
      it { should exist }
      it { should have_label('app','web') }
      its('metadata') { should_not be_nil }
      its('annotations') { should_not be_empty }
  end

  describe k8sobjects(api: 'v1', type: 'pods', namespace: 'default', labelSelector: 'app=web') do 
      it { should exist }
      its('count') { should eq 2 }
  end

  k8sobjects(api: 'v1', type: 'pods', namespace: 'default', labelSelector: 'app=web').items.each do |pod|
      describe "#{pod.namespace}/#{pod.name} pod" do
          subject { k8s_pod(namespace: pod.namespace, name: pod.name) }
          it { should have_latest_container_tag }
          it { should be_running }
      end
      describe "#{pod.namespace}/#{pod.name} pod" do
          subject { k8s_container(namespace: pod.namespace, pod_name: pod.name, name: 'nginx') }
          it { should exist }
          its('image') { should eq 'nginx:latest' }
          its('args') { should be_nil }
          its('command') { should be_nil }
      end
  end
end

control "bb-kubernetes-deploy-kronos-default-nginx-deployment1" do
  title 'Ensure nginx-deployment1 deployment exists'
  desc 'Ensure nginx-deployment1 deployment exists with required labels and metadata'
  impact 1.0

  tag k8s_type: 'deployment'
  tag k8s_deploy_name: 'nginx-deployment1'
  tag k8s_ns_name: 'default'

  describe "Namespace: default, Deployment: nginx-deployment1" do
      subject { k8s_deployment(name: 'nginx-deployment1') }
      it { should exist }
      it { should have_label('app','web1') }
      its('metadata') { should_not be_nil }
      its('annotations') { should_not be_empty }
  end

  describe k8sobjects(api: 'v1', type: 'pods', namespace: 'default', labelSelector: 'app=web1') do 
      it { should exist }
      its('count') { should eq 3 }
  end

  k8sobjects(api: 'v1', type: 'pods', namespace: 'default', labelSelector: 'app=web1').items.each do |pod|
      describe "#{pod.namespace}/#{pod.name} pod" do
          subject { k8s_pod(namespace: pod.namespace, name: pod.name) }
          it { should have_latest_container_tag }
          it { should be_running }
      end
      describe "#{pod.namespace}/#{pod.name} pod" do
          subject { k8s_container(namespace: pod.namespace, pod_name: pod.name, name: 'nginx1') }
          it { should exist }
          its('image') { should eq 'nginx:latest' }
          its('args') { should be_nil }
          its('command') { should be_nil }
      end
  end
end
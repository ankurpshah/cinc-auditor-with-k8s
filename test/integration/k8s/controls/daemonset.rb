title 'Check Required Daemonset present'

control "bb-kubernetes-ds-kronos-kube-system-svclb-traefik" do
    title 'Ensure svclb-traefik daemonset exists'
    desc 'Ensure svclb-traefik daemonset exists with required labels and metadata'
    impact 1.0
  
    tag k8s_type: 'daemonset'
    tag k8s_ds_name: 'svclb-traefik'
    tag k8s_ns_name: 'kube-system'
  
    describe "Namespace: kube-system, Deployment: traefik" do
        subject { k8s_daemon_set(name: 'svclb-traefik-374894d1', namespace: 'kube-system') }
        it { should exist }
        it { should have_label('svccontroller.k3s.cattle.io/nodeselector','false') }
        it { should have_label('svccontroller.k3s.cattle.io/svcname', 'traefik') }
        it { should have_label('svccontroller.k3s.cattle.io/svcnamespace','kube-system') }
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
  
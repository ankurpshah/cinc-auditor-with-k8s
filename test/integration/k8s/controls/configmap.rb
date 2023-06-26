title 'Check Required ConfigMap present'

control "bb-kubernetes-cm-kronos-kube-system-extension-apiserver-authentication" do
  title 'Ensure extension-apiserver-authentication deployment exists'
  desc 'Ensure extension-apiserver-authentication deployment exists with required labels and metadata'
  impact 1.0

  tag k8s_type: 'configmap'
  tag k8s_deploy_name: 'extension-apiserver-authentication'
  tag k8s_ns_name: 'kube-system'

    describe k8s_config_map(namespace: 'kube-system', name: 'extension-apiserver-authentication') do
        it { should exist }
        its('data') { should_not be_empty }
    end
end

control "bb-kubernetes-cm-kronos-kube-system-cluster-dns" do
    title 'Ensure cluster-dns deployment exists'
    desc 'Ensure cluster-dns deployment exists with required labels and metadata'
    impact 1.0
  
    tag k8s_type: 'configmap'
    tag k8s_deploy_name: 'cluster-dns'
    tag k8s_ns_name: 'kube-system'
  
    describe k8s_config_map(namespace: 'kube-system', name: 'cluster-dns') do
        it { should exist }
        its('data') { should eq ({ :clusterDNS => '10.43.0.10', :clusterDomain => 'cluster.local' }) }
    end
end

control "bb-kubernetes-cm-kronos-kube-system-local-path-config" do
    title 'Ensure local-path-config deployment exists'
    desc 'Ensure local-path-config deployment exists with required labels and metadata'
    impact 1.0
  
    tag k8s_type: 'configmap'
    tag k8s_deploy_name: 'local-path-config'
    tag k8s_ns_name: 'kube-system'
  
    describe k8s_config_map(namespace: 'kube-system', name: 'local-path-config') do
        it { should exist }
        its('data') { should have_key(:"config.json") }
        its('data') { should have_key(:"helperPod.yaml") }
        its('data') { should have_key(:setup) }
        its('data') { should have_key(:teardown) }
    end
end
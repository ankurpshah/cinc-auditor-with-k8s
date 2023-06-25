title 'Check Required Namespace present'

namespaces = ['default', 'kube-system', 'kube-public', 'kube-node-lease']

namespaces.each do |ns|
    control "bb-kubernetes-namespace-kronos-#{ns}" do
        title 'Ensure namespace exists'
        desc 'Ensure namespace exists with required labels and metadata'
        impact 1.0

        tag k8s_type: 'namespace'
        tag k8s_ns_name: ns

        describe "Namespace: #{ns}" do
            subject { k8s_namespace(name: ns) }
            it { should exist }
            its('labels') { should eq 'kubernetes.io/metadata.name': ns }
            its('metadata') { should_not be_nil }
        end
    end
end

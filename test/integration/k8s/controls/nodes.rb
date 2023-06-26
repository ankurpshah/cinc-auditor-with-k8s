title 'Check Required Nodes present'

control "bb-kubernetes-node-kronos-k3d-devcluster-agent" do
    title 'Ensure k3d-devcluster-agent node exists'
    desc 'Ensure k3d-devcluster-agent node exists with required labels and metadata'
    impact 1.0

    tag k8s_type: 'node'
    tag k8s_node_name: 'k3d-devcluster-agent'

    k8sobjects(type: 'nodes', labelSelector: 'node.kubernetes.io/instance-type=k3s').items.each do |node|
        describe "Node: #{node.name}" do
            subject { k8s_node(name: node.name) }
            it { should exist }
            it { should have_label('beta.kubernetes.io/arch', 'amd64') }
            it { should have_label('beta.kubernetes.io/instance-type', 'k3s') }
            it { should have_label('beta.kubernetes.io/os', 'linux') }
            it { should have_label('kubernetes.io/arch', 'amd64') }
            it { should have_label('kubernetes.io/os', 'linux') }
            it { should have_label('node.kubernetes.io/instance-type', 'k3s') }
        end
    end
end

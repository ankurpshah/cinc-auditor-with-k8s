describe k8s_deployment(name: 'nginx-deployment') do
    it { should exist }
    its('labels') { should eq :app=>'web' }
    its('annotations') { should_not be_empty }
    its('namespace') { should eq 'default' }
    its('kind') { should eq 'Deployment' }
    its('metadata') { should_not be_nil }
  end
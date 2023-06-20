describe aws_security_group(group_name: 'prod_sg') do
    it { should exist }
    its('description') { eq 'prod_sg' }
    it { should allow_in_only(ipv4_range: '1.1.1.1/32', port: 22, protocol: 'tcp') }
    it { should allow_out_only(ipv4_range: '0.0.0.0/0', protocol: 'all') }
end
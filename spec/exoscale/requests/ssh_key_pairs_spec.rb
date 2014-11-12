# encoding: UTF-8

require "minitest/autorun"
require "fog/exoscale"

describe Fog::Compute::Exoscale do
  before do
    @config = {
      :exoscale_api_key           => ENV["EXO_API_KEY"],
      :exoscale_secret_access_key => ENV["EXO_SECRET_KEY"]
    }

    @client = Fog::Compute::Exoscale.new(@config)
    @current_amount_of_key_pairs = @client.list_ssh_key_pairs['listsshkeypairsresponse']['count']
  end
  
  describe "when creating a new keypair" do
    before do
      @new_keypair = @client.create_ssh_key_pair(:name => "fog_test_keypair_#{Random.new.rand(1..2000)}")['createsshkeypairresponse']['keypair']
    end
  
    it "must have one more keypair" do
      @client.list_ssh_key_pairs['listsshkeypairsresponse']['count'].must_equal @current_amount_of_key_pairs + 1
    end
    
    it "must list the new keypair" do
      @client.list_ssh_key_pairs(:name => @new_keypair['name'])['listsshkeypairsresponse']['sshkeypair'][0]['fingerprint'].must_equal @new_keypair['fingerprint']
    end
    
    after do
      @client.delete_ssh_key_pair(:name => @new_keypair['name'])
    end
  end
  
  describe "when registering an existing keypair" do
    before do 
      public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCkjKmD6MIog9vVOPuBqONFzKD7GfZSlpWkyVbDI5QrkCFabn0r4h4k6/zavq+u2F4n/+o5WMMgP/r7PPZOYeVqIcCWYD1EuC2uuv2L/CIUH/teKm1AOKzYANWugQzBi+UVWlpittFW+mqR6/M85Cyx6Hw/vAr2ZbF1pn9NpNIoToW8J5mQT7ibBhPhzvflOdCKyDmvuY8CFCZwqcV+uDL+zZ3Qs9zleEEuPWMJKJyWTqWeQL+9g/8mA4xuJv5ObvDQlLKrOU+aPKRCtyluja99elZkHkE5vHjlVC1RgMyCkIkcp0DyBJLHfQ89qfAbv29E9l9p/+lxW4/v873g6w8x"
      private_key = "-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEApIypg+jCKIPb1Tj7gajjRcyg+xn2UpaVpMlWwyOUK5AhWm59
K+IeJOv82r6vrtheJ//qOVjDID/6+zz2TmHlaiHAlmA9RLgtrrr9i/wiFB/7Xipt
QDis2ADVroEMwYvlFVpaYrbRVvpqkevzPOQsseh8P7wK9mWxdaZ/TaTSKE6FvCeZ
kE+4mwYT4c735TnQisg5r7mPAhQmcKnFfrgy/s2d0LPc5XhBLj1jCSiclk6lnkC/
vYP/JgOMbib+Tm7w0JSyqzlPmjykQrcpbo2vfXpWZB5BObx45VQtUYDMgpCJHKdA
8gSSx30PPanwG79vRPZfaf/pcVuP7/O94OsPMQIDAQABAoIBAB/U7j4MWvMHfxFi
cpUEnOK10TaCMTqM0uoL4PLjARjkSu95jFFe7sHpvQJ7/PRv+tb2FNN/LlAg0Gal
xmgnXAAKA32TpIaUspGorr/TyKvn+/KddoED9bvbfXrCkDso2uokjnOmNh0DWHZe
FLHk2hiYhuC1edFsnsXJrbrRda5CIwDdbK86MEX5YcC2E6CN38ZglEFDRsrtIrC2
o7NPD7gm4gaUIbsUtrWBCV6J5NSMAMpDjtavKI31SniCfux06a9amJF90ONsQnQA
9BuzXobGkjt8vdS22Q9sVozjiUlGBM6KaEi+xznLxAw+Sl0Ay+24Z0qULvAxCgOB
D3Qel6ECgYEA0tWFdzhLn68MgMV30+WA3wc2hONZyAXa7REJtqsVORvxoxTvmV/t
xK3dJCrPCv2mxDrx4YXbtaqLlpTwD66KGHiTFGAMNa4P5VZsPyFVd/1T9vbcV38Z
6i75MBqrvQJbbkx+AW6wQc02dhGaG7+2n8EhW2LvaACs0aHS9Pp4RyUCgYEAx8zR
mHTfo81evpAgnTjBievqqVUL0OAd+NdroUNyc/xUfAQ2ygTyR6IaPapjrX5O2FYY
XdQwevi+6HHZnTB5qSDgD16iSmZbOzj0h5ZysIgAtrKJz9px0ULd4I53PitfbS/j
pfI+yq+qMNE6tMCcHbCSZowFsTU8h9r4DrOvAB0CgYEApkMgB05rxLekooAW6RFZ
uYfUpKMtkCGd7cm74UO1bt3shnDiKg+OT8XUWMsxjzdMpf7d9L088FxXzB4T2ioI
WRfs1OqRdluXyYGHx5kf74nlByLRzGY9J4J3nEnMGTecprTHwZVqhdmxExb6ctuS
xxTkm07AAUJXBtIYrHxBEckCgYEAxKULrNdqvRcGJtxHnTYdFhfBr8Nqi7vpA99R
qThuz0UMCbtECXTw2BvtY7/ttvXXuAiUltSemolzq+dR3Om29ATNQZNMe5leNV2L
Hl+upZxVx3rVNGO1HdaH9dmB9whNNXOqxMs1jdtyz/U9qGThwj7k+FTbzVuuJbAX
8LBcjukCgYAFTuxwedfCsqrFPB7JR99W3RLKdguelem9qYmo7J1mKAlBvob5Sdj2
YyF8LyvCKFTDbE/yerkZe/5FQzjo8K+5mqyW3YqCI6vOTSw4S3r+zLBXNiaqTPfF
HV8gl2NTLZ10S1UWcC+Sn3ViOBjqVN5vNAcxK1BjKR8SDDCOlUmhAg==
-----END RSA PRIVATE KEY-----"
      
      @existing_key_pair = { "publickey" => public_key,
                             "name"       => "fog_test_keypair_#{Random.new.rand(1..2000)}"}
    end
    
    it "must register an existing key" do
      @client.register_ssh_key_pair(:name => @existing_key_pair['name'], :publickey => @existing_key_pair['publickey'])['registersshkeypairresponse']['keypair']['fingerprint'].must_equal @client.list_ssh_key_pairs['listsshkeypairsresponse']['sshkeypair'].select{|k| k['name']==@existing_key_pair['name']}[0]['fingerprint']
    end
    
    after do
      @client.delete_ssh_key_pair(:name => @existing_key_pair['name'])
    end
  end
end

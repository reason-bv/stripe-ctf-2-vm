Veewee::Session.declare({
  :cpu_count => '1',
  :memory_size => '1024',
  :disk_size => '65536',
  :disk_format => 'VDI',
  :hostiocache => 'off',
  :os_type_id => 'Ubuntu_64',
  :iso_file => "ubuntu-14.04.3-server-amd64.iso",
  :iso_src => "http://releases.ubuntu.com/14.04/ubuntu-14.04.3-server-amd64.iso",
  :iso_md5 => "01545fa976c8367b4f0d59169ac4866c",
  :iso_download_timeout => "1000",
  :boot_wait => "4",
  :boot_cmd_sequence => [
    '<Esc><Esc><Enter>',
    '/install/vmlinuz noapic preseed/url=http://%IP%:%PORT%/preseed.cfg ',
    'debian-installer=en_US auto locale=en_US kbd-chooser/method=us ',
    'hostname=%NAME% ',
    'fb=false debconf/frontend=noninteractive ',
    'keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=us keyboard-configuration/variant=us console-setup/ask_detect=false ',
    'initrd=/install/initrd.gz -- <Enter>'
],
  :kickstart_port => "7122",
  :kickstart_timeout => "300",
  :kickstart_file => "preseed.cfg",
  :ssh_login_timeout => "10000",
  :ssh_user => 'WILL BE REPLACED',
  :ssh_password => 'WILL BE REPLACED',
  :ssh_key => "",
  :ssh_host_port => "WILL BE REPLACED",
  :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -H -S bash '%f'",
  :shutdown_cmd => "shutdown -P now",
  :postinstall_files => [
    "provision.sh",
    "cleanup.sh"
  ],
  :postinstall_timeout => "10000"
})

Veewee::Definition.declare({
  :hooks => {
    # This runs before the postinstall_files scripts.
    :before_postinstall => Proc.new {
      # The PATH environment variable has the path of the definition directory
      # in it at this point, which is convenient.

      # Copy over the levels.
      definition.box.scp(path + '/levels.zip', '/tmp/levels.zip')
      # Copy the configuration for provisioning.
      definition.box.scp(path + '/environment.sh', '/tmp/environment.sh')
      # Copy the scripts to be used by the CTF user.
      definition.box.scp(path + '/ctf-check-pass', '/tmp/ctf-check-pass');
      definition.box.scp(path + '/ctf-check-unlocked', '/tmp/ctf-check-unlocked');
      definition.box.scp(path + '/ctf-halt', '/tmp/ctf-halt');
      definition.box.scp(path + '/ctf-run', '/tmp/ctf-run');
      definition.box.scp(path + '/ctf-unlock', '/tmp/ctf-unlock');
      definition.box.scp(path + '/ctf-unlocker', '/tmp/ctf-unlocker');
      # Copy the SSH public key.
      definition.box.scp(path + '/id_rsa.pub', '/tmp/id_rsa.pub');
    }
  }
})

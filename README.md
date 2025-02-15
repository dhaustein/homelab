# Setup

1. Clone this repo

2. Create a virtual environment and install dependencies

```
$ python3 -m venv .venv
$ source .venv/bin/activate
$ pip install --upgrade pip setuptools
$ pip install -r requirements.txt
$ ansible-galaxy collection install community.general
```

3. Create an SSH key for the ansible user

4. Configure the SSH connection

Example of the SSH config:
```
$ cat ~/.ssh/config
Host server
  HostName 192.168.xxx.xxx
  User ansible
  Preferredauthentications publickey
  IdentityFile /home/<username>/.ssh/id_ed25519
```

_The inventory file is hardcoded to use the name `server`_

5. Export ansible user sudo pass

```
export ANSIBLE_BECOME_PASS=<secret>
```
_Tip: install and use `direnv` to not have to manually export the env var every time._

6. Run the playbook

Example on how to run the media containers roles only:
```
$ ansible-playbook -v --tags "containers,containers_media" homelab.yml
```

# TODOs

## General

- consider switching to `uv` for package management

## Maintenance role

- move dnf update to maintenance role
- add snapshots subvolume on /volumes/snapshots
- mount snapshots as /mnt/snapshots (if needed)
- add periodic (monthly) TRIM systemd unit
- add on-demand scrubbing
- add on-demand filesystem healtcheck

```
btrfs device stats
btrfs fi usage -T /mnt/media/
btrfs fi df /mnt/media/
```

## Networking role

- setup firewall
- check DNS settings

## Performance role

- install autocpufreq or tweak governor
- later on check writes on drives with `iotop`
- check swap, swappines, consider zram

## Vars todos

- move `/mnt/podman` to vars (might require templating container and conf files)
- move `/mnt/podman/containers/` to vars

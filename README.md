# Personal Assistant

Self-hosted AI assistant stack (Hermes agent + Executor MCP gateway) with an Ansible provisioning playbook for the VPS it runs on.

# How-To:

## Deploy to a fresh VPS

```
cd ansible
ansible-galaxy collection install ansible.posix community.general
cp example.inventory.yml inventory.yml   # fill in
make run                                 # or: make dry-run to preview
```

- Fill `ansible/inventory.yml` (from `example.inventory.yml`) with the VPS IP and SSH key.
- Secrets go in `ansible/vars/secrets.yml` (from `example.secrets.yml`; encrypt with `ansible-vault`)
- Docker must already be installed on the target - the playbook fails if it is not
- The playbook clones this repo to `~/hermes-agent/stack`, templates `.env` (chmod 600), and brings up the stack
- User must exist and own the deploy paths: run as that `ansible_user`

## After deploy

```
make hermes-setup                       # LLM provider + Telegram channel
```

(`docker exec -it hermes hermes setup`)

Wire hermes to executor's MCP endpoint in hermes config:
`http://executor:4788/mcp` (compose-internal DNS, loopback-only).

Executor UI via SSH tunnel:
```
ssh -L 4788:127.0.0.1:4788 <vps>   # then open http://localhost:4788
```

## Backups

`restic` snapshots the data dir to a Cloudflare R2 bucket.
The `backup` role schedules a daily backup + prune and a weekly `restic check`.

```
make backup-now          # run backup + prune now
make backup-snapshots    # list snapshots
make backup-check        # verify repo integrity
make backup-stats        # repo size
make backup-log          # tail backup log
```

## Local run

```
cp ansible/templates/env.j2 .env   # fill in
docker compose up -d
```

Root `Makefile` covers everyday stack ops.

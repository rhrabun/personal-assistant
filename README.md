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

- Fill `ansible/inventory.yml` (from `example.inventory.yml`) first: VPS IP, SSH key, and env secrets (`telegram_bot_token`, `llm_api_key`, `better_auth_secret`, `executor_*`)
- Docker must already be installed on the target - the playbook fails if it is not
- The playbook clones this repo to `~/hermes-agent/stack`, templates `.env` (chmod 600), and brings up the stack
- User must exist and own the deploy paths: run as that `ansible_user`

## After deploy

```
make setup                              # LLM provider + Telegram channel
```

(`docker exec -it hermes hermes setup`)

Wire hermes to executor's MCP endpoint in hermes config:
`http://executor:4788/mcp` (compose-internal DNS, loopback-only).

Executor UI via SSH tunnel:
```
ssh -L 4788:127.0.0.1:4788 <vps>   # then open http://localhost:4788
```

## Local run

```
cp ansible/templates/env.j2 .env   # fill in
docker compose up -d
```

Root `Makefile` covers everyday stack ops (`make up`, `setup`, `status`, `logs`, `executor-logs`, ...).
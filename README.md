# Personal Assistant

Self-hosted AI assistant stack (Hermes agent + Executor MCP gateway) with an Ansible provisioning playbook for the VPS it runs on.

# How-To:

## Deploy to a fresh VPS

```
cd ansible
ansible-galaxy collection install ansible.posix community.general
ansible-playbook -i inventory.yml deploy.yml
```

- Fill `ansible/inventory.yml` first: VPS IP, `deploy_ssh_key`, and env secrets (`telegram_bot_token`, `llm_api_key`, `better_auth_secret`)
- The playbook hardens SSH, installs Docker, clones this repo to `/opt/stack`, and runs the stack
- Heres user must exist: first run as root, then switch `ansible_user` to it

## After deploy

```
docker exec -it hermes hermes setup      # LLM provider + Telegram channel
```

Wire hermes to executor's MCP endpoint in hermes config:
`http://executor:4788/mcp` (compose-internal DNS, loopback-only).

Executor UI via SSH tunnel:
```
ssh -L 4788:127.0.0.1:4788 <vps>   # then open http://localhost:4788
```

## Local run

```
cp .env.example .env   # fill in
docker compose up -d
```
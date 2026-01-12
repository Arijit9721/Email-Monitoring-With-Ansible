# Role Name

A brief description of the role goes here.

## Requirements

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

## Role Variables

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

## Dependencies

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

## License

BSD

## Author Information

An optional section for the role authors to include contact information, or a website (HTML is not allowed).

## Interview Questions

### 1. Security

**Q:** Why do we create a specific `node_exporter` system user with `/sbin/nologin`?
**A:** Running the exporter as root would be a security risk. If the process were compromised, the attacker would have root access. By creating a dedicated system user with no shell access, we follow the **Principle of Least Privilege**.

### 2. Service Management

**Q:** What happens if the Node Exporter process crashes?
**A:** In the `exporter.service.j2` template, we set `Restart=on-failure` (or `always`). This instructs the Systemd init system to automatically detect the crash and restart the process, ensuring high availability of metrics without human intervention.

### 3. Verification

**Q:** How does the playbook confirm that Node Exporter is actually correctly installed and running?
**A:** It uses the `uri` module to check `http://localhost:9100/metrics`. This endpoint is where Node Exporter exposes its data. If this returns a HTTP 200 OK status, we know the application is up, binding to the port correctly, and able to serve requests.

### 4. Restart Policies

**Q:** Why use `Restart=on-failure` here instead of `always`?
**A:** While `always` is also fine, `on-failure` is specifically chosen to restart the service _only_ if it crashes (exit code != 0). If an administrator manually stops the service (clean exit code 0), Systemd will respect that and _not_ restart it. This can be useful for maintenance, whereas `always` is more aggressive.

### 5. Architecture

**Q:** Why doesn't Node Exporter need a `/data` directory or a config file like Prometheus?
**A:**

- **Stateless:** Node Exporter is **stateless**. It doesn't store any data; it simply reads the kernel metrics (from `/proc` and `/sys`) in real-time when Prometheus scrapes it. Therefore, no data directory is needed.
- **Simple Config:** It is designed to be simple and "zero-config" for basic usage. Most of its behavior is controlled via CLI flags (like `--web.listen-address`) rather than a complex configuration file.

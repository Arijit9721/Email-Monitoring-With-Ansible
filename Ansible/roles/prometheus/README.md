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

### 1. Installation Method

**Q:** Why do we install Prometheus using a specific binary tarball instead of `apt install prometheus`?
**A:** The default OS repositories often contain outdated versions of Prometheus. Downloading the binary directly from GitHub allows us to install a specific, recent version (controlled by the `{{ version }}` variable) to ensure we have the latest features and security patches.

### 2. Service Configuration

**Q:** Since we are downloading a raw binary, how does the system know how to run it as a service?
**A:** We manually create a **Systemd Unit File** using a Jinja2 template (`prometheus.service.j2`). This file tells systemd:

- Which user to run as (`User={{ userId }}`).
- Where the binary is located (`ExecStart`).
- To restart automatically on failure (`Restart=always`).

### 3. Templating

**Q:** Why is the configuration file `prometheus.conf` generated from a `.j2` template?
**A:** This allows us to inject **Ansible Inventory** data dynamically. We use a Jinja2 loop (`{% for host in groups['env_dev'] %}`) to automatically discover and add all other servers in the environment as scrape targets. A static file wouldn't be able to adapt to new servers being added to the inventory.

### 4. Application Architecture

**Q:** Why do we separate the configuration into `/etc/prometheus` and the data into `/data/prometheus`?
**A:** This follows standard Linux conventions (Filesystem Hierarchy Standard):

- `/etc/`: Is for **configuration files** that are read-only for the application and managed by admins/Ansible.
- `/data/` (or `/var/lib/`): Is for **variable data** (the Time Series Database) which grows over time and needs to be writable by the `prometheus` user. Keeping them separate makes backups and upgrades easier.

### 5. Alerting

**Q:** Why do we have a separate `alert.rules.yaml` file?
**A:** Prometheus allows including external rule files. Separating the _rules_ (logic for when to fire an alert) from the main _configuration_ (scraping targets, ports) is a best practice for maintainability. It allows us to update alert logic without touching the core infrastructure config.

### 6. Resilience

**Q:** Why is the service set to `Restart=always`?
**A:** Prometheus is a critical infrastructure component. If it stops, we lose monitoring visibility. `Restart=always` ensures that Systemd attempts to restart the service no matter how it stopped (crash, OOM kill, or clean exit), ensuring maximum uptime.

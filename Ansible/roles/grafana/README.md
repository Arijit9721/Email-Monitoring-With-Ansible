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

### 1. Installation Strategy

**Q:** Why do we install Grafana using the APT repository method instead of downloading a binary tarball like we did for Prometheus?
**A:**

- **Complexity:** Grafana has many external dependencies (like font libraries) and a complex directory structure for static assets (JavaScript/CSS). The APT package handles all of this automatically.
- **Maintenance:** Using the official repository (`apt_repository`) ensures we can easily update to the latest stable version with standard system tools (`apt update`), avoiding "Dependency Hell."

### 2. User Management

**Q:** We didn't create a `grafana` user or group in the Ansible tasks. How does the service run safely?
**A:** The `grafana` APT package includes **post-installation scripts** that automatically create the `grafana` user and group during installation. It also sets up correctly owned directories (`/var/lib/grafana`), so we don't have to write those tasks manually.

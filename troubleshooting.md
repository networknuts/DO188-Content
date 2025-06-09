# Podman Troubleshooting Guide

A concise reference for diagnosing and resolving common issues encountered when working with Podman containers.

---

## Prerequisites

* Ensure Podman is installed (check with `podman --version`).
* Confirm you have the necessary permissions (root or rootless mode).
* Verify network connectivity if pulling images from remote registries.

---

## 1. Container Creation Issues

### Symptom: Image Pull Failure

* **Error**: `error pulling image "<image>" ...` or timeout.
* **Possible Causes**:

  * Incorrect image name or tag.
  * Registry requires authentication.
  * Network connectivity or firewall restrictions.
* **Resolution**:

  1. Validate the image name (`docker.io/library/nginx:latest`).
  2. Log in to the registry: `podman login registry.example.com`.
  3. Test network: `ping registry.example.com` or `curl`.

### Symptom: Permission Denied or Unprivileged User Errors

* **Error**: `permission denied`, `cannot allocate namespace "user"`.
* **Possible Causes**:

  * Trying to run privileged operations in rootless mode.
  * SELinux policies enforcing restrictions.
* **Resolution**:

  1. Run with elevated privileges: `sudo podman run ...`.
  2. Use rootless mode configuration: `podman unshare` to debug namespace issues.
  3. Check SELinux logs (`ausearch -m avc`) and adjust with `:z` or `:Z` on mounts.

---

## 2. Port Mapping Issues

### Symptom: Container Not Accessible on Host Port

* **Error**: Service unreachable on mapped port.
* **Possible Causes**:

  * Incorrect port mapping syntax.
  * Host firewall (iptables) blocking traffic.
  * Binding only to localhost.
* **Resolution**:

  1. Verify mapping syntax: `-p hostPort:containerPort` (e.g., `-p 8080:80`).
  2. Check active ports: `ss -tln | grep 8080`.
  3. Update firewall rules: `sudo firewall-cmd --add-port=8080/tcp --permanent && firewall-cmd --reload`.
  4. Bind to all interfaces: `-p 0.0.0.0:8080:80`.

---

## 3. DNS Resolution Issues

### Symptom: DNS Lookup Fails Inside Container

* **Error**: `ping: bad address`, `Temporary failure in name resolution`.
* **Possible Causes**:

  * Host `resolv.conf` misconfiguration.
  * Disabled user network namespace DNS propagation.
* **Resolution**:

  1. Inspect container DNS settings: `podman inspect --format='{{.HostConfig.Dns}}' <container>`.
  2. Override DNS servers: `--dns 8.8.8.8 --dns 8.8.4.4`.
  3. Share host resolv.conf: `--volume /etc/resolv.conf:/etc/resolv.conf:ro`.

---

## 4. Volume Mount Issues

### Symptom: Mount Error or Data Not Persisting

* **Error**: `cannot create mount destination`, `permission denied on mount`.
* **Possible Causes**:

  * Host path does not exist.
  * Incorrect mount syntax.
  * SELinux blocking access.
* **Resolution**:

  1. Confirm host path exists: `ls /path/on/host`.
  2. Use absolute paths: `--volume /host/path:/container/path`.
  3. Adjust SELinux context: add `:z` (shared) or `:Z` (private) to the volume flag.

---

## 5. Environment Variable Issues

### Symptom: Environment Variables Not Available in Container

* **Error**: Application inside container cannot read expected variables.
* **Possible Causes**:

  * Incorrect `-e` syntax.
  * Variables not defined in `--env-file`.
* **Resolution**:

  1. Set inline: `-e MY_VAR=value`.
  2. Use an env file: `--env-file ./env.list` (format: `KEY=value`).
  3. Verify inside container: `podman exec <id> env | grep MY_VAR`.

---

## 6. Logging and Debugging Tools

* **View Logs**: `podman logs <container>`.
* **Inspect Container**: `podman inspect <container>` for detailed configuration.
* **Monitor Events**: `podman events` to stream runtime events.
* **Interactive Shell**: `podman exec -it <container> /bin/sh` to enter the container.

---

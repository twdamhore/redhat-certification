# RHCSA Objective 1 - Project Context

> **For Claude:** Read this file at the start of each session to understand project state.

## Project Overview

Practice environment for RHCSA (Red Hat Certified System Administrator) exam on RHEL 10 / AlmaLinux 10.1. Tasks are designed to be **20% harder** than actual exam requirements.

## Environment

| Item | Details |
|------|---------|
| VM OS | AlmaLinux 10.1 |
| Disk | 20 GiB (some unallocated space available) |
| VMs | Single VM (no multi-VM setup needed for Objective 1) |
| Production? | No - safe to experiment, can reinstall |

## File Structure

```
rhcsa/2026/objective-01/
├── prepare.sh      # Run as root - sets up /exam/objective1/ with tasks
├── score.sh        # Run as root - validates tasks, shows score (70% to pass)
├── prompts.txt     # Log of all Claude Code prompts
└── CONTEXT.md      # This file - project context for Claude
```

## Objective 1: Understand and Use Essential Tools

Covers these RHCSA sub-objectives (with 20% harder tasks):

| Task | Points | Key Challenge |
|------|--------|---------------|
| I/O Redirection | 10 | stderr/stdout separation, complex pipes |
| grep/Regex | 15 | Extended regex, unique extraction |
| SSH Config | 10 | Ed25519 keys, custom config file |
| Archive/Compression | 15 | tar exclusions, xz/bz2/gz formats |
| File Operations | 10 | Hidden files, batch rename |
| Hard/Soft Links | 10 | Relative vs absolute paths |
| Permissions | 20 | SETUID, SETGID, STICKY BIT |
| Documentation | 5 | man/info research |
| Text Editing | 5 | Create/modify configs |

## Users/Groups Created by prepare.sh

- User: `examuser`
- Groups: `examgroup`, `developers`

## Current Status

- [x] Objective 1 scripts created
- [ ] Objectives 2-10 (not started)

## RHCSA RHEL 10 Objectives (Full List)

1. **Understand and use essential tools** ← CURRENT
2. Manage software (RPM repositories, Flatpak)
3. Create simple shell scripts
4. Operate running systems
5. Configure local storage
6. Create and configure file systems
7. Deploy, configure, and maintain systems
8. Manage basic networking
9. Manage users and groups
10. Manage security

## Notes

- Containers (Podman) removed from RHCSA 10
- Flatpak added to RHCSA 10
- 20 GiB disk has unallocated space for storage tasks (Objectives 3-4)

## How to Use

```bash
# On VM:
git clone https://github.com/twdamhore/redhat-certification.git
cd redhat-certification/rhcsa/2026/objective-01
sudo ./prepare.sh
# complete tasks in /exam/objective1/
sudo ./score.sh
```

---
*Last updated: 2026-01-09*

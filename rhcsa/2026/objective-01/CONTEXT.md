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
├── prepare.sh      # Run as root - sets up /exam/objective1/ with 33 tasks
├── score.sh        # Run as root - validates tasks (70/100 to pass)
├── prompts.txt     # Log of all Claude Code prompts
└── CONTEXT.md      # This file - project context for Claude
```

## Objective 1: Understand and Use Essential Tools

**33 Tasks Total** (3 tasks × 11 sub-objectives)

| Sub-Obj | Topic | Points | Key Challenges |
|---------|-------|--------|----------------|
| 1 | Shell Commands | 9 | Brace expansion, command substitution |
| 2 | I/O Redirection | 9 | stderr/stdout separation, pipelines |
| 3 | grep/Regex | 9 | Extract usernames, IPs, HTTP errors |
| 4 | SSH | 9 | Ed25519 keys, config file, permissions |
| 5 | User Switching | 9 | su, sudo, file ownership |
| 6 | Archive/Compression | 9 | tar.gz, tar.bz2, exclusions |
| 7 | Text Files | 9 | Create, modify, append |
| 8 | File Operations | 9 | Copy, move/rename, mkdir with brace |
| 9 | Links | 9 | Hard links, relative/absolute symlinks |
| 10 | Permissions | 10 | Standard perms, SETGID, STICKY bit |
| 11 | Documentation | 10 | man pages research |

## Users/Groups Created by prepare.sh

- Users: `examuser` (exam123), `testuser` (test123), `admin` (admin123)
- Groups: `examgroup`, `developers`, `operators`

## Scoring Behavior

- **PASS**: Shows `[PASS] Task X.Y: what was verified`
- **FAIL**: Shows `[    ] Task X.Y: Not complete` (no hints)
- Pass threshold: 70/100 points

## Current Status

- [x] Objective 1 scripts created (v2 - 33 tasks)
- [ ] Objectives 2-10 (not started)

## RHCSA RHEL 10 Objectives (Full List)

1. **Understand and use essential tools** ← DONE
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
- 20 GiB disk has unallocated space for storage tasks (Objectives 5-6)
- prepare.sh is idempotent - rerun to reset environment

## How to Use

```bash
# On VM:
git clone https://github.com/twdamhore/redhat-certification.git
cd redhat-certification/rhcsa/2026/objective-01
sudo ./prepare.sh    # Sets up environment (rerun to reset)
cat /exam/objective1/TASKS.txt  # Read task instructions
# complete tasks...
sudo ./score.sh      # Check score
```

---
*Last updated: 2026-01-09*

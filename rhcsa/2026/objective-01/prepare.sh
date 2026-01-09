#!/bin/bash
#
# RHCSA Objective 1: Understand and Use Essential Tools
# Preparation Script - Sets up the exam environment
#
# This script creates tasks that are 20% harder than standard RHCSA requirements
# Target: AlmaLinux 10.1 / RHEL 10
#
# Run as root: sudo ./prepare.sh
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${NC}"
   exit 1
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  RHCSA Objective 1: Essential Tools${NC}"
echo -e "${BLUE}  Preparation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Create exam working directory
EXAM_DIR="/exam/objective1"
mkdir -p "$EXAM_DIR"
cd "$EXAM_DIR"

echo -e "${GREEN}[*] Setting up exam environment...${NC}"

# ============================================
# TASK 1: Input/Output Redirection (Advanced)
# ============================================
echo -e "${YELLOW}[Task 1] Setting up I/O Redirection challenges...${NC}"

mkdir -p "$EXAM_DIR/task1_redirection"
cd "$EXAM_DIR/task1_redirection"

# Create sample log files with mixed output
cat > application.log << 'EOF'
2026-01-09 10:00:01 INFO Application started successfully
2026-01-09 10:00:02 DEBUG Loading configuration from /etc/app/config.yml
2026-01-09 10:00:03 WARNING Configuration file has deprecated settings
2026-01-09 10:00:04 ERROR Failed to connect to database: timeout
2026-01-09 10:00:05 INFO Retrying database connection...
2026-01-09 10:00:06 ERROR Database connection failed: host unreachable
2026-01-09 10:00:07 CRITICAL Application shutting down due to fatal error
2026-01-09 10:01:00 INFO Application restarted
2026-01-09 10:01:01 INFO Database connection established
2026-01-09 10:01:02 WARNING Memory usage above 80%
2026-01-09 10:01:03 ERROR Disk space low on /var/log
2026-01-09 10:01:04 INFO User login: admin from 192.168.1.100
2026-01-09 10:01:05 DEBUG Query executed: SELECT * FROM users
EOF

# Create a script that outputs to both stdout and stderr
cat > mixed_output.sh << 'EOF'
#!/bin/bash
echo "Starting process..."
echo "Error: Cannot find config file" >&2
echo "Attempting fallback..."
echo "Warning: Using default values" >&2
echo "Process completed successfully"
echo "Error: Minor issue detected" >&2
EOF
chmod +x mixed_output.sh

# ============================================
# TASK 2: grep and Regular Expressions (Advanced)
# ============================================
echo -e "${YELLOW}[Task 2] Setting up grep/regex challenges...${NC}"

mkdir -p "$EXAM_DIR/task2_grep"
cd "$EXAM_DIR/task2_grep"

# Create complex data files
cat > employees.csv << 'EOF'
ID,Name,Email,Department,Salary,Phone,HireDate
001,John Smith,john.smith@company.com,Engineering,75000,555-123-4567,2020-03-15
002,Jane Doe,jane.doe@company.com,Marketing,65000,555-234-5678,2019-07-22
003,Bob Johnson,bob.j@external.org,Engineering,82000,555-345-6789,2018-11-30
004,Alice Williams,alice.w@company.com,HR,58000,555-456-7890,2021-01-10
005,Charlie Brown,charlie.brown@company.com,Engineering,95000,555-567-8901,2017-05-20
006,Diana Prince,diana@external.net,Marketing,71000,555-678-9012,2022-02-28
007,Edward Norton,e.norton@company.com,Finance,88000,555-789-0123,2016-09-14
008,Fiona Green,fiona.green@company.com,Engineering,79000,555-890-1234,2019-12-01
009,George White,g.white@external.org,HR,62000,555-901-2345,2020-06-15
010,Helen Black,helen.b@company.com,Finance,92000,555-012-3456,2015-04-22
EOF

cat > servers.conf << 'EOF'
# Server Configuration File
# Format: hostname:ip:port:status:environment

webserver01:192.168.1.10:80:active:production
webserver02:192.168.1.11:80:active:production
webserver03:192.168.1.12:8080:inactive:staging
dbserver01:192.168.2.20:3306:active:production
dbserver02:192.168.2.21:3306:standby:production
appserver01:10.0.0.100:8443:active:production
appserver02:10.0.0.101:8443:active:staging
cache01:172.16.0.50:6379:active:production
cache02:172.16.0.51:6379:inactive:development
monitor01:192.168.3.30:9090:active:production
# backup servers below
backup01:192.168.4.40:22:active:production
backup02:192.168.4.41:22:standby:disaster-recovery
EOF

cat > access.log << 'EOF'
192.168.1.100 - - [09/Jan/2026:10:00:01 +0000] "GET /index.html HTTP/1.1" 200 1234
192.168.1.101 - - [09/Jan/2026:10:00:02 +0000] "POST /api/login HTTP/1.1" 200 567
10.0.0.50 - - [09/Jan/2026:10:00:03 +0000] "GET /admin/dashboard HTTP/1.1" 403 89
192.168.1.100 - - [09/Jan/2026:10:00:04 +0000] "GET /images/logo.png HTTP/1.1" 200 45678
172.16.0.200 - - [09/Jan/2026:10:00:05 +0000] "DELETE /api/users/15 HTTP/1.1" 401 123
192.168.1.102 - - [09/Jan/2026:10:00:06 +0000] "PUT /api/config HTTP/1.1" 500 234
10.0.0.51 - - [09/Jan/2026:10:00:07 +0000] "GET /static/style.css HTTP/1.1" 304 0
192.168.1.100 - - [09/Jan/2026:10:00:08 +0000] "POST /api/upload HTTP/1.1" 201 789
172.16.0.201 - - [09/Jan/2026:10:00:09 +0000] "GET /api/users HTTP/1.1" 200 5678
192.168.1.103 - - [09/Jan/2026:10:00:10 +0000] "GET /nonexistent HTTP/1.1" 404 100
EOF

# ============================================
# TASK 3: SSH Configuration (Local Setup)
# ============================================
echo -e "${YELLOW}[Task 3] Setting up SSH challenges...${NC}"

mkdir -p "$EXAM_DIR/task3_ssh"
cd "$EXAM_DIR/task3_ssh"

# Create a requirements file for the candidate
cat > ssh_requirements.txt << 'EOF'
SSH Configuration Requirements:
==============================

You need to configure SSH for user 'examuser' with the following specifications:

1. Create an SSH key pair (Ed25519 algorithm) with a specific comment
2. Configure SSH client settings in ~/.ssh/config
3. Set proper permissions on all SSH files
4. Configure SSH to use a specific identity file for certain hosts

Target configurations will be verified by the scoring script.
EOF

# ============================================
# TASK 4: Archive and Compression (Advanced)
# ============================================
echo -e "${YELLOW}[Task 4] Setting up archive/compression challenges...${NC}"

mkdir -p "$EXAM_DIR/task4_archive"
cd "$EXAM_DIR/task4_archive"

# Create a complex directory structure to archive
mkdir -p project/{src,docs,tests,config,.hidden}
echo "Main application code" > project/src/main.c
echo "Helper functions" > project/src/helpers.c
echo "Header file" > project/src/main.h
echo "API Documentation" > project/docs/api.md
echo "User Guide" > project/docs/user_guide.md
echo "Unit tests" > project/tests/test_main.c
echo "Integration tests" > project/tests/test_integration.c
echo "Production config" > project/config/production.yml
echo "Development config" > project/config/development.yml
echo "Secret keys - DO NOT ARCHIVE" > project/config/secrets.key
echo "Hidden configuration" > project/.hidden/internal.conf
echo "Cache file - exclude" > project/.hidden/cache.tmp
touch -d "2025-06-15" project/src/main.c
touch -d "2025-06-16" project/src/helpers.c
touch -d "2025-07-01" project/docs/api.md

# Create an existing archive for extraction task
cd "$EXAM_DIR/task4_archive"
mkdir -p extract_source
echo "File 1 content" > extract_source/file1.txt
echo "File 2 content" > extract_source/file2.txt
mkdir -p extract_source/subdir
echo "Nested file" > extract_source/subdir/nested.txt
tar -czvf source_archive.tar.gz extract_source
tar -cjvf source_archive.tar.bz2 extract_source
xz -k -c extract_source/file1.txt > file1.txt.xz
rm -rf extract_source

# ============================================
# TASK 5: File and Directory Operations (Advanced)
# ============================================
echo -e "${YELLOW}[Task 5] Setting up file operations challenges...${NC}"

mkdir -p "$EXAM_DIR/task5_files"
cd "$EXAM_DIR/task5_files"

# Create complex file structure for operations
mkdir -p source_files/{documents,images,backups,.config}
for i in {1..5}; do
    echo "Document $i content - $(date +%s%N | sha256sum | head -c 20)" > "source_files/documents/report_$i.txt"
done
for i in {1..3}; do
    dd if=/dev/urandom bs=1024 count=1 2>/dev/null | base64 > "source_files/images/image_$i.jpg"
done
echo "backup_2025_01.sql" > source_files/backups/backup_2025_01.sql
echo "backup_2025_02.sql" > source_files/backups/backup_2025_02.sql
echo "app_settings=default" > source_files/.config/settings.ini
echo "user_preferences=none" > source_files/.config/preferences.ini

# Create files with special characters in names (tricky!)
touch "source_files/documents/report with spaces.txt"
touch "source_files/documents/report-with-dashes.txt"
touch "source_files/documents/file_$(date +%Y%m%d).log"

# ============================================
# TASK 6: Hard and Soft Links (Advanced)
# ============================================
echo -e "${YELLOW}[Task 6] Setting up link challenges...${NC}"

mkdir -p "$EXAM_DIR/task6_links"
cd "$EXAM_DIR/task6_links"

# Create original files for linking
mkdir -p originals targets
echo "This is the original configuration file version 1.0" > originals/config.conf
echo "Shared library content - important system file" > originals/libshared.so
echo "Application binary placeholder" > originals/application.bin
echo "Log rotation target" > originals/current.log
chmod 644 originals/config.conf
chmod 755 originals/libshared.so
chmod 755 originals/application.bin

# Create a scenario file
cat > link_requirements.txt << 'EOF'
Link Creation Requirements:
===========================

Create the following links in the 'targets' directory:

1. HARD LINK: config.conf.backup -> originals/config.conf
2. SOFT LINK: lib -> originals/libshared.so
3. SOFT LINK: app -> originals/application.bin (relative path required)
4. SOFT LINK: latest.log -> originals/current.log (absolute path required)

After creating links, verify:
- Hard link has same inode as original
- Soft links are relative/absolute as specified
- All links are functional
EOF

# ============================================
# TASK 7: Permissions (Advanced - includes special perms)
# ============================================
echo -e "${YELLOW}[Task 7] Setting up permissions challenges...${NC}"

mkdir -p "$EXAM_DIR/task7_permissions"
cd "$EXAM_DIR/task7_permissions"

# Create user and group for testing if they don't exist
id examuser &>/dev/null || useradd -m examuser
getent group examgroup &>/dev/null || groupadd examgroup
getent group developers &>/dev/null || groupadd developers
usermod -aG examgroup examuser 2>/dev/null || true
usermod -aG developers examuser 2>/dev/null || true

# Create files and directories with specific permission requirements
mkdir -p shared_project/{public,private,team,scripts}

echo "Public readme file" > shared_project/public/README.md
echo "Private data - restricted access" > shared_project/private/data.db
echo "Team document - group access only" > shared_project/team/project_plan.md
echo '#!/bin/bash\necho "Team script executed by: $(whoami)"' > shared_project/scripts/deploy.sh
echo '#!/bin/bash\necho "Admin only script"' > shared_project/scripts/admin_tool.sh
mkdir -p shared_project/uploads

# Create permission requirements
cat > permission_requirements.txt << 'EOF'
Permission Configuration Requirements:
======================================

Configure permissions for shared_project/ as follows:

1. public/README.md:
   - Owner: examuser, Group: examgroup
   - Permissions: rw-r--r-- (644)

2. private/data.db:
   - Owner: root, Group: root
   - Permissions: rw------- (600)

3. team/project_plan.md:
   - Owner: examuser, Group: developers
   - Permissions: rw-rw---- (660)

4. scripts/deploy.sh:
   - Owner: root, Group: developers
   - Permissions: rwxr-x--- (750) with SETGID bit

5. scripts/admin_tool.sh:
   - Owner: root, Group: root
   - Permissions: rwx------ (700) with SETUID bit

6. uploads/ directory:
   - Owner: examuser, Group: examgroup
   - Permissions: rwxrwx--T (1770) - STICKY BIT set

7. shared_project/ directory:
   - Apply SETGID so new files inherit group ownership
EOF

# ============================================
# TASK 8: System Documentation
# ============================================
echo -e "${YELLOW}[Task 8] Setting up documentation challenges...${NC}"

mkdir -p "$EXAM_DIR/task8_documentation"
cd "$EXAM_DIR/task8_documentation"

cat > documentation_tasks.txt << 'EOF'
Documentation Research Tasks:
=============================

Using man, info, and /usr/share/doc, find answers to:

1. Find the configuration file location for the 'sudoers' using man pages
   Save answer to: answer1.txt

2. Find which man section contains information about file formats
   Save answer to: answer2.txt

3. Find the option for 'tar' that preserves extended attributes (xattr)
   Save answer to: answer3.txt

4. Using man pages, find the default umask value mentioned in bash documentation
   Save answer to: answer4.txt

5. Locate and read the README file for 'systemd' in /usr/share/doc
   Record the main purpose stated in: answer5.txt
EOF

# ============================================
# TASK 9: Text File Creation and Editing
# ============================================
echo -e "${YELLOW}[Task 9] Setting up text editing challenges...${NC}"

mkdir -p "$EXAM_DIR/task9_editing"
cd "$EXAM_DIR/task9_editing"

# Create file that needs editing
cat > network_config.txt << 'EOF'
# Network Configuration File
# Generated: 2025-01-01

[interface]
name=eth0
type=Ethernet
bootproto=dhcp
onboot=yes

[dns]
server1=8.8.8.8
server2=8.8.4.4

[routes]
default=192.168.1.1

# End of configuration
EOF

cat > editing_tasks.txt << 'EOF'
Text Editing Tasks:
===================

1. Create a new file called 'server_info.txt' containing EXACTLY:
   - Line 1: Hostname: examserver
   - Line 2: IP: 192.168.100.50
   - Line 3: Gateway: 192.168.100.1
   - Line 4: DNS: 192.168.100.2
   (No trailing blank lines, no leading spaces)

2. Modify network_config.txt:
   - Change bootproto from 'dhcp' to 'static'
   - Add 'ipaddr=10.0.0.100' after the bootproto line
   - Add 'netmask=255.255.255.0' after ipaddr
   - Change server1 DNS to '1.1.1.1'
   - Add a comment '# Modified by examuser' at the end

3. Create a file 'multiline.txt' with exactly 10 lines numbered 1-10
   Each line should contain: "Line X: $(random_content)"
   Where X is line number and content is anything

4. Append the current date to 'server_info.txt' as a 5th line
   Format: Date: YYYY-MM-DD
EOF

# ============================================
# Summary and Instructions
# ============================================
echo -e "${YELLOW}[*] Creating task summary...${NC}"

mkdir -p "$EXAM_DIR"
cat > "$EXAM_DIR/INSTRUCTIONS.txt" << 'EOF'
================================================================================
                RHCSA Objective 1: Understand and Use Essential Tools
                            EXAM PRACTICE TASKS
================================================================================

Time Limit: 90 minutes (suggested)
Passing Score: 70%
Difficulty: RHCSA + 20%

INSTRUCTIONS:
-------------
1. Complete all tasks in the directories below
2. Do NOT modify any files with 'requirements' or 'tasks' in the name
3. Use ONLY command-line tools (no GUI)
4. You may use man, info, and /usr/share/doc for reference
5. Run score.sh when complete to check your progress

TASK DIRECTORIES:
-----------------
/exam/objective1/task1_redirection/  - I/O Redirection (10 points)
/exam/objective1/task2_grep/         - grep and Regular Expressions (15 points)
/exam/objective1/task3_ssh/          - SSH Configuration (10 points)
/exam/objective1/task4_archive/      - Archive and Compression (15 points)
/exam/objective1/task5_files/        - File Operations (10 points)
/exam/objective1/task6_links/        - Hard and Soft Links (10 points)
/exam/objective1/task7_permissions/  - Permissions (20 points)
/exam/objective1/task8_documentation/- System Documentation (5 points)
/exam/objective1/task9_editing/      - Text Editing (5 points)

SPECIFIC TASKS:
---------------

TASK 1 - I/O Redirection (Complete in task1_redirection/):
a) Run mixed_output.sh and redirect ONLY errors to 'errors.log'
b) Run mixed_output.sh and redirect stdout to 'output.log', stderr to 'errors2.log'
c) Extract all ERROR and CRITICAL lines from application.log to 'critical.log'
d) Count total lines in application.log, save count (number only) to 'linecount.txt'
e) Create a pipeline: cat application.log | filter WARNING | count > warnings_count.txt

TASK 2 - grep and Regular Expressions (Complete in task2_grep/):
a) Find all @company.com emails in employees.csv, save to 'company_emails.txt'
b) Find employees with salary >= 80000, save full lines to 'high_earners.txt'
c) Find all active production servers from servers.conf to 'active_prod.txt'
d) Extract all IP addresses from access.log to 'ip_addresses.txt' (IPs only, unique)
e) Find all HTTP error codes (4xx and 5xx) from access.log to 'http_errors.txt'
f) Find lines NOT starting with # in servers.conf to 'servers_only.txt'

TASK 3 - SSH Configuration (Complete in task3_ssh/ and ~examuser/.ssh/):
a) Generate Ed25519 SSH key pair for examuser (no passphrase, comment: "examuser@rhcsa")
b) Create ~/.ssh/config for examuser with Host entry "examserver" pointing to 127.0.0.1
c) Set correct permissions: .ssh (700), private key (600), public key (644), config (600)

TASK 4 - Archive and Compression (Complete in task4_archive/):
a) Create 'project.tar.gz' from project/ EXCLUDING *.key and *.tmp files
b) Create 'project.tar.bz2' with ONLY the src/ directory, preserving permissions
c) Extract source_archive.tar.gz to 'extracted_gz/' directory
d) Extract ONLY file1.txt.xz to 'extracted_xz/' directory
e) Create 'project.tar.xz' from project/ with maximum compression

TASK 5 - File Operations (Complete in task5_files/):
a) Copy ALL .txt files from source_files/documents/ to a new 'txt_backup/' directory
b) Move all .sql files to a new 'database_backups/' directory
c) Create directory structure: organized/{docs,media,config} in one command
d) Delete all files in source_files/.config/ but keep the directory
e) Rename all .jpg files in source_files/images/ to .jpeg extension

TASK 6 - Hard and Soft Links (Complete in task6_links/targets/):
a) Create hard link: config.conf.backup -> originals/config.conf
b) Create symbolic link: lib -> originals/libshared.so (relative path)
c) Create symbolic link: app -> ../originals/application.bin (relative)
d) Create symbolic link: latest.log -> /exam/objective1/task6_links/originals/current.log

TASK 7 - Permissions (Complete in task7_permissions/):
Apply ALL permissions as specified in permission_requirements.txt
Pay special attention to:
- SETUID on admin_tool.sh
- SETGID on deploy.sh and shared_project/ directory
- STICKY BIT on uploads/

TASK 8 - Documentation (Complete in task8_documentation/):
Research and save answers as specified in documentation_tasks.txt

TASK 9 - Text Editing (Complete in task9_editing/):
Complete all tasks as specified in editing_tasks.txt

================================================================================
                           Good luck!
================================================================================
EOF

# Set ownership
chown -R root:root "$EXAM_DIR"
chmod -R 755 "$EXAM_DIR"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Environment setup complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "Exam directory: ${BLUE}$EXAM_DIR${NC}"
echo -e "Read instructions: ${BLUE}cat $EXAM_DIR/INSTRUCTIONS.txt${NC}"
echo -e "Run scoring: ${BLUE}sudo ./score.sh${NC}"
echo ""
echo -e "${YELLOW}User 'examuser' has been created for testing purposes.${NC}"
echo -e "${YELLOW}Groups 'examgroup' and 'developers' have been created.${NC}"
echo ""

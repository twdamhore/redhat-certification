#!/bin/bash
#
# RHCSA Objective 1: Understand and Use Essential Tools
# Preparation Script - Sets up the exam environment
#
# 11 Sub-objectives, 40+ Tasks Total
# Difficulty: RHCSA + 20%
# Target: AlmaLinux 10.1 / RHEL 10
#
# Run as: sudo ./prepare.sh
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Detect real user (even when running with sudo)
if [[ -n "$SUDO_USER" ]] && [[ "$SUDO_USER" != "root" ]]; then
    REAL_USER="$SUDO_USER"
elif [[ $(logname 2>/dev/null) ]] && [[ $(logname) != "root" ]]; then
    REAL_USER=$(logname)
elif [[ -n "$USER" ]] && [[ "$USER" != "root" ]]; then
    REAL_USER="$USER"
else
    echo -e "${RED}Error: Cannot detect non-root user.${NC}"
    echo -e "${RED}Please run as: sudo ./prepare.sh (from a non-root login)${NC}"
    exit 1
fi

REAL_USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

if [[ -z "$REAL_USER_HOME" ]] || [[ ! -d "$REAL_USER_HOME" ]]; then
    echo -e "${RED}Error: Cannot find home directory for user '$REAL_USER'${NC}"
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run with sudo${NC}"
   exit 1
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  RHCSA Objective 1: Essential Tools${NC}"
echo -e "${BLUE}  Preparation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "${CYAN}Detected user: $REAL_USER${NC}"
echo -e "${CYAN}Home directory: $REAL_USER_HOME${NC}"
echo ""

EXAM_DIR="$REAL_USER_HOME/rhcsa-lab/objective-01"
rm -rf "$EXAM_DIR" 2>/dev/null || true
mkdir -p "$EXAM_DIR"

echo -e "${GREEN}[*] Setting up exam environment...${NC}"

# ============================================
# Create users and groups
# ============================================
echo -e "${YELLOW}[*] Creating users and groups...${NC}"

getent group examgroup &>/dev/null || groupadd examgroup
getent group developers &>/dev/null || groupadd developers
getent group operators &>/dev/null || groupadd operators

id examuser &>/dev/null || useradd -m -G examgroup,developers examuser
id testuser &>/dev/null || useradd -m -G operators testuser
id admin &>/dev/null || useradd -m admin

echo "examuser:exam123" | chpasswd
echo "testuser:test123" | chpasswd
echo "admin:admin123" | chpasswd

# Clean examuser's .ssh for fresh start
rm -rf /home/examuser/.ssh 2>/dev/null || true

# ============================================
# SUB-OBJECTIVE 1: Shell Commands (4 tasks)
# ============================================
echo -e "${YELLOW}[1/11] Setting up shell command tasks...${NC}"

mkdir -p "$EXAM_DIR/01_shell"
cd "$EXAM_DIR/01_shell"

mkdir -p data
echo "server1.example.com" > data/server1.txt
echo "server2.example.com" > data/server2.txt
echo "server3.example.com" > data/server3.txt
for i in {1..5}; do echo "log entry $i" > "data/log_$i.txt"; done

mkdir -p config
echo "DB_HOST=localhost" > config/database.conf
echo "DB_PORT=5432" >> config/database.conf
echo "DB_NAME=production" >> config/database.conf

# ============================================
# SUB-OBJECTIVE 2: I/O Redirection (5 tasks)
# ============================================
echo -e "${YELLOW}[2/11] Setting up I/O redirection tasks...${NC}"

mkdir -p "$EXAM_DIR/02_redirection"
cd "$EXAM_DIR/02_redirection"

cat > generate_report.sh << 'SCRIPT'
#!/bin/bash
echo "Report Generation Started"
echo "Warning: Old data detected" >&2
echo "Processing record 1..."
echo "Processing record 2..."
echo "Error: Record 3 corrupted" >&2
echo "Processing record 4..."
echo "Error: Database timeout" >&2
echo "Report Generation Complete"
SCRIPT
chmod +x generate_report.sh

cat > system.log << 'EOF'
Jan 09 10:00:01 server sshd[1234]: Accepted publickey for root
Jan 09 10:00:02 server kernel: Out of memory: Kill process
Jan 09 10:00:03 server sshd[1235]: Failed password for invalid user
Jan 09 10:00:04 server systemd[1]: Started Apache
Jan 09 10:00:05 server kernel: CPU0: Temperature above threshold
Jan 09 10:00:06 server sshd[1236]: Accepted password for admin
Jan 09 10:00:07 server kernel: Kernel panic - not syncing
Jan 09 10:00:08 server crond[999]: Job started
Jan 09 10:00:09 server sshd[1237]: Failed password for root
Jan 09 10:00:10 server systemd[1]: Stopping firewalld
Jan 09 10:00:11 server sshd[1238]: Failed password for admin
Jan 09 10:00:12 server kernel: EXT4-fs error
EOF

cat > numbers.txt << 'EOF'
42
17
99
8
256
73
EOF

# ============================================
# SUB-OBJECTIVE 3: grep and regex (6 tasks)
# ============================================
echo -e "${YELLOW}[3/11] Setting up grep/regex tasks...${NC}"

mkdir -p "$EXAM_DIR/03_grep"
cd "$EXAM_DIR/03_grep"

cat > users.txt << 'EOF'
jsmith:x:1001:1001:John Smith:/home/jsmith:/bin/bash
jdoe:x:1002:1002:Jane Doe:/home/jdoe:/bin/bash
bob:x:1003:1003:Bob Johnson:/home/bob:/sbin/nologin
alice:x:1004:1004:Alice Williams:/home/alice:/bin/bash
charlie:x:1005:1005:Charlie Brown:/home/charlie:/bin/zsh
sysadmin:x:1006:1006:System Admin:/home/sysadmin:/bin/bash
backup:x:1007:1007:Backup User:/var/backup:/sbin/nologin
mysql:x:27:27:MySQL Server:/var/lib/mysql:/sbin/nologin
nginx:x:998:998:Nginx User:/var/lib/nginx:/sbin/nologin
developer:x:1008:1008:Dev User:/home/developer:/bin/bash
EOF

cat > network.conf << 'EOF'
# Network Configuration
interface=eth0
ip_address=192.168.1.100
netmask=255.255.255.0
gateway=192.168.1.1
dns1=8.8.8.8
dns2=8.8.4.4

# Secondary Interface
interface=eth1
ip_address=10.0.0.50
netmask=255.255.0.0
# gateway not set for eth1

# Management Interface
interface=mgmt0
ip_address=172.16.100.25
netmask=255.255.255.128
gateway=172.16.100.1
EOF

cat > webserver.log << 'EOF'
192.168.1.50 - - [09/Jan/2026:10:15:01] "GET /index.html" 200 1234
10.0.0.100 - - [09/Jan/2026:10:15:02] "POST /api/login" 401 89
192.168.1.50 - - [09/Jan/2026:10:15:03] "GET /style.css" 200 567
172.16.0.25 - - [09/Jan/2026:10:15:04] "GET /admin" 403 120
192.168.1.75 - - [09/Jan/2026:10:15:05] "DELETE /api/user/5" 500 45
10.0.0.100 - - [09/Jan/2026:10:15:06] "POST /api/login" 200 234
192.168.1.50 - - [09/Jan/2026:10:15:07] "GET /images/logo.png" 404 78
10.0.0.101 - - [09/Jan/2026:10:15:08] "PUT /api/config" 201 456
192.168.1.100 - - [09/Jan/2026:10:15:09] "GET /dashboard" 200 2345
172.16.0.30 - - [09/Jan/2026:10:15:10] "GET /secret" 403 90
EOF

mkdir -p logs
echo "ERROR: Connection failed" > logs/app1.log
echo "INFO: Started successfully" >> logs/app1.log
echo "WARNING: Low memory" > logs/app2.log
echo "ERROR: Timeout occurred" >> logs/app2.log
echo "DEBUG: Processing complete" > logs/app3.log

cat > emails.txt << 'EOF'
Contact us at support@company.com for help
Sales inquiries: sales@company.com
John's email is john.doe@example.org
Invalid email: notanemail
Another contact: admin@test-domain.co.uk
Personal: mary_jane@gmail.com
EOF

# ============================================
# SUB-OBJECTIVE 4: SSH (3 tasks)
# ============================================
echo -e "${YELLOW}[4/11] Setting up SSH tasks...${NC}"

mkdir -p "$EXAM_DIR/04_ssh"

# ============================================
# SUB-OBJECTIVE 5: Users and Multiuser (4 tasks)
# ============================================
echo -e "${YELLOW}[5/11] Setting up user switching tasks...${NC}"

# These tasks use examuser's home directory since examuser needs write access
EXAMUSER_HOME="/home/examuser"
mkdir -p "$EXAMUSER_HOME/rhcsa-lab"
cd "$EXAMUSER_HOME/rhcsa-lab"

# Clean up any previous attempt
rm -rf shared_workspace reports examuser_was_here.txt sudo_test.txt 2>/dev/null

mkdir -p shared_workspace
chmod 770 shared_workspace
chown examuser:developers shared_workspace

mkdir -p reports
chmod 755 reports
chown examuser:examuser reports

# ============================================
# SUB-OBJECTIVE 6: Archive and Compression (5 tasks)
# ============================================
echo -e "${YELLOW}[6/11] Setting up archive tasks...${NC}"

mkdir -p "$EXAM_DIR/06_archive"
cd "$EXAM_DIR/06_archive"

mkdir -p webapp/{src,config,logs,tmp,public}
echo "#!/usr/bin/env python3" > webapp/src/main.py
echo "def helper(): pass" > webapp/src/utils.py
echo "console.log('app');" > webapp/public/app.js
echo "body { margin: 0; }" > webapp/public/style.css
echo "database: postgres" > webapp/config/config.yml
echo "secret_key: abc123" > webapp/config/secrets.yml
echo "[2026-01-09] App started" > webapp/logs/app.log
echo "[2026-01-09] Debug info" > webapp/logs/debug.log
echo "cache_data" > webapp/tmp/cache.tmp
echo "session_data" > webapp/tmp/session.tmp

touch -d "2025-06-01 10:00:00" webapp/src/main.py
touch -d "2025-06-15 14:30:00" webapp/src/utils.py

mkdir -p backup_data/attachments
echo "CREATE TABLE users..." > backup_data/database.sql
echo "id,name,email" > backup_data/users.csv
echo "1,John,john@test.com" >> backup_data/users.csv
echo "PDF content" > backup_data/attachments/file1.pdf
echo "PDF content 2" > backup_data/attachments/file2.pdf
tar -czvf backup.tar.gz backup_data 2>/dev/null
rm -rf backup_data

# ============================================
# SUB-OBJECTIVE 7: Text Files (4 tasks)
# ============================================
echo -e "${YELLOW}[7/11] Setting up text editing tasks...${NC}"

mkdir -p "$EXAM_DIR/07_textfiles"
cd "$EXAM_DIR/07_textfiles"

cat > hosts.local << 'EOF'
# Local host entries
127.0.0.1   localhost localhost.localdomain
::1         localhost localhost.localdomain

# Application servers
192.168.1.10  webserver1
192.168.1.11  webserver2
192.168.1.20  dbserver

# Development
10.0.0.100   devbox
EOF

cat > application.conf << 'EOF'
# Application Configuration
app_name=myapp
app_port=8080
debug_mode=true
log_level=INFO
max_connections=100

# Database settings
db_host=localhost
db_port=3306
db_name=production
db_user=appuser

# Cache settings
cache_enabled=false
cache_ttl=300
EOF

cat > sshd_config.sample << 'EOF'
# SSH Server Configuration
Port 22
PermitRootLogin yes
PasswordAuthentication yes
PubkeyAuthentication yes
MaxAuthTries 6
EOF

# ============================================
# SUB-OBJECTIVE 8: File Operations (5 tasks)
# ============================================
echo -e "${YELLOW}[8/11] Setting up file operation tasks...${NC}"

mkdir -p "$EXAM_DIR/08_files"
cd "$EXAM_DIR/08_files"

mkdir -p source/{documents,images,videos,misc,temp}
echo "Report Q1 2025" > "source/documents/report_q1.txt"
echo "Report Q2 2025" > "source/documents/report_q2.txt"
echo "Report Q3 2025" > "source/documents/report_q3.txt"
echo "Report Q4 2025" > "source/documents/report_q4.txt"
echo "Meeting notes January" > "source/documents/meeting_notes.txt"
echo "Budget 2025" > "source/documents/budget_2025.xlsx"
dd if=/dev/urandom bs=100 count=1 2>/dev/null | base64 > source/images/photo1.jpg
dd if=/dev/urandom bs=100 count=1 2>/dev/null | base64 > source/images/photo2.jpg
dd if=/dev/urandom bs=100 count=1 2>/dev/null | base64 > source/images/photo3.png
dd if=/dev/urandom bs=100 count=1 2>/dev/null | base64 > source/images/screenshot.png
echo "video content" > source/videos/intro.mp4
echo "misc file" > source/misc/notes.txt
echo "temp data 1" > source/temp/cache1.tmp
echo "temp data 2" > source/temp/cache2.tmp
echo "temp data 3" > source/temp/session.tmp
touch source/documents/.hidden_doc
touch source/documents/.secret_notes

# ============================================
# SUB-OBJECTIVE 9: Links (4 tasks)
# ============================================
echo -e "${YELLOW}[9/11] Setting up link tasks...${NC}"

mkdir -p "$EXAM_DIR/09_links"
cd "$EXAM_DIR/09_links"

mkdir -p original
echo "Configuration file v1.0" > original/app.conf
echo "Library content - shared object" > original/libcustom.so.1.0
echo "Current log data - rotating" > original/application.log
echo "Important data file" > original/data.db
chmod 644 original/app.conf
chmod 755 original/libcustom.so.1.0
chmod 644 original/application.log
chmod 640 original/data.db

mkdir -p links

# ============================================
# SUB-OBJECTIVE 10: Permissions (5 tasks)
# ============================================
echo -e "${YELLOW}[10/11] Setting up permissions tasks...${NC}"

mkdir -p "$EXAM_DIR/10_permissions"
cd "$EXAM_DIR/10_permissions"

mkdir -p project/{bin,data,shared,uploads,config,scripts}
echo "#!/bin/bash" > project/bin/run.sh
echo "echo 'Running...'" >> project/bin/run.sh
echo "#!/bin/bash" > project/bin/admin.sh
echo "echo 'Admin task'" >> project/bin/admin.sh
echo "data content" > project/data/records.db
echo "shared doc" > project/shared/readme.txt
echo "config data" > project/config/settings.ini
echo "secret config" > project/config/credentials.conf
echo "#!/bin/bash" > project/scripts/backup.sh
echo "#!/bin/bash" > project/scripts/deploy.sh

# ============================================
# SUB-OBJECTIVE 11: Documentation (4 tasks)
# ============================================
echo -e "${YELLOW}[11/11] Setting up documentation tasks...${NC}"

mkdir -p "$EXAM_DIR/11_docs"
cd "$EXAM_DIR/11_docs"

mkdir -p answers

# ============================================
# Create Instructions File
# ============================================
cat > "$EXAM_DIR/TASKS.txt" << 'TASKFILE'
================================================================================
           RHCSA OBJECTIVE 1: UNDERSTAND AND USE ESSENTIAL TOOLS
================================================================================

Time Suggested: 120 minutes
Pass Score: 70/100 points

IMPORTANT:
- Complete tasks in the directories under ~/rhcsa-lab/objective-01/
- Run 'sudo ./score.sh' to check your progress
- The scoring verifies RESULTS, not methods - but practice the specified methods

================================================================================
SUB-OBJECTIVE 1: ACCESS SHELL AND ISSUE COMMANDS
Directory: ~/rhcsa-lab/objective-01/01_shell/
================================================================================

Task 1.1 (3 pts)
Create files file_a.txt, file_b.txt, file_c.txt using brace expansion

Task 1.2 (3 pts)
Create 'hostname.txt' containing the system hostname using command substitution

Task 1.3 (2 pts)
Count .txt files in 'data/' directory and save the number to 'count.txt'

Task 1.4 (2 pts)
Read config/database.conf and extract only the value of DB_NAME (just the value,
not the variable name), save to 'dbname.txt'

================================================================================
SUB-OBJECTIVE 2: INPUT-OUTPUT REDIRECTION
Directory: ~/rhcsa-lab/objective-01/02_redirection/
================================================================================

Task 2.1 (2 pts)
Run './generate_report.sh' and redirect ONLY stderr to 'errors.log'

Task 2.2 (3 pts)
Run './generate_report.sh' with stdout to 'stdout.log' and stderr to 'stderr.log'

Task 2.3 (2 pts)
From 'system.log', count lines containing both 'sshd' AND 'Failed',
save count to 'failed_ssh.txt'

Task 2.4 (2 pts)
Sort numbers.txt numerically and save to 'sorted_numbers.txt'

Task 2.5 (2 pts)
Append the text "Log analysis complete" to a new file 'summary.log',
then append current date (just the date) on a new line

================================================================================
SUB-OBJECTIVE 3: GREP AND REGULAR EXPRESSIONS
Directory: ~/rhcsa-lab/objective-01/03_grep/
================================================================================

Task 3.1 (2 pts)
From 'users.txt', extract usernames (first field) of /bin/bash users to 'bash_users.txt'

Task 3.2 (3 pts)
From 'network.conf', extract all IP addresses (IPs only), unique and sorted
numerically, to 'ip_list.txt'

Task 3.3 (2 pts)
From 'webserver.log', find lines with HTTP 4xx or 5xx errors to 'http_errors.log'

Task 3.4 (2 pts)
Count total lines containing 'ERROR' (case insensitive) in logs/ directory,
save count to 'error_count.txt'

Task 3.5 (2 pts)
From 'users.txt', find users with UID >= 1000 AND using /bin/bash,
save full lines to 'regular_bash_users.txt'

Task 3.6 (2 pts)
Extract all valid email addresses from 'emails.txt' to 'valid_emails.txt'
(format: something@something.something)

================================================================================
SUB-OBJECTIVE 4: ACCESS REMOTE SYSTEMS USING SSH
Directory: ~/.ssh/ (as examuser)
================================================================================

Task 4.1 (3 pts)
As 'examuser', generate Ed25519 SSH key pair with no passphrase,
comment 'examuser@rhcsa-lab'

Task 4.2 (3 pts)
Create ~/.ssh/config with Host 'lab' pointing to 127.0.0.1, user 'examuser'

Task 4.3 (3 pts)
Set correct SSH permissions: directory 700, private key 600, public key 644, config 600

================================================================================
SUB-OBJECTIVE 5: LOG IN AND SWITCH USERS
Directory: ~examuser/rhcsa-lab/ (examuser's home)
================================================================================

Task 5.1 (2 pts)
As 'examuser', create 'examuser_was_here.txt' containing 'Created by examuser'

Task 5.2 (3 pts)
As 'examuser' using sudo, create 'sudo_test.txt' owned by root containing
'Created with sudo'

Task 5.3 (2 pts)
Create 'shared_workspace/team_file.txt' as examuser, with content
'Team collaboration file', owned by examuser:developers

Task 5.4 (3 pts)
As 'examuser', run 'whoami' and save output to 'reports/current_user.txt',
then run 'id' and append to same file

================================================================================
SUB-OBJECTIVE 6: ARCHIVE, COMPRESS, UNPACK FILES
Directory: ~/rhcsa-lab/objective-01/06_archive/
================================================================================

Task 6.1 (2 pts)
Create 'webapp_src.tar.gz' with ONLY webapp/src and webapp/public

Task 6.2 (3 pts)
Create 'webapp_backup.tar.bz2' with webapp/ EXCLUDING .tmp files and logs/

Task 6.3 (2 pts)
Extract 'backup.tar.gz' into 'restored/' directory

Task 6.4 (2 pts)
List contents of backup.tar.gz (filenames only) and save to 'archive_contents.txt'

Task 6.5 (2 pts)
Create 'webapp_config.tar.xz' containing only webapp/config/ directory

================================================================================
SUB-OBJECTIVE 7: CREATE AND EDIT TEXT FILES
Directory: ~/rhcsa-lab/objective-01/07_textfiles/
================================================================================

Task 7.1 (2 pts)
Create 'server_info.txt' with exactly:
Hostname: rhcsa-lab
IP: 192.168.100.10
Gateway: 192.168.100.1
DNS: 8.8.8.8

Task 7.2 (3 pts)
Modify 'application.conf': change debug_mode to false, log_level to WARNING,
cache_enabled to true

Task 7.3 (2 pts)
Append to 'hosts.local': 192.168.1.50  monitoring

Task 7.4 (2 pts)
In 'sshd_config.sample', change PermitRootLogin from yes to no,
and PasswordAuthentication from yes to no

================================================================================
SUB-OBJECTIVE 8: FILE AND DIRECTORY OPERATIONS
Directory: ~/rhcsa-lab/objective-01/08_files/
================================================================================

Task 8.1 (2 pts)
Copy all .txt files from 'source/documents/' to new 'backup/docs/'

Task 8.2 (3 pts)
Move .jpg and .png from 'source/images/' to 'archive/images/',
rename with 'img_' prefix

Task 8.3 (2 pts)
Create directory structure: organized/2025/{q1,q2,q3,q4}/reports

Task 8.4 (2 pts)
Delete all .tmp files in 'source/temp/' but keep the directory

Task 8.5 (2 pts)
Find and copy all hidden files (starting with .) from source/documents/
to 'hidden_backup/'

================================================================================
SUB-OBJECTIVE 9: CREATE HARD AND SOFT LINKS
Directory: ~/rhcsa-lab/objective-01/09_links/
================================================================================

Task 9.1 (2 pts)
In 'links/', create HARD link 'app.conf.bak' to original/app.conf

Task 9.2 (3 pts)
In 'links/', create SYMBOLIC link 'lib' to original/libcustom.so.1.0
using RELATIVE path

Task 9.3 (2 pts)
In 'links/', create SYMBOLIC link 'current.log' to original/application.log
using ABSOLUTE path

Task 9.4 (2 pts)
In 'links/', create SYMBOLIC link 'libcustom.so' pointing to 'lib'
(symlink to symlink)

================================================================================
SUB-OBJECTIVE 10: PERMISSIONS
Directory: ~/rhcsa-lab/objective-01/10_permissions/
================================================================================

Task 10.1 (2 pts)
Set project/data/records.db: owner=examuser, group=examgroup, mode=640

Task 10.2 (3 pts)
Set project/bin/run.sh: owner=root, group=developers, mode=2750 (SETGID)

Task 10.3 (2 pts)
Set project/uploads/: owner=examuser, group=examgroup, mode=1770 (STICKY)

Task 10.4 (2 pts)
Set project/scripts/ directory and ALL files inside: group=operators, mode=750

Task 10.5 (2 pts)
Set project/config/credentials.conf: owner=root, group=root, mode=600

================================================================================
SUB-OBJECTIVE 11: SYSTEM DOCUMENTATION
Directory: ~/rhcsa-lab/objective-01/11_docs/answers/
================================================================================

Task 11.1 (2 pts)
Find signal NUMBER for SIGKILL, save to 'answers/signal_number.txt'

Task 11.2 (3 pts)
Find tar option for SELinux context, save option name to 'answers/tar_selinux.txt'

Task 11.3 (2 pts)
Find rsyslog documentation path in /usr/share/doc, save to 'answers/rsyslog_doc.txt'

Task 11.4 (2 pts)
Use apropos/man -k to find commands related to 'password',
save the list to 'answers/password_commands.txt'

================================================================================
                              END OF TASKS
                         Total: ~100 points
================================================================================

Run: sudo /path/to/score.sh to check your progress

TASKFILE

# Grant sudo access to examuser
cat > /etc/sudoers.d/examuser << 'EOF'
examuser ALL=(ALL) NOPASSWD: ALL
EOF
chmod 440 /etc/sudoers.d/examuser

# Set ownership to real user (not root)
chown -R "$REAL_USER:$REAL_USER" "$EXAM_DIR"
chmod -R 755 "$EXAM_DIR"

# Note: Sub-objective 5 files are in /home/examuser/rhcsa-lab/ (set up earlier)

# Make sure examuser is also REAL_USER for SSH tasks (or use REAL_USER)
# Update: We'll use REAL_USER for SSH tasks instead of examuser

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Environment setup complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "Exam directory: ${BLUE}$EXAM_DIR${NC}"
echo -e "  (also: ${BLUE}~/rhcsa-lab/objective-01/${NC})"
echo ""
echo -e "Read tasks:     ${BLUE}cat $EXAM_DIR/TASKS.txt${NC}"
echo -e "Check score:    ${BLUE}sudo ./score.sh${NC}"
echo ""
echo -e "${CYAN}Practice user: $REAL_USER${NC}"
echo -e "${CYAN}Helper users created:${NC}"
echo -e "  examuser (password: exam123) - groups: examgroup, developers"
echo -e "  testuser (password: test123) - groups: operators"
echo ""
echo -e "${YELLOW}Good luck!${NC}"
echo ""

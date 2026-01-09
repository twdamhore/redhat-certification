#!/bin/bash
#
# RHCSA Objective 1: Understand and Use Essential Tools
# Preparation Script - Sets up the exam environment
#
# 11 Sub-objectives × 3 Tasks = 33 Tasks Total
# Difficulty: RHCSA + 20%
# Target: AlmaLinux 10.1 / RHEL 10
#
# Run as root: sudo ./prepare.sh
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${NC}"
   exit 1
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  RHCSA Objective 1: Essential Tools${NC}"
echo -e "${BLUE}  Preparation Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

EXAM_DIR="/exam/objective1"
rm -rf "$EXAM_DIR" 2>/dev/null || true
mkdir -p "$EXAM_DIR"

echo -e "${GREEN}[*] Setting up exam environment...${NC}"

# ============================================
# Create users and groups
# ============================================
echo -e "${YELLOW}[*] Creating users and groups...${NC}"

# Create groups
getent group examgroup &>/dev/null || groupadd examgroup
getent group developers &>/dev/null || groupadd developers
getent group operators &>/dev/null || groupadd operators

# Create users
id examuser &>/dev/null || useradd -m -G examgroup,developers examuser
id testuser &>/dev/null || useradd -m -G operators testuser
id admin &>/dev/null || useradd -m admin

# Set passwords (for user switching tasks)
echo "examuser:exam123" | chpasswd
echo "testuser:test123" | chpasswd
echo "admin:admin123" | chpasswd

# ============================================
# SUB-OBJECTIVE 1: Shell Commands
# ============================================
echo -e "${YELLOW}[1/11] Setting up shell command tasks...${NC}"

mkdir -p "$EXAM_DIR/1_shell_commands"
cd "$EXAM_DIR/1_shell_commands"

# Create source files for command tasks
mkdir -p data
echo "server1.example.com" > data/server1.txt
echo "server2.example.com" > data/server2.txt
echo "server3.example.com" > data/server3.txt
for i in {1..5}; do echo "log entry $i" > "data/log_$i.txt"; done

# ============================================
# SUB-OBJECTIVE 2: I/O Redirection
# ============================================
echo -e "${YELLOW}[2/11] Setting up I/O redirection tasks...${NC}"

mkdir -p "$EXAM_DIR/2_redirection"
cd "$EXAM_DIR/2_redirection"

# Create script with mixed output
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

# Create log file for processing
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
EOF

# ============================================
# SUB-OBJECTIVE 3: grep and regex
# ============================================
echo -e "${YELLOW}[3/11] Setting up grep/regex tasks...${NC}"

mkdir -p "$EXAM_DIR/3_grep"
cd "$EXAM_DIR/3_grep"

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

# ============================================
# SUB-OBJECTIVE 4: SSH
# ============================================
echo -e "${YELLOW}[4/11] Setting up SSH tasks...${NC}"

mkdir -p "$EXAM_DIR/4_ssh"
cd "$EXAM_DIR/4_ssh"

# Ensure examuser's .ssh doesn't exist (clean slate)
rm -rf /home/examuser/.ssh 2>/dev/null || true

# ============================================
# SUB-OBJECTIVE 5: Users and Multiuser
# ============================================
echo -e "${YELLOW}[5/11] Setting up user switching tasks...${NC}"

mkdir -p "$EXAM_DIR/5_users"
cd "$EXAM_DIR/5_users"

# Create a file that needs specific ownership
echo "Confidential data" > confidential.txt
chmod 600 confidential.txt
chown root:root confidential.txt

# Create directory for user collaboration
mkdir -p shared_workspace
chmod 770 shared_workspace
chown root:developers shared_workspace

# ============================================
# SUB-OBJECTIVE 6: Archive and Compression
# ============================================
echo -e "${YELLOW}[6/11] Setting up archive tasks...${NC}"

mkdir -p "$EXAM_DIR/6_archive"
cd "$EXAM_DIR/6_archive"

# Create project structure
mkdir -p webapp/{src,config,logs,tmp,public}
echo "main.py" > webapp/src/main.py
echo "utils.py" > webapp/src/utils.py
echo "app.js" > webapp/public/app.js
echo "style.css" > webapp/public/style.css
echo "config.yml" > webapp/config/config.yml
echo "secrets.yml" > webapp/config/secrets.yml
echo "app.log" > webapp/logs/app.log
echo "debug.log" > webapp/logs/debug.log
echo "cache.tmp" > webapp/tmp/cache.tmp
echo "session.tmp" > webapp/tmp/session.tmp

# Set specific timestamps for testing
touch -d "2025-06-01 10:00:00" webapp/src/main.py
touch -d "2025-06-15 14:30:00" webapp/src/utils.py
touch -d "2025-07-01 09:00:00" webapp/config/config.yml

# Create an archive for extraction tasks
mkdir -p backup_data
echo "database.sql" > backup_data/database.sql
echo "users.csv" > backup_data/users.csv
mkdir -p backup_data/attachments
echo "file1.pdf" > backup_data/attachments/file1.pdf
echo "file2.pdf" > backup_data/attachments/file2.pdf
tar -czvf backup.tar.gz backup_data 2>/dev/null
rm -rf backup_data

# ============================================
# SUB-OBJECTIVE 7: Text Files
# ============================================
echo -e "${YELLOW}[7/11] Setting up text editing tasks...${NC}"

mkdir -p "$EXAM_DIR/7_textfiles"
cd "$EXAM_DIR/7_textfiles"

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

# Database settings
db_host=localhost
db_port=3306
db_name=production
db_user=appuser

# Cache settings
cache_enabled=false
cache_ttl=300
EOF

# ============================================
# SUB-OBJECTIVE 8: File Operations
# ============================================
echo -e "${YELLOW}[8/11] Setting up file operation tasks...${NC}"

mkdir -p "$EXAM_DIR/8_files"
cd "$EXAM_DIR/8_files"

mkdir -p source/{documents,images,videos,misc}
echo "Report Q1 2025" > "source/documents/report_q1.txt"
echo "Report Q2 2025" > "source/documents/report_q2.txt"
echo "Report Q3 2025" > "source/documents/report_q3.txt"
echo "Meeting notes" > "source/documents/meeting_notes.txt"
echo "Budget 2025" > "source/documents/budget_2025.xlsx"
dd if=/dev/urandom bs=100 count=1 2>/dev/null | base64 > source/images/photo1.jpg
dd if=/dev/urandom bs=100 count=1 2>/dev/null | base64 > source/images/photo2.jpg
dd if=/dev/urandom bs=100 count=1 2>/dev/null | base64 > source/images/photo3.png
echo "video content" > source/videos/intro.mp4
echo "misc file" > source/misc/notes.txt
echo "temp data" > source/misc/temp.bak
touch source/documents/.hidden_doc

# ============================================
# SUB-OBJECTIVE 9: Links
# ============================================
echo -e "${YELLOW}[9/11] Setting up link tasks...${NC}"

mkdir -p "$EXAM_DIR/9_links"
cd "$EXAM_DIR/9_links"

mkdir -p original
echo "Configuration file v1.0" > original/app.conf
echo "Library content" > original/libcustom.so
echo "Current log data" > original/application.log
chmod 644 original/app.conf
chmod 755 original/libcustom.so
chmod 644 original/application.log

mkdir -p links

# ============================================
# SUB-OBJECTIVE 10: Permissions
# ============================================
echo -e "${YELLOW}[10/11] Setting up permissions tasks...${NC}"

mkdir -p "$EXAM_DIR/10_permissions"
cd "$EXAM_DIR/10_permissions"

mkdir -p project/{bin,data,shared,uploads,config}
echo "#!/bin/bash" > project/bin/run.sh
echo "#!/bin/bash" > project/bin/admin.sh
echo "data content" > project/data/records.db
echo "shared doc" > project/shared/readme.txt
echo "config data" > project/config/settings.ini
echo "secret config" > project/config/credentials.conf

# ============================================
# SUB-OBJECTIVE 11: Documentation
# ============================================
echo -e "${YELLOW}[11/11] Setting up documentation tasks...${NC}"

mkdir -p "$EXAM_DIR/11_documentation"
cd "$EXAM_DIR/11_documentation"

# Create answer files placeholder directory
mkdir -p answers

# ============================================
# Create Instructions File
# ============================================
cat > "$EXAM_DIR/TASKS.txt" << 'TASKFILE'
================================================================================
           RHCSA OBJECTIVE 1: UNDERSTAND AND USE ESSENTIAL TOOLS
                        33 TASKS - 100 POINTS TOTAL
================================================================================

Time Suggested: 90 minutes
Pass Score: 70 points

IMPORTANT:
- Complete tasks in the directories under /exam/objective1/
- Run 'score.sh' to check your progress
- Each task is worth approximately 3 points
- Tasks marked [HARDER] are 20% above standard RHCSA difficulty

================================================================================
SUB-OBJECTIVE 1: ACCESS SHELL AND ISSUE COMMANDS (9 points)
Directory: /exam/objective1/1_shell_commands/
================================================================================

Task 1.1 [HARDER]
Using a SINGLE command with brace expansion, create these files in the current
directory: file_a.txt, file_b.txt, file_c.txt

Task 1.2 [HARDER]
Using command substitution, create a file called 'hostname.txt' that contains
ONLY the system's hostname (no newline issues, just the hostname)

Task 1.3 [HARDER]
Using a single command line, count the total number of .txt files in the 'data'
subdirectory and save ONLY the number to 'count.txt'

================================================================================
SUB-OBJECTIVE 2: INPUT-OUTPUT REDIRECTION (9 points)
Directory: /exam/objective1/2_redirection/
================================================================================

Task 2.1
Run './generate_report.sh' and redirect ONLY the error messages to 'errors.log'
(stdout should still display on screen)

Task 2.2 [HARDER]
Run './generate_report.sh' redirecting stdout to 'stdout.log' and stderr to
'stderr.log' (both in the same command)

Task 2.3 [HARDER]
From 'system.log', extract lines containing "sshd" AND containing "Failed",
then count them, saving only the count number to 'failed_ssh.txt'

================================================================================
SUB-OBJECTIVE 3: GREP AND REGULAR EXPRESSIONS (9 points)
Directory: /exam/objective1/3_grep/
================================================================================

Task 3.1 [HARDER]
From 'users.txt', extract only the usernames (first field before :) of users
who have '/bin/bash' as their shell. Save to 'bash_users.txt' (one per line)

Task 3.2 [HARDER]
From 'network.conf', extract all IP addresses (just the IPs, not the full lines).
Save unique IPs only to 'ip_list.txt', sorted numerically

Task 3.3 [HARDER]
From 'webserver.log', find all requests that resulted in HTTP 4xx or 5xx errors.
Save the full log lines to 'http_errors.log'

================================================================================
SUB-OBJECTIVE 4: ACCESS REMOTE SYSTEMS USING SSH (9 points)
Directory: /exam/objective1/4_ssh/ and /home/examuser/.ssh/
================================================================================

Task 4.1 [HARDER]
As user 'examuser', generate an Ed25519 SSH key pair with:
- No passphrase
- Comment: "examuser@rhcsa-lab"
- Save in the default location (~/.ssh/)

Task 4.2
Create an SSH config file for 'examuser' at ~/.ssh/config with a host alias
'lab' that connects to 127.0.0.1 as user 'examuser'

Task 4.3
Ensure all SSH files for 'examuser' have correct permissions:
- ~/.ssh directory: 700
- Private key: 600
- Public key: 644
- Config file: 600

================================================================================
SUB-OBJECTIVE 5: LOG IN AND SWITCH USERS (9 points)
Directory: /exam/objective1/5_users/
================================================================================

Task 5.1
Switch to user 'examuser' and create a file 'examuser_was_here.txt' in the
5_users directory containing the text "Created by examuser"

Task 5.2 [HARDER]
As user 'examuser', use sudo to create a file 'sudo_test.txt' in /exam/objective1/5_users/
owned by root, containing "Created with sudo"
(Note: examuser has been granted sudo access for this task)

Task 5.3 [HARDER]
Create a file 'shared_workspace/team_file.txt' as user 'examuser' containing
"Team collaboration file". The file must be owned by examuser:developers

================================================================================
SUB-OBJECTIVE 6: ARCHIVE, COMPRESS, UNPACK FILES (9 points)
Directory: /exam/objective1/6_archive/
================================================================================

Task 6.1 [HARDER]
Create 'webapp_src.tar.gz' containing ONLY the 'webapp/src' and 'webapp/public'
directories (not config, logs, or tmp)

Task 6.2 [HARDER]
Create 'webapp_backup.tar.bz2' containing the entire 'webapp' directory but
EXCLUDING all .tmp files and the 'logs' directory

Task 6.3
Extract 'backup.tar.gz' into a new directory called 'restored'

================================================================================
SUB-OBJECTIVE 7: CREATE AND EDIT TEXT FILES (9 points)
Directory: /exam/objective1/7_textfiles/
================================================================================

Task 7.1
Create a new file 'server_info.txt' with exactly these 4 lines:
Hostname: rhcsa-lab
IP: 192.168.100.10
Gateway: 192.168.100.1
DNS: 8.8.8.8

Task 7.2 [HARDER]
Modify 'application.conf':
- Change debug_mode from 'true' to 'false'
- Change log_level from 'INFO' to 'WARNING'
- Change cache_enabled from 'false' to 'true'

Task 7.3
Append a new host entry to 'hosts.local':
192.168.1.50  monitoring

================================================================================
SUB-OBJECTIVE 8: FILE AND DIRECTORY OPERATIONS (9 points)
Directory: /exam/objective1/8_files/
================================================================================

Task 8.1
Copy ALL .txt files from 'source/documents/' to a new directory 'backup/docs/'
(create the directory structure as needed)

Task 8.2 [HARDER]
Move all image files (.jpg and .png) from 'source/images/' to a new directory
'archive/images/' and rename them with prefix 'img_' (e.g., photo1.jpg becomes
img_photo1.jpg)

Task 8.3 [HARDER]
Create this directory structure in a SINGLE command:
  organized/2025/{q1,q2,q3,q4}/reports

================================================================================
SUB-OBJECTIVE 9: CREATE HARD AND SOFT LINKS (9 points)
Directory: /exam/objective1/9_links/
================================================================================

Task 9.1
In the 'links' directory, create a HARD link named 'app.conf.bak' pointing to
'original/app.conf'

Task 9.2 [HARDER]
In the 'links' directory, create a SYMBOLIC link named 'lib' pointing to
'original/libcustom.so' using a RELATIVE path

Task 9.3 [HARDER]
In the 'links' directory, create a SYMBOLIC link named 'current.log' pointing to
'original/application.log' using an ABSOLUTE path

================================================================================
SUB-OBJECTIVE 10: LIST, SET, AND CHANGE PERMISSIONS (10 points)
Directory: /exam/objective1/10_permissions/
================================================================================

Task 10.1
Set permissions on 'project/data/records.db':
- Owner: examuser, Group: examgroup
- Permissions: rw-r----- (640)

Task 10.2 [HARDER]
Set permissions on 'project/bin/run.sh':
- Owner: root, Group: developers
- Permissions: rwxr-x--- with SETGID bit (2750)

Task 10.3 [HARDER]
Set permissions on 'project/uploads/':
- Owner: examuser, Group: examgroup
- Permissions: rwxrwx--- with STICKY bit (1770)

================================================================================
SUB-OBJECTIVE 11: USE SYSTEM DOCUMENTATION (10 points)
Directory: /exam/objective1/11_documentation/answers/
================================================================================

Task 11.1
Using man pages, find which signal number corresponds to SIGKILL.
Save only the number to 'answers/signal_number.txt'

Task 11.2 [HARDER]
Using man pages, find the tar option that preserves SELinux security context.
Save the long option name (e.g., --option-name) to 'answers/tar_selinux.txt'

Task 11.3 [HARDER]
Find the location of the rsyslog documentation in /usr/share/doc.
Save the full directory path to 'answers/rsyslog_doc_path.txt'

================================================================================
                              END OF TASKS
================================================================================

Run: sudo /path/to/score.sh to check your progress

TASKFILE

# Grant sudo access to examuser for specific tasks
cat > /etc/sudoers.d/examuser << 'EOF'
examuser ALL=(ALL) NOPASSWD: /usr/bin/touch, /usr/bin/tee, /bin/touch
EOF
chmod 440 /etc/sudoers.d/examuser

# Set final permissions
chown -R root:root "$EXAM_DIR"
chmod -R 755 "$EXAM_DIR"
chmod 770 "$EXAM_DIR/5_users/shared_workspace"
chown root:developers "$EXAM_DIR/5_users/shared_workspace"

echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}  Environment setup complete!${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "Exam directory: ${BLUE}$EXAM_DIR${NC}"
echo -e "Read tasks:     ${BLUE}cat $EXAM_DIR/TASKS.txt${NC}"
echo -e "Check score:    ${BLUE}sudo ./score.sh${NC}"
echo ""
echo -e "${CYAN}Users created:${NC}"
echo -e "  examuser (password: exam123) - groups: examgroup, developers"
echo -e "  testuser (password: test123) - groups: operators"
echo -e "  admin    (password: admin123)"
echo ""
echo -e "${YELLOW}Good luck!${NC}"
echo ""

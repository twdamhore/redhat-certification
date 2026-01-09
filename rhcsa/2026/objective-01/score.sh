#!/bin/bash
#
# RHCSA Objective 1: Understand and Use Essential Tools
# Scoring Script
#
# Shows task questions + PASS/NOT COMPLETE (no hints on validation)
#
# Run as root: sudo ./score.sh
#

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
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
    echo -e "${RED}Please run as: sudo ./score.sh (from a non-root login)${NC}"
    exit 1
fi

REAL_USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

if [[ -z "$REAL_USER_HOME" ]] || [[ ! -d "$REAL_USER_HOME" ]]; then
    echo -e "${RED}Error: Cannot find home directory for user '$REAL_USER'${NC}"
    exit 1
fi

EXAM_DIR="$REAL_USER_HOME/rhcsa-lab/objective-01"
TOTAL_POINTS=0
MAX_POINTS=100

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run with sudo${NC}"
   exit 1
fi

if [[ ! -d "$EXAM_DIR" ]]; then
    echo -e "${RED}Exam environment not found. Run prepare.sh first.${NC}"
    exit 1
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  RHCSA Objective 1: Scoring${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

show_task() {
    local task=$1
    local pts=$2
    local question=$3
    echo -e "${WHITE}Task $task ($pts pts):${NC} $question"
}

pass_task() {
    local points=$1
    TOTAL_POINTS=$((TOTAL_POINTS + points))
    echo -e "  ${GREEN}[PASS]${NC}"
    echo ""
}

fail_task() {
    echo -e "  ${RED}[NOT COMPLETE]${NC}"
    echo ""
}

# ============================================
# SUB-OBJECTIVE 1: Shell Commands
# ============================================
echo -e "${CYAN}=== Sub-objective 1: Shell Commands ===${NC}"
echo ""
cd "$EXAM_DIR/01_shell" 2>/dev/null

show_task "1.1" "3" "Create files file_a.txt, file_b.txt, file_c.txt"
if [[ -f "file_a.txt" ]] && [[ -f "file_b.txt" ]] && [[ -f "file_c.txt" ]]; then
    pass_task 3
else
    fail_task
fi

show_task "1.2" "3" "Create 'hostname.txt' containing the system hostname"
if [[ -f "hostname.txt" ]]; then
    content=$(cat hostname.txt | tr -d '[:space:]')
    actual=$(hostname | tr -d '[:space:]')
    if [[ "$content" == "$actual" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "1.3" "2" "Count .txt files in 'data/' and save number to 'count.txt'"
if [[ -f "count.txt" ]]; then
    count=$(cat count.txt | tr -d '[:space:]')
    actual=$(ls data/*.txt 2>/dev/null | wc -l)
    if [[ "$count" == "$actual" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "1.4" "2" "Extract DB_NAME value from config/database.conf to 'dbname.txt'"
if [[ -f "dbname.txt" ]]; then
    content=$(cat dbname.txt | tr -d '[:space:]')
    if [[ "$content" == "production" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 2: I/O Redirection
# ============================================
echo -e "${CYAN}=== Sub-objective 2: I/O Redirection ===${NC}"
echo ""
cd "$EXAM_DIR/02_redirection" 2>/dev/null

show_task "2.1" "2" "Run './generate_report.sh' redirecting ONLY stderr to 'errors.log'"
if [[ -f "errors.log" ]]; then
    if grep -q "Error:\|Warning:" errors.log && ! grep -q "Report Generation\|Processing record" errors.log; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "2.2" "3" "Run './generate_report.sh' with stdout to 'stdout.log' and stderr to 'stderr.log'"
if [[ -f "stdout.log" ]] && [[ -f "stderr.log" ]]; then
    if grep -q "Report Generation" stdout.log && grep -q "Error:" stderr.log; then
        if ! grep -q "Error:" stdout.log && ! grep -q "Report Generation" stderr.log; then
            pass_task 3
        else
            fail_task
        fi
    else
        fail_task
    fi
else
    fail_task
fi

show_task "2.3" "2" "Count lines with 'sshd' AND 'Failed' from system.log to 'failed_ssh.txt'"
if [[ -f "failed_ssh.txt" ]]; then
    count=$(cat failed_ssh.txt | tr -d '[:space:]')
    if [[ "$count" == "3" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "2.4" "2" "Sort numbers.txt numerically to 'sorted_numbers.txt'"
if [[ -f "sorted_numbers.txt" ]]; then
    expected=$(sort -n numbers.txt)
    actual=$(cat sorted_numbers.txt)
    if [[ "$expected" == "$actual" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "2.5" "2" "Create 'summary.log' with 'Log analysis complete' and current date"
if [[ -f "summary.log" ]]; then
    if grep -q "Log analysis complete" summary.log && [[ $(wc -l < summary.log) -ge 2 ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 3: grep/regex
# ============================================
echo -e "${CYAN}=== Sub-objective 3: grep and Regular Expressions ===${NC}"
echo ""
cd "$EXAM_DIR/03_grep" 2>/dev/null

show_task "3.1" "2" "Extract usernames of /bin/bash users from users.txt to 'bash_users.txt'"
if [[ -f "bash_users.txt" ]]; then
    count=$(wc -l < bash_users.txt | tr -d '[:space:]')
    if [[ "$count" == "5" ]] && grep -q "jsmith" bash_users.txt && grep -q "developer" bash_users.txt; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "3.2" "3" "Extract unique sorted IPs from network.conf to 'ip_list.txt'"
if [[ -f "ip_list.txt" ]]; then
    ip_count=$(grep -cE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' ip_list.txt 2>/dev/null || echo 0)
    if [[ $ip_count -ge 6 ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "3.3" "2" "Find HTTP 4xx/5xx errors from webserver.log to 'http_errors.log'"
if [[ -f "http_errors.log" ]]; then
    count=$(grep -cE ' (4[0-9]{2}|5[0-9]{2}) ' http_errors.log 2>/dev/null || echo 0)
    if [[ $count -ge 5 ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "3.4" "2" "Count 'ERROR' lines (case insensitive) in logs/ to 'error_count.txt'"
if [[ -f "error_count.txt" ]]; then
    count=$(cat error_count.txt | tr -d '[:space:]')
    if [[ "$count" == "2" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "3.5" "2" "Find users with UID>=1000 AND /bin/bash to 'regular_bash_users.txt'"
if [[ -f "regular_bash_users.txt" ]]; then
    count=$(wc -l < regular_bash_users.txt | tr -d '[:space:]')
    if [[ $count -ge 4 ]] && grep -q "jsmith" regular_bash_users.txt; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "3.6" "2" "Extract valid email addresses from emails.txt to 'valid_emails.txt'"
if [[ -f "valid_emails.txt" ]]; then
    count=$(wc -l < valid_emails.txt | tr -d '[:space:]')
    if [[ $count -ge 4 ]] && grep -q "@" valid_emails.txt; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 4: SSH
# ============================================
echo -e "${CYAN}=== Sub-objective 4: SSH ===${NC}"
echo ""

EXAMUSER_HOME=$(getent passwd examuser | cut -d: -f6)

show_task "4.1" "3" "Generate Ed25519 SSH key for examuser with comment 'examuser@rhcsa-lab'"
if [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519" ]] && [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519.pub" ]]; then
    if grep -q "examuser@rhcsa-lab" "$EXAMUSER_HOME/.ssh/id_ed25519.pub"; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "4.2" "3" "Create ~/.ssh/config with Host 'lab' pointing to 127.0.0.1"
if [[ -f "$EXAMUSER_HOME/.ssh/config" ]]; then
    if grep -qi "Host lab" "$EXAMUSER_HOME/.ssh/config" && grep -q "127.0.0.1\|localhost" "$EXAMUSER_HOME/.ssh/config"; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "4.3" "3" "Set SSH permissions: dir=700, private=600, public=644, config=600"
perms_ok=true
if [[ -d "$EXAMUSER_HOME/.ssh" ]]; then
    [[ "$(stat -c %a "$EXAMUSER_HOME/.ssh")" == "700" ]] || perms_ok=false
    [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519" ]] && [[ "$(stat -c %a "$EXAMUSER_HOME/.ssh/id_ed25519")" == "600" ]] || perms_ok=false
    [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519.pub" ]] && [[ "$(stat -c %a "$EXAMUSER_HOME/.ssh/id_ed25519.pub")" == "644" ]] || perms_ok=false
    [[ -f "$EXAMUSER_HOME/.ssh/config" ]] && [[ "$(stat -c %a "$EXAMUSER_HOME/.ssh/config")" == "600" ]] || perms_ok=false
else
    perms_ok=false
fi
if $perms_ok; then pass_task 3; else fail_task; fi

# ============================================
# SUB-OBJECTIVE 5: Users
# ============================================
echo -e "${CYAN}=== Sub-objective 5: Users ===${NC}"
echo ""
cd "$EXAM_DIR/05_users" 2>/dev/null

show_task "5.1" "2" "As examuser, create 'examuser_was_here.txt' with 'Created by examuser'"
if [[ -f "examuser_was_here.txt" ]]; then
    owner=$(stat -c %U examuser_was_here.txt)
    if [[ "$owner" == "examuser" ]] && grep -q "Created by examuser" examuser_was_here.txt; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "5.2" "3" "As examuser with sudo, create 'sudo_test.txt' owned by root"
if [[ -f "sudo_test.txt" ]]; then
    owner=$(stat -c %U sudo_test.txt)
    if [[ "$owner" == "root" ]] && grep -q "Created with sudo" sudo_test.txt; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "5.3" "2" "Create shared_workspace/team_file.txt owned by examuser:developers"
if [[ -f "shared_workspace/team_file.txt" ]]; then
    owner=$(stat -c %U shared_workspace/team_file.txt)
    group=$(stat -c %G shared_workspace/team_file.txt)
    if [[ "$owner" == "examuser" ]] && [[ "$group" == "developers" ]]; then
        if grep -q "Team collaboration file" shared_workspace/team_file.txt; then
            pass_task 2
        else
            fail_task
        fi
    else
        fail_task
    fi
else
    fail_task
fi

show_task "5.4" "3" "Save 'whoami' and 'id' output to reports/current_user.txt"
if [[ -f "reports/current_user.txt" ]]; then
    if grep -q "examuser" reports/current_user.txt && grep -q "uid=" reports/current_user.txt; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 6: Archive
# ============================================
echo -e "${CYAN}=== Sub-objective 6: Archive ===${NC}"
echo ""
cd "$EXAM_DIR/06_archive" 2>/dev/null

show_task "6.1" "2" "Create webapp_src.tar.gz with ONLY webapp/src and webapp/public"
if [[ -f "webapp_src.tar.gz" ]]; then
    has_src=$(tar -tzf webapp_src.tar.gz 2>/dev/null | grep -c "src/")
    has_public=$(tar -tzf webapp_src.tar.gz 2>/dev/null | grep -c "public/")
    has_config=$(tar -tzf webapp_src.tar.gz 2>/dev/null | grep -c "config/")
    if [[ $has_src -gt 0 ]] && [[ $has_public -gt 0 ]] && [[ $has_config -eq 0 ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "6.2" "3" "Create webapp_backup.tar.bz2 excluding .tmp and logs/"
if [[ -f "webapp_backup.tar.bz2" ]]; then
    has_tmp=$(tar -tjf webapp_backup.tar.bz2 2>/dev/null | grep -c "\.tmp$")
    has_logs=$(tar -tjf webapp_backup.tar.bz2 2>/dev/null | grep -c "/logs/")
    has_src=$(tar -tjf webapp_backup.tar.bz2 2>/dev/null | grep -c "src/")
    if [[ $has_tmp -eq 0 ]] && [[ $has_logs -eq 0 ]] && [[ $has_src -gt 0 ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "6.3" "2" "Extract backup.tar.gz into 'restored/' directory"
if [[ -d "restored" ]]; then
    if [[ -f "restored/backup_data/database.sql" ]] || [[ -f "restored/database.sql" ]] || [[ -d "restored/backup_data" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "6.4" "2" "List backup.tar.gz contents to 'archive_contents.txt'"
if [[ -f "archive_contents.txt" ]]; then
    if grep -q "backup_data" archive_contents.txt || grep -q "database.sql" archive_contents.txt; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "6.5" "2" "Create webapp_config.tar.xz with webapp/config/"
if [[ -f "webapp_config.tar.xz" ]]; then
    if tar -tJf webapp_config.tar.xz 2>/dev/null | grep -q "config"; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 7: Text Files
# ============================================
echo -e "${CYAN}=== Sub-objective 7: Text Files ===${NC}"
echo ""
cd "$EXAM_DIR/07_textfiles" 2>/dev/null

show_task "7.1" "2" "Create server_info.txt with hostname, IP, gateway, DNS"
if [[ -f "server_info.txt" ]]; then
    if grep -q "Hostname: rhcsa-lab" server_info.txt && grep -q "IP: 192.168.100.10" server_info.txt; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "7.2" "3" "Modify application.conf: debug=false, log=WARNING, cache=true"
if [[ -f "application.conf" ]]; then
    if grep -q "debug_mode=false" application.conf && \
       grep -q "log_level=WARNING" application.conf && \
       grep -q "cache_enabled=true" application.conf; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "7.3" "2" "Append '192.168.1.50  monitoring' to hosts.local"
if [[ -f "hosts.local" ]]; then
    if grep -qE "192\.168\.1\.50[[:space:]]+monitoring" hosts.local; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "7.4" "2" "Change sshd_config.sample: PermitRootLogin=no, PasswordAuth=no"
if [[ -f "sshd_config.sample" ]]; then
    if grep -q "PermitRootLogin no" sshd_config.sample && grep -q "PasswordAuthentication no" sshd_config.sample; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 8: File Operations
# ============================================
echo -e "${CYAN}=== Sub-objective 8: File Operations ===${NC}"
echo ""
cd "$EXAM_DIR/08_files" 2>/dev/null

show_task "8.1" "2" "Copy .txt files from source/documents/ to backup/docs/"
if [[ -d "backup/docs" ]]; then
    count=$(ls backup/docs/*.txt 2>/dev/null | wc -l)
    if [[ $count -ge 4 ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "8.2" "3" "Move and rename images to archive/images/ with 'img_' prefix"
if [[ -d "archive/images" ]]; then
    count=$(ls archive/images/img_* 2>/dev/null | wc -l)
    if [[ $count -ge 3 ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "8.3" "2" "Create organized/2025/{q1,q2,q3,q4}/reports structure"
if [[ -d "organized/2025/q1/reports" ]] && [[ -d "organized/2025/q4/reports" ]]; then
    pass_task 2
else
    fail_task
fi

show_task "8.4" "2" "Delete .tmp files in source/temp/ but keep directory"
if [[ -d "source/temp" ]]; then
    tmp_count=$(ls source/temp/*.tmp 2>/dev/null | wc -l)
    if [[ $tmp_count -eq 0 ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "8.5" "2" "Copy hidden files from source/documents/ to hidden_backup/"
if [[ -d "hidden_backup" ]]; then
    count=$(ls -a hidden_backup/ 2>/dev/null | grep '^\.' | grep -v '^\.\.$' | grep -v '^\.$' | wc -l)
    if [[ $count -ge 2 ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 9: Links
# ============================================
echo -e "${CYAN}=== Sub-objective 9: Links ===${NC}"
echo ""
cd "$EXAM_DIR/09_links" 2>/dev/null

show_task "9.1" "2" "Create HARD link links/app.conf.bak to original/app.conf"
if [[ -f "links/app.conf.bak" ]]; then
    orig_inode=$(stat -c %i original/app.conf 2>/dev/null)
    link_inode=$(stat -c %i links/app.conf.bak 2>/dev/null)
    if [[ "$orig_inode" == "$link_inode" ]] && [[ -n "$orig_inode" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "9.2" "3" "Create SYMBOLIC link links/lib to original/libcustom.so.1.0 (relative)"
if [[ -L "links/lib" ]]; then
    target=$(readlink links/lib)
    if [[ "$target" != /* ]] && [[ -f "links/lib" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "9.3" "2" "Create SYMBOLIC link links/current.log (absolute path)"
if [[ -L "links/current.log" ]]; then
    target=$(readlink links/current.log)
    if [[ "$target" == /* ]] && [[ -f "links/current.log" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "9.4" "2" "Create SYMBOLIC link links/libcustom.so pointing to 'lib'"
if [[ -L "links/libcustom.so" ]]; then
    target=$(readlink links/libcustom.so)
    if [[ "$target" == "lib" ]] && [[ -f "links/libcustom.so" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 10: Permissions
# ============================================
echo -e "${CYAN}=== Sub-objective 10: Permissions ===${NC}"
echo ""
cd "$EXAM_DIR/10_permissions" 2>/dev/null

show_task "10.1" "2" "Set project/data/records.db: examuser:examgroup, mode 640"
if [[ -f "project/data/records.db" ]]; then
    o=$(stat -c %U project/data/records.db); g=$(stat -c %G project/data/records.db); p=$(stat -c %a project/data/records.db)
    if [[ "$o" == "examuser" ]] && [[ "$g" == "examgroup" ]] && [[ "$p" == "640" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "10.2" "3" "Set project/bin/run.sh: root:developers, mode 2750 (SETGID)"
if [[ -f "project/bin/run.sh" ]]; then
    o=$(stat -c %U project/bin/run.sh); g=$(stat -c %G project/bin/run.sh); p=$(stat -c %a project/bin/run.sh)
    if [[ "$o" == "root" ]] && [[ "$g" == "developers" ]] && [[ "$p" == "2750" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "10.3" "2" "Set project/uploads/: examuser:examgroup, mode 1770 (STICKY)"
if [[ -d "project/uploads" ]]; then
    o=$(stat -c %U project/uploads); g=$(stat -c %G project/uploads); p=$(stat -c %a project/uploads)
    if [[ "$o" == "examuser" ]] && [[ "$g" == "examgroup" ]] && [[ "$p" == "1770" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "10.4" "2" "Set project/scripts/ and files: group=operators, mode 750"
if [[ -d "project/scripts" ]]; then
    g=$(stat -c %G project/scripts); p=$(stat -c %a project/scripts)
    if [[ "$g" == "operators" ]] && [[ "$p" == "750" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "10.5" "2" "Set project/config/credentials.conf: root:root, mode 600"
if [[ -f "project/config/credentials.conf" ]]; then
    o=$(stat -c %U project/config/credentials.conf); g=$(stat -c %G project/config/credentials.conf); p=$(stat -c %a project/config/credentials.conf)
    if [[ "$o" == "root" ]] && [[ "$g" == "root" ]] && [[ "$p" == "600" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 11: Documentation
# ============================================
echo -e "${CYAN}=== Sub-objective 11: Documentation ===${NC}"
echo ""
cd "$EXAM_DIR/11_docs" 2>/dev/null

show_task "11.1" "2" "Find SIGKILL signal number, save to answers/signal_number.txt"
if [[ -f "answers/signal_number.txt" ]]; then
    num=$(cat answers/signal_number.txt | tr -d '[:space:]')
    if [[ "$num" == "9" ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "11.2" "3" "Find tar SELinux option, save to answers/tar_selinux.txt"
if [[ -f "answers/tar_selinux.txt" ]]; then
    content=$(cat answers/tar_selinux.txt | tr -d '[:space:]')
    if [[ "$content" == "--selinux" ]] || [[ "$content" == "--xattrs" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

show_task "11.3" "2" "Find rsyslog doc path in /usr/share/doc, save to answers/rsyslog_doc.txt"
if [[ -f "answers/rsyslog_doc.txt" ]]; then
    path=$(cat answers/rsyslog_doc.txt | tr -d '[:space:]')
    if [[ "$path" == *"rsyslog"* ]]; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

show_task "11.4" "2" "Find password-related commands with apropos, save to answers/password_commands.txt"
if [[ -f "answers/password_commands.txt" ]]; then
    if [[ -s "answers/password_commands.txt" ]] && grep -qi "pass\|pwd" answers/password_commands.txt; then
        pass_task 2
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# Final Score
# ============================================
echo -e "${BLUE}============================================${NC}"
PERCENTAGE=$((TOTAL_POINTS * 100 / MAX_POINTS))

echo -e "  Score: ${CYAN}$TOTAL_POINTS / $MAX_POINTS${NC} ($PERCENTAGE%)"
echo -e "${BLUE}============================================${NC}"

if [[ $TOTAL_POINTS -ge 70 ]]; then
    echo ""
    echo -e "${GREEN}  *** PASSED ***${NC}"
    echo ""
else
    echo ""
    echo -e "${YELLOW}  Need 70 points to pass${NC}"
    echo ""
fi

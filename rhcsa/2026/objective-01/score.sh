#!/bin/bash
#
# RHCSA Objective 1: Understand and Use Essential Tools
# Scoring Script
#
# Shows: Task question + PASS/NOT COMPLETE
# No hints on how tasks are validated
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

EXAM_DIR="/exam/objective1"
TOTAL_POINTS=0
MAX_POINTS=100

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${NC}"
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
    local question=$2
    echo -e "${WHITE}Task $task:${NC} $question"
}

pass_task() {
    local points=$1
    TOTAL_POINTS=$((TOTAL_POINTS + points))
    echo -e "         ${GREEN}[PASS]${NC}"
    echo ""
}

fail_task() {
    echo -e "         ${RED}[NOT COMPLETE]${NC}"
    echo ""
}

# ============================================
# SUB-OBJECTIVE 1: Shell Commands (9 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 1: Access Shell and Issue Commands ===${NC}"
echo ""
cd "$EXAM_DIR/1_shell_commands" 2>/dev/null

# Task 1.1
show_task "1.1" "Using a SINGLE command with brace expansion, create files: file_a.txt, file_b.txt, file_c.txt"
if [[ -f "file_a.txt" ]] && [[ -f "file_b.txt" ]] && [[ -f "file_c.txt" ]]; then
    pass_task 3
else
    fail_task
fi

# Task 1.2
show_task "1.2" "Create 'hostname.txt' containing ONLY the system's hostname using command substitution"
if [[ -f "hostname.txt" ]]; then
    content=$(cat hostname.txt | tr -d '[:space:]')
    actual_hostname=$(hostname | tr -d '[:space:]')
    if [[ "$content" == "$actual_hostname" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 1.3
show_task "1.3" "Count .txt files in 'data/' subdirectory, save ONLY the number to 'count.txt'"
if [[ -f "count.txt" ]]; then
    count=$(cat count.txt | tr -d '[:space:]')
    actual_count=$(ls data/*.txt 2>/dev/null | wc -l)
    if [[ "$count" == "$actual_count" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 2: I/O Redirection (9 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 2: Input-Output Redirection ===${NC}"
echo ""
cd "$EXAM_DIR/2_redirection" 2>/dev/null

# Task 2.1
show_task "2.1" "Run './generate_report.sh' redirecting ONLY stderr to 'errors.log'"
if [[ -f "errors.log" ]]; then
    if grep -q "Error:\|Warning:" errors.log 2>/dev/null && ! grep -q "Report Generation\|Processing record" errors.log 2>/dev/null; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 2.2
show_task "2.2" "Run './generate_report.sh' with stdout to 'stdout.log' and stderr to 'stderr.log'"
if [[ -f "stdout.log" ]] && [[ -f "stderr.log" ]]; then
    if grep -q "Report Generation" stdout.log 2>/dev/null && grep -q "Error:" stderr.log 2>/dev/null; then
        if ! grep -q "Error:" stdout.log 2>/dev/null && ! grep -q "Report Generation" stderr.log 2>/dev/null; then
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

# Task 2.3
show_task "2.3" "From 'system.log', count lines with both 'sshd' AND 'Failed', save count to 'failed_ssh.txt'"
if [[ -f "failed_ssh.txt" ]]; then
    count=$(cat failed_ssh.txt | tr -d '[:space:]')
    if [[ "$count" == "2" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 3: grep/regex (9 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 3: grep and Regular Expressions ===${NC}"
echo ""
cd "$EXAM_DIR/3_grep" 2>/dev/null

# Task 3.1
show_task "3.1" "From 'users.txt', extract usernames (first field) of users with '/bin/bash' shell to 'bash_users.txt'"
if [[ -f "bash_users.txt" ]]; then
    user_count=$(wc -l < bash_users.txt | tr -d '[:space:]')
    if [[ "$user_count" == "5" ]]; then
        if grep -q "jsmith" bash_users.txt && grep -q "alice" bash_users.txt; then
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

# Task 3.2
show_task "3.2" "From 'network.conf', extract all IP addresses (IPs only), unique and sorted, to 'ip_list.txt'"
if [[ -f "ip_list.txt" ]]; then
    ip_count=$(grep -cE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' ip_list.txt 2>/dev/null || echo 0)
    if [[ $ip_count -ge 6 ]]; then
        sorted_check=$(sort -t. -k1,1n -k2,2n -k3,3n -k4,4n ip_list.txt | uniq)
        actual=$(cat ip_list.txt)
        if [[ "$sorted_check" == "$actual" ]]; then
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

# Task 3.3
show_task "3.3" "From 'webserver.log', find requests with HTTP 4xx or 5xx errors, save full lines to 'http_errors.log'"
if [[ -f "http_errors.log" ]]; then
    error_count=$(grep -cE ' (4[0-9]{2}|5[0-9]{2}) ' http_errors.log 2>/dev/null || echo 0)
    if [[ $error_count -ge 5 ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 4: SSH (9 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 4: Access Remote Systems Using SSH ===${NC}"
echo ""

EXAMUSER_HOME=$(getent passwd examuser | cut -d: -f6)

# Task 4.1
show_task "4.1" "As 'examuser', generate Ed25519 SSH key pair with no passphrase, comment 'examuser@rhcsa-lab'"
if [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519" ]] && [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519.pub" ]]; then
    if grep -q "examuser@rhcsa-lab" "$EXAMUSER_HOME/.ssh/id_ed25519.pub" 2>/dev/null; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 4.2
show_task "4.2" "Create ~/.ssh/config for 'examuser' with Host 'lab' pointing to 127.0.0.1 as user 'examuser'"
if [[ -f "$EXAMUSER_HOME/.ssh/config" ]]; then
    if grep -qi "Host lab" "$EXAMUSER_HOME/.ssh/config" 2>/dev/null; then
        if grep -q "127.0.0.1\|localhost" "$EXAMUSER_HOME/.ssh/config" 2>/dev/null; then
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

# Task 4.3
show_task "4.3" "Set SSH permissions: ~/.ssh (700), private key (600), public key (644), config (600)"
perms_ok=true
if [[ -d "$EXAMUSER_HOME/.ssh" ]]; then
    [[ "$(stat -c %a "$EXAMUSER_HOME/.ssh")" == "700" ]] || perms_ok=false
    [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519" ]] && [[ "$(stat -c %a "$EXAMUSER_HOME/.ssh/id_ed25519")" == "600" ]] || perms_ok=false
    [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519.pub" ]] && [[ "$(stat -c %a "$EXAMUSER_HOME/.ssh/id_ed25519.pub")" == "644" ]] || perms_ok=false
    [[ -f "$EXAMUSER_HOME/.ssh/config" ]] && [[ "$(stat -c %a "$EXAMUSER_HOME/.ssh/config")" == "600" ]] || perms_ok=false
else
    perms_ok=false
fi
if $perms_ok; then
    pass_task 3
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 5: Users (9 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 5: Log in and Switch Users ===${NC}"
echo ""
cd "$EXAM_DIR/5_users" 2>/dev/null

# Task 5.1
show_task "5.1" "As 'examuser', create 'examuser_was_here.txt' containing 'Created by examuser'"
if [[ -f "examuser_was_here.txt" ]]; then
    owner=$(stat -c %U examuser_was_here.txt)
    if [[ "$owner" == "examuser" ]] && grep -q "Created by examuser" examuser_was_here.txt 2>/dev/null; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 5.2
show_task "5.2" "As 'examuser', use sudo to create 'sudo_test.txt' owned by root, containing 'Created with sudo'"
if [[ -f "sudo_test.txt" ]]; then
    owner=$(stat -c %U sudo_test.txt)
    if [[ "$owner" == "root" ]] && grep -q "Created with sudo" sudo_test.txt 2>/dev/null; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 5.3
show_task "5.3" "Create 'shared_workspace/team_file.txt' as examuser, owned by examuser:developers, containing 'Team collaboration file'"
if [[ -f "shared_workspace/team_file.txt" ]]; then
    owner=$(stat -c %U shared_workspace/team_file.txt)
    group=$(stat -c %G shared_workspace/team_file.txt)
    if [[ "$owner" == "examuser" ]] && [[ "$group" == "developers" ]]; then
        if grep -q "Team collaboration file" shared_workspace/team_file.txt 2>/dev/null; then
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

# ============================================
# SUB-OBJECTIVE 6: Archive (9 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 6: Archive, Compress, Unpack Files ===${NC}"
echo ""
cd "$EXAM_DIR/6_archive" 2>/dev/null

# Task 6.1
show_task "6.1" "Create 'webapp_src.tar.gz' containing ONLY 'webapp/src' and 'webapp/public' directories"
if [[ -f "webapp_src.tar.gz" ]]; then
    has_src=$(tar -tzf webapp_src.tar.gz 2>/dev/null | grep -c "src/")
    has_public=$(tar -tzf webapp_src.tar.gz 2>/dev/null | grep -c "public/")
    has_config=$(tar -tzf webapp_src.tar.gz 2>/dev/null | grep -c "config/")
    has_logs=$(tar -tzf webapp_src.tar.gz 2>/dev/null | grep -c "logs/")
    if [[ $has_src -gt 0 ]] && [[ $has_public -gt 0 ]] && [[ $has_config -eq 0 ]] && [[ $has_logs -eq 0 ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 6.2
show_task "6.2" "Create 'webapp_backup.tar.bz2' with 'webapp/' but EXCLUDING .tmp files and logs/ directory"
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

# Task 6.3
show_task "6.3" "Extract 'backup.tar.gz' into a new directory called 'restored'"
if [[ -d "restored" ]]; then
    if [[ -f "restored/backup_data/database.sql" ]] || [[ -f "restored/database.sql" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 7: Text Files (9 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 7: Create and Edit Text Files ===${NC}"
echo ""
cd "$EXAM_DIR/7_textfiles" 2>/dev/null

# Task 7.1
show_task "7.1" "Create 'server_info.txt' with: Hostname: rhcsa-lab, IP: 192.168.100.10, Gateway: 192.168.100.1, DNS: 8.8.8.8"
if [[ -f "server_info.txt" ]]; then
    if grep -q "Hostname: rhcsa-lab" server_info.txt && \
       grep -q "IP: 192.168.100.10" server_info.txt && \
       grep -q "Gateway: 192.168.100.1" server_info.txt && \
       grep -q "DNS: 8.8.8.8" server_info.txt; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 7.2
show_task "7.2" "Modify 'application.conf': debug_mode=false, log_level=WARNING, cache_enabled=true"
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

# Task 7.3
show_task "7.3" "Append to 'hosts.local': 192.168.1.50  monitoring"
if [[ -f "hosts.local" ]]; then
    if grep -qE "192\.168\.1\.50[[:space:]]+monitoring" hosts.local; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 8: File Operations (9 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 8: File and Directory Operations ===${NC}"
echo ""
cd "$EXAM_DIR/8_files" 2>/dev/null

# Task 8.1
show_task "8.1" "Copy ALL .txt files from 'source/documents/' to new directory 'backup/docs/'"
if [[ -d "backup/docs" ]]; then
    txt_count=$(ls backup/docs/*.txt 2>/dev/null | wc -l)
    if [[ $txt_count -ge 4 ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 8.2
show_task "8.2" "Move .jpg and .png from 'source/images/' to 'archive/images/', rename with 'img_' prefix"
if [[ -d "archive/images" ]]; then
    img_count=$(ls archive/images/img_* 2>/dev/null | wc -l)
    if [[ $img_count -ge 3 ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 8.3
show_task "8.3" "Create directory structure: organized/2025/{q1,q2,q3,q4}/reports (single command)"
if [[ -d "organized/2025/q1/reports" ]] && \
   [[ -d "organized/2025/q2/reports" ]] && \
   [[ -d "organized/2025/q3/reports" ]] && \
   [[ -d "organized/2025/q4/reports" ]]; then
    pass_task 3
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 9: Links (9 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 9: Create Hard and Soft Links ===${NC}"
echo ""
cd "$EXAM_DIR/9_links" 2>/dev/null

# Task 9.1
show_task "9.1" "In 'links/', create HARD link 'app.conf.bak' pointing to 'original/app.conf'"
if [[ -f "links/app.conf.bak" ]]; then
    orig_inode=$(stat -c %i original/app.conf 2>/dev/null)
    link_inode=$(stat -c %i links/app.conf.bak 2>/dev/null)
    if [[ "$orig_inode" == "$link_inode" ]] && [[ -n "$orig_inode" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 9.2
show_task "9.2" "In 'links/', create SYMBOLIC link 'lib' to 'original/libcustom.so' using RELATIVE path"
if [[ -L "links/lib" ]]; then
    link_target=$(readlink links/lib)
    if [[ "$link_target" != /* ]] && [[ -f "links/lib" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 9.3
show_task "9.3" "In 'links/', create SYMBOLIC link 'current.log' to 'original/application.log' using ABSOLUTE path"
if [[ -L "links/current.log" ]]; then
    link_target=$(readlink links/current.log)
    if [[ "$link_target" == /* ]] && [[ -f "links/current.log" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 10: Permissions (10 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 10: List, Set, and Change Permissions ===${NC}"
echo ""
cd "$EXAM_DIR/10_permissions" 2>/dev/null

# Task 10.1
show_task "10.1" "Set 'project/data/records.db': owner=examuser, group=examgroup, permissions=640"
if [[ -f "project/data/records.db" ]]; then
    owner=$(stat -c %U project/data/records.db)
    group=$(stat -c %G project/data/records.db)
    perms=$(stat -c %a project/data/records.db)
    if [[ "$owner" == "examuser" ]] && [[ "$group" == "examgroup" ]] && [[ "$perms" == "640" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 10.2
show_task "10.2" "Set 'project/bin/run.sh': owner=root, group=developers, permissions=2750 (SETGID)"
if [[ -f "project/bin/run.sh" ]]; then
    owner=$(stat -c %U project/bin/run.sh)
    group=$(stat -c %G project/bin/run.sh)
    perms=$(stat -c %a project/bin/run.sh)
    if [[ "$owner" == "root" ]] && [[ "$group" == "developers" ]] && [[ "$perms" == "2750" ]]; then
        pass_task 4
    else
        fail_task
    fi
else
    fail_task
fi

# Task 10.3
show_task "10.3" "Set 'project/uploads/': owner=examuser, group=examgroup, permissions=1770 (STICKY)"
if [[ -d "project/uploads" ]]; then
    owner=$(stat -c %U project/uploads)
    group=$(stat -c %G project/uploads)
    perms=$(stat -c %a project/uploads)
    if [[ "$owner" == "examuser" ]] && [[ "$group" == "examgroup" ]] && [[ "$perms" == "1770" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# ============================================
# SUB-OBJECTIVE 11: Documentation (10 points)
# ============================================
echo -e "${CYAN}=== Sub-objective 11: Use System Documentation ===${NC}"
echo ""
cd "$EXAM_DIR/11_documentation" 2>/dev/null

# Task 11.1
show_task "11.1" "Using man pages, find the signal NUMBER for SIGKILL. Save to 'answers/signal_number.txt'"
if [[ -f "answers/signal_number.txt" ]]; then
    num=$(cat answers/signal_number.txt | tr -d '[:space:]')
    if [[ "$num" == "9" ]]; then
        pass_task 3
    else
        fail_task
    fi
else
    fail_task
fi

# Task 11.2
show_task "11.2" "Using man pages, find tar option for SELinux context. Save long option to 'answers/tar_selinux.txt'"
if [[ -f "answers/tar_selinux.txt" ]]; then
    content=$(cat answers/tar_selinux.txt | tr -d '[:space:]')
    if [[ "$content" == "--selinux" ]] || [[ "$content" == "--xattrs" ]] || [[ "$content" == "--xattrs-include"* ]]; then
        pass_task 4
    else
        fail_task
    fi
else
    fail_task
fi

# Task 11.3
show_task "11.3" "Find rsyslog documentation path in /usr/share/doc. Save full path to 'answers/rsyslog_doc_path.txt'"
if [[ -f "answers/rsyslog_doc_path.txt" ]]; then
    path=$(cat answers/rsyslog_doc_path.txt | tr -d '[:space:]')
    if [[ -d "$path" ]] || [[ "$path" == *"rsyslog"* ]]; then
        pass_task 3
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

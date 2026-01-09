#!/bin/bash
#
# RHCSA Objective 1: Understand and Use Essential Tools
# Scoring Script - Validates task completion
#
# Run as root: sudo ./score.sh
#

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Exam directory
EXAM_DIR="/exam/objective1"

# Scoring variables
TOTAL_POINTS=0
MAX_POINTS=100
PASS_THRESHOLD=70

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${NC}"
   exit 1
fi

# Check if exam environment exists
if [[ ! -d "$EXAM_DIR" ]]; then
    echo -e "${RED}Exam environment not found. Run prepare.sh first.${NC}"
    exit 1
fi

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  RHCSA Objective 1: Essential Tools${NC}"
echo -e "${BLUE}  Scoring Script${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Helper function to award points
award_points() {
    local points=$1
    local message=$2
    TOTAL_POINTS=$((TOTAL_POINTS + points))
    echo -e "${GREEN}[+$points] $message${NC}"
}

fail_check() {
    local message=$1
    echo -e "${RED}[FAIL] $message${NC}"
}

info_check() {
    local message=$1
    echo -e "${YELLOW}[INFO] $message${NC}"
}

# ============================================
# TASK 1: I/O Redirection (10 points)
# ============================================
echo -e "${CYAN}=== Task 1: I/O Redirection (10 points) ===${NC}"

cd "$EXAM_DIR/task1_redirection" 2>/dev/null || { fail_check "Task 1 directory not found"; }

# 1a: errors.log should contain only stderr from mixed_output.sh (2 points)
if [[ -f "errors.log" ]]; then
    # Should contain error lines, not stdout lines
    if grep -q "Error:" errors.log && ! grep -q "Starting process" errors.log && ! grep -q "completed successfully" errors.log; then
        award_points 2 "Task 1a: errors.log correctly contains only stderr"
    else
        fail_check "Task 1a: errors.log has incorrect content"
    fi
else
    fail_check "Task 1a: errors.log not found"
fi

# 1b: output.log and errors2.log (2 points)
if [[ -f "output.log" ]] && [[ -f "errors2.log" ]]; then
    if grep -q "Starting process" output.log && grep -q "Error:" errors2.log; then
        if ! grep -q "Error:" output.log 2>/dev/null; then
            award_points 2 "Task 1b: stdout and stderr correctly separated"
        else
            fail_check "Task 1b: output.log should not contain errors"
        fi
    else
        fail_check "Task 1b: Files exist but have incorrect content"
    fi
else
    fail_check "Task 1b: output.log or errors2.log not found"
fi

# 1c: critical.log should have ERROR and CRITICAL lines (2 points)
if [[ -f "critical.log" ]]; then
    error_count=$(grep -c "ERROR\|CRITICAL" critical.log 2>/dev/null || echo 0)
    if [[ $error_count -ge 4 ]]; then
        award_points 2 "Task 1c: critical.log contains ERROR/CRITICAL lines"
    else
        fail_check "Task 1c: critical.log missing ERROR/CRITICAL lines (found $error_count, expected 4+)"
    fi
else
    fail_check "Task 1c: critical.log not found"
fi

# 1d: linecount.txt should contain the number 13 (2 points)
if [[ -f "linecount.txt" ]]; then
    count=$(cat linecount.txt | tr -d '[:space:]')
    if [[ "$count" == "13" ]]; then
        award_points 2 "Task 1d: linecount.txt has correct count"
    else
        fail_check "Task 1d: linecount.txt has wrong count (got: $count, expected: 13)"
    fi
else
    fail_check "Task 1d: linecount.txt not found"
fi

# 1e: warnings_count.txt (2 points)
if [[ -f "warnings_count.txt" ]]; then
    wcount=$(cat warnings_count.txt | tr -d '[:space:]')
    if [[ "$wcount" == "2" ]]; then
        award_points 2 "Task 1e: warnings_count.txt has correct count"
    else
        fail_check "Task 1e: warnings_count.txt has wrong count (got: $wcount, expected: 2)"
    fi
else
    fail_check "Task 1e: warnings_count.txt not found"
fi

# ============================================
# TASK 2: grep and Regular Expressions (15 points)
# ============================================
echo ""
echo -e "${CYAN}=== Task 2: grep and Regular Expressions (15 points) ===${NC}"

cd "$EXAM_DIR/task2_grep" 2>/dev/null || { fail_check "Task 2 directory not found"; }

# 2a: company_emails.txt (2.5 points)
if [[ -f "company_emails.txt" ]]; then
    email_count=$(grep -c "@company.com" company_emails.txt 2>/dev/null || echo 0)
    external_count=$(grep -c "@external" company_emails.txt 2>/dev/null || echo 0)
    if [[ $email_count -ge 6 ]] && [[ $external_count -eq 0 ]]; then
        award_points 2 "Task 2a: company_emails.txt correct"
    else
        fail_check "Task 2a: company_emails.txt incorrect (company: $email_count, external: $external_count)"
    fi
else
    fail_check "Task 2a: company_emails.txt not found"
fi

# 2b: high_earners.txt - salary >= 80000 (2.5 points)
if [[ -f "high_earners.txt" ]]; then
    # Should have: Bob (82000), Charlie (95000), Edward (88000), Helen (92000) = 4 people
    high_count=$(wc -l < high_earners.txt | tr -d '[:space:]')
    if [[ $high_count -ge 4 ]]; then
        award_points 3 "Task 2b: high_earners.txt correct"
    else
        fail_check "Task 2b: high_earners.txt has $high_count lines, expected 4+"
    fi
else
    fail_check "Task 2b: high_earners.txt not found"
fi

# 2c: active_prod.txt - active production servers (2.5 points)
if [[ -f "active_prod.txt" ]]; then
    # Should have servers with :active:production
    active_prod=$(grep -c ":active:production" active_prod.txt 2>/dev/null || echo 0)
    if [[ $active_prod -ge 5 ]]; then
        award_points 2 "Task 2c: active_prod.txt correct"
    else
        fail_check "Task 2c: active_prod.txt has $active_prod lines, expected 5+"
    fi
else
    fail_check "Task 2c: active_prod.txt not found"
fi

# 2d: ip_addresses.txt - unique IPs only (2.5 points)
if [[ -f "ip_addresses.txt" ]]; then
    # Check for IP format and uniqueness
    ip_count=$(grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' ip_addresses.txt | wc -l)
    unique_count=$(grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' ip_addresses.txt | sort -u | wc -l)
    if [[ $ip_count -ge 6 ]] && [[ $ip_count -eq $unique_count ]]; then
        award_points 3 "Task 2d: ip_addresses.txt correct (unique IPs)"
    else
        fail_check "Task 2d: ip_addresses.txt not correct (found $ip_count IPs, $unique_count unique)"
    fi
else
    fail_check "Task 2d: ip_addresses.txt not found"
fi

# 2e: http_errors.txt - 4xx and 5xx errors (2.5 points)
if [[ -f "http_errors.txt" ]]; then
    # Should find 403, 401, 500, 404
    error_count=$(grep -cE '"[^"]*" [45][0-9]{2}' http_errors.txt 2>/dev/null || echo 0)
    if [[ $error_count -ge 4 ]]; then
        award_points 2 "Task 2e: http_errors.txt correct"
    else
        # Try alternate check - just look for error codes
        error_count2=$(grep -cE ' [45][0-9]{2} ' http_errors.txt 2>/dev/null || echo 0)
        if [[ $error_count2 -ge 4 ]]; then
            award_points 2 "Task 2e: http_errors.txt correct"
        else
            fail_check "Task 2e: http_errors.txt has $error_count errors, expected 4"
        fi
    fi
else
    fail_check "Task 2e: http_errors.txt not found"
fi

# 2f: servers_only.txt - non-comment lines (2.5 points)
if [[ -f "servers_only.txt" ]]; then
    comment_lines=$(grep -c '^#' servers_only.txt 2>/dev/null || echo 0)
    server_lines=$(grep -c ':' servers_only.txt 2>/dev/null || echo 0)
    if [[ $comment_lines -eq 0 ]] && [[ $server_lines -ge 10 ]]; then
        award_points 3 "Task 2f: servers_only.txt correct (no comments)"
    else
        fail_check "Task 2f: servers_only.txt has comments or wrong content"
    fi
else
    fail_check "Task 2f: servers_only.txt not found"
fi

# ============================================
# TASK 3: SSH Configuration (10 points)
# ============================================
echo ""
echo -e "${CYAN}=== Task 3: SSH Configuration (10 points) ===${NC}"

EXAMUSER_HOME=$(getent passwd examuser | cut -d: -f6)

# 3a: Ed25519 key pair exists with correct comment (4 points)
if [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519" ]] && [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519.pub" ]]; then
    if grep -q "examuser@rhcsa" "$EXAMUSER_HOME/.ssh/id_ed25519.pub"; then
        award_points 4 "Task 3a: Ed25519 key pair with correct comment"
    else
        award_points 2 "Task 3a: Ed25519 key exists but comment incorrect"
    fi
else
    # Check for any SSH key
    if [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519" ]]; then
        award_points 1 "Task 3a: Ed25519 private key found, missing public key"
    else
        fail_check "Task 3a: Ed25519 key pair not found"
    fi
fi

# 3b: SSH config with Host examserver (3 points)
if [[ -f "$EXAMUSER_HOME/.ssh/config" ]]; then
    if grep -qi "Host examserver" "$EXAMUSER_HOME/.ssh/config" && grep -q "127.0.0.1\|localhost" "$EXAMUSER_HOME/.ssh/config"; then
        award_points 3 "Task 3b: SSH config with Host examserver"
    else
        award_points 1 "Task 3b: SSH config exists but Host examserver not configured correctly"
    fi
else
    fail_check "Task 3b: SSH config not found"
fi

# 3c: Correct permissions (3 points)
perms_correct=0
if [[ -d "$EXAMUSER_HOME/.ssh" ]]; then
    ssh_perms=$(stat -c "%a" "$EXAMUSER_HOME/.ssh")
    if [[ "$ssh_perms" == "700" ]]; then
        ((perms_correct++))
    fi

    if [[ -f "$EXAMUSER_HOME/.ssh/id_ed25519" ]]; then
        key_perms=$(stat -c "%a" "$EXAMUSER_HOME/.ssh/id_ed25519")
        if [[ "$key_perms" == "600" ]]; then
            ((perms_correct++))
        fi
    fi

    if [[ -f "$EXAMUSER_HOME/.ssh/config" ]]; then
        config_perms=$(stat -c "%a" "$EXAMUSER_HOME/.ssh/config")
        if [[ "$config_perms" == "600" ]]; then
            ((perms_correct++))
        fi
    fi

    if [[ $perms_correct -ge 2 ]]; then
        award_points 3 "Task 3c: SSH permissions correct ($perms_correct/3 checked)"
    else
        award_points 1 "Task 3c: Some SSH permissions correct ($perms_correct/3)"
    fi
else
    fail_check "Task 3c: .ssh directory not found"
fi

# ============================================
# TASK 4: Archive and Compression (15 points)
# ============================================
echo ""
echo -e "${CYAN}=== Task 4: Archive and Compression (15 points) ===${NC}"

cd "$EXAM_DIR/task4_archive" 2>/dev/null || { fail_check "Task 4 directory not found"; }

# 4a: project.tar.gz excluding *.key and *.tmp (3 points)
if [[ -f "project.tar.gz" ]]; then
    # Check that secrets.key and cache.tmp are NOT in the archive
    if ! tar -tzf project.tar.gz 2>/dev/null | grep -qE '\.(key|tmp)$'; then
        archive_count=$(tar -tzf project.tar.gz 2>/dev/null | wc -l)
        if [[ $archive_count -gt 5 ]]; then
            award_points 3 "Task 4a: project.tar.gz correct (excludes .key/.tmp)"
        else
            fail_check "Task 4a: project.tar.gz seems incomplete"
        fi
    else
        fail_check "Task 4a: project.tar.gz contains .key or .tmp files"
    fi
else
    fail_check "Task 4a: project.tar.gz not found"
fi

# 4b: project.tar.bz2 with only src/ (3 points)
if [[ -f "project.tar.bz2" ]]; then
    # Should contain only src directory files
    if tar -tjf project.tar.bz2 2>/dev/null | grep -q "src/" && ! tar -tjf project.tar.bz2 2>/dev/null | grep -q "docs/"; then
        award_points 3 "Task 4b: project.tar.bz2 correct (only src/)"
    else
        fail_check "Task 4b: project.tar.bz2 should contain only src/"
    fi
else
    fail_check "Task 4b: project.tar.bz2 not found"
fi

# 4c: extracted_gz/ directory (3 points)
if [[ -d "extracted_gz" ]]; then
    if [[ -f "extracted_gz/extract_source/file1.txt" ]] || [[ -f "extracted_gz/file1.txt" ]]; then
        award_points 3 "Task 4c: source_archive.tar.gz extracted correctly"
    else
        fail_check "Task 4c: extracted_gz/ exists but content missing"
    fi
else
    fail_check "Task 4c: extracted_gz/ directory not found"
fi

# 4d: extracted_xz/file1.txt (3 points)
if [[ -d "extracted_xz" ]]; then
    if [[ -f "extracted_xz/file1.txt" ]]; then
        award_points 3 "Task 4d: file1.txt.xz extracted correctly"
    else
        fail_check "Task 4d: extracted_xz/ exists but file1.txt missing"
    fi
else
    fail_check "Task 4d: extracted_xz/ directory not found"
fi

# 4e: project.tar.xz (3 points)
if [[ -f "project.tar.xz" ]]; then
    if tar -tJf project.tar.xz &>/dev/null; then
        award_points 3 "Task 4e: project.tar.xz created"
    else
        fail_check "Task 4e: project.tar.xz is not a valid xz archive"
    fi
else
    fail_check "Task 4e: project.tar.xz not found"
fi

# ============================================
# TASK 5: File Operations (10 points)
# ============================================
echo ""
echo -e "${CYAN}=== Task 5: File Operations (10 points) ===${NC}"

cd "$EXAM_DIR/task5_files" 2>/dev/null || { fail_check "Task 5 directory not found"; }

# 5a: txt_backup/ with .txt files (2 points)
if [[ -d "txt_backup" ]]; then
    txt_count=$(ls txt_backup/*.txt 2>/dev/null | wc -l)
    if [[ $txt_count -ge 5 ]]; then
        award_points 2 "Task 5a: txt_backup/ has .txt files"
    else
        fail_check "Task 5a: txt_backup/ has only $txt_count .txt files"
    fi
else
    fail_check "Task 5a: txt_backup/ directory not found"
fi

# 5b: database_backups/ with .sql files (2 points)
if [[ -d "database_backups" ]]; then
    sql_count=$(ls database_backups/*.sql 2>/dev/null | wc -l)
    if [[ $sql_count -ge 2 ]]; then
        # Also verify they were moved (not in original location)
        if [[ ! -f "source_files/backups/backup_2025_01.sql" ]]; then
            award_points 2 "Task 5b: .sql files moved to database_backups/"
        else
            award_points 1 "Task 5b: .sql files copied (not moved)"
        fi
    else
        fail_check "Task 5b: database_backups/ has only $sql_count .sql files"
    fi
else
    fail_check "Task 5b: database_backups/ directory not found"
fi

# 5c: organized/{docs,media,config} structure (2 points)
if [[ -d "organized/docs" ]] && [[ -d "organized/media" ]] && [[ -d "organized/config" ]]; then
    award_points 2 "Task 5c: organized/ directory structure correct"
else
    fail_check "Task 5c: organized/{docs,media,config} not found"
fi

# 5d: source_files/.config/ empty but exists (2 points)
if [[ -d "source_files/.config" ]]; then
    file_count=$(ls -A source_files/.config/ 2>/dev/null | wc -l)
    if [[ $file_count -eq 0 ]]; then
        award_points 2 "Task 5d: .config/ emptied but preserved"
    else
        fail_check "Task 5d: .config/ still has $file_count files"
    fi
else
    fail_check "Task 5d: source_files/.config/ directory removed or not found"
fi

# 5e: .jpg renamed to .jpeg (2 points)
if [[ -d "source_files/images" ]]; then
    jpg_count=$(ls source_files/images/*.jpg 2>/dev/null | wc -l)
    jpeg_count=$(ls source_files/images/*.jpeg 2>/dev/null | wc -l)
    if [[ $jpg_count -eq 0 ]] && [[ $jpeg_count -ge 3 ]]; then
        award_points 2 "Task 5e: .jpg files renamed to .jpeg"
    else
        fail_check "Task 5e: jpg:$jpg_count jpeg:$jpeg_count (expected 0 jpg, 3+ jpeg)"
    fi
else
    fail_check "Task 5e: source_files/images/ not found"
fi

# ============================================
# TASK 6: Hard and Soft Links (10 points)
# ============================================
echo ""
echo -e "${CYAN}=== Task 6: Hard and Soft Links (10 points) ===${NC}"

cd "$EXAM_DIR/task6_links" 2>/dev/null || { fail_check "Task 6 directory not found"; }

# 6a: Hard link config.conf.backup (2.5 points)
if [[ -f "targets/config.conf.backup" ]]; then
    orig_inode=$(stat -c "%i" originals/config.conf 2>/dev/null)
    link_inode=$(stat -c "%i" targets/config.conf.backup 2>/dev/null)
    if [[ "$orig_inode" == "$link_inode" ]]; then
        award_points 3 "Task 6a: Hard link config.conf.backup correct"
    else
        fail_check "Task 6a: config.conf.backup is not a hard link (different inodes)"
    fi
else
    fail_check "Task 6a: targets/config.conf.backup not found"
fi

# 6b: Symbolic link lib (relative) (2.5 points)
if [[ -L "targets/lib" ]]; then
    link_target=$(readlink targets/lib)
    if [[ "$link_target" != /* ]] && [[ -f "targets/lib" ]]; then
        award_points 2 "Task 6b: Symbolic link lib (relative)"
    else
        if [[ -f "targets/lib" ]]; then
            award_points 1 "Task 6b: Link lib works but should be relative (got: $link_target)"
        else
            fail_check "Task 6b: Link lib is broken"
        fi
    fi
else
    fail_check "Task 6b: targets/lib not found or not a symlink"
fi

# 6c: Symbolic link app (relative) (2.5 points)
if [[ -L "targets/app" ]]; then
    link_target=$(readlink targets/app)
    if [[ "$link_target" != /* ]] && [[ -f "targets/app" ]]; then
        award_points 2 "Task 6c: Symbolic link app (relative)"
    else
        if [[ -f "targets/app" ]]; then
            award_points 1 "Task 6c: Link app works but should be relative"
        else
            fail_check "Task 6c: Link app is broken"
        fi
    fi
else
    fail_check "Task 6c: targets/app not found or not a symlink"
fi

# 6d: Symbolic link latest.log (absolute) (2.5 points)
if [[ -L "targets/latest.log" ]]; then
    link_target=$(readlink targets/latest.log)
    if [[ "$link_target" == /* ]] && [[ -f "targets/latest.log" ]]; then
        award_points 3 "Task 6d: Symbolic link latest.log (absolute)"
    else
        if [[ -f "targets/latest.log" ]]; then
            award_points 1 "Task 6d: Link latest.log works but should be absolute"
        else
            fail_check "Task 6d: Link latest.log is broken"
        fi
    fi
else
    fail_check "Task 6d: targets/latest.log not found or not a symlink"
fi

# ============================================
# TASK 7: Permissions (20 points)
# ============================================
echo ""
echo -e "${CYAN}=== Task 7: Permissions (20 points) ===${NC}"

cd "$EXAM_DIR/task7_permissions" 2>/dev/null || { fail_check "Task 7 directory not found"; }

# 7.1: public/README.md - examuser:examgroup 644 (3 points)
if [[ -f "shared_project/public/README.md" ]]; then
    owner=$(stat -c "%U" shared_project/public/README.md)
    group=$(stat -c "%G" shared_project/public/README.md)
    perms=$(stat -c "%a" shared_project/public/README.md)
    if [[ "$owner" == "examuser" ]] && [[ "$group" == "examgroup" ]] && [[ "$perms" == "644" ]]; then
        award_points 3 "Task 7.1: README.md permissions correct"
    else
        fail_check "Task 7.1: README.md incorrect (owner:$owner group:$group perms:$perms)"
    fi
else
    fail_check "Task 7.1: README.md not found"
fi

# 7.2: private/data.db - root:root 600 (3 points)
if [[ -f "shared_project/private/data.db" ]]; then
    owner=$(stat -c "%U" shared_project/private/data.db)
    group=$(stat -c "%G" shared_project/private/data.db)
    perms=$(stat -c "%a" shared_project/private/data.db)
    if [[ "$owner" == "root" ]] && [[ "$group" == "root" ]] && [[ "$perms" == "600" ]]; then
        award_points 3 "Task 7.2: data.db permissions correct"
    else
        fail_check "Task 7.2: data.db incorrect (owner:$owner group:$group perms:$perms)"
    fi
else
    fail_check "Task 7.2: data.db not found"
fi

# 7.3: team/project_plan.md - examuser:developers 660 (3 points)
if [[ -f "shared_project/team/project_plan.md" ]]; then
    owner=$(stat -c "%U" shared_project/team/project_plan.md)
    group=$(stat -c "%G" shared_project/team/project_plan.md)
    perms=$(stat -c "%a" shared_project/team/project_plan.md)
    if [[ "$owner" == "examuser" ]] && [[ "$group" == "developers" ]] && [[ "$perms" == "660" ]]; then
        award_points 3 "Task 7.3: project_plan.md permissions correct"
    else
        fail_check "Task 7.3: project_plan.md incorrect (owner:$owner group:$group perms:$perms)"
    fi
else
    fail_check "Task 7.3: project_plan.md not found"
fi

# 7.4: deploy.sh - root:developers 2750 (SETGID) (3 points)
if [[ -f "shared_project/scripts/deploy.sh" ]]; then
    owner=$(stat -c "%U" shared_project/scripts/deploy.sh)
    group=$(stat -c "%G" shared_project/scripts/deploy.sh)
    perms=$(stat -c "%a" shared_project/scripts/deploy.sh)
    if [[ "$owner" == "root" ]] && [[ "$group" == "developers" ]] && [[ "$perms" == "2750" ]]; then
        award_points 3 "Task 7.4: deploy.sh permissions correct (SETGID)"
    else
        fail_check "Task 7.4: deploy.sh incorrect (owner:$owner group:$group perms:$perms, expected 2750)"
    fi
else
    fail_check "Task 7.4: deploy.sh not found"
fi

# 7.5: admin_tool.sh - root:root 4700 (SETUID) (3 points)
if [[ -f "shared_project/scripts/admin_tool.sh" ]]; then
    owner=$(stat -c "%U" shared_project/scripts/admin_tool.sh)
    group=$(stat -c "%G" shared_project/scripts/admin_tool.sh)
    perms=$(stat -c "%a" shared_project/scripts/admin_tool.sh)
    if [[ "$owner" == "root" ]] && [[ "$group" == "root" ]] && [[ "$perms" == "4700" ]]; then
        award_points 3 "Task 7.5: admin_tool.sh permissions correct (SETUID)"
    else
        fail_check "Task 7.5: admin_tool.sh incorrect (owner:$owner group:$group perms:$perms, expected 4700)"
    fi
else
    fail_check "Task 7.5: admin_tool.sh not found"
fi

# 7.6: uploads/ - examuser:examgroup 1770 (STICKY) (3 points)
if [[ -d "shared_project/uploads" ]]; then
    owner=$(stat -c "%U" shared_project/uploads)
    group=$(stat -c "%G" shared_project/uploads)
    perms=$(stat -c "%a" shared_project/uploads)
    if [[ "$owner" == "examuser" ]] && [[ "$group" == "examgroup" ]] && [[ "$perms" == "1770" ]]; then
        award_points 3 "Task 7.6: uploads/ permissions correct (STICKY)"
    else
        fail_check "Task 7.6: uploads/ incorrect (owner:$owner group:$group perms:$perms, expected 1770)"
    fi
else
    fail_check "Task 7.6: uploads/ directory not found"
fi

# 7.7: shared_project/ with SETGID (2 points)
if [[ -d "shared_project" ]]; then
    perms=$(stat -c "%a" shared_project)
    if [[ "${perms:0:1}" == "2" ]] || [[ "$perms" == "2755" ]] || [[ "$perms" == "2775" ]]; then
        award_points 2 "Task 7.7: shared_project/ has SETGID"
    else
        fail_check "Task 7.7: shared_project/ should have SETGID (perms: $perms)"
    fi
else
    fail_check "Task 7.7: shared_project/ not found"
fi

# ============================================
# TASK 8: System Documentation (5 points)
# ============================================
echo ""
echo -e "${CYAN}=== Task 8: System Documentation (5 points) ===${NC}"

cd "$EXAM_DIR/task8_documentation" 2>/dev/null || { fail_check "Task 8 directory not found"; }

# 8.1: answer1.txt - sudoers config file location (1 point)
if [[ -f "answer1.txt" ]]; then
    if grep -qi "sudoers\|/etc/sudoers" answer1.txt; then
        award_points 1 "Task 8.1: sudoers config location found"
    else
        fail_check "Task 8.1: answer1.txt doesn't mention sudoers"
    fi
else
    fail_check "Task 8.1: answer1.txt not found"
fi

# 8.2: answer2.txt - man section for file formats (1 point)
if [[ -f "answer2.txt" ]]; then
    if grep -qE "[5]|five|section 5" answer2.txt; then
        award_points 1 "Task 8.2: Man section 5 correct"
    else
        fail_check "Task 8.2: answer2.txt incorrect (expected section 5)"
    fi
else
    fail_check "Task 8.2: answer2.txt not found"
fi

# 8.3: answer3.txt - tar xattr option (1 point)
if [[ -f "answer3.txt" ]]; then
    if grep -qi "xattr\|--xattrs" answer3.txt; then
        award_points 1 "Task 8.3: tar xattr option found"
    else
        fail_check "Task 8.3: answer3.txt doesn't mention xattr"
    fi
else
    fail_check "Task 8.3: answer3.txt not found"
fi

# 8.4: answer4.txt - default umask (1 point)
if [[ -f "answer4.txt" ]]; then
    if grep -qE "022|0022|umask" answer4.txt; then
        award_points 1 "Task 8.4: umask value found"
    else
        fail_check "Task 8.4: answer4.txt incorrect"
    fi
else
    fail_check "Task 8.4: answer4.txt not found"
fi

# 8.5: answer5.txt - systemd purpose (1 point)
if [[ -f "answer5.txt" ]]; then
    if grep -qi "system\|service\|manager\|init" answer5.txt; then
        award_points 1 "Task 8.5: systemd purpose documented"
    else
        fail_check "Task 8.5: answer5.txt doesn't describe systemd"
    fi
else
    fail_check "Task 8.5: answer5.txt not found"
fi

# ============================================
# TASK 9: Text Editing (5 points)
# ============================================
echo ""
echo -e "${CYAN}=== Task 9: Text Editing (5 points) ===${NC}"

cd "$EXAM_DIR/task9_editing" 2>/dev/null || { fail_check "Task 9 directory not found"; }

# 9.1: server_info.txt created correctly (1.5 points)
if [[ -f "server_info.txt" ]]; then
    if grep -q "Hostname: examserver" server_info.txt && grep -q "192.168.100" server_info.txt; then
        line_count=$(wc -l < server_info.txt)
        if [[ $line_count -ge 4 ]]; then
            award_points 2 "Task 9.1: server_info.txt created correctly"
        else
            award_points 1 "Task 9.1: server_info.txt partial"
        fi
    else
        fail_check "Task 9.1: server_info.txt content incorrect"
    fi
else
    fail_check "Task 9.1: server_info.txt not found"
fi

# 9.2: network_config.txt modified (2 points)
if [[ -f "network_config.txt" ]]; then
    points=0
    if grep -q "bootproto=static" network_config.txt; then ((points++)); fi
    if grep -q "ipaddr=10.0.0.100" network_config.txt; then ((points++)); fi
    if grep -q "netmask=255.255.255.0" network_config.txt; then ((points++)); fi
    if grep -q "server1=1.1.1.1" network_config.txt; then ((points++)); fi
    if grep -q "Modified by examuser" network_config.txt; then ((points++)); fi

    if [[ $points -ge 4 ]]; then
        award_points 2 "Task 9.2: network_config.txt modified correctly"
    elif [[ $points -ge 2 ]]; then
        award_points 1 "Task 9.2: network_config.txt partially modified ($points/5)"
    else
        fail_check "Task 9.2: network_config.txt modifications incomplete ($points/5)"
    fi
else
    fail_check "Task 9.2: network_config.txt not found"
fi

# 9.3: multiline.txt with 10 lines (0.5 points)
if [[ -f "multiline.txt" ]]; then
    line_count=$(wc -l < multiline.txt)
    if [[ $line_count -eq 10 ]] && grep -q "Line 1" multiline.txt && grep -q "Line 10" multiline.txt; then
        award_points 1 "Task 9.3: multiline.txt created correctly"
    else
        fail_check "Task 9.3: multiline.txt has $line_count lines (expected 10)"
    fi
else
    fail_check "Task 9.3: multiline.txt not found"
fi

# ============================================
# Final Score
# ============================================
echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}           FINAL SCORE${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

PERCENTAGE=$((TOTAL_POINTS * 100 / MAX_POINTS))

echo -e "Points: ${CYAN}$TOTAL_POINTS / $MAX_POINTS${NC}"
echo -e "Percentage: ${CYAN}$PERCENTAGE%${NC}"
echo ""

if [[ $PERCENTAGE -ge $PASS_THRESHOLD ]]; then
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}     PASSED! Congratulations!${NC}"
    echo -e "${GREEN}============================================${NC}"
else
    echo -e "${RED}============================================${NC}"
    echo -e "${RED}     NOT PASSED (Need ${PASS_THRESHOLD}% to pass)${NC}"
    echo -e "${RED}============================================${NC}"
fi

echo ""
echo -e "Review the output above to see which tasks need work."
echo ""

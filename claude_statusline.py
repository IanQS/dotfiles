#!/usr/bin/env python3
"""Two-line status line: model/dir/git on line 1, context/limits/cache on line 2."""

import json
import subprocess
import os
import sys
from pathlib import Path

def get_git_info(cwd):
    """Get branch name and dirty status."""
    try:
        # Check if in a git repo
        subprocess.run(
            ['git', '-C', cwd, 'rev-parse', '--git-dir'],
            capture_output=True, check=True
        )
        # Get branch name
        branch = subprocess.check_output(
            ['git', '-C', cwd, '--no-optional-locks', 'branch', '--show-current'],
            text=True, stderr=subprocess.DEVNULL
        ).strip() or 'detached'

        # Check if dirty (has uncommitted changes)
        dirty = subprocess.run(
            ['git', '-C', cwd, '--no-optional-locks', 'diff-index', '--quiet', 'HEAD', '--'],
            capture_output=True
        ).returncode != 0

        return f" {branch}{'*' if dirty else ''}"
    except:
        return ""

def format_directory(cwd, project_dir):
    """Return (project_name, relative_path or current_dir)."""
    cwd_path = Path(cwd)
    project_path = Path(project_dir)

    # Get project name (last folder in project_dir)
    project_name = project_path.name

    try:
        # If inside project, get relative path
        rel = cwd_path.relative_to(project_path)
        rel_str = str(rel)
        # If at project root, return just project name
        if rel_str == '.':
            return project_name, ""
        return project_name, rel_str
    except ValueError:
        # Outside project, show current folder
        return project_name, cwd_path.name

def make_context_bar(pct, width=10):
    """Create a progress bar: [████░░░░░░] 45%"""
    filled = (pct * width) // 100
    empty = width - filled
    bar = '█' * filled + '░' * empty
    return bar

def format_rate_limits(data):
    """Format rate limit percentages."""
    limits = data.get('rate_limits', {})
    parts = []

    five_h = limits.get('five_hour', {}).get('used_percentage')
    if five_h is not None:
        parts.append(f"5h: {int(five_h)}%")

    seven_d = limits.get('seven_day', {}).get('used_percentage')
    if seven_d is not None:
        parts.append(f"7d: {int(seven_d)}%")

    return ' '.join(parts) if parts else ""

def format_cache_info(data):
    """Format prompt cache hit ratio."""
    cache = data.get('prompt_cache', {})
    if cache and cache.get('caching_observed'):
        hit_ratio = cache.get('hit_ratio')
        if hit_ratio is not None:
            pct = int(hit_ratio * 100)
            return f"Cache: {pct}% hits"
    return ""

def line2_builder(data, RESET):
    # Line 2: Context bar, rate limits, cache hit ratio
    ctx_info = ""
    usage = data.get('context_window', {}).get('current_usage')
    if usage:
        current = (usage.get('input_tokens', 0) +
                  usage.get('cache_creation_input_tokens', 0) +
                  usage.get('cache_read_input_tokens', 0))
        size = data.get('context_window', {}).get('context_window_size', 1)
        pct = (current * 100) // size
        bar = make_context_bar(pct)
        ctx_info = f"[{bar}] {pct}%"

    YELLOW = '\033[33m'
    GREEN = '\033[32m'

    rate_limits = format_rate_limits(data)
    cache_info = format_cache_info(data)

    # Build line 2 with available components
    line2_parts = []
    if ctx_info:
        line2_parts.append(f"{YELLOW}{ctx_info}{RESET}")
    if rate_limits:
        line2_parts.append(f"{GREEN}{rate_limits}{RESET}")
    if cache_info:
        line2_parts.append(cache_info)

    return "  |  ".join(line2_parts) if line2_parts else ""



def main():
    data = json.load(sys.stdin)

    # Extract data
    model = data.get('model', {}).get('display_name', 'Model')
    cwd = data['workspace']['current_dir']
    project_dir = data['workspace']['project_dir']

    # Line 1: Model, Project/Directory, Git
    project_name, rel_path = format_directory(cwd, project_dir)
    git_info = get_git_info(cwd)

    CYAN = '\033[36m'
    RESET = '\033[0m'

    # Build line 1: [Model] project_name / rel_path | branch
    line1_parts = [f"{CYAN}[{model}]{RESET}", project_name]
    if rel_path:
        line1_parts.append(rel_path)
    if git_info:
        line1_parts.append(git_info)

    line1 = " | ".join(line1_parts)

    # Output both lines
    line2 = line2_builder(data, RESET)
    print(line1)
    if line2:
        print(line2)

if __name__ == '__main__':
    main()

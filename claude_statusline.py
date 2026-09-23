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
    """Show relative path from project root, or just folder name."""
    cwd_path = Path(cwd)
    project_path = Path(project_dir)

    try:
        # If inside project, show relative path
        rel = cwd_path.relative_to(project_path)
        return str(rel) if str(rel) != '.' else '.'
    except ValueError:
        # Outside project, just show folder name
        return cwd_path.name

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

    # Line 1: Model, Directory, Git
    display_dir = format_directory(cwd, project_dir)
    git_info = get_git_info(cwd)

    CYAN = '\033[36m'
    RESET = '\033[0m'

    line1 = f"{CYAN}[{model}]{RESET}"
    if display_dir != ".":
        line1 = line1 + f"\t Dir: {display_dir}"
    if git_info:
        line1 = line1 + f"\t Git:{git_info}"

    # Output both lines
    line2 = line2_builder(data, RESET)
    print(line1)
    if line2:
        print(line2)

if __name__ == '__main__':
    main()

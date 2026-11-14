"""Summarises failed logons per source address and flags sources that need review.

Usage: python analyze_failed_logons.py failed_logons.csv [threshold]
Input columns: Time, User, Source, LogonType (see scripts/get_failed_logons.ps1).
The result is an indicator only, not proof of an attack.
"""
import csv
import sys
from collections import Counter, defaultdict

DEFAULT_THRESHOLD = 3


def analyze(path):
    attempts = Counter()
    accounts = defaultdict(set)
    with open(path, newline="", encoding="utf-8-sig") as f:
        for row in csv.DictReader(f):
            src = (row.get("Source") or "").strip() or "unknown"
            attempts[src] += 1
            accounts[src].add((row.get("User") or "").strip())
    return attempts, accounts


def classify(n, n_accounts, threshold):
    if n < threshold:
        return "ok", None
    if n_accounts >= 3:
        return "ALERT", "Possible password spraying (one source, several accounts)"
    if n_accounts == 1:
        return "ALERT", "Possible brute force on a single account"
    return "ALERT", "Repeated failures from one source"


def main():
    if len(sys.argv) < 2:
        sys.exit("Usage: python analyze_failed_logons.py failed_logons.csv [threshold]")
    threshold = int(sys.argv[2]) if len(sys.argv) > 2 else DEFAULT_THRESHOLD
    attempts, accounts = analyze(sys.argv[1])
    bar = "=" * 32
    print(bar)
    print("     SECURITY LOG ANALYSIS")
    print(bar)
    for src, n in attempts.most_common():
        status, activity = classify(n, len(accounts[src]), threshold)
        print(f"\nIP Address: {src}")
        print(f"Failed Attempts: {n}")
        print(f"Targeted Accounts: {len(accounts[src])}")
        print(f"Status: {status}")
        if activity:
            print(f"Possible Activity: {activity}")
    print("\n" + bar)
    print("Indicator only, not proof of an attack: review the events manually.")


if __name__ == "__main__":
    main()

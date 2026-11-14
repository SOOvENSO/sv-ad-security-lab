"""Generates a CSV of fictional lab users (First, Last, Sam).

Names are randomly combined from short lists: any resemblance to real people is coincidental.
Usage: python generate_users.py [count] [output.csv]
"""
import csv
import sys

FIRST = ["Sara", "Omar", "Hind", "Yassine", "Salma", "Anas", "Imane", "Karim", "Nadia", "Reda",
         "Zineb", "Amine", "Meryem", "Hamza", "Loubna", "Mehdi", "Khadija", "Ayoub", "Soukaina", "Walid"]
LAST = ["Alami", "Idrissi", "Bennani", "Tazi", "Fassi", "Chraibi", "Berrada", "Lahlou", "Benjelloun", "Kettani",
        "Sebti", "Amrani", "Naciri", "Ouazzani", "Zniber", "Skalli", "Mekouar", "Bennis", "Guessous", "Lamrani"]


def main():
    count = int(sys.argv[1]) if len(sys.argv) > 1 else 1000
    out = sys.argv[2] if len(sys.argv) > 2 else "users_generated.csv"
    with open(out, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["First", "Last", "Sam"])
        for i in range(count):
            first = FIRST[i % len(FIRST)]
            last = LAST[(i // len(FIRST)) % len(LAST)]
            sam = f"{first[0].lower()}.{last.lower()}{i + 1:04d}"  # unique, under 20 characters
            w.writerow([first, last, sam])
    print(f"{count} fictional users written to {out}")


if __name__ == "__main__":
    main()

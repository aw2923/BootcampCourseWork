import sys


def main():
    if len(sys.argv) != 2:
        print("Usage: python3 require_one_argument.py VALUE", file=sys.stderr)
        return 1
    print(f"Received: {sys.argv[1]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
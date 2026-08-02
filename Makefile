.PHONY: lint format format-check test hash-wordlist check-word reveal-wordlist help

# SwiftLint needs a full Xcode toolchain (SourceKit), not bare Command Line Tools.
XCODE_DEVELOPER := $(shell ls -d /Applications/Xcode*.app/Contents/Developer 2>/dev/null | sort | tail -1)
ifneq ($(XCODE_DEVELOPER),)
export DEVELOPER_DIR ?= $(XCODE_DEVELOPER)
endif

WORDLIST_PLAIN ?= Maintainer/en.txt
WORDLIST_HASHES ?= Sources/ProfanityFilter/Resources/WordLists/en.hashes

help:
	@echo "Targets:"
	@echo "  make lint            Run SwiftLint"
	@echo "  make format          Apply SwiftFormat"
	@echo "  make format-check    SwiftFormat --lint (CI)"
	@echo "  make test            Run swift test"
	@echo "  make hash-wordlist   Hash plaintext word list → en.hashes"
	@echo "  make check-word WORD=…  Probe membership in en.hashes"
	@echo "  make reveal-wordlist Show local plaintext word list if present"

lint:
	swiftlint lint --config .swiftlint.yml

format:
	swiftformat .

format-check:
	swiftformat --lint .

test:
	swift test

hash-wordlist:
	@test -f "$(WORDLIST_PLAIN)" || (echo "Missing plaintext list at $(WORDLIST_PLAIN)" >&2; exit 1)
	swift Scripts/hash-wordlist.swift "$(WORDLIST_PLAIN)" "$(WORDLIST_HASHES)"

check-word:
	@test -n "$(WORD)" || (echo "Usage: make check-word WORD=example" >&2; exit 1)
	@test -f "$(WORDLIST_HASHES)" || (echo "Missing $(WORDLIST_HASHES); run make hash-wordlist" >&2; exit 1)
	swift Scripts/check-word.swift "$(WORD)" "$(WORDLIST_HASHES)"

reveal-wordlist:
	@if [ -f "$(WORDLIST_PLAIN)" ]; then \
		cat "$(WORDLIST_PLAIN)"; \
	else \
		echo "No local plaintext at $(WORDLIST_PLAIN) (gitignored)." >&2; \
		exit 1; \
	fi

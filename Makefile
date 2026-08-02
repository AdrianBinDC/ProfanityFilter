.PHONY: lint format format-check test hash-wordlist check-word reveal-wordlist help

# SwiftLint needs a full Xcode toolchain (SourceKit), not bare Command Line Tools.
XCODE_DEVELOPER := $(shell ls -d /Applications/Xcode*.app/Contents/Developer 2>/dev/null | sort | tail -1)
ifneq ($(XCODE_DEVELOPER),)
export DEVELOPER_DIR ?= $(XCODE_DEVELOPER)
endif

help:
	@echo "Targets:"
	@echo "  make lint            Run SwiftLint"
	@echo "  make format          Apply SwiftFormat"
	@echo "  make format-check    SwiftFormat --lint (CI)"
	@echo "  make test            Run swift test"
	@echo "  make hash-wordlist   Hash plaintext word list (engine PR)"
	@echo "  make check-word WORD=…  Probe membership (engine PR)"
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
	@echo "hash-wordlist will be implemented with the censor engine PR." >&2
	@exit 1

check-word:
	@echo "check-word will be implemented with the censor engine PR. WORD='$(WORD)'" >&2
	@exit 1

reveal-wordlist:
	@echo "reveal-wordlist will be implemented with the censor engine PR." >&2
	@exit 1

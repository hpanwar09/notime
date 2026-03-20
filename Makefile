.PHONY: build run install uninstall clean

build:
	swift build -c release

run: build
	./.build/release/notime &

install: build
	@mkdir -p $(HOME)/.local/bin
	@cp .build/release/notime $(HOME)/.local/bin/notime
	@echo ""
	@echo "  notime installed to ~/.local/bin/notime"
	@echo ""
	@echo "  make sure ~/.local/bin is in your PATH:"
	@echo "    export PATH=\"\$$HOME/.local/bin:\$$PATH\""
	@echo ""
	@echo "  then run:  notime"
	@echo ""

uninstall:
	@rm -f $(HOME)/.local/bin/notime
	@launchctl unload ~/Library/LaunchAgents/com.notime.widget.plist 2>/dev/null || true
	@rm -f ~/Library/LaunchAgents/com.notime.widget.plist
	@echo "  notime removed"

autostart:
	@mkdir -p ~/Library/LaunchAgents
	@NOTIME_PATH="$(HOME)/.local/bin/notime"; \
	if [ ! -f "$$NOTIME_PATH" ]; then echo "run 'make install' first"; exit 1; fi; \
	sed "s|__NOTIME_PATH__|$$NOTIME_PATH|g" launchagent.plist > ~/Library/LaunchAgents/com.notime.widget.plist
	@launchctl load ~/Library/LaunchAgents/com.notime.widget.plist
	@echo "  notime will start on login"

clean:
	swift package clean

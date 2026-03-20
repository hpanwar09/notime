.PHONY: build start stop restart install uninstall autostart clean

build:
	@swift build -c release

start: build
	@pkill -x notime 2>/dev/null; sleep 0.3; ./.build/release/notime &
	@echo "  notime started"

stop:
	@pkill -x notime 2>/dev/null && echo "  notime stopped" || echo "  notime not running"

restart: stop start

install: build
	@./build.sh
	@rm -rf /Applications/notime.app
	@cp -r notime.app /Applications/
	@xattr -cr /Applications/notime.app
	@echo "  installed to /Applications/notime.app"
	@echo "  run: open -a notime"

uninstall: stop
	@rm -rf /Applications/notime.app
	@rm -f $(HOME)/.local/bin/notime
	@launchctl unload ~/Library/LaunchAgents/com.notime.widget.plist 2>/dev/null || true
	@rm -f ~/Library/LaunchAgents/com.notime.widget.plist
	@echo "  notime removed"

autostart:
	@mkdir -p ~/Library/LaunchAgents
	@if [ ! -d "/Applications/notime.app" ]; then echo "  run 'make install' first"; exit 1; fi
	@sed "s|__NOTIME_PATH__|/Applications/notime.app/Contents/MacOS/notime|g" launchagent.plist > ~/Library/LaunchAgents/com.notime.widget.plist
	@launchctl load ~/Library/LaunchAgents/com.notime.widget.plist
	@echo "  notime will start on login"

clean:
	@swift package clean
	@rm -rf notime.app notime.zip

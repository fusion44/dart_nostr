
#!/usr/bin/env -S just --justfile

# get all dependencies
install-deps: 
    dart pub get

# (Re-)generate all required code
generate:
	dart run build_runner build --delete-conflicting-outputs



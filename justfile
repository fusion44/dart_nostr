
#!/usr/bin/env -S just --justfile

# get all dependencies
install-deps: 
    dart pub get

# (Re-)generate all required code
generate:
	dart run build_runner build --delete-conflicting-outputs

# Format code and sort imports
format:
    dart run import_sorter:main
    dart run import_path_converter:main
    dart format . --fix
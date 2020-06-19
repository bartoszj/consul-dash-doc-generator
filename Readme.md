Consul Dash Docs Generator
==========================

This projects is based on [packer-dash-doc-generator](https://github.com/bartoszj/packer-dash-doc-generator).

### Installation

```bash
rbenv install 2.5.3
gem install -N bundler
bundle install
```

### Build

To build execute command:

```bash
./build.sh <version>
```

Then move the docset into a proper directory.

### Hints

- Uncomment `sed` line in Rakefile:

    ```
    sh "sed -i '' 's|npm run static\$|bash -c \"npm install; npm run static\"|g' Makefile"
    ```

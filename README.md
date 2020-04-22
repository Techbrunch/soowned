# soowned

TODO

```
SoOwned
    -v, --version                    Show version
    -h, --help                       Show help
    -k KEYWORD, --keyword=KEYWORD    Keyword
    -d DOMAIN, --domain=DOMAIN       Domain
    -D PATH                          Path to a file providing root domain names
    -w PATH                          Wordlist
```

## Installation

```
crystal build src/soowned.cr --release --no-debug -o bin/soowned
```

## Usage

```
./bin/soowned -h
./bin/soowned -d app.test.com -w lists/small.txt
./bin/soowned -D domains.txt -w lists/small.txt
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/soowned/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
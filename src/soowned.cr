require "option_parser"
require "public_suffix"

keyword = ""
domain = ""
path_to_wordlist = ""
path_to_domains = ""
buckets = [] of String

OptionParser.parse do |parser|
  parser.banner = "SoOwned"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.on "-k KEYWORD", "--keyword=KEYWORD", "Keyword" do |opt|
    keyword = opt
  end

  parser.on "-d DOMAIN", "--domain=DOMAIN", "Domain" do |opt|
    domain = opt
  end

  parser.on "-D PATH", "Path to a file providing root domain names" do |opt|
    path_to_domains = opt
  end

  parser.on "-w PATH", "Wordlist" do |opt|
    path_to_wordlist = opt
  end
end

wordlist = [] of String

if File.exists?(path_to_wordlist)
  puts "Got wordlist"
  File.each_line(path_to_wordlist) do |line|
    wordlist << line
  end
end

puts path_to_domains
if File.exists?(path_to_domains)
  puts "Got domains"
  File.each_line(path_to_domains) do |domain|
    puts domain
    buckets.concat(generate_names(domain, wordlist))
  end
else
  buckets.concat(generate_names(domain, wordlist))
end

buckets_file = File.new "buckets.txt", "w"
buckets.each do |bucket|
  buckets_file.puts bucket
end
buckets_file.close

def generate_names(domain, wordlist)
  buckets = [] of String
  puts domain

  begin
    domain_parsed = PublicSuffix.parse(domain) # media.target.com
  rescue
    return buckets
  end

  tld = domain_parsed.tld
  sld = domain_parsed.sld
  trd = domain_parsed.trd

  separators = [".", "-", "_", ""]

  # TODO
  environments = [
    "acc",
    "acceptance",
    "dev",
    "development",
    "prd",
    "prod",
    "production",
    "qa",
    "staging",
    "test",
    "testing",
    "uat",
    "validation",
  ]

  wordlist.each do |word|
    combinations = [
      [word, sld],      # assets-google
      [sld, word],      # google-assets
      [word, sld, tld], # assets-google-com
      [tld, sld, word], # com-google-assets
    ]

    if trd
      combinations << [word, trd, sld, tld] # assets-www-google-com
    end

    combinations.each do |combination|
      separators.each do |separator|
        buckets << combination.join(separator)
      end
    end
  end
  buckets
end

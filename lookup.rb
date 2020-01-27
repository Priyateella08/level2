def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html

  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end
# `domain` contains the domain name we have to look up.

domain = get_command_line_argument
# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines

dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
	record_array=[]
	dns_raw.each do |row|
	column=row.split(",")
	record_array.push(column)
	end
	dns_records = Hash.new do |hash, key|
    	hash[key] = {}
  	end
  	record_arr.each do |column|
    	record_key = (column[0].to_s).strip
    	domain_key = (column[1].to_s).strip
    	dns_records[record_key][domain_key] = (column[2].to_s).strip
  	end
  	return dns_records
end

def resolve(dns_records, lookup_chain, domain)
  	if (dns_records.fetch("CNAME").has_key?(domain))
    	lookup_chain.push(dns_records.fetch("CNAME").fetch(domain))
    	lookup_chain = resolve(dns_records, lookup_chain, lookup_chain.last)
  	else if (dns_records.fetch("A").has_key?(domain))
    	lookup_chain.push(dns_records.fetch("A").fetch(domain))
  	else
    	lookup_chain.push("Error: record not found for " + domain)
   	end
end
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
	
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")


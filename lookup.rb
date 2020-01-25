def get_command_line_argument
 
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end


domain = get_command_line_argument

dns_raw = File.readlines("zone")

def parse_dns(dns_raw)
	arr=Array.new
	dns_raw.each do |row|
	column=row.split(",")
	arr.push(column)
	end
	dns_records = Hash.new do |hash, key|
    	hash[key] = {}
  	end
  	arr.each do |column|
    	record_key = (column[0].to_s).strip
    	sub_key = (column[1].to_s).strip
    	dns_records[record_key][sub_key] = (column[2].to_s).strip
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
	
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")


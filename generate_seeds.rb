

seeds = File.open('./state_country_seeds.rb', 'w')

seeds.write("# encoding: UTF-8\n")

File.open('./countryInfo.txt').each_line do |l|
	next if  /^#/ =~ l

	data = l.split(/\t/)
	name, iso, iso3, iso_name, numcode = data[4], data[0], data[1], data[4], data[2]

	# Spree::Country.create!({"name"=>"Switzerland", "iso3"=>"CH", "iso"=>"CH", "iso_name"=>"CHAD", "numcode"=>"148"}, :without_protection => true)
	seeds.write("Spree::Country.create!({ 'name' => \"#{name}\", 'iso3' => '#{iso3}', 'iso' => '#{iso}', 'iso_name' => \"#{iso_name}\", 'numcode' => '#{numcode}' }, without_protection: true)\n")
end

current_country_iso = ''

File.open('./admin1CodesASCII.txt').each_line do |l|
	data = l.split(/\t/)
	country_state_info = data[0].split('.')
	name, full_name, country_iso, state_iso = data[1], data[2], country_state_info[0], country_state_info[1]
	abbr = "#{country_iso}-#{state_iso}"
	name = full_name if name == ''

	if current_country_iso != country_iso
		current_country_iso = country_iso
		seeds.write("country_id = ActiveRecord::Base.connection.execute(\"SELECT id FROM spree_countries WHERE iso = '%s'\" % '#{country_iso}').first['id']\n")	
	end
	
	seeds.write("Spree::State.create!({ 'name' => \"#{name}\", 'abbr' => '#{abbr}', 'country_id' => country_id }, without_protection: true)\n")
end

seeds.close()
require 'json'

# methods go here
def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  #$report_file = File.new("report.txt", "w+")
end

def print_report_heading
  puts ".oOOOo.          o                   `OooOOo.                                "
  puts "o     o         O                     o     `o                               "
  puts "O.              o                     O      O                            O  "
  puts " `OOoo.         O                     o     .O                           oOo "
  puts "      `O .oOoO' o  .oOo. .oOo         OOooOO'  .oOo. .oOo. .oOo. `OoOo.   o  "
  puts "       o O   o  O  OooO' `Ooo.        o    o   OooO' O   o O   o  o       O  "
  puts "O.    .O o   O  o  O         O        O     O  O     o   O o   O  O       o  "
  puts " `oooO'  `OoO'o Oo `OoO' `OoO'        O      o `OoO' oOoO' `OoO'  o       `oO"
  puts "                                                     O                       "
  puts "                                                     o'                      "
end

def print_date(time)
  puts time.strftime("%A, %B %d, %Y")
end

def print_product_heading
  puts "                     _            _       "
  puts "                    | |          | |      "
  puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  puts "| |                                       "
  puts "|_|                                       " 
end

def print_brand_heading
	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	puts
end

def print_heading
  # Print "Sales Report" in ascii art
  print_report_heading

  # Print today's date
  print_date(Time.now)

  # Print "Products" in ascii art
  print_brand_heading
end

def print_data
  # First we generate the information for the products.
  make_products_section
  
  # Finally we generate the information for the brands  
  make_brands_section
end

def create_report

  print_heading
  
  print_data
  
# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
	# Calculate and print the total amount of sales
	# Calculate and print the average price the toy sold for
	# Calculate and print the average discount (% or $) based off the average sales price

# Print "Brands" in ascii art

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined

end

def print_text(txt)
  puts txt
end
def print_money(val)
  puts "$#{val}"
end

def make_products_section
  # For each product in the data set:
  $products_hash["items"].each do |toy|

    # Print the name of the toy
    print_text (toy["title"])

    # Print the retail price of the toy
    retail_Price = toy["full-price"]
    print_money(retail_Price)
    
    # Calculate and print the total number of purchases
    num_Purchased = toy["purchases"].length
    print_text(num_Purchased)
    
    # Calculate and print the total amount of sales
    total_price = toy["purchases"].inject(0) do |sum, purchase|
      sum + purchase["price"]
    end
    print_money(total_price)
    
    # Calculate and print the average price the toy sold for
    average_price = total_price/num_Purchased
    print_money(average_price)
    
    # Calculate and print the average discount (% or $) based off the average sales price
    discount = retail_Price.to_f  - average_price
    print_money(discount.round(2))
    
  end

end

def make_brands_section
  
  #Get the specific brands
  brands =  $products_hash["items"].map { |item| item["brand"]}.uniq
  
# For each brand in the data set:
  brands.each do |brand| 
    
    puts "Brand #{brand}"
    
    brand_toys = $products_hash["items"].select { |toy| toy["brand"] == brand}
    
    # Count and print the number of the brand's toys we stock
    stock = 0
    brand_toys.each do |toy|
      stock += toy["stock"].to_i
    end
    print_text(stock)
    
    toy_price = 0.0
    # Calculate and print the average price of the brand's toys
    brand_toys.each do |toy|
      toy_price += toy["full-price"].to_f
    end
    print_money((toy_price/stock).round(2))
    
    total_revenue = 0.0
    # Calculate and print the total revenue of all the brand's toy sales combined
    brand_toys.each do |toy|
      
      toy["purchases"].each do |purchase|
        total_revenue += purchase["price"].to_f
      end 
      
    end
    print_money(total_revenue.round(2))
    
  end
end

# start report generation
start # call start method to trigger report generation

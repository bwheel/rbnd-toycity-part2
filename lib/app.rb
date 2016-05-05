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
  $report_file = File.new("report.txt", "w+")
end

def print_report_heading
  $report_file.puts ".oOOOo.          o                   `OooOOo.                                "
  $report_file.puts "o     o         O                     o     `o                               "
  $report_file.puts "O.              o                     O      O                            O  "
  $report_file.puts " `OOoo.         O                     o     .O                           oOo "
  $report_file.puts "      `O .oOoO' o  .oOo. .oOo         OOooOO'  .oOo. .oOo. .oOo. `OoOo.   o  "
  $report_file.puts "       o O   o  O  OooO' `Ooo.        o    o   OooO' O   o O   o  o       O  "
  $report_file.puts "O.    .O o   O  o  O         O        O     O  O     o   O o   O  O       o  "
  $report_file.puts " `oooO'  `OoO'o Oo `OoO' `OoO'        O      o `OoO' oOoO' `OoO'  o       `oO"
  $report_file.puts "                                                     O                       "
  $report_file.puts "                                                     o'                      "
end

def print_date(time)
  $report_file.puts time.strftime("%A, %B %d, %Y")
end

def print_product_heading
  $report_file.puts "                     _            _       "
  $report_file.puts "                    | |          | |      "
  $report_file.puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
  $report_file.puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
  $report_file.puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
  $report_file.puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
  $report_file.puts "| |                                       "
  $report_file.puts "|_|                                       " 
end

def print_brand_heading
	$report_file.puts " _                         _     "
	$report_file.puts "| |                       | |    "
	$report_file.puts "| |__  _ __ __ _ _ __   __| |___ "
	$report_file.puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	$report_file.puts "| |_) | | | (_| | | | | (_| \\__ \\"
	$report_file.puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	$report_file.puts
end

def print_heading
  # Print "Sales Report" in ascii art
  print_report_heading

  # Print today's date
  print_date(Time.now)

  # Print "Products" in ascii art
  print_product_heading
end

def print_data
  # First we generate the information for the products.
  make_products_section
  
  print_brand_heading
  
  # Finally we generate the information for the brands  
  make_brands_section
end

def create_report

  print_heading
  
  print_data
  
#
end


def print_title(txt)
  $report_file.puts "Title: #{txt}"
end

def print_retail_price(txt)
  $report_file.puts "Retail Price: $#{txt}"
end

def print_num_purchased(txt)
  $report_file.puts "Number Purchased: #{txt}"
end

def print_total_sales(txt)
  $report_file.puts "Total Sales: $#{txt}"
end

def print_average_price(txt)
  $report_file.puts "Average Price: $#{txt}"
end

def print_discount(txt)
  $report_file.puts "Discount: $#{txt}"
end

def print_brand(txt)
  $report_file.puts "Brand: #{txt}"
end

def print_brand_stock(txt)
  $report_file.puts "Stock: #{txt}"
end

def print_average_brand_price(txt)
  $report_file.puts "Average Price: $#{txt}"
end

def print_brand_revenue(txt)
  $report_file.puts "Revenue: $#{txt}"
end

def print_line_break
  $report_file.puts
end

def calc_number_purchased(toy)
  toy["purchases"].length
end

def calc_total_sales(toy)
  return toy["purchases"].inject(0) do |sum, purchase|
    sum + purchase["price"]
  end
end

def calc_average_price(total_price, num_Purchased)
  total_price/num_Purchased
end

def calc_discount(retail_Price, average_price)
  (retail_Price.to_f  - average_price).round(2)
end

def calc_brands
  $products_hash["items"].map { |item| item["brand"]}.uniq
end

def calc_brand_toys(brand)
  $products_hash["items"].select { |toy| toy["brand"] == brand}
end

def calc_stock(brand_toys)
  stock = 0
  brand_toys.each do |toy|
    stock += toy["stock"].to_i
  end
  return stock
end

def calc_average_brand_price( brand_toys)
  toy_price = 0
  brand_toys.each do |toy|
    toy_price += toy["full-price"].to_f
  end
  return (toy_price/brand_toys.length).round(2)
  
end

def calc_brand_revenue(brand_toys)
  
  total_revenue = 0.0
  brand_toys.each do |toy|
    toy["purchases"].each do |purchase|
      total_revenue += purchase["price"].to_f
    end 
  end
  
  return total_revenue.round(2)
end

def make_products_section
  # For each product in the data set:
  $products_hash["items"].each do |toy|

    # Print the name of the toy
    print_title(toy["title"])

    # Print the retail price of the toy
    retail_Price = toy["full-price"]
    print_retail_price(retail_Price)
    
    # Calculate and print the total number of purchases
    num_purchased = calc_number_purchased(toy)
    print_num_purchased(num_purchased)
    
    # Calculate and print the total amount of sales
    total_sales = calc_total_sales(toy) 
    print_total_sales(total_sales)
    
    # Calculate and print the average price the toy sold for
    average_price = calc_average_price(total_sales, num_purchased)
    print_average_price(average_price)
    
    # Calculate and print the average discount (% or $) based off the average sales price
    print_discount(calc_discount(retail_Price, average_price))
    
    #add a line here for readability
    print_line_break
  end

end

def make_brands_section
  
  #Get the specific brands
  brands =  calc_brands
  
# For each brand in the data set:
  brands.each do |brand| 
    
    print_brand(brand)
    
    brand_toys = calc_brand_toys(brand)
    
    # Count and print the number of the brand's toys we stock
    print_brand_stock(calc_stock(brand_toys))
    
    # Calculate and print the average price of the brand's toys
    print_average_brand_price(calc_average_brand_price(brand_toys))
    
    # Calculate and print the total revenue of all the brand's toy sales combined
    print_brand_revenue(calc_brand_revenue(brand_toys))
    
    # add a line here for readability
    print_line_break
  end
end

# start report generation
start # call start method to trigger report generation

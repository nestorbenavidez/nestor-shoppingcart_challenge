class ShoppingCart
  BASIC_SALES_TAX_RATE = 10.0
  IMPORT_DUTY_RATE = 5.0
  TAX_EXEMPT_CATEGORIES = ['books', 'food', 'medical']

  def initialize(items)
    @items = items
  end

  def calculate_total
    total_cost = 0
    total_sales_tax = 0

    @items.each do |item|
      sales_tax = calculate_sales_tax(item)
      total_sales_tax += sales_tax
      total_cost += item.price + sales_tax
      puts "#{item.quantity} #{item.name}: #{'%.2f' % (item.price + sales_tax)}"
    end

    puts "Sales Taxes: #{'%.2f' % total_sales_tax}"
    puts "Total: #{'%.2f' % total_cost}"
  end

  private

  def calculate_sales_tax(item)
    sales_tax_rate = 0.0
    sales_tax_rate += BASIC_SALES_TAX_RATE unless item.tax_exempt?
    sales_tax_rate += IMPORT_DUTY_RATE if item.imported?
    sales_tax = item.price * sales_tax_rate / 100
    rounded_tax = (sales_tax / 0.05).ceil * 0.05
    rounded_tax.round(2)
  end
end

class Item
  attr_accessor :name, :price, :quantity

  def initialize(name, price, quantity = 1)
    @name = name
    @price = price
    @quantity = quantity
  end

  def tax_exempt?
    ShoppingCart::TAX_EXEMPT_CATEGORIES.any? { |category| @name.downcase.include?(category) }
  end

  def imported?
    @name.downcase.include?('imported')
  end
end


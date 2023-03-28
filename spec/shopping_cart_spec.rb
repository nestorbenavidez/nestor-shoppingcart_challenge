require 'spec_helper'
require 'shopping_cart'
# shopping_cart_spec.rb


RSpec.describe ShoppingCart do
  describe "#calculate_total" do
    it "calculates the total cost and sales tax for a list of items" do
      items = [
        Item.new("books", 12.49),
        Item.new("music CD", 14.99),
        Item.new("chocolate bar", 0.85)
      ]
      shopping_cart = ShoppingCart.new(items)

      expect { shopping_cart.calculate_total }
        .to output(
              "1 books: 12.49\n" \
          "1 music CD: 16.49\n" \
          "1 chocolate bar: 0.95\n" \
          "Sales Taxes: 1.60\n" \
          "Total: 29.93\n"
            ).to_stdout
    end
  end

  describe "#calculate_sales_tax" do
    it "calculates the sales tax for a non-exempt and non-imported item" do
      item = Item.new("music CD", 14.99)
      shopping_cart = ShoppingCart.new([item])

      expect(shopping_cart.send(:calculate_sales_tax, item)).to eq(1.50)
    end

    it "calculates the sales tax for an exempt item" do
      item = Item.new("books", 12.49)
      shopping_cart = ShoppingCart.new([item])

      expect(shopping_cart.send(:calculate_sales_tax, item)).to eq(0.0)
    end

    it "calculates the sales tax for an imported item" do
      item = Item.new("imported bottle of perfume", 47.50)
      shopping_cart = ShoppingCart.new([item])

      expect(shopping_cart.send(:calculate_sales_tax, item)).to eq(7.15)
    end
  end
end

RSpec.describe Item do
  describe "#tax_exempt?" do
    it "returns true for a tax-exempt item" do
      item = Item.new("books", 12.49)

      expect(item.tax_exempt?).to eq(true)
    end

    it "returns false for a non-exempt item" do
      item = Item.new("music CD", 14.99)

      expect(item.tax_exempt?).to eq(false)
    end
  end

  describe "#imported?" do
    it "returns true for an imported item" do
      item = Item.new("imported bottle of perfume", 47.50)

      expect(item.imported?).to eq(true)
    end

    it "returns false for a non-imported item" do
      item = Item.new("book", 12.49)

      expect(item.imported?).to eq(false)
    end
  end
end

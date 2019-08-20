require_relative 'customer'

class Order
  attr_reader :id
  attr_accessor :customer, :products, :fulfillment_status

  def initialize(id, products, customer, fulfillment_status = :pending)
    
    unless [:pending, :paid, :processing, :shipped, :complete].include? fulfillment_status
      raise ArgumentError
    end

    @id = id
    @products = products
    @customer = customer
    @fulfillment_status = fulfillment_status
  end

  def total
    return 0 if @products.length == 0
    the_sum = @products.values.sum
    the_sum = the_sum*1.075
    the_sum = the_sum.round(2)
    return the_sum
  end

  def add_product(product, price)
    if @products.length == 0
      @products = {product=>price}
    elsif @products.keys.include? product
      raise ArgumentError
    else
      @products[product] = price
    end
  end

  def self.all
    order_array_of_arrays = CSV.read('data/orders.csv').map(&:to_a)
    order_instances = order_array_of_arrays.map do |order_array|
      product_hash = {}
      product_array = order_array[1].split(";")
      product_array.each do |product|
        product_split = product.split(":")
        product_hash[product_split[0]] = product_split[1].to_f
      end

      customer = Customer.find(order_array[2].to_i)
      self.new(order_array[0].to_i, product_hash, customer, order_array[3].to_sym)
    end
    return order_instances
  end

  def self.find(id)
    order_instances = self.all
    the_order = order_instances.find do |order|
      order.id == id
    end
    return the_order
  end


end
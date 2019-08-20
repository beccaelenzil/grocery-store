require 'csv'

class Customer
  attr_accessor :email, :address
  attr_reader :id

  def initialize(id, email, address)
    @id = id
    @email = email
    @address = address
  end

  def self.all
    customer_array_of_arrays = CSV.read('data/customers.csv').map(&:to_a)
    customer_instances = customer_array_of_arrays.map do |customer_array|
      self.new(customer_array[0].to_s.to_i, customer_array[1], {street: customer_array[2], city: customer_array[3], state: customer_array[4], zip: customer_array[5]})
    end
    return customer_instances
  end

  def self.find(id)
    customer_instances = self.all
    the_customer = customer_instances.find do |customer|
      customer.id == id
    end
    return the_customer
  end

end
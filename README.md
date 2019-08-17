# Grocery Store

## At a Glance
- Individual, [stage 2](https://github.com/Ada-Developers-Academy/pedagogy/blob/master/rule-of-three.md) project
- Due before class, **Mon., Aug 26**

## Learning Goals

Skills that should be demonstrated through this project:

- Test-Driven-Development
- Using instance variables and methods
- Object composition
- Reading data from a CSV file

## Objective

We want to write library code that grocery stores would use. We want our library code to be able to keep track of the orders that folks make in the store.

## Getting Started

1. Fork the project master.
1. Clone the forked repo: `$ git clone [YOUR FORKED REPO URL]`
1. `cd` into the dir created `$ cd grocery-store`
1. Run `gem install minitest-skip` to install an extra gem for testing (more on what this actually does later).

### Tests

This is the first project where you'll be writing your own tests. Following the instructions from the [TDD lecture](https://github.com/Ada-Developers-Academy/textbook-curriculum/blob/master/00-programming-fundamentals/intro-to-automated-tests.md), there are three things in our project directory:

```
Rakefile
lib/
specs/
```

Each class you write should get its own file, `lib/class_name.rb`. The specs for that class will be in `specs/class_name_spec.rb`, and you can run all specs using the `rake` command from your terminal.

## Implementation Requirements

### Wave 1

#### Wave 1 Goals
- Create a **class**
- Write **instance methods** inside a **class** to perform actions
- Link two classes using **composition**
- Use exceptions to handle errors
- Verify code correctness by **testing**

#### Testing Requirements in Wave 1
For Wave 1, all tests have been provided for you. For each piece of functionality that you build, you should run the tests from the command line using the `rake` command. To focus on only one test at a time, change all `it` methods to `xit` except for the **one test** you'd like to run. All tests provided should be passing at the end of your work on Wave 1.

#### `Customer` Implementation Requirements

Create a class called `Customer`. Each new Customer should include the following attributes:
- ID, a number
- Email address, a string
- Delivery address, a hash

ID should be _readable_ but not _writable_; the other two attributes can be both read and written.

#### `Order` Implementation Requirements

Create a class called `Order`. Each new Order should include the following attributes:
- ID, a number (read-only)
- A collection of products and their cost. This data will be given as a hash that looks like this:
    ```ruby
    { "banana" => 1.99, "cracker" => 3.00 }
    ```
    - Zero products is permitted (an empty hash)
    - You can assume that there is **only one** of each product
- An instance of `Customer`, the person who placed this order
- A `fulfillment_status`, a symbol, one of `:pending`, `:paid`, `:processing`, `:shipped`, or `:complete`
  - If no `fulfillment_status` is provided, it will default to `:pending`
  - If a status is given that is not one of the above, an `ArgumentError` should be raised

In addition, `Order` should have:
- A `total` method which will calculate the total cost of the order by:
  - Summing up the products
  - Adding a 7.5% tax
  - Rounding the result to two decimal places
- An `add_product` method which will take in two parameters, product name and price, and add the data to the product collection
  - If a product with the same name has already been added to the order, an `ArgumentError` should be raised

### Optional Enhancements
Make sure to write tests for any optionals you implement!

- Add a `remove_product` method to the `Order` class which will take in one parameter, a product name, and remove the product from the collection
  - If no product with that name was found, an `ArgumentError` should be raised

### Wave 2

#### Wave 2 Goals
- Create and use class methods
- Use a CSV file for loading data
- Create your own tests to verify method correctness

#### Testing Requirements in Wave 2
You enter Wave 2 with all tests from Wave 1 passing. In Wave 2, all the tests for `Customer` and one of the specs for `Order` have been provided. The remaining tests are stubbed out in `order_spec.rb`. Filling in these stubs is part of Wave 2.

**When you are done with Wave 2, all your tests from Wave 1 should still pass!**

#### Required `Customer` Updates

Add the following **class methods** to the `Customer` class:
- `self.all` - returns a collection of `Customer` instances, representing all of the Customer described in the CSV file
- `self.find(id)` - returns an instance of `Customer` where the value of the id field in the CSV matches the passed parameter

`Customer.find` should not parse the CSV file itself. Instead it should invoke `Customer.all` and search through the results for a customer with a matching ID.

##### Customer CSV File

Customer data lives in the file `data/customers.csv`. The data in this file has the following columns:

Field       | Type    | Description
---         | ---     | ---
Customer ID | Integer | A unique identifier corresponding to the Customer
Email       | String  | The customer's e-mail address
Address 1   | String  | The customer's street address
City        | String  | The customer's city
State       | String  | The customer's state
Zip Code    | String  | The customer's zip code

**Note:** The columns in the CSV file don't quite match the parameters for the constructor. You'll need to do some work

##### Error Handling

What should your program do if `Customer.find` is called with an ID that doesn't exist? Hint: what does [the `find` method for a Ruby array](https://ruby-doc.org/core/Enumerable.html#method-i-find) do?

#### Required `Order` Updates

Add the following **class methods** to the `Order` class:
- `self.all` - returns a collection of `Order` instances, representing all of the Orders described in the CSV file
- `self.find(id)` - returns an instance of `Order` where the value of the id field in the CSV matches the passed parameter

As before, `Order.find` should call `Order.all` instead of loading the CSV file itself.

##### Order CSV File

Order data lives in the file `data/orders.csv`. The data in this file has the following columns:

Field       | Type    | Description
------------|---------|------------
ID          | Integer | A unique identifier for that Online Order
Products    | String  | The list of products in the following format: `name:price;nextname:nextprice`
Customer ID | Integer | A unique identifier corresponding to a Customer
Status      | String  | A string representing the order's current status

The data in this file is very different than what `Order.new` takes. You will have two big pieces of work here:

1. Parse the list of products into a hash
    - This would be a great piece of logic to put into a helper method
    - You might want to look into Ruby's `split` method
    - We recommend manually copying the first product string from the CSV file and using pry to prototype this logic
1. Turn the customer ID into an instance of `Customer`
    - Didn't you just write a method to do this?

### Optional Enhancements

- `Order.find_by_customer(customer_id)` - returns a **list** of `Order` instances where the value of the customer's ID matches the passed parameter.

### Optional Wave 3: Saving Order Data

Add a new class method to each of `Order` and `Customer` called `save`. The `save` method should take one parameter, a file name, and save the list of objects to that file in the same format as the original CSV file.

When you're done, you should be able to write code like the following:

```
$ pry -r ./lib/customer.rb
pry> Customer.save('new_customer_list.csv')
pry> exit
$ cat new_customer_list.csv
1,leonard.rogahn@hagenes.org,71596 Eden Route,Connellymouth,LA,98872-9105
2,ruben_nikolaus@kreiger.com,876 Kemmer Cove,East Luellatown,AL,21362
[ ... ]
```

We do not require testing for this wave - testing with external resouces like files is tricky to get right. Instead, do some brainstorming: what kind of things would tests need to do, and what error cases would they handle? Why is testing tricky, and what might be done to overcome these problems? How could you learn more about this?

## What We Are Looking For
Check out the [feedback template](feedback.md) to see what instructors will be looking for.

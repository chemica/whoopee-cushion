# whoopee-cushion


When accessing a JSON API the data you get back can be fiddly to work with. It's likely to be a deeply nested hash,
which leads to ugly Ruby code like this:

```ruby
customer_id = api_response['Products'].first['Customer']['CustomerId']
```

You might prefer to use a cleaner, less fiddly and more beautiful syntax, like this:

```ruby
customer_id = api_response.products.first.customer.customer_id
```

The whoopee-cushion gem creates a deep object model from any JSON (or hash) you throw at it. It's faster than using
recursive algorithms based on OpenStructs because it uses Ruby's faster Struct objects under the hood. Because the
conversion of keys to snake case is baked in, the hash tree only needs to be walked once, leading to a further
performance benefit compared to using a combination of gems to obtain the desired result.

## Setup

```ruby
gem install whoopee-cushion
```

or

```ruby
gem "whoopee-cushion"
```

in your Gemfile.

In your Ruby code:

```ruby
require 'whoopee_cushion'
```

## Usage

```ruby
hash = { :a => "first", :CamelCase => "camel", :c => "third", :d => { :e => 4, :camelBackCase => [1, 2, 3, 4, 5] } }
obj = WhoopeeCushion::Inflate.from_hash(hash)

puts obj.a
#=> "first"

obj.camel_case
#=> "camel"

puts obj.d.camel_back_case.first
#=> 1
```

You can also go straight from JSON, or turn off the automatic camel case conversion:

```ruby
json = '{"CamelCase": "no", "json": "yes"}'

obj = WhoopeeCushion::Inflate.from_json(json, :convert_keys => false)

obj.CamelCase
#=> "no"
```

If you have an array, you can use from_array:

```ruby
WhoopeeCushion::Inflate.from_array([1, 2, 3, { a => 4, b => 5 }])
#=> [1, 2, 3, #<struct a=4, b=5>]
```

If you're not sure whether you have an array or a hash for some reason, use from_object:

```ruby
WhoopeeCushion::Inflate.from_object([1, 2, 3, { a:4, b:5 }])
#=> [1, 2, 3, #<struct a=4, b=5>]

WhoopeeCushion::Inflate.from_object({a:4, b:5})
#=> #<struct a=4, b=5>
```

If you want to carry out your own string conversion for the keys, use a lambda:

```ruby
hash = { :a => 1, :CamelCase => 2, :c => 3, :d => { :e => 4, :f => [:a, :b, :c, :d, :e] } }

obj = WhoopeeCushion::Inflate.from_hash(hash, :convert_keys => lambda { |s| "#{s}_foo" })

obj.a_foo
#=> 1

obj.CamelCase_foo
#=> 2

obj.d_foo.f_foo.first
#=> :a
```

Type less stuff:

```ruby
include WhoopeeCushion

Inflate.from_hash({ a: 1 })
#=> #<struct a=1>
```

## Performance

Check the project out, bundle it and run the simple `rake benchmark` suite to see some figures. Comparisons are made
against the recursive-open-struct gem and simple OpenStruct creates. The whoopee-cushion gem performs very well against
both when not converting strings to snake case (quite an expensive operation, using a stripped-down version of the
Rails 'underscore' method.) When converting strings the performance increase is diminished, but it still comes out well.

If you can increase performance (or otherwise improve the gem in any way) please fork it and issue a pull request.

## Limitations

If your JSON has numerical keys, you won't be able to access them using dot notation for obvious reasons. In this case
you can `send` the key to the object instead.

```ruby
a = WhoopeeCushion::Inflate.from_hash({ 1=>2 })
#=> #<struct :"1"=2>

a.1
SyntaxError: (irb):113: no .<digit> floating literal anymore; put 0 before dot

a.send('1')
#=> 2
```

Also, this is a highly dynamic operation. If you use an IDE it will almost certainly complain about missing methods.

## What next?

The next feature on the cards is the ability to add abstract behaviour to particular objects using modules.
Calculated fields, mix-ins etc.

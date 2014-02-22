whoopee-cushion
===============

Imagine the scene. You're accessing a nice JSON API, but the data you get back is difficult to work with. There are a
number of reasons why this is, but mainly it's because you're dealing with a giant hash, using camel case for keys.

It all leads to ugly, unreadable Ruby code like this:

`obj['Products'].first['Customer']['CustomerId']`

Wouldn't it be nice if you could access all your API response data like this?

`obj.products.first.customer.customer_id`

whoopee-cushion will let you do just that. It's faster than using OpenStructs or any recursive algorithms based on them
because it uses Ruby's faster Struct objects under the hood.

Setup
=====

`gem install whoopee-cushion`

or

`gem "whoopee-cushion"`

in your Gemfile.

In your Ruby code:

`require 'whoopee_cushion'`

then

`hash = {:a => 1, :CamelCase => 2, :c => 3, :d => { :e => 4, :f => [1,2,3,4,5]}}

obj = WhoopeeCushion::Inflate.from_hash(hash)

puts obj.a
puts obj.camel_case
puts obj.d.f.first`

You can also go straight from JSON, or turn off the automatic camel case conversion:

`json = '{"CamelCase": "no", "json": "yes"}

obj = WhoopeeCushion::Inflate.from_json(json, :to_snake_keys => false)

puts obj.CamelCase`

Have fun.
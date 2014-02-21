whoopee-cushion
===============

Imagine the scene. You're accessing a nice JSON API, but the data you get back is difficult to work with. There are a
number of reasons why this is, but mainly it's because you're dealing with a giant hash, using camel case for keys.

It all leads to ugly, unreadable Ruby code like this:

`obj['Products'].first['Customer']['CustomerId']`

Wouldn't it be nice if you could access all your API response data like this?

`obj.products.first.customer.customer_id`

whoopee-cushion will let you do just that. It's a fast and
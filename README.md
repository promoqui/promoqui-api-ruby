# PromoQui API Wrapper for Ruby

This library is for internal use only. It serves as an helper for Ruby developers when interacting with the PromoQui REST API for Crawlers.

The Settings class allows you to set the URL of the API domain.

You should not attempt to use this library against the official PromoQui API domain without permission from PromoQui SPA. Feel free however, to use it for your own projects and to report any problem you may find.

# Setup

First of all, configure the library to use your provided api host and key:

```ruby
PQSDK::Settings.host = 'api.promotest.dev'
PQSDK::Settings.app_secret = 'sup3rs3cr3t'
```

The PromoQui REST API requires the app secret to be exchanged with a token with a duration of 3 hours. All the Token exchange and renovation is handled internally by the library, so that you can completely ignore it.

# Working with cities

```ruby
city = PQSDK::City.find_or_create('Rome')
```

That line of code will interrogate the PromoQui database for that City, eventually creating it if not found, and will return a City object, containing all the details like: latitude, longitude, inhabitants and most importantly the City ID.

# Working with stores

```ruby
store = PQSDK::Store.find('Via Roma, 32', '80100')
if store.nil?
  store = PQSDK::Store.new
  # Set all the store details (including opening hours)
  store.save
end
```

That code will interrogate the database for a store at that address, with that zipcode, among the stores for the retailer we were assigned. If a store was not found, it will create it.

# Working with leaflets

```ruby
leaflet = PQSDK::Leaflet.find(url)
if leaflet.nil?
  leaflet = PQSDK::Leaflet.new
  leaflet.name = 'Nice leaflet'
  leaflet.url = url
  leaflet.store_ids = [ store.id ]
  leaflet.save
end
```

That code will try to find a leaflet with the same url (to avoid inserting it again). If it is not found it will create a new leaflet. Pay attention at the `store_ids` field. It must be an array of valid store ids, for which the leaflet is valid.

A few seconds after the creation, the PromoQui infrastructure will begin to parse and upload the leaflet pages to the website.

If you do not dispose of a valid GET url from which the leaflet can be taken, but you are however able to obtain a binary version of the leaflet (raw PDF data bytes), you can still upload it like this:

```ruby
leaflet = PQSDK::Leaflet.new
leaflet.url = url # Set to a significant URL to avoid repetitions
leaflet.store_ids = [ store.id ]
leaflet.pdf_data = binary_blob
leaflet.save
```

# Have a nice day

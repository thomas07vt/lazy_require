# LazyRequire
[![Code Climate](https://codeclimate.com/github/thomas07vt/lazy_require/badges/gpa.svg)](https://codeclimate.com/github/thomas07vt/lazy_require)

Isn't it annoying when you try to load one file that is dependent on another file that hasn't been loaded yet?
**LazyRequire** lets you require all your project files without worrying about the load order.

It has a similar function to the Rails autoloader, but is much simpler.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lazy_require'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lazy_require



## Usage
Given this folder structure:

```terminal
app_root
  |- lib/
    |- first.rb
    |- second.rb
  |- app.rb
```

If you have files like these inside lib:
```ruby
# first.rb
# The First class depends on the Second class
class First < Second
end
```

```ruby
# second.rb
class Second
  # Does something special
end
```

You might want to load all files inside your lib directory from the app.rb root file.
Doing something like this could easily fail if load order matters:
```ruby
# App.rb

# This might cause issues
Dir['./lib/**/*.rb'].each { |file| require file }

class App
  # Some stuff here
end
```

In the above files, its required to load the "second.rb" file prior to the "first.rb" file.
You could add a line like this, explicitly adding the require line:

```ruby
# first.rb

require_relative './second.rb'
# The First class depends on the Second class
class First < Second
end
```

But that can get cumbersome, especially when you start moving or renaming files in your project.

With **LazyRequire**, you can ask it to load all the files in your project/folder, without having to think about the load order. If **LazyRequire** tries to load a file, which has an unloaded dependency, it will simply skip that file and try again later. So your app.rb file can look something like this:

```ruby
# App.rb

LazyRequire.load_all('./lib/**/*.rb')

class App
  # Some stuff here
end
```

**LazyRequire.load_all()** accepts any glob pattern and will try to require all files that it finds with that glob pattern. If it it successfully loads all files it will return true:

```ruby
2.3.0 :010 >   LazyRequire.load_all('./spec/support/load_all/**/*.rb')
#=> true 
```

If it cannot load any of the files, it will raise an exception:

```ruby
2.3.0 :006 > LazyRequire.load_all('./spec/support/errors/**/*.rb')
RuntimeError: Could not load files: 
./spec/support/errors/top_two.rb
./spec/support/errors/top.rb

	from ../code/lazy_require/lib/lazy_require.rb:12:in `load'
	from ../code/lazy_require/lib/lazy_require.rb:22:in `load_all'
	from (irb):6
```

If you want to load a specific collection of files and avoid using the glob pattern, you can do that to using the #load() method.

```ruby
files = [
  './spec/support/errors/top_two.rb',
  './spec/support/errors/top.rb',
]

LazyRequire.load(files)
#=> true
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thomas07vt/lazy_require.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


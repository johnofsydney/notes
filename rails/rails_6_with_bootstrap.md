# Rails 6 with Bootstrap and Webpacker
#### Steps for getting bootstrap into a Rails 6 project using webpacker

Follow the steps below. For further info read the links at the bottom

## Make the project
```
$ rails new rails_6_with_bootstrap -T --skip-turbolinks
$ $ cd rails_6_with_bootstrap
```

### Add the new, main CSS file in the javascript folder
```
$ mkdir app/javascript/stylesheets
$ touch app/javascript/stylesheets/application.scss
```

### Add a view page and controller
```
$ mkdir app/views/home
$ touch app/views/home/index.html.erb
$ touch app/controllers/home_controller.rb
```

### Add a route to home
#### config/routes.rb
```
root to: 'home#index'
```

### Add home controller action
#### app/controllers/home_controller.rb
```
class HomeController < ApplicationController
  def index; end
end
```

### Add some content to your home page
#### app/views/home/index.html.erb
```
<h1>Welcome to bootstrap</h1>
```
---


## Add dependencies using yarn
```
$ yarn add jquery
$ yarn add popper.js
$ yarn add bootstrap

# to use materialize css swap the last line for
# $ yard add materialize
```

## Modify the application.html.erb thusly
#### app/views/layouts/application.html.erb
```
<%= stylesheet_pack_tag 'application', media: 'all' %>
<%= javascript_pack_tag 'application' %>
```

## import the new stylesheet into application.js manifest
#### app/javascript/packs/application.js
```
import '../stylesheets/application'
```

## import bootstrap into the new stylesheet application.scss
####  app/javascript/stylesheets/application.scss
```
@import "~bootstrap/scss/bootstrap";

# or use
# @import 'materialize-css/dist/css/materialize';
# for materialize css
```

## Ammend web pack config as follows
#### config/webpack/environment.js
```
const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.prepend(
  "Provide",
  new webpack.ProvidePlugin({
    $: "jquery/src/jquery",
    jQuery: "jquery/src/jquery",
    Popper: ["popper.js", "default"]
  })
);

module.exports = environment
```



## Further reading
_This note is based on these articles_

[by @adrian_teh on medium](https://medium.com/@adrian_teh/ruby-on-rails-6-with-webpacker-and-bootstrap-step-by-step-guide-41b52ef4081f)

[by @guilhermepejon on medium (bootstrap)](https://medium.com/@guilhermepejon/how-to-install-bootstrap-4-3-in-a-rails-6-app-using-webpack-9eae7a6e2832)

[by @guilhermepejon on medium (materialize)](https://medium.com/@guilhermepejon/how-to-install-materialize-css-in-rails-6-0-0-beta2-using-webpack-347c03b7104e)







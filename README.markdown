Sequencescape Client API
========================

Usage
-----

Pretty simple:

* First you need a connection to the server
* Then you need to retrieve the model you want to work with from it
* Before doing something

In code:

    api = Sequencescape::Api.new(:url => 'the server URL', :cookie => 'your sign on cookie')
    first_submission = api.submission.first
    last_submission  = api.submission.last
    first_submission.requests.all == last_submission.requests.all

Or something like that!

You can control the 'namespace' that the API uses for class lookups using the `:namespace` option and passing the module/class.  For instance,
by default the code looks in the Sequencescape module, which would be:

    api = Sequencescape::Api.new(:namespace => Sequencescape)

If you're in a Rails environment then:

    class ApplicationController < ActionController::Base
      include Sequencescape::Api::Rails::ApplicationController
    end

Every request will then get it's own API instance available through `api` based on the browser cookie sent.

You can add extra options to the initialisation of the API by defining the `extra_options` method and returning a hash.

If you want to declare a model that can be instantiated then:

* It must exist in the Sequencescape namespace (sorry, limitation for the moment)
* It should extend Sequencescape::Api::Resource
* And you can use has_many and belongs_to like you would on an ActiveRecord model

In code:

    class Sequencescape::MyModel < Sequencescape::Api::Resource
      has_many :submissions, :class_name => 'Sequencescape::Submission'
      belongs_to :user, :class_name => 'Sequencescape::User'
    end

Instances must be accessed through the API instance, i.e.:

    instance_of_my_model = api.my_model.find('UUID of instance')


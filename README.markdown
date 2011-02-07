Sequencescape Client API
========================

Usage within a Rails application
--------------------------------
NOTE: You must be using Rails 3.x for this gem to work.

In your Gemfile write: 

    gem 'sequencescape-client-api', :git => 'https://github.com/sanger/sequencescape-client-api.git', :require => 'sequencescape'

In your app/controllers/application.rb write:

    class ApplicationController < ActionController::base
      include ::Sequencescape::Api::Rails::ApplicationController
      ::Sequencescape::Api::ConnectionFactory.default_url = 'http://server:port/api/1/'
    end

If you need to set more options on the initial API construction simply define a method called `extra_options` in your ApplicationController and return a hash containing them (symbol keys please).

In your model controller you can now do:

    class SubmissionsController < ApplicationController
      def index
        @submissions = api.submission.all
      end
    end

Usage from the console
----------------------

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

Extending the basic models
--------------------------
By default the Sequencescape::Api class will lookup model classes from the Sequencescape namespace.  If you need more than just this default behaviour, for example you need to add extra information contained within a DB, then you need to extend these classes.  As an example, imagine that you wanted to add a message to every batch that was returned from the server; you could do:

    class MySpecific::Batch < Sequencescape::Batch
      def message_details
        @message_details = Message.find_by_uuid(self.uuid) || Message.new(:uuid => self.uuid)
      end
    end

You then only need to pass the `:namespace => MySpecific` option to the API initializer; in a Rails environment you'd do:

    class ApplicationController
      def extra_options
        { :namespace => MySpecific }
      end
    end

You only need to extend the classes you are interested in: all others will be picked up from the namespace.

Adding more models
------------------
If you want to declare a model that can be instantiated then:

* It should extend Sequencescape::Api::Resource
* And you can use has_many and belongs_to like you would on an ActiveRecord model

In code:

    class Sequencescape::MyModel < Sequencescape::Api::Resource
      has_many :submissions, :class_name => 'Sequencescape::Submission'
      belongs_to :user, :class_name => 'Sequencescape::User'
    end

Instances must be accessed through the API instance, i.e.:

    instance_of_my_model = api.my_model.find('UUID of instance')


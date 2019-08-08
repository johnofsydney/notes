
# RSpec

General overview: http://www.betterspecs.org/
When to use `let`: https://stackoverflow.com/questions/5359558/when-to-use-rspec-let/5359979#5359979
matchers: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/

---


### build vs create

The create() method persists the instance of the model while the build()method keeps it only on memory.
Personally, I use the create() method only when persistence is really necessary since writing to DB makes testing time consuming.
e.g.
I create users to authentication with create() because my authentication engine queries the DB.
To check if a model has an attribute the build() method will do because no DB access is required.

---

Using FactoryGirl.build(:factory_name) does not persist to the db and does not call save!, so your Active Record validations will not run. This is much faster, but validations might be important.
Using FactoryGirl.create(:factory_name) will persist to the db and will call Active Record validations. This is obviously slower but can catch validation errors (if you care about them in your tests).


```ruby
describe "#method_in_code" do
    subject(:perform) { method_in_code( event: event, context: context) } 
    #
    # _subject_ is a quite like _let_ - basically we're declaring a variable
    # _perform_ is the variable name
    # it refers to the method we're testing with the arguments specified
    # later on, in our expectations, we can invoke the method by calling _perform_

    let(:special_thing) do
      {
        'person' => "John Johnsonson",
        'expiry' => Time.new,
        'type' =>   'Card',
        'token' => "xyz123"
      }.to_json
    end
    let(:event) do
      {
        'Records' => [
          {"body" => special_thing}, 
          {"body" => "bar"}, 
          {"body" => "baz"}, 
        ]
      }
    end
    let (:context) {}
    #
    # with these _lets_ we are declaring the variables that our method requires as arguments
    # note how one variable uses another variable as one of it's values
    # both special_thing and event are POROs, but it would be very common to 
    # use a factory to create an instance of a model / database record using _let_

    it "checks the s3 client receives the expected data" do
    # 

      stub_ssm_response = { 
        get_parameter: {
          parameter: { name: 'foo', value: 'bar', type: 'String', version: 1 }
        }
      }
      # 
      # this is a stub
      # a stub is like a tiny mock. it provides the _minimum_ impersonation of the actual
      # corresponding code element that our test requires to execute

      ssm_mock_client = Aws::SSM::Client.new(stub_responses: stub_ssm_response )
      # 
      # this is a mock.
      # as this (and other) AWS components have inbuilt mocking capabilities we don't
      # need to build our own from scratch. Doing it this way has the advantage of checking
      # our calls to and the mock are checked by the actual AWS client. Also our stubbed
      # response has to be the correct format / shape.

      s3_mock_client = Aws::S3::Client.new(stub_responses: true)
      # this is another mock
      # Built in the same way, but as our test does not require any response from this client
      # we don't specify any response stub. This is the minimum setup for AWS mock client

      allow(Aws::SSM::Client).to receive(:new).and_return(ssm_mock_client)
      allow(Aws::S3::Client).to receive(:new).and_return(s3_mock_client)
      # 
      # these are _spys_
      # each time the corresponding code element recievs a call to the
      # new method of the AWS Client, we will inject our mocked version into the test


      allow(s3_mock_client).to receive(:put_object)
      # 
      # explicitly describe what methods can be called on the mocked client
      # (becuase we are using the built in AWS client mock, 
      # we can only provide valid methods here)
      
      
      perform
      # 
      # invoke the method as decribed in the _subject_ above.
      
      expect( s3_mock_client).to have_received(:put_object).with( 
        {:body => special_thing}, 
        {:bucket=> ""}, 
        {:key => special_thing['token']}
      )
      # 
      # the expectation section. In this case we are checking that 
      # - we have invoked the put_object method of the S3 client
      # - the arguments passed to the method are what we expect them to be
      # 
      # the method under test does not return a value,
      # so this is a nice way to test somehing that happens inside the method
    end
  end
```
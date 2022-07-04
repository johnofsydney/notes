# Rspec

## Configuration
Assuming you have the gem "rspec" in your gemfile, then
```sh
$ bundle install
$ rspec init
```
is probably enough to get started

---
## Running tests
To run tests for a _project_ always use `bundle exec`, which uses the ruby, and the gems of the current project, rather than the globally installed versions

For Rspec
```sh
$ bundle exec rspec
```

But also for other commands, e.g. rubocop:
```sh
$ bundle exec rubocop
```

```sh
# To run all the tests
$ bundle exec rspec

# To run the tests in a specific file:
$ bundle exec rspec spec/functions/finalise_something_spec.rb

# To run the tests at a specific line number:
$ bundle exec rspec spec/functions/finalise_something_spec.rb:177

# To run the tests matching a particular phrase (in the test description):
$ bundle exec rspec spec/functions/finalise_something_spec.rb -e "weekend"
```
---
## Test Outlines
### Typical Test

```ruby
describe "#method_in_code" do
  subject(:result) { described_class.method_in_code(event: event) }

  let(:event) { day: 'saturday' }

  it { expect(result).to eq(true) }
end
```
#### `describe`
Use a `describe` block to test all aspects of a class.
Each method will have a nested `describe` block.
We can use nested contexts to test different scenarios, see below.

#### `subject` and `let`
This is how _lazily loaded_ variables are declared in Rspec
`subject` and `let` are functionally the same, but we reserve `subject` for the _thing being tested_.
Think about what the method _does_ when naming the subject. Good names for the `subject` include:
- _the name of the method itself_ eg: `subject(:transform) { described_class.new(color).transform(animal, vegetable, mineral) }`
- `result` - if the method is supposed to return an answer; like `true` / `false` or `5`
- `perform` - especially good if the method is supposed to start other actions that won't all be shown in the return value, like instantiating other services, which can be checked with spies.

#### `it`
The expectation / assertion is where we test that the method (when passed the particular arguments) delivers the expected results.
What we are checking in this example is the return value of the method under test.

### Nested Contexts
Nested `context` blocks allow us to pass different variables into the method under test and check the code delivers the expected results for the different combinations.
`describe` and `context` are functionally the same, but generally we will use a `describe` for the class wih a nested `describe` for each method under test, whereas nested `context` blocks will be concerned with covering the different combinations of input arguments, and API responses from within the method.

```ruby
describe "#method_in_code" do
  subject(:result) { described_class.method_in_code(event: event) }

  context 'when the event is on a weekend' do
    let(:event) { day: 'saturday' }

    it { expect(result).to eq(true) }
  end

  context 'when the event is on a monday' do
    let(:event) { day: 'monday' }

    it { expect(result).to eq(false) }
  end
end
```

Often as we move through a nest of contexts it is necessary to vary a variable that was declared and used for the top context. If it is a single variable, we can just overwrite it as per the example above. But if we need to add / subtract values from a hash, this can be done as so:
```rb
context 'at the top' do
  # basic set of options
  let(:options) do
    {
      direction: direction,
      size: size
    }
  end
  let(:direction) { 'north' }
  let(:size) { 'large' }

  it { expect(result).to eq(true) }

  context 'in the middle' do
    # add some new key/value pairs using super().merge()
    let(:options) do
      super().merge(
        color: color
      )
    end
    let(:direction) { 'east' }
    let(:size) { 'medium' }
    let(:color) { 'red' }

    it { expect(result).to eq(true) }

    context 'at the bottom' do
      # add some new key/value pairs using super().merge()
      # and remove some keys using .reject
      let(:options) do
        super().merge(
          speed: speed
        ).reject do |key, _value|
          %i[size color].include?(key)
        end
      end
      let(:direction) { 'south' }
      let(:speed) { 'fast' }

      it { expect(result).to eq(true) }
    end
  end
end
```

### Before / Do
- Runs before _each_ test
- In the order
  - before :suite
  - before :context
  - before :example
  - after  :example
  - after  :context
  - after  :suite
- You can _sometimes_ move the invocation of the method under test into the before / do block, but pay attention, because if your invocation is in a `before` block, then **none of the downstream before blocks will be applied before the invocation of the method under test**

---

## Spies (Testing side effects)
It's easy to check for the return value of a method (e.g. `it { expect(result).to eq(false) }`) but it is a little more complicated to check for side effects of a method.
In order to check if another API was invoked during the operation of the method under test, we will need to _spy_ on that API.
This is acheived by specifying the class and method in the before block. Once this is done we can check to see if a class received a method invocation, and with what arguments.
```ruby
describe "#method_in_code" do
  subject(:result) { described_class.method_in_code(event: event) }

  before do
    allow(Rollbar).to receive(:warn)
  end

  let(:event) { day: 'monday' }

  it { expect(result).to eq(false) }
  it 'Rollbar receives a warning when invoked on a weekday' do
    expect(Rollbar)
      .to have_received(:warn)
      .with(/method cannot be invoked on a weekday/)
  end
end
```
**A note of caution**
When we define a spy like this we can observe that it was invoked, and with what arguments.
But without specifying a return value, it will return `nil` so be careful!
Options to specify a return value include
- `.and_call_original` => if we need to use the real code rather than a stubbed return value
- `.and_return(100)` => can specify an actual value to return, or a stubbed variable

---

## Shared Examples
If the assertion for a varity of combinations is the same, then we can use shared examples to keep things DRY. And to keep the test file smaller and readbale. This is especially true when the it block spans many lines
```ruby
describe "#method_in_code" do
  subject(:result) { described_class.method_in_code(event: event) }

  before do
    allow(Rollbar).to receive(:warn)
  end

  context 'when the event is on a weekend' do
    let(:event) { day: 'saturday' }

    it { expect(result).to eq(true) }
    it { expect(Rollbar).to_not have_received(:warn) }
  end

  shared_examples 'returns false and warns rollbar' do
    it { expect(result).to eq(false) }
    it { expect(Rollbar).to have_received(:warn) }
  end

  context 'when the event is on a monday' do
    let(:event) { day: 'monday' }

    it_behaves_like 'returns false and warns rollbar'
  end

  context 'when the event is on a tuesday' do
    let(:event) { day: 'tuesday' }

    it_behaves_like 'returns false and warns rollbar'
  end

  context 'when the event is on a wednesday' do
    let(:event) { day: 'wednesday' }

    it_behaves_like 'returns false and warns rollbar'
  end

  context 'when the event is on a thursday' do
    let(:event) { day: 'thursday' }

    it_behaves_like 'returns false and warns rollbar'
  end

  context 'when the event is on a friday' do
    let(:event) { day: 'friday' }

    it_behaves_like 'returns false and warns rollbar'
  end
end
```

Of course, rspec is ruby, so we can also do this for brevity:
```rb
  context 'when the event is on a weekday' do
    %w[monday tuesday wednesday thursday friday].each do |weekday|
      let(:event) { day: weekday }

      it_behaves_like 'returns false and warns rollbar'
    end
  end
```


### `shared_examples`
- When we want to observe the same results for a variety of situations, create a `shared examples` block, which contains all of the expectations that we wish to assert.
- The further upstream in the test file that you can move the shared examples, the more contexts you can use that example in, and the DRYer your tests can become.
- As test files can become very repetitive as you assert that the same result will apply under a variety of conditions, this is an excellent way to keep code DRY.
- If there are a significant number of shared examples, these can be moved to a seperate file and imported into the test file with a `require` statement.

### `it_behaves_like`
To assert the shared examnples simply call the assertion with `it_behaves_like`
You can have many `it_behaves_like` statements within a context, just as you might have many individual `it` statements.

---
## Mocks, Stubs, Doubles, Class Doubles, Instance Doubles
When we are conducting a _Unit Test_ we only want to test the code in that unit (usually class). The class under test will interact with other classes / APIs and often it's appropriate to _Mock_ the response from those classes / APIs.
Mocks and Stubs are _doubles_ (in the sense of stunt double), that _stand in_ for the response from external code.
- A `mock` is a stand in for a larger thing, e.g. a whole class or API
- A `stub` is a stand in for a smaller thing, e.g. the response to a specific API method.

We can talk of _injecting_ a mocked response into our tests. The point of doing so is
- speed: we don't have to wait for external APIs to respond
- control: we can make sure all of the varied responses are provided, and can prove that our code responds in predictable ways
- convention:
  - Don't test library code
  - Unit tests != Integration tests: keep the unit tests small and focussed.

### Mocking a 3rd party client (example 1):
Super basic Mock
```rb
before do
  allow(Cronitor).to receive(:new).and_return(cronitor)
  allow(cronitor).to receive(:ping)
end

let(:cronitor) { instance_double(Cronitor, ping: true) }
```

### Mocking one of our own clients (example 2)
In this case we are mocking our `client` with the double `mock_client`
We have defined variables which will be returned when the relevant methods of our mock are invoked. These are `stubs`
These stubs can be varied within different contexts to make sure all corners of the code are providing predictable results.
```rb
before do
  allow(described_class).to receive(:client).and_return(mock_client)
end

let(:mock_client) do
  instance_double('CleverApi', transact: transact_result, delete: delete_result)
end

let(:transact_result) { { success: success, response_id: '123' } }
let(:delete_result) { { success: success, response_id: '456' } }
let(:success) { true }
```

### Mocking an AWS Service
These are a noteworthy case, because the best way to Mock an AWS service is to invoke the actual service, and to specify `stub_responses: true`
Not only does this this prevent method calls to non-existent methods, but it helps keep your responses aligned with the real responses more strictly.
In the case below, `states_mock_client` is a mock and it has all of the methods (that are used in our code) stubed with the `stub_states_response`

```rb
before do
  allow(Aws::States::Client).to receive(:new).and_return(states_mock_client)
  allow(states_mock_client).to receive(:list_state_machines).and_call_original
  allow(states_mock_client).to receive(:start_execution).and_call_original
end

let(:states_mock_client) { Aws::States::Client.new(stub_responses: stub_states_response) }
let(:stub_states_response) do
  {
    list_state_machines: {
      state_machines: [
        {
          state_machine_arn: 'machine_arn',
          name: 'machine_name',
          type: 'STANDARD',
          creation_date: Time.new
        },
        {
          state_machine_arn: arn_of_machine,
          name: name_of_machine,
          type: 'STANDARD',
          creation_date: Time.new
        }
      ]
    },
    start_execution: {
      execution_arn: arn_of_execution,
      start_date: invoke_time
    }
  }
end

```
### `stub_const`
A final noteworthy case is `stub_const`, to test for different const values, often env variables, like so
```rb
before do
  stub_const('ENV', { 'AWS_STAGE' => 'prod' })
end
```

---
## Testing exceptions
In order to test error handling it is necessary to raise exceptions, and to test for them

```ruby
before do
  allow(Person).to_receive(:new).and_return(mock_person)
end

let(:person) double('Person')

context 'when there are handled errors' do
  before do
    allow(person).to_receive(:type).and_raise(NameError) # a handled error
  end

  # If this is a handled error, then there's nothing special about the assertion.
  it { expect(perform).to eq(false) }
end

context 'when there are unhandled errors' do
  before do
    allow(person).to_receive(:type).and_raise(TypeError) # an unhandled error
  end

  # If this is an unhandled error, then we must wrap the invocation in a block.
  it { expect { perform }.to raise_exception(NameError) }
end
 ```
Under normal circumstances the invocation of the method under test (shorthand here is `perform`) will be invoked and evaluated first, and then compared to the assertion.

If we are testing that a particular set of circumstances will raise an exception, then we don't want that order of events, and we must wrap the invocation in a block.

---

## When checking that _Other Things Changed_
When we set `perform` or `result` as the return value of (say) the instance method under test, it's easy to check the components of the returned value.
But to check what else might have changed as a result of running the method it's a bit trickier.
In fact it is another example of how we should wrap the invocation in a block, just like the exception test above.
```ruby
it 'calls the Status API and updates the card' do
  expect { perform }
    .to change { credit_card.reload.status }
    .from(nil).to(CreditCard::STATUS_SUSPENDED)
end
```

---
## Testing arguments
Testing if the expected fields of a hash have been received can be acheived like so:
```ruby
expect(sqs_mock_client).to have_received(:send_message) do |arguments|
  message_body = JSON.parse(arguments[:message_body])
  expect(message_body['technician']).to eq(job.technician)
  expect(message_body['job_number']).to eq(job.job_number)
end
```
---
## Testing a Private Method
Apparently it is not good practice to test private methods, but if you do need to do it here's an example.
`parse_line` is the private method. and it's invoked using the magic word `.send` => `described_class.new.send`

```ruby
describe 'parse_line' do
  let(:line) do
    [
      'A',                                 # position 0
      'B234567',                           # positions 1 to 7
      'C90123456',                         # positions 8 to 16
    ].join('')
  end

  let(:expected_parsed_line) do
    {
      record_indicator: 'A',
      bsb: 'B234567',
      account_number: 'C90123456',
    }
  end

  it 'parses the file line correctly' do
    expect(described_class.new.send(:parse_line, line)).to eq(expected_parsed_line)
  end
end
```

---
## Build vs Create
The `create` method persists the instance of the model to the database, while `build` keeps it only on memory.
- `build`
  - faster
  - skips validations
- create
  - runs validations (these might be important to your test)
  - saves to the database, so it's possible to test retrieval and whether an action changes a database record.

--

## Miscallaneous Notes
Using the `hash_including` matcher:
```ruby
expect(errors).to include(
  a_hash_including(
    "message" => AUTHENTICATION_ERROR
  )
)
```

Using the `match_array` matcher
```rb
expect(data.keys).to match_array(expected_fields)
```

Using `:aggregate_failures`
```rb
it "has a heading and a subheading", :aggregate_failures do
  expect(subject.heading).to be_present
  expect(subject.subheading).to be_present
end
```

### Using Regex and 'match`
Testing for a literal pattern
```rb
expect(subject.errors).to match(/Your account has not been approved/)
```

Using a Regex variable
```rb
money_regex = /\$\d+\.\d{2}/
expect(response['price']).to match(money_regex)
```
Using string interpolation within the Regexp to match to a test variable
```rb
expect(response['dollars']).to match(/\$(#{rate_cents.to_s[..-3]})\.(#{rate_cents.to_s[-2..]})/)
```

Using `request` and `response` for controller specs:
when you send a `post` or ` `get` request as part of a controller or GraphQL test, both the `request` and the `response` objects are _magically_ available for interrogation, without needing to be declared.
```rb
it 'Creates a User' do
  # NB do the `post` inside your `it` block, rather in a `before` block
  # it is not DRY, but it is better (stops confusing effect of later before blocks being effectively ignored)
  post '/graphql', params: { query: mutation_create_user }

  json = JSON.parse(response.body)
```

## Readings
- General overview: http://www.betterspecs.org/
- When to use `let`: https://stackoverflow.com/questions/5359558/when-to-use-rspec-let/5359979#5359979
- matchers: https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/

---

--
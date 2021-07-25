# Rspec

## Configuration
Assuming you have the gem "rspec" in your gemfile, then
```sh
$ bundle install
$ rspec init
```
is probably enough to get started

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
$ bundle exec rspec spec/functions/dynamo_reader_spec.rb

# To run the tests at a specific line number:
$ bundle exec rspec spec/functions/finalise_settlement_spec.rb:177

# To run the tests matching a particular phrase (in the test description):
$ bundle exec rspec spec/functions/finalise_settlement_spec.rb -e "MDES"
```

## Test Outlines
### Typical Test

```ruby
describe "#method_in_code" do
  subject(:result) { described_class.method_in_code(event: event) }

  let(:event) { day: 'saturday' }

  it { expect(result).to eq(true) }
end
```
#### describe
Use a `describe` block to test all aspects of a class.
Each method will have a nested `describe` block.
We can use nested contexts to test different scenarios, see below.

#### subject and let
This is how _lazily loaded_ variables are declared in Rspec
`subject` and `let` are functionally the same, but we reserve `subject` for the _thing being tested_.


#### it
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

### Spies (Testing side effects)
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
When we define a like this we can observe that it was invoked, and with what arguments.
But without specifying a return value, it will return `nil` so be careful!
Options to specify a return value include
`.and_call_original` => if we need to use the real code than a stubbed return value
`.and_return(100)` => can specify an actual value to return, or a stubbed variable


### Shared Examples
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

#### `shared_examnples`
When we want to observe the same results for a variety of situations, create a `shared examples` block, which contains all of the expectations that we wish to assert.
The further upstream in the test file that you can move the shared examples, the more contexts you can use that example in, and the DRYer your tests can become.
As test files can become very repetitive as you assert that the same result will apply under a variety of conditions, this is an excellent way to keep code DRY.
If there are a significant number of shared examples, these can be moved to a seperate file and imported into the test file with a `require` statement.
#### `it_behaves_like`
To assert the shared examnples simply call the assertion with `it_behaves_like`
You can have many `it_behaves_like` statements within a context, just as you might have many individual `it` statements.




### Mocks, Stubs, Doubles, Class Doubles, Instance Doubles
When we are conducting a _Unit Test_ we only want to test the code in that unit (usually class). The class under test will interact with other classes / APIs and often it's appropriate to _Mock_ the response from those classes / APIs.
Mocks and Stubs are _doubles_ (in the sense of stunt double), that _stand in_ for the response from external code.
- A `mock` is a stand in for a larger thing, e.g. a whole class or API
- A 'stub` is a stand in for a smaller thing, e.g. the response to a specific API method.

We can talk of _injecting_ a mocked response into our tests. The point of doing so is
- speed: we don't have to wait for external APIs to respond
- control: we can make sure all of the varied responses are provided, and can prove that our code responds in predictable ways
- convention:
  - Don't test library code
  - Unit tests != Integration tests: keep the unit tests small and focussed.

E.g. Mocking a 3rtd party client:
```rb

before do

end
```


### Factories

### Build vs Create

### Testing exceptions
### Testing arguments
require File.join(File.dirname(__FILE__), 'test_helper')
require File.join(File.dirname(__FILE__), '../lib/status_parser')
require "nokogiri"

class PassengerStatusTest < Test::Unit::TestCase

  def setup
    example_output_file = File.join(File.dirname(__FILE__), 'test_commands/passenger-status --show=xml')
    @status_parser = Status.new(File.read(example_output_file))
  end

  test "max possible passenger processes are parsed correctly" do
    assert_equal 22, @status_parser.max_process_count
  end

  test "number of running passenger processes are parsed correctly" do
    assert_equal 444, @status_parser.current_process_count
  end

  test "number of enabled passenger processes are parsed correctly" do
    assert_equal 111, @status_parser.enabled_process_count
  end

  test "number of disabling passenger processes are parsed correctly" do
    assert_equal 222, @status_parser.disabling_process_count
  end

  test "number of disabled passenger processes are parsed correctly" do
    assert_equal 333, @status_parser.disabled_process_count
  end

  test "number of disable_wait passenger processes are parsed correctly" do
    assert_equal 666, @status_parser.disable_wait_process_count
  end

  test "number of being spawned passenger processes are parsed correctly" do
    assert_equal 777, @status_parser.being_spawned_process_count
  end

  test "requests waiting on global queue are parsed correctly" do
    assert_equal 555, @status_parser.waiting_request_count
  end

  test "number of sessions (summed as total) parsed correctly" do
    assert_equal 1, @status_parser.sessions
  end

  test "CPU (summed as total) parsed correctly" do
    assert_equal 4.5, @status_parser.cpu
  end

  test "memory by app parsed correctly" do
    assert_equal 55620, @status_parser.process_memory['Passenger RackApp: testapp1']
  end

  test "time since last used parsed correctly" do
    assert 5670 < @status_parser.last_used_time["1"]
  end

end

require "benchmark"

class Benchmarker

  class Report
    attr_accessor :longest
    attr_accessor :shortest
    attr_accessor :average
    attr_accessor :times

    def initialize(times)
      @times = times
    end

    def longest
      times.sort.last
    end

    def shortest
      times.sort.first
    end

    def average
      times.inject(0.0) { |sum, time| sum += time } / times.size.to_f
    end

    def ms(time)
      (((self.send(time) * 1000.0) * 100.0).to_i) / 100
    end

    def to_s
      "Average: #{ms(:average)}ms\n" +
      "Longest: #{ms(:longest)}ms\n" +
      "Shortest: #{ms(:shortest)}ms"
    end

  end

  attr_accessor :iterations
  def initialize(iterations)
    @iterations = iterations
  end

  def run(name = nil, &block)
    puts "Benchmarking: #{name}"
    times = []
    iterations.times do
      print "."; STDOUT.flush
      time = Benchmark.measure(&block)
      times.push time.real
    end
    puts "\n"
    Report.new(times)
  end

end

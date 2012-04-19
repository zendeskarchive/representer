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

    def median
      lowest = times.min
      highest = times.max
      total = times.inject(:+)
      len = times.length
      average = total.to_f / len # to_f so we don't get an integer result
      sorted = times.sort
      median = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2
    end

    def average
      times.inject(0.0) { |sum, time| sum += time } / times.size.to_f
    end

    def sd
      (median - average).abs
    end

    def ms(time)
      (((self.send(time) * 1000.0) * 100.0).to_i) / 100
    end

    def to_s
      "Average: #{ms(:average)}ms\n" +
      "Median: #{ms(:median)}ms\n" +
      "Longest: #{ms(:longest)}ms\n" +
      "Shortest: #{ms(:shortest)}ms\n" +
      "Standard deviation: #{ms(:sd)}ms\n"
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

require 'station'

class Oystercard
  attr_reader :balance, :entry_station, :journey_history

  DEFAULT_BALANCE = 0
  MINIMUM_BALANCE = 1
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @entry_station = nil
		@journey_history = []
  end

  def top_up(amount)
    if @balance + amount > MAXIMUM_BALANCE
      raise "Top up invalid, balance maximum is #{Oystercard::MAXIMUM_BALANCE}, your current balance is #{@balance}"
    end
    @balance += amount
  end

  def touch_in(station)
    if @balance < MINIMUM_BALANCE
      raise 'Insufficient funds'
    end
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @journey_history << { :entry => @entry_station, :exit => station }
		@entry_station = nil
  end

  def in_journey?
		@entry_station != nil ? true : false
  end

  private
  
  def deduct(amount)
    @balance -= amount
  end


end

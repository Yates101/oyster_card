require 'oystercard'

describe Oystercard do

  let(:start_station) { double("mock_entry_station") }
  let(:end_station) { double("mock_exit_station") }
  let(:test_card) { Oystercard.new(20) }

  describe 'when first created' do
    it { is_expected.to respond_to(:balance) }

    it 'initialises with the default balance' do
      expect(subject.balance).to eq (Oystercard::DEFAULT_BALANCE)
    end
  end

  describe 'top up features' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'increases the balance by the argument amount using :top_up' do
      expect { test_card.top_up(10) }.to change { test_card.balance }.by(10)
    end

    it 'raises an error if the top_up method puts balance over maximum balance' do
      expect { subject.top_up(Oystercard::MAXIMUM_BALANCE + 1) }.to raise_error("Top up invalid, balance maximum is #{Oystercard::MAXIMUM_BALANCE}, your current balance is #{subject.balance}")
    end
  end

  describe 'touch_in' do

    it { is_expected.to respond_to(:touch_in) }

    it'prevents touch in when balance is below £1' do
      expect { subject.touch_in(start_station) }.to raise_error('Insufficient funds')
    end

    it 'remembers the entry station' do
      # subject.top_up(20)
  		test_card.touch_in(start_station)

		  expect(test_card.entry_station).to eq start_station
    end
  end

  describe 'touch_out' do
    it { is_expected.to respond_to(:touch_out).with(1).argument }

    it 'deducts card balance by the fare' do
      expect { test_card.touch_out(end_station) }.to change { test_card.balance }.by (-Oystercard::MINIMUM_FARE)
    end

    it 'resets the entry station' do
      test_card.touch_in(start_station)
      test_card.touch_out(end_station)

      expect(test_card.entry_station).to eq nil
    end

  end
  describe 'in_journey?' do
    it { is_expected.to respond_to(:in_journey?)}

    it 'tells if in journey' do
      test_card.touch_in(start_station)

      expect(test_card.in_journey?).to eq true 
    end

    it 'tells if not in journey' do
      test_card.touch_out(end_station)

      expect(test_card.in_journey?).to eq false
    end
  end

  describe 'journey history' do
    it 'has somewhere to store history' do
      expect(test_card.journey_history).to eq([])
    end

    it 'shows all my previous trips' do
      test_card = Oystercard.new(20)
      test_card.touch_in(start_station)
      test_card.touch_out(end_station)

      expect(test_card.journey_history).to eq([{ :entry => start_station, :exit => end_station }])
    end
  end

end

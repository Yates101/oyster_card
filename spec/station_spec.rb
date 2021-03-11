require 'station'

describe Station do
    describe 'station attributes' do
        it 'station instances have a zone variable' do
            waterloo = Station.new(2)
            expect(waterloo.zone).to eq 2
        end
    end
end
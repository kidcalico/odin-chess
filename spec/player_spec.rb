require_relative '../lib/player'

describe Player do
  subject(:player) { described_class.new('b') }
  describe '#algebraic_to_coord' do
    it 'receives an algebraic coordinate, and returns a numeric coordinate array' do
      alg = 'g7'
      result = player.algebraic_to_coord(alg)
      expected = [1, 6]
      expect(result).to eq(expected)
    end
  end

  describe '#get_input' do
    context 'when first and second inputs are invalid' do
      before do
        short = 'g'
        long = 'blargh'
        reverse = '4a'
        correct = 'a4'
        allow(player).to receive(:gets).and_return(short, long, reverse, correct)
      end
      it 'rejects input that is not two characters or the wrong order, accepts algebraic format' do
        result = player.get_input('piece')
        expect(result).to eq([4, 0])
      end
    end

    context 'when first input is valid' do
      before do
        correct = 'C6'
        allow(player).to receive(:gets).and_return(correct)
      end

      it 'accepts algebraic format regardless of case' do
        result = player.get_input('piece')
        expect(result).to eq([2, 2])
      end
    end
  end
end

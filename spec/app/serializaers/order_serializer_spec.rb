RSpec.describe OrderSerializer do
  let(:serialized_order) { described_class.new(order).serializable_hash[:data] }
  describe 'with error' do
    let(:order) { create(:order, :damaged) }
    it 'has error attribute' do
      expect(serialized_order[:attributes]).to have_key(:error)
    end
  end

  describe 'withour_error' do
    let(:order) { create(:order) }
    it 'has exactly root attributes' do
      expect(serialized_order[:attributes].keys).to contain_exactly(:id, :state, :assembler_id, :courier_id, :cost_cops, :client)
    end

    it 'has exactly client attributes' do
      expect(serialized_order[:attributes][:client].keys).to contain_exactly(:customer_id, :customer_email, :address, :front_door, :floor, :intercom)
    end

    context 'when with_item passed' do
      let(:order) { create(:order_with_items) }
      let(:serialized_order) { described_class.new(order, params: { with_items: true }).serializable_hash[:data] }
      it 'returns items relation' do
        expect(serialized_order[:relationships]).to have_key(:items)
      end
    end

    context 'withour with_item param' do
      let(:order) { create(:order_with_items) }
      it 'returns empty items relation' do
        expect(serialized_order[:relationships]).to be_empty
      end
    end
  end
end
RSpec.describe OrderBlueprint do
  let(:serialized_order) { described_class.render_as_hash(order) }
  describe 'with error' do
    let(:order) { create(:order, :damaged) }
    it 'has error attribute' do
      expect(serialized_order).to have_key(:error)
    end
  end

  describe 'withour_error' do
    let(:order) { create(:order) }
    it 'has exactly root attributes' do
      expect(serialized_order.keys).to contain_exactly(:id, :state, :assembler_id, :courier_id, :cost_cops, :client, :items, :created_at)
    end

    it 'has exactly client attributes' do
      expect(serialized_order[:client].keys).to contain_exactly(:customer_id, :customer_email, :address, :front_door, :floor, :intercom)
    end

    context 'when with_item passed' do
      let(:order) { create(:order_with_items) }
      let(:serialized_order) { described_class.render_as_hash(order, view: :extended) }
      it 'returns items relation' do
        expect(serialized_order).to have_key(:items)
        expect(serialized_order[:items]).not_to be_empty
      end
    end

    context 'withour with_item param' do
      let(:order) { create(:order_with_items) }
      it 'returns empty items relation' do
        expect(serialized_order[:items]).to eq([])
      end
    end
  end
end
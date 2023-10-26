RSpec.describe 'ItemsFilter' do
  let(:filter) { Orchestrator['items_filter'] }

  describe "#call" do
    context "when filter is empty" do
      it "returns relation" do
        expect(filter.call).to eq(Item.all)
      end
    end

    context 'when search by id' do
      before { create_list(:item, 2) }
      it 'returns currect item' do
        expected_item = Item.last
        actual_items = filter.call(id: expected_item.id).first
        expect(actual_items).to eq(expected_item)
      end
    end

    context 'when search by any other attribute' do
      before { create_list(:item, 5) }
      it 'returns currect item' do
        expected_item = Item.last
        actual_items = filter.call(
          filter: {
            weight: expected_item.weight
          }
        ).first
        expect(actual_items).to eq(expected_item)
      end

      it 'returns currect item in currect order' do
        actual_scop = filter.call(
          filter: {
            weight: 0..
          },
          order: {
            created_at: :desc
          }
        )
        expected_scope = Item.where(weight: 0..).order(created_at: :desc)
        expect(actual_scop.pluck(:id)).to eq(expected_scope.pluck(:id))
      end

      context 'and filter contains negative predicate' do
        it 'returns currect items' do
          exclude_item = Item.last
          actual_items = filter.call(
            filter: {
              id: "not_#{exclude_item.id}"
            }
          )

          expect(actual_items.ids).not_to include(exclude_item.id)
        end
      end
    end
  end
end